return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		filesystem = {
			filtered_items = {
				visible = false,
				show_hidden_count = true,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_by_name = {
					".git",
					".DS_Store",
					"thumbs.db",
				},
				always_show_by_pattern = {
					"*/.dotfiles/*",
					"*/.dotfiles/*/.*",
				},
				never_show = {
					".git",
				},
			},
		},
	},
}
