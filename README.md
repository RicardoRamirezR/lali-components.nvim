# Laravel / Livewire Components

<p align="center">
    <a href="https://dotfyle.com/plugins/RicardoRamirezR/lali-components.nvim">
        <img src="https://dotfyle.com/plugins/RicardoRamirezR/lali-components.nvim/shield" />
    </a>
</p>


![lali](https://github.com/RicardoRamirezR/lali-components.nvim/assets/6526545/62b8227d-8b25-4bf7-b755-6b0d6c1a39f4)

## Features

### 1. Navigating to Components with `gf`

Using the `gf` command on certain component names in your code will open the corresponding component file. This feature works with the following patterns:
- `<x-name>`
- `@extends('name')`
- `@include('name')`
- `<livewire:name>`
- `@livewire('name')`

If the component has an associated class, you will be prompted to choose which one to open.

### 2. Autocompletion with `nvim-cmp`

When using the Neovim completion plugin (`nvim-cmp`), suggestions for relevant components will appear as you type the following prefixes:
- `<x-`
- `@extends`
- `@include`
- `<live`
- `@livewire`

## Setup

To get started with `lali-components.nvim`, add the plugin to your `init.lua` or `init.vim` file:

**Using packer**:

```lua
use 'ricardoramirezr/lali-components.nvim'
```
    
**Using lazy**:

```lua
{ 'ricardoramirezr/lali-components.nvim' }
```

## Usage

1. **Navigating to Components**:
    Place your cursor on the component name and press `gf`. If the component has multiple classes, you will be prompted to choose which one to open.

2. **Autocompletion**:
    Start typing the component prefix (`<x-`, `@extends`, etc.) and `nvim-cmp` will suggest the relevant components. Select from the suggestions to complete your component names quickly.

## Example

Here is an example to illustrate the usage of the plugin:

```blade
<!-- Blade Template Example -->
<x-button>Click Me</x-button>

@extends('layouts.app')

@include('partials.header')

<livewire:counter />
@livewire('counter')
```

In the example above, you can:

- Place your cursor on <x-button>, @extends('layouts.app'), @include('partials.header'), <livewire:counter />, or @livewire('counter') and press gf to navigate to the respective component file.
- Start typing <x-, @extends, @include, <live, or @livewire to get autocompletion suggestions from nvim-cmp.

## Contributing

Contributions are welcome! Please submit issues and pull requests to the GitHub repository.

## License

This plugin is open-source and distributed under the MIT License.

