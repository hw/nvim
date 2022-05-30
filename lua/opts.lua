local opt = vim.opt
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

opt.syntax = "ON"
opt.number = true
opt.cursorline = true
opt.signcolumn = "yes:2"

opt.list = true
opt.listchars:append("trail:·")
opt.listchars:append("tab:▸ ")
opt.listchars:append("eol:↴")

opt.clipboard = 'unnamed'
opt.completeopt = "menuone,noinsert,noselect"
opt.wildmenu = true

opt.mouse = 'a'
vim.g.t_co = 256
