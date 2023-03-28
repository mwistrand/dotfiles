local lspconfig = require('plugins.lspconfig')
local home = os.getenv('HOME')
local jdtls = require('jdtls')
local utils = require('utils')
local vscode = require('dap.ext.vscode')

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

local on_attach = function(client, bufnr)
	lspconfig.on_attach(client, bufnr)

	-- attach the debugger
	jdtls.setup_dap({ hotcodereplace = 'auto' })
	jdtls.setup.add_commands()
	-- jdtls.dap.setup_dap_main_class_configs()

	local opts = { buffer = bufnr }
	nnoremap('<LocalLeader>ro', jdtls.organize_imports, opts)
	nnoremap('<LocalLeader>rev', jdtls.extract_variable, opts)
	nnoremap('<LocalLeader>rec', jdtls.extract_constant, opts)
	vnoremap('<LocalLeader>rem', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)

	nnoremap('<LocalLeader>ca', vim.lsp.buf.code_action, { buffer=buffer, desc='Code actions'})
	vnoremap('<LocalLeader>ca', '<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>', opts)

	-- nvim-dap
	nnoremap('<LocalLeader>bb', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], opts)
	nnoremap('<LocalLeader>bc', [[<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>]], opts)
	nnoremap('<LocalLeader>bl', [[<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>]], opts)
	nnoremap('<LocalLeader>br', [[<cmd>lua require('dap').clear_breakpoints()<cr>]], opts)
	nnoremap('<LocalLeader>ba', '<cmd>Telescope dap list_breakpoints<cr>', opts)

	nnoremap('<LocalLeader>dm', '<cmd>JdtRefreshDebugConfigs<cr>', opts) -- setup main classes
	nnoremap('<LocalLeader>dc', [[<cmd>lua require('dap').continue()<cr>]], opts)
	nnoremap('<LocalLeader>dj', [[<cmd>lua require('dap').step_over()<cr>]], opts)
	nnoremap('<LocalLeader>dk', [[<cmd>lua require('dap').step_into()<cr>]], opts)
	nnoremap('<LocalLeader>do', [[<cmd>lua require('dap').step_out()<cr>]], opts)
	nnoremap('<LocalLeader>dd', [[<cmd>lua require('dap').disconnect()<cr>]], opts)
	nnoremap('<LocalLeader>dt', [[<cmd>lua require('dap').terminate()<cr>]], opts)
	nnoremap('<LocalLeader>dr', [[<cmd>lua require('dap').repl.toggle()<cr>]], opts)
	nnoremap('<LocalLeader>dl', [[<cmd>lua require('dap').run_last()<cr>]], opts)

	nnoremap('<LocalLeader>uo', [[<cmd>lua require('dapui').open()<cr>]], opts)
	nnoremap('<LocalLeader>uc', [[<cmd>lua require('dapui').close()<cr>]], opts)
	nnoremap('<LocalLeader>ut', [[<cmd>lua require('dapui').toggle()<cr>]], opts)

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
		home .. '/.asdf/installs/java/openjdk-18.0.1/bin/java',
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
		'-jar', vim.fn.glob('/opt/homebrew/Cellar/jdtls/1.20.0/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),

		-- The configuration for jdtls is also placed where jdtls was installed. This will
		-- need to be updated depending on your environment
		'-configuration', '/opt/homebrew/Cellar/jdtls/1.20.0/libexec/config_mac',

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
