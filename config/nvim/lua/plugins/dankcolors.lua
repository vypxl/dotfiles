return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#11140f',
				base01 = '#11140f',
				base02 = '#81887e',
				base03 = '#81887e',
				base04 = '#d3dccf',
				base05 = '#fafff8',
				base06 = '#fafff8',
				base07 = '#fafff8',
				base08 = '#ffb29f',
				base09 = '#ffb29f',
				base0A = '#bfe7ab',
				base0B = '#a8fba3',
				base0C = '#e8ffdc',
				base0D = '#bfe7ab',
				base0E = '#dbffc8',
				base0F = '#dbffc8',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#81887e',
				fg = '#fafff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#bfe7ab',
				fg = '#11140f',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#81887e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e8ffdc', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#dbffc8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#bfe7ab',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#bfe7ab',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e8ffdc',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a8fba3',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d3dccf' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d3dccf' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#81887e',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
