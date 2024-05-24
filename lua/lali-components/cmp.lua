-- Custom nvim-cmp source for Laravel components

local Lali = {}

local registered = false

Lali.setup = function()
  if registered then
    return
  end

  registered = true

  local has_cmp, cmp = pcall(require, "cmp")

  if not has_cmp then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, { __index = source })
  end

  source.get_trigger_characters = function()
    return { "<x-", "<liv" }
  end

  local function get_laravel_components(prefix)
    local components = {}

    local components_dir = "resources/views/components/"
    if prefix == "<livewire:" then
      components_dir = "resources/views/livewire/"
    end

    local handle = io.popen("find " .. components_dir .. " -type f")

    for filename in handle:lines() do
      local component_name = filename:match(components_dir .. "(.+)")
      if component_name then
        component_name = component_name:gsub("^/", ""):gsub("%.blade%.php$", "")
        component_name = prefix .. component_name:gsub("/", ".")
        table.insert(components, { label = component_name })
      end
    end

    handle:close()

    return components
  end

  source.complete = function(_, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = nil

    if vim.startswith(input, "<x-") then
      prefix = "<x-"
    end
    if vim.startswith(input, "<live") then
      prefix = "<livewire:"
    end

    if prefix then
      local items = {}
      local larave_components = get_laravel_components(prefix)

      for _, component in ipairs(larave_components) do
        table.insert(items, {
          filterText = component.label,
          label = component.label,
          textEdit = {
            newText = component.label .. " />",
            range = {
              start = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1 - #input,
              },
              ["end"] = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1,
              },
            },
          },
        })
      end
      callback({
        items = items,
        isIncomplete = true,
      })
    else
      callback({ isIncomplete = true })
    end
  end

  local current_sources = cmp.get_config().sources
  local new_sources = {}

  table.insert(new_sources, { name = "components" })
  for _, current_source in ipairs(current_sources) do
    table.insert(new_sources, current_source)
  end

  cmp.register_source("components", source.new())
  cmp.setup.filetype("blade", {
    sources = cmp.config.sources(new_sources),
  })
end

return Lali
