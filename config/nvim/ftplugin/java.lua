local jdtls = require('jdtls')
local create_config = require('plugins.jdtls').create_config
local nmap = require('utils').nmap

-- Finally, start jdtls. This will run the language server using the configuration we specified,
-- setup the keymappings, and attach the LSP client to the current buffer
jdtls.start_or_attach(create_config())

-- test commands (requires on vim-test)
-- nmap('<LocalLeader>tn', ':TestNearest<cr>')
-- nmap('<LocalLeader>tf', ':TestFile<cr>')
-- nmap('<LocalLeader>ts', ':TestSuite<cr>')
-- nmap('<LocalLeader>tl', ':TestLast<cr>')
-- nmap('<LocalLeader>tg', ':TestVisit<cr>')
-- }}}
