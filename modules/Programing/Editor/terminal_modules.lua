local window_h = vim.fn.winheight("0") / 3

local terminals = {}
local curr_term = nil

-- To delete buffer use bdelete buff_name/number
-- TODO: rework this into an event listener
local toggle = false

function CreateTerm()
    vim.cmd(string.format("rightb %ssplit term://zsh", window_h))
end

function CloseTerm()
    if vim.fn.winnr("$") > 1 then
        vim.cmd.close()
    end
end

function AddTerm()
    CreateTerm()
    curr_term = vim.fn.bufname("$")
    table.insert(terminals, curr_term)
end

function OpenTerm()
    if table.getn(terminals) == 0 then
        AddTerm()
    else
        vim.cmd(string.format("rightb %ssplit %s", window_h, curr_term))
    end
end


vim.keymap.set("t", "<c-t>", function ()
    CloseTerm()
    AddTerm()
    vim.cmd.startinsert()
end)

vim.keymap.set("t", "<c-x>", function()
    -- NOTE passing 0 doesn't work 
    local deletedBuf = vim.fn.bufname("%")
    local bufHandle = vim.fn.bufnr(deletedBuf)

    local deletedBufIndex = nil
    -- Delete buff from terminals
    for i, bufName in ipairs(terminals) do
        if bufName == deletedBuf then
            deletedBufIndex = i
            break
        end
    end

    if deletedBufIndex == nil then
        vim.print("Cannot find deletedBuf in term")
        vim.print(deletedBuf)
        vim.print(terminals)
        return
    else
        table.remove(terminals, deletedBufIndex)
    end
    --
    -- Get buff from buf list
    if bufHandle == -1 then
        print("Cannot find deletedBuf in ls buf")
        vim.print(bufHandle)
        vim.print(terminals)
        return
    else
        vim.api.nvim_win_close(0, true)
        if deletedBufIndex > 1 then
            curr_term = terminals[deletedBufIndex - 1]
            OpenTerm()
        else
            toggle = false
        end
    end

end)


vim.keymap.set({"n", "t"}, "\\",
    function ()
        if toggle == false then
            toggle = true
            OpenTerm()
            vim.cmd.startinsert()
            vim.print("h", toggle)
            vim.print("false ->", toggle)
        elseif toggle == true then
            toggle = false
            CloseTerm()
            vim.print("h", toggle)
            vim.print("true ->", toggle)
        end
    end,
    {
        desc = "Invoke terminal"
    }
)

----------------------------
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local bufferPreviewer = previewers.new_buffer_previewer({
    define_preview = function(self, entry, status)
      local buf_handle = vim.fn.bufnr(entry[1])
      local content = vim.api.nvim_buf_get_lines(buf_handle, -50, -1, false)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 50, false, content)
      --local last_line = vim.fn.line("$")
      --vim.api.nvim_win_set_cursor(win_handler[1], {60, 100})
    end
})

local bufferPicker = function(opts)
    opts = opts or {}
    opts.sorting_strategy = "descending"

    pickers.new(opts, {
        prompt_title = "Terminals",
        finder = finders.new_table({
            results = terminals
        }),
        sorter = conf.generic_sorter(opts),
        previewer = bufferPreviewer,
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)

            local selection = action_state.get_selected_entry()
            vim.print(selection)
            if selection == nil then
                return
            end

            if selection[1] == nil then
                vim.print("nil selection")
                return
            else
                vim.print("running")
                CloseTerm()
                curr_term = selection[1] -- Get buff name
                OpenTerm()
            end

          end)
          return true
        end,
    }):find()
end

vim.keymap.set("t", "<leader>o", function ()
    bufferPicker()
end)


