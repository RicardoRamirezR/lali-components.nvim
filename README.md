# Laravel / Livewire Components

<p>
    <a href="https://dotfyle.com/plugins/RicardoRamirezR/lali-components.nvim">
        <img src="https://dotfyle.com/plugins/RicardoRamirezR/lali-components.vim/shield" />
    </a>
</p>

![lali](https://github.com/RicardoRamirezR/lali-components.nvim/assets/6526545/62b8227d-8b25-4bf7-b755-6b0d6c1a39f4)

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

