# InYourFace.nvim 😈

A fun Neovim plugin that reacts to your code quality using ASCII Mr. Incredible.

## Features

- Shows face based on errors
- Works with LSP diagnostics
- Floating window UI

## Installation (lazy.nvim)

```lua
{
  "yourname/inyourface.nvim",
  config = function()
    require("inyourface").setup()
  end,
}
```

## Usage
```
:InYourFace
```

## Requirements
- Neovim 0.9+
- LSP (rust-analyzer, etc.)


## Setup

- Place ASCII files in:

```
~/.config/nvim/faces/
```

## LICENSE

Create:

```text
MIT License
```
