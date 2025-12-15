--- Named Layer Module
--- A wrapper around libmodal layers that tracks active layer names in vim.g.activeLayerName

local M = {}

--- Create a new named layer. The name of the layer will be available in `vim.g.activeLayerName`
--- @param name string The name to identify this layer
--- @param ... any Arguments to pass to libmodal's layer.new()
--- @return table layer The named layer object with enter() and exit() methods
function M.new(name, ...)
  local layer = require("libmodal").layer.new(...)

  local previous_layer_name = vim.g.activeLayerName

  local enter = layer.enter
  function layer:enter()
    vim.g.activeLayerName = name
    enter(self)
  end

  local exit = layer.exit
  function layer:exit()
    exit(self)
    vim.g.activeLayerName = previous_layer_name
  end

  return layer
end

--- Enter a named layer. The name of the layer will be available in `vim.g.activeLayerName`
--- @param name string The name to identify this layer
--- @param keymap table Custom key mappings for this layer
--- @param exit_char? string Optional key to exit the layer (e.g., '<Esc>')
--- @return function? exit_fn If no exit_char is provided, returns a function to manually exit the layer
function M.enter(name, keymap, exit_char)
  local layer = M.new(name, keymap, exit_char)
  layer:enter()

  if exit_char == nil then
    return function()
      layer:exit()
    end
  end

  layer:map("n", exit_char, function()
    layer:exit()
  end, {})
end

--- Get the name of the currently active layer
--- @return string? name The name of the active layer, or nil if no layer is active
function M.get_active()
  return vim.g.activeLayerName
end

--- Check if a specific layer is currently active
--- @param name string The layer name to check
--- @return boolean is_active True if the specified layer is active
function M.is_active(name)
  return vim.g.activeLayerName == name
end

return M
