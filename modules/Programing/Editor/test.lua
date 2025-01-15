local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

local buf = {
    "test.lua",
    "~/.config/home-manager/Programing/Editor/terminal_modules.lua"
}

-- our picker function: colors
local test = vim.cmd.ls()
vim.print(test)

local previewer = require("telescope.previewers").new_buffer_previewer({
    define_preview = function(self, entry, status)
      local buf_handle = vim.fn.bufnr(entry[1])
      local content = vim.api.nvim_buf_get_lines(buf_handle, -50, -1, false)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 50, false, content)
      --local last_line = vim.fn.line("$")

      --vim.api.nvim_win_set_cursor(win_handler[1], {60, 100})
    end
})


local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = buf
    },
    previewer = previewer,
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
colors()
