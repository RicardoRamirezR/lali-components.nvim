# Laravel / Livewire Components

![lali](https://github.com/RicardoRamirezR/lali-components.nvim/assets/6526545/d6ef2508-8910-4162-83c7-be0954991581)

Using the **gf** command on a component name like ```<x-name```, ```@extends('name')```, ```@include('name')```, ```<livewire:name``` or ```@livewire('name')``` will open the component itself. If it has a class, you will need to choose which one to open.

When using **cmp**, as you write ```<x-```, ```@extends```, ```@include```, ```<live``` or ```@livewire``` nvim-cmp will suggest the relevant components.

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

