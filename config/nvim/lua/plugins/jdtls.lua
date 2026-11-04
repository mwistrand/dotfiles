local dap = require('dap')
local lspconfig = require('plugins.lspconfig')
local home = os.getenv('HOME')
local jdtls = require('jdtls')
local ui = require('plugins.dap-ui')
local utils = require('utils')

local nnoremap = utils.nnoremap
local vnoremap = utils.vnoremap

-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { 'gradlew', 'mvnw', '.git' }
local root_dir = require('jdtls.setup').find_root(root_markers)

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

-- Check if a directory contains a Quarkus project
local function check_quarkus_in_dir(dir)
	local pom_path = dir .. '/pom.xml'
	local gradle_path = dir .. '/build.gradle'

	-- Check pom.xml for Quarkus dependency
	if vim.fn.filereadable(pom_path) == 1 then
		local pom_content = vim.fn.readfile(pom_path)
		for _, line in ipairs(pom_content) do
			if line:match('quarkus') then
				return 'quarkus'
			end
		end
	end

	-- Check build.gradle for Quarkus dependency
	if vim.fn.filereadable(gradle_path) == 1 then
		local gradle_content = vim.fn.readfile(gradle_path)
		for _, line in ipairs(gradle_content) do
			if line:match('quarkus') then
				return 'quarkus'
			end
		end
	end

	return nil
end

-- Check if a directory contains a Spring Boot project
local function check_spring_in_dir(dir)
	local pom_path = dir .. '/pom.xml'
	local gradle_path = dir .. '/build.gradle'

	-- Check pom.xml for Spring Boot dependency
	if vim.fn.filereadable(pom_path) == 1 then
		local pom_content = vim.fn.readfile(pom_path)
		for _, line in ipairs(pom_content) do
			if line:match('spring%-boot') then
				return 'spring'
			end
		end
	end

	-- Check build.gradle for Spring Boot dependency
	if vim.fn.filereadable(gradle_path) == 1 then
		local gradle_content = vim.fn.readfile(gradle_path)
		for _, line in ipairs(gradle_content) do
			if line:match('spring%-boot') or line:match('org%.springframework%.boot') then
				return 'spring'
			end
		end
	end

	return nil
end

-- Detect project type in a directory (returns 'quarkus', 'spring', or nil)
local function detect_project_type(dir)
	return check_quarkus_in_dir(dir) or check_spring_in_dir(dir)
end

-- Find all Java subprojects in the workspace
local function find_java_subprojects()
	local projects = {}

	-- Check root directory first
	local root_type = detect_project_type(root_dir)
	if root_type then
		table.insert(projects, {
			path = root_dir,
			name = vim.fn.fnamemodify(root_dir, ':t'),
			type = root_type,
		})
	end

	-- Scan immediate subdirectories for subprojects
	local handle = vim.loop.fs_scandir(root_dir)
	if handle then
		while true do
			local name, type = vim.loop.fs_scandir_next(handle)
			if not name then break end

			if type == 'directory' and not name:match('^%.') then
				local subdir = root_dir .. '/' .. name
				local subproject_type = detect_project_type(subdir)
				if subproject_type then
					table.insert(projects, {
						path = subdir,
						name = name,
						type = subproject_type,
					})
				end
			end
		end
	end

	return projects
end

-- Every time this is called, it either starts the debugger and executes the main code path,
-- or displays a window of options if a session has already started.
function create_connect_debugger_cmd(is_debug)
	return function()
		require('jdtls.dap').setup_dap_main_class_configs({
			verbose = true,
			on_ready = function()
				dap.continue()

				dap.listeners.after.event_initialized['dotfiles'] = function()
					if is_debug == true then
						ui.open_footer()
					else
						ui.show_footer_group('terminal')
					end
				end
			end
		})
	end
end

-- Attach to a running Quarkus dev mode session (port 5005 by default)
local function attach_quarkus_debugger(project_name)
	local name = project_name and ('Attach to Quarkus: ' .. project_name) or 'Attach to Quarkus Dev Mode'
	dap.run({
		type = 'java',
		request = 'attach',
		name = name,
		hostName = 'localhost',
		port = 5005,
		vmArgs = '-Djava.rmi.server.hostname=localhost -Dquarkus.profile=local,private',
	})

	dap.listeners.after.event_initialized['dotfiles'] = function()
		ui.open_footer()
	end
end

-- Start debugging for a specific project
local function start_debug_for_project(project, is_debug)
	if project.type == 'quarkus' then
		attach_quarkus_debugger(project.name)
	else
		create_connect_debugger_cmd(is_debug)()
	end
end

-- Smart debug command: detects subprojects and prompts if multiple found
local function create_smart_debug_cmd(is_debug)
	return function()
		local projects = find_java_subprojects()

		if #projects == 0 then
			-- No specific framework detected, fall back to default behavior
			create_connect_debugger_cmd(is_debug)()
		elseif #projects == 1 then
			-- Single project found, start it directly
			start_debug_for_project(projects[1], is_debug)
		else
			-- Multiple projects found, prompt for selection
			vim.ui.select(projects, {
				prompt = 'Select project to debug:',
				format_item = function(project)
					return string.format('[%s] %s', project.type, project.name)
				end,
			}, function(selected)
				if selected then
					start_debug_for_project(selected, is_debug)
				end
			end)
		end
	end
end

local on_attach = function(client, bufnr)
	lspconfig.on_attach(client, bufnr)

	-- attach the debugger
	jdtls.setup_dap({
		hotcodereplace = 'auto',
		config_overrides = {
			-- AllowRedefinitionToAddDeleteMethods required for BlockHound
			vmArgs = '-XX:+AllowRedefinitionToAddDeleteMethods -Djava.rmi.server.hostname=localhost -Dspring.profiles.active=local,private'
		}
	})
	jdtls.setup.add_commands()

	local opts = { buffer = bufnr }
	nnoremap('<LocalLeader>ro', jdtls.organize_imports, opts)
	nnoremap('<LocalLeader>rev', jdtls.extract_variable, opts)
	nnoremap('<LocalLeader>rec', jdtls.extract_constant, opts)
	vnoremap('<LocalLeader>rem', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)

	nnoremap('<LocalLeader>c', create_smart_debug_cmd(true), opts)
	nnoremap('<LocalLeader>s', create_connect_debugger_cmd(false), opts)
	nnoremap('<LocalLeader>da', function() attach_quarkus_debugger() end, opts) -- Explicitly attach to Quarkus/remote debugger

	nnoremap('<LocalLeader>tc', jdtls.test_class, opts)
	nnoremap('<LocalLeader>tn', jdtls.test_nearest_method, opts)

end

local bundles = {
	-- path to the java debug server
	home .. '/.local/share/microsoft/java-debug/com.microsoft.java.debug.plugin-0.44.0.jar',
}
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.local/share/microsoft/vscode-java-test/*.jar', 1), '\n'))

local jdtls_config = {
	flags = {
		debounce_text_changes = 80,
	},
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = root_dir,
	init_options = {
		bundles = bundles
	},
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request for a list of options
	settings = {
		java = {
			format = {
				settings = {
					-- Use Google Java style guidelines for formatting
					-- To use, make sure to download the file from https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
					-- and place it in the ~/.local/share/eclipse directory
					url = home .. '/.local/share/eclipse/java-google-style.xml',
					profile = 'GoogleStyle',
				},
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = 'fernflower' },
			completion = {
				favoriteStaticMembers = {
					'java.util.Objects.requireNonNull',
					'java.util.Objects.requireNonNullElse',
					'org.junit.jupiter.api.Assertions.*',
					'org.mockito.Mockito.*',
				},
				filteredTypes = {
					'com.sun.*',
					'io.micrometer.shaded.*',
					'java.awt.*',
					'jdk.*',
					'sun.*',
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}'
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},

			-- If you are developing in projects with different Java versions, you need
			-- to tell eclipse.jdt.ls to use the location of the JDK for your Java version
			-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
			-- And search for `interface RuntimeOption`
			-- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
			configuration = {
				runtimes = {
					{
						name = 'JavaSE-18',
						path = home .. '/.asdf/installs/java/openjdk-18.0.1',
					},
					{
						name = 'JavaSE-17',
						path = home .. '/.asdf/installs/java/openjdk-17.0.1',
					},
					{
						name = 'JavaSE-21',
						path = home .. '/.asdf/installs/java/openjdk-21.0.1',
					},
					{
						name = 'JavaSE-24',
						path = home .. '/.asdf/installs/java/openjdk-24',
					},
					{
						name = 'JavaSE-25',
						path = home .. '/.asdf/installs/java/openjdk-25',
					},
				}
			}
		}
	},

	-- cmd is the command that starts the language server. Whatever is placed
	-- here is what is passed to the command line to execute jdtls.
	-- Note that eclipse.jdt.ls must be started with a Java version of 17 or higher
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	-- for the full list of options
	cmd = {
		home .. '/.asdf/installs/java/openjdk-25/bin/java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-Xmx4g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-javaagent:' .. '/usr/local/share/lombok.jar',

		-- The jar file is located where jdtls was installed. This will need to be updated
		-- to the location where you installed jdtls
		'-jar', vim.fn.glob('/opt/homebrew/Cellar/jdtls/1.50.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),

		-- The configuration for jdtls is also placed where jdtls was installed. This will
		-- need to be updated depending on your environment
		'-configuration', '/opt/homebrew/Cellar/jdtls/1.50.0/libexec/config_mac',

		-- Use the workspace_folder defined above to store data for this project
		'-data', workspace_folder,
	},
}

local config = lspconfig.create_config(function(default_config)
	return vim.tbl_extend('keep', vim.deepcopy(jdtls_config), vim.deepcopy(default_config))
end)

-- As this is only needed for Java files, the plugin is started within the relevant ftplugin file
local M = {}
M.create_config = function()
	return config
end
return M
