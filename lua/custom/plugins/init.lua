-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	build = function()
	-- 		vim.fn["mkdp#util#install"]()
	-- 	end,
	-- 	config = function()
	-- 		vim.g.mkdp_browser = "/usr/bin/vivaldi"
	-- 	end,
	-- 	ft = { "markdown" },
	-- },

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	-- {
	-- 	-- amongst your other plugins
	-- 	"akinsho/toggleterm.nvim",
	-- 	version = "*",
	-- 	config = true,
	-- 	-- or
	-- },
	{
		"eandrju/cellular-automaton.nvim",
	},
}
