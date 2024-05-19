-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- surround lines when scrolling.
-- cursor will always be centred with a value of 999
vim.opt.scrolloff = 999

-- where new windows will open
vim.opt.splitbelow = true
vim.opt.splitright = true

-- insert x spaces when tab is pressed
vim.opt.expandtab = true
-- number of spaces to use for each step of indentation
vim.opt.shiftwidth = 4
-- length of tab as number of spaces when file is saved
-- vim.opt.tabstop = 4

-- sync with system clipboard
vim.opt.clipboard = "unnamedplus"

-- h: 'virtualedit'
-- "Virtual editing means that the cursor can be positioned where there is no actual character"
vim.opt.virtualedit = "block"

-- preview :%s commands in a split pane
-- brilliant for when changes are spread throughout a file, as it displays them close together for preview
vim.opt.inccommand = "split"

-- useful for e.g. searching commands, or within a file.
-- for ex. commands in plugins must start with a capital letter,
-- whereas built-in commands always start with a lowercase.
-- I may not remember (or know) where a command is from, so this setting is helpful
vim.opt.ignorecase = true
-- "Override the 'ignorecase' option if the search pattern contains upper case characters."
vim.opt.smartcase = true

-- access to colours from terminal system
vim.opt.termguicolors = true
-- adds highlight bar to cursor line
vim.opt.cursorline = true

vim.g.mapleader = " "
