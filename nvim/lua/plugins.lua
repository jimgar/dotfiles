-- set up lazy.nvim https://github.com/folke/lazy.nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- lazy assumes these come from github.
	{
		-- colour scheme
		"rebelot/kanagawa.nvim",
		config = function()
			-- make the colour scheme persist across sessions
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},
	{
		-- parsers for languages
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- these 5 are non-negotiable and must be installed: "c", "lua", "vim", "vimdoc", "query"
				ensure_installed = {
					"c",
					"go",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"query",
					"r",
					"rnoweb",
					"vim",
					"vimdoc",
				},
				build = ":TSUpdate",
				auto_install = true,
				highlight = { enable = true },
				-- module for selecting bits of code on an incremental basis
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Leader>ss",
						node_incremental = "<Leader>si",
						scope_incremental = "<Leader>sc",
						node_decremental = "<Leader>sd",
					},
				},
				-- module for acting on functions, classes, etc.
				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- these are the motions
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						},
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						include_surrounding_whitespace = true,
					},
				},
			})
		end,
	},
	{
		-- configured in treesitter above
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	{
		"neovim/nvim-lspconfig",
	},
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason-lspconfig").setup()
			require("mason-lspconfig").setup_handlers({
				function(server_name)
					local capabilities = require("cmp_nvim_lsp").default_capabilities()
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
	},
	{
		-- a dependency of telescope, vgit, neogit, neo-tree
		-- It's not a plugin that I imagine I'll ever need to work with myself.
		"nvim-lua/plenary.nvim",
	},
	{
		-- UI component library. A dependency for neo-tree
		"MunifTanjim/nui.nvim",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim", -- image support in preview window
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "auto" },
			})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer",
	},
	{
		"hrsh7th/cmp-path",
	},
	{
		"hrsh7th/cmp-cmdline",
	},
	{
		"R-nvim/cmp-r",
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"R-nvim/cmp-r",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
				}, { { name = "cmp_r" } }, {
					{ name = "buffer" },
				}),
			})

			require("cmp_r").setup({})

			-- Use buffer source for `/` and `?`
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':'
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	},
	{
		"hrsh7th/cmp-vsnip",
	},
	{
		"hrsh7th/vim-vsnip",
	},
	{
		"R-nvim/R.nvim",
		lazy = false,
		config = function()
			-- Create a table with the options to be passed to setup()
			local opts = {
				rmdchunk = 0,
				pdfviewer = "open",
				R_args = { "--quiet", "--no-save" },
				hook = {
					on_filetype = function()
						-- This function will be called at the FileType event
						-- of files supported by R.nvim. This is an
						-- opportunity to create mappings local to buffers.
						vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
						vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
					end,
				},
				min_editor_width = 72,
				rconsole_width = 78,
				disable_cmds = {
					"RClearConsole",
					"RCustomStart",
					"RSPlot",
					"RSaveClose",
				},
			}
			-- Check if the environment variable "R_AUTO_START" exists.
			-- If using fish shell, you could put in your config.fish:
			-- alias r "R_AUTO_START=true nvim"
			if vim.env.R_AUTO_START == "true" then
				opts.auto_start = 1
				opts.objbr_auto_start = true
			end
			require("r").setup(opts)
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					r = { "styler" },
					rmd = { "styler" },
					go = { "goimports" },
				},
				format_on_save = {
					timeout_ms = 2000,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		-- Plugin for commenting code
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
