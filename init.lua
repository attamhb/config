local set = vim.opt

set.background = "dark"
set.clipboard = "unnamedplus"
set.completeopt = "noinsert,menuone,noselect"
set.expandtab = true
set.foldexpr = "nvim_treesitter#foldexpr()"
set.foldmethod = "manual"
set.hidden = true
set.inccommand = "split"
set.mouse = "a"
set.number = true
set.relativenumber = true
set.shiftwidth = 4
set.smarttab = true
set.splitbelow = true
set.splitright = true
set.swapfile = false
set.tabstop = 4
set.termguicolors = true
set.title = true
set.ttimeoutlen = 0
set.updatetime = 250
set.wildmenu = true
set.wrap = true
set.showmode = false

vim.cmd([[
  filetype plugin indent on
  syntax on
]])


function LineNumberColors()
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#696889', bold=false })
    vim.api.nvim_set_hl(0, 'LineNr', { fg='#66cdaa', bold=false })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#696889', bold=false })
end


LineNumberColors()
set.laststatus=0

