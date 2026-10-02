require('vis')
-- global
vis.events.subscribe(vis.events.INIT, function()
    vis:command('set theme default')
end)
-- window
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
    vis:command('set numbers true')
    vis:command('set autoindent true')
    vis:command('set tabwidth 2')
    vis:command('set showtabs true')
    vis:command('set expandtab on')
    vis:map(vis.modes.NORMAL," p", '"+p')
    vis:map(vis.modes.VISUAL," y", '"+y')
    if win.syntax == 'makefile' or win.syntax == 'go' then
        vis:command('set expandtab off')
    end
    vis:map(vis.modes.NORMAL, " fm", function()
        vis:command("open .")
        vis:feedkeys("<C-w>k")
        vis:command("wq!")
    end, "")
end)

-- modal
local modal = require('plugins/vis-modal')
-- vis-autoclose
local autoclose = require('plugins/vis-autoclose')
-- colorizer
local colorizer = require('plugins/vis-colorizer')
colorizer.three = false
colorizer.six   = true
-- complete-filename
local completefilename = require('plugins/complete-filename')
-- vis-lspc
local lsp = require('plugins/vis-lspc')
--lsp.ls_map.clangd = {
--  formatting_options = {tabSize = 2, insertSpaces = false}
--}
lsp.ls_map.lua = {
    name = 'lua-language-server',
    cmd = 'lua-language-server',
    settings = {
        Lua = {diagnostics = { globals = {'vis'}}, telemetry = {enable = false}},
    },
    formatting_options = {tabSize = 2, insertSpaces = true},
}

