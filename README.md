# Laravel / Livewire Components

Using the **gf** command on a component name like ```<x-name``` or ```<livewire:name``` will open the component itself. If it has a class, you will need to choose which one to open.

When using **cmp**, as you write ```<x-``` or ```<live```, nvim-cmp will suggest the relevant components.

Install using [Lazy](https://github.com/folke/lazy.nvim):
```lua
return {
  "ricardoramirezr/lali-components.nvim",
  dependencies = {
    'hrsh7th/nvim-cmp'
  },
  version = false,
  ft = "blade",
  config = function()
    require("lali-components").setup()
  end,
}
```

