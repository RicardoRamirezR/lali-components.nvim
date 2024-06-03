-- Custom opener for Laravel components

local M = {}
local rhs

local registered = false

local function has_telescope()
  return pcall(require, "telescope")
end

local function component_picker_telescope(opts, options)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  opts = opts or {}

  pickers
      .new(opts, {
        prompt_title = "Select Component File",
        finder = finders.new_table(options),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(bufnr, _)
          actions.select_default:replace(function()
            actions.close(bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("edit " .. selection[1]:gsub("^%d+%.%s*", ""))
          end)

          return true
        end,
      })
      :find()
end

local function component_picker_native(options)
  local choice_str = "Choose a file:\n"
  for _, option in ipairs(options) do
    choice_str = choice_str .. option .. "\n"
  end

  local choice = vim.fn.input(choice_str .. "Enter number: ")
  local index = tonumber(choice)
  if index and options[index] then
    vim.cmd("edit " .. options[index]:gsub("^%d+%.%s*", ""))
  else
    print("Invalid choice")
  end
end

local function component_picker(options)
  if has_telescope() then
    component_picker_telescope(require("telescope.themes").get_dropdown({}), options)
  else
    component_picker_native(options)
  end
end

local function get_keymap_rhs(mode, lhs)
  local mappings = vim.api.nvim_get_keymap(mode)
  for _, mapping in ipairs(mappings) do
    if mapping.lhs == lhs then
      return mapping.rhs:gsub("<[lL][tT]>", "<")
    end
  end

  return nil
end

local function starts_with(str, prefix)
  return string.sub(str, 1, string.len(prefix)) == prefix
end

local function remove_prefix(str, prefix)
  if str:sub(1, #prefix) == prefix then
    return str:sub(#prefix + 1)
  else
    return str
  end
end

local function capitalize(name)
  return name:gsub("(%a)([^/]*)", function(first, rest)
    return first:upper() .. rest
  end)
end

local function get_prefix(component_name, prefix_map)
  local prefix

  for key, _ in pairs(prefix_map) do
    if starts_with(component_name, key) then
      prefix = key
      break
    end
  end

  return prefix
end

local function get_component_type_and_name()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local start_word = line:sub(1, col + 1):match("()[-%w]+$")

  if not start_word then
    print("No word found")
    return
  end

  local start_select = line:sub(1, start_word - 1):match(".*()[<@]")

  if not start_select then
    return
  end

  local end_select = line:find("%s", col + 1)

  if not end_select then
    end_select = #line + 1
  end

  local selected_text = line:sub(start_select + 1, end_select - 1)
  return selected_text
end

local function laravel_component(component_name)
  return {
    "resources/views/components/" .. component_name .. ".blade.php",
    "app/View/Components/" .. capitalize(component_name) .. ".php",
  }
end

local function laravel_view(component_name)
  component_name = component_name:gsub("['()%)]", "")
  return {
    "resources/views/" .. component_name .. ".blade.php",
    nil,
  }
end

local function livewire_component(component_name)
  component_name = component_name:gsub("['()%)]", "")
  return {
    "resources/views/livewire/" .. component_name .. ".blade.php",
    "app/Http/Livewire/" .. capitalize(component_name) .. ".php",
  }
end

local function get_paths(component_name)
  local prefix_map = {
    ["extends("] = laravel_view,
    ["include("] = laravel_view,
    ["livewire("] = livewire_component,
    ["livewire:"] = livewire_component,
    ["x-"] = laravel_component,
  }
  local prefix = get_prefix(component_name, prefix_map)
  if prefix then
    component_name = remove_prefix(component_name, prefix)
    return prefix_map[prefix](component_name)
  end
end

local function exec_native_gf(cfile)
  if rhs then
    rhs = rhs:gsub("<[cC][fF][iI][lL][eE]>", cfile)
    rhs = rhs:gsub("<[cC][rR]>", "")
    vim.cmd(rhs)
  else
    vim.fn.execute("normal! gf")
  end
end

function M.gf(cfile)
  if not vim.bo.filetype:find("blade", 1, true) then
    exec_native_gf(cfile)
    return
  end

  local component_name = get_component_type_and_name()

  if not component_name then
    return exec_native_gf(cfile)
  end

  local prefix_map = {
    ["extends("] = true,
    ["include("] = true,
    ["livewire("] = true,
    ["livewire:"] = true,
    ["x-"] = true,
  }

  local prefix = get_prefix(component_name, prefix_map)

  if not prefix then
    return exec_native_gf(cfile)
  end

  component_name = string.gsub(component_name, "%.", "/")

  local file_path, class_path = unpack(get_paths(component_name))
  local choices = {}

  if vim.fn.filereadable(file_path) == 1 then
    table.insert(choices, "1. " .. file_path)
  end

  if vim.fn.filereadable(class_path) == 1 then
    table.insert(choices, "2. " .. class_path)
  end

  if #choices <= 1 then
    vim.cmd("edit " .. file_path)
    return
  end

  if #choices == 2 then
    component_picker(choices)
    return
  end

  exec_native_gf()
end

M.setup = function()
  if registered then
    return
  end

  registered = true

  rhs = get_keymap_rhs("n", "gf")

  vim.keymap.set("n", "gf", function()
    local cfile = vim.fn.expand("<cfile>")
    M.gf(cfile)
  end, { noremap = true, silent = true })
end

return M
