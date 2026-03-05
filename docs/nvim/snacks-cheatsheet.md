# Snacks.nvim Cheatsheet

## Lazygit

| Key          | Description      |
| ------------ | ---------------- |
| `<leader>lg` | Open Lazygit     |
| `<leader>lf` | Lazygit file log |

## Explorer

| Key         | Description        |
| ----------- | ------------------ |
| `<leader>e` | Open File Explorer |

### Explorer Window Keys

| Key          | Description                  |
| ------------ | ---------------------------- |
| `l` / `<CR>` | Open file / Expand directory |
| `h`          | Close directory              |
| `<BS>`       | Go to parent directory       |
| `a`          | Add file/directory           |
| `d`          | Delete                       |
| `r`          | Rename                       |
| `c`          | Copy                         |
| `m`          | Move                         |
| `y`          | Yank path                    |
| `p`          | Paste                        |
| `o`          | Open with system app         |
| `P`          | Toggle preview               |
| `H`          | Toggle hidden files          |
| `I`          | Toggle ignored files         |
| `Z`          | Close all directories        |
| `.`          | Focus on current file        |
| `u`          | Update/Refresh               |
| `<c-c>`      | Change directory (tcd)       |
| `<leader>/`  | Grep in directory            |
| `<c-t>`      | Open terminal                |
| `]g` / `[g`  | Next/Prev git change         |
| `]d` / `[d`  | Next/Prev diagnostic         |
| `]e` / `[e`  | Next/Prev error              |
| `]w` / `[w`  | Next/Prev warning            |
| `q`          | Close explorer               |

## Picker

### Top Pickers (Quick Access)

| Key               | Description          |
| ----------------- | -------------------- |
| `<leader><space>` | Smart Find Files     |
| `<leader>,`       | Buffers              |
| `<leader>/`       | Grep                 |
| `<leader>:`       | Command History      |
| `<leader>n`       | Notification History |

### Find

| Key          | Description      |
| ------------ | ---------------- |
| `<leader>fb` | Buffers          |
| `<leader>fc` | Find Config File |
| `<leader>ff` | Find Files       |
| `<leader>fg` | Find Git Files   |
| `<leader>fp` | Projects         |
| `<leader>fr` | Recent           |

### Git

| Key          | Description      |
| ------------ | ---------------- |
| `<leader>gb` | Git Branches     |
| `<leader>gl` | Git Log          |
| `<leader>gL` | Git Log Line     |
| `<leader>gs` | Git Status       |
| `<leader>gS` | Git Stash        |
| `<leader>gd` | Git Diff (Hunks) |
| `<leader>gf` | Git Log File     |

### Grep

| Key          | Description              |
| ------------ | ------------------------ |
| `<leader>sb` | Buffer Lines             |
| `<leader>sB` | Grep Open Buffers        |
| `<leader>sg` | Grep                     |
| `<leader>sw` | Visual selection or word |

### Search

| Key          | Description            |
| ------------ | ---------------------- |
| `<leader>s"` | Registers              |
| `<leader>s/` | Search History         |
| `<leader>sa` | Autocmds               |
| `<leader>sc` | Command History        |
| `<leader>sC` | Commands               |
| `<leader>sd` | Diagnostics            |
| `<leader>sD` | Buffer Diagnostics     |
| `<leader>sh` | Help Pages             |
| `<leader>sH` | Highlights             |
| `<leader>si` | Icons                  |
| `<leader>sj` | Jumps                  |
| `<leader>sk` | Keymaps                |
| `<leader>sl` | Location List          |
| `<leader>sm` | Marks                  |
| `<leader>sM` | Man Pages              |
| `<leader>sp` | Search for Plugin Spec |
| `<leader>sq` | Quickfix List          |
| `<leader>sR` | Resume                 |
| `<leader>su` | Undo History           |
| `<leader>uC` | Colorschemes           |

### LSP

| Key          | Description           |
| ------------ | --------------------- |
| `gd`         | Go to Definition      |
| `gD`         | Go to Declaration     |
| `gr`         | Find References       |
| `gI`         | Go to Implementation  |
| `gy`         | Go to Type Definition |
| `<leader>ss` | LSP Symbols           |
| `<leader>sS` | LSP Workspace Symbols |

### Picker Window Keys

#### Input Window

| Key                   | Description               |
| --------------------- | ------------------------- |
| `<CR>`                | Confirm selection         |
| `<Esc>`               | Cancel/Close              |
| `<C-j>` / `<Down>`    | Move down                 |
| `<C-k>` / `<Up>`      | Move up                   |
| `<C-n>` / `<C-p>`     | Move down/up              |
| `<C-d>` / `<C-u>`     | Scroll list down/up       |
| `<C-f>` / `<C-b>`     | Scroll preview down/up    |
| `<Tab>`               | Select and next           |
| `<S-Tab>`             | Select and prev           |
| `<C-a>`               | Select all                |
| `<C-q>`               | Send to quickfix          |
| `<C-s>`               | Open in split             |
| `<C-v>`               | Open in vsplit            |
| `<C-t>`               | Open in new tab           |
| `<S-CR>`              | Pick window and jump      |
| `/`                   | Toggle focus (input/list) |
| `<a-p>`               | Toggle preview            |
| `<a-m>`               | Toggle maximize           |
| `<a-h>`               | Toggle hidden files       |
| `<a-i>`               | Toggle ignored files      |
| `<a-f>`               | Toggle follow             |
| `<a-r>`               | Toggle regex              |
| `<a-w>`               | Cycle windows             |
| `<a-d>`               | Inspect item              |
| `<C-Up>` / `<C-Down>` | History back/forward      |
| `?`                   | Toggle help               |
| `gg` / `G`            | Go to top/bottom          |

#### List Window

| Key                | Description              |
| ------------------ | ------------------------ |
| `<CR>`             | Confirm                  |
| `j` / `k`          | Move down/up             |
| `i`                | Focus input              |
| `zz` / `zt` / `zb` | Scroll center/top/bottom |

## Dashboard

| Key | Description      |
| --- | ---------------- |
| `e` | New file         |
| `f` | Find file        |
| `g` | Find text (grep) |
| `r` | Recent files     |
| `n` | File explorer    |
| `s` | Restore session  |
| `q` | Quit             |
