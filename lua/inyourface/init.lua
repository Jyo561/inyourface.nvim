local M = {}

local state = {
  buf = nil,
  win = nil,
  active = false,
}

-- Get number of diagnostics
local function get_error_count()
  return #vim.diagnostic.get(0)
end

-- Map error count → face + message
local function get_face(count)
  if count == 0 then
    return "happy.txt", "😎 Perfect code."
  elseif count < 5 then
    return "normal.txt", "🙂 Minor issues."
  elseif count < 15 then
    return "angry.txt", "😡 Fix your code."
  else
    return "uncanny.txt", "💀 This is unacceptable."
  end
end

-- Render ASCII window
local function render()
  local count = get_error_count()
  local file, message = get_face(count)

  local path = vim.fn.expand("~/.config/nvim/faces/" .. file)
  local lines = vim.fn.readfile(path)

  table.insert(lines, "")
  table.insert(lines, "👉 " .. message)

  -- Create buffer if needed
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end

  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  local width = math.min(50, vim.o.columns - 5)
  local height = math.min(100, vim.o.lines - 5)

  -- Create or update window
  if not state.win or not vim.api.nvim_win_is_valid(state.win) then
    state.win = vim.api.nvim_open_win(state.buf, false, {
      relative = "editor",
      width = width,
      height = height,
      row = 1,
      col = vim.o.columns - 70,
      style = "minimal",
      border = "rounded",
    })
  else
    vim.api.nvim_win_set_config(state.win, {
      relative = "editor",
      width = width,
      height = height,
      row = 1,
      col = vim.o.columns - 70,
    })
  end
end

-- Close window
local function close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
  state.buf = nil
end

-- Toggle plugin
function M.toggle()
  if state.active then
    close()
    state.active = false
    return
  end

  state.active = true
  render()
end

-- Setup function
function M.setup()
  -- Command
  vim.api.nvim_create_user_command("InYourFace", function()
    M.toggle()
  end, {})

  -- Update when diagnostics change
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      if state.active then
        render()
      end
    end,
  })

  -- Fix position on resize
  vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      if state.active and state.win then
        vim.api.nvim_win_set_config(state.win, {
          col = vim.o.columns - 70,
        })
      end
    end,
  })
end

return M   
