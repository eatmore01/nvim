# nvim 

Personal Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim), tuned for DevOps work
(Terraform, Kubernetes/YAML, Go, Bash, Docker).

```bash
brew install ripgrep fd node yamllint tree-sitter-cli
```

## Structure

```
init.lua               -- options, base keymaps, entry point
lua/replace.lua         -- custom "replace from cursor to EOF" command (not a plugin spec)
lua/plugins/*.lua       -- one file per plugin/feature, loaded via require("lazy").setup("plugins")
lazy-lock.json          -- pinned plugin commits (auto-managed by lazy.nvim, don't hand-edit)
```

Leader key is `<Space>`.

Window-local `cwd` follows the current buffer's repo root (nearest `.git`/`.terraform`,
via `vim.fs.root()` on `BufReadPost`/`BufNewFile` in `init.lua`). This keeps Telescope,
`tflint`/`yamllint` (both resolve their target/config relative to `cwd`, not the buffer's
directory), and nvim-tree scoped to whichever repo you're actually editing — important
once you're bouncing between multiple repos (terraform modules, k8s manifests, go
services, ...) in one session instead of one repo per Neovim instance.

## Keymaps

### General

| Key | Mode | Action |
|---|---|---|
| `<C-b>` | n | Toggle file tree (NvimTree) |
| `<S-l>` | n | Clear search highlight |
| `<A-j>` / `<A-k>` | n | Move current line down / up |
| `<Tab>` / `<S-Tab>` | v | Indent / unindent selection |
| `<leader>w` | n | Write file |
| `J` | n | Disabled (no-op) |

### Delete/change without clobbering the register

`d`, `dd`, `D`, `c`, `C`, `x` are remapped to the black-hole register (`"_`) in normal/visual mode,
so deleting/changing text never overwrites what you last yanked. Use explicit registers
(`"ayy`, `"ap`, ...) when you actually want to store something.

### Buffers (bufferline)

| Key | Action |
|---|---|
| `<leader>1`..`<leader>5` | Go to buffer 1-5 |
| `<leader>b` | Pick buffer |
| `<leader>d` | Close all other buffers |
| `<leader>q` | Close current buffer (safe, via `Bdelete`) |

### Search & replace

| Key | Action |
|---|---|
| `<leader>c` | Prompt-based replace, current line to end of file (`lua/replace.lua`) — asks for pattern, then replacement, runs `.,$s/.../.../gc` with per-match confirm |

For project-wide (multi-file) search/replace, use Telescope live grep (`<leader>fg`) to build a
quickfix list, then `:cdo s/.../.../gc | update`.

### Telescope (fuzzy finder)

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | List open buffers |
| `<leader>fh` | Help tags |
| `<leader>gs` | Git status |

Sorting uses `telescope-fzf-native.nvim` (native C sorter) when it's built successfully;
silently falls back to Telescope's default lua sorter otherwise (`pcall`-wrapped
`load_extension`).

### Git / diff review (diffview.nvim)

| Key | Action |
|---|---|
| `<leader>gd` | Diff current tree against HEAD |
| `<leader>gh` | File history for the current file (`DiffviewFileHistory %`) |

Lazy-loaded on `:DiffviewOpen`/`:DiffviewFileHistory`.

### Sessions (persistence.nvim)

| Key | Action |
|---|---|
| `<leader>ps` | Restore session for the current directory |
| `<leader>pl` | Restore the last session (any directory) |
| `<leader>pd` | Don't save a session on this exit (one-off) |

Session is saved automatically on exit (per-`cwd`), no extra config needed.

### LSP (buffer-local, set on `LspAttach`)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | List references |
| `K` | Hover, or line diagnostics if any are present on the current line |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |

### Formatting & linting

| Key | Action |
|---|---|
| `<leader>fmt` | Format buffer/selection (conform.nvim, falls back to LSP formatter) |

Format-on-save is enabled for all `formatters_by_ft` filetypes below. Linting runs automatically
on write/read via `nvim-lint`.

| Filetype | Formatter | Linter |
|---|---|---|
| yaml/yml | yamlfmt | yamllint |
| sh/bash | shfmt | shellcheck |
| go | goimports, gofumpt | golangci-lint |
| terraform/hcl/tf | terraform fmt | tflint |
| json | prettier | - |
| lua | stylua | - |

### YAML schema picker (yamlls)

`yamlls` auto-detects `.gitlab-ci.yml` and any YAML with a `kind:`/`apiVersion:` (Kubernetes) and
attaches the matching schema on `BufReadPost` automatically. You can also drive it manually:

| Key / Command | Action |
|---|---|
| `<leader>y` | Pick a schema (Kubernetes / GitLab CI) via `vim.ui.select` |
| `<leader>yy` | Show which schema(s) are currently active for the buffer |
| `:YamlSchemaK8s` | Force Kubernetes schema (uses `kind`/`apiVersion` in the buffer to pick the exact schema variant) |
| `:YamlSchemaGitlab` | Force GitLab CI schema |

## Plugins

- **lazy.nvim** — plugin manager
- **mason.nvim** / **mason-lspconfig** / **mason-tool-installer** — install LSPs, formatters, linters
- **nvim-lspconfig** — LSP client config (yamlls, bashls, gopls, terraformls, lua_ls, jsonls, dockerls)
- **nvim-treesitter** (branch `main`) — syntax highlighting/indent for hcl, terraform, yaml, go, dockerfile, bash, json, lua, markdown. Uses the rewritten `main`-branch API (`require("nvim-treesitter").install{...}` + a `FileType` autocmd calling `vim.treesitter.start()`/setting `indentexpr` — the old `.configs.setup({highlight=...})` API is gone on this branch). Requires the `tree-sitter` CLI (`brew install tree-sitter-cli`) on `$PATH` to compile parsers.
- **conform.nvim** — formatting
- **nvim-lint** — linting
- **nvim-cmp** + **LuaSnip** — completion/snippets
- **telescope.nvim** (+ **telescope-fzf-native.nvim**) — fuzzy finder
- **nvim-tree.lua** — file explorer
- **bufferline.nvim** — buffer tabs
- **lualine.nvim** — statusline (mode, git branch/diff, diagnostics, filename, filetype, LSP client, location)
- **mini.comment** — commenting
- **diffview.nvim** — diff/PR-style review inside nvim
- **persistence.nvim** — per-directory session save/restore

## Known external dependencies

Some tools are installed outside Mason because Mason's package requires a newer runtime than the
system default:

- **yamllint** — install via `brew install yamllint` (Mason's package needs Python ≥3.10; macOS
  system Python is 3.9.6). Not in `mason-tool-installer`'s `ensure_installed` for this reason.
- **node** — install via `brew install node` required on `$PATH` for four of the Mason-installed LSPs: `yamlls`, `bashls`,
  `dockerls`, `jsonls` (all npm packages under the hood). Without it they fail to spawn
  (`Client <name> quit with exit code 127`), and since the buffer-local `K` mapping in
  `lsp.lua` is only set inside the `LspAttach` autocmd, diagnostics/hover via `K` silently do
  nothing on those filetypes too. Install with `brew install node`. `gopls`, `terraformls`, and
  `lua_ls` don't need it.
- **tree-sitter-cli** — install via `brew install tree-sitter-cli`. `brew install tree-sitter`
  only gets you `libtree-sitter` (the C library); the `tree-sitter` *command*, which
  nvim-treesitter's `main` branch shells out to for compiling every parser, is a separate
  formula. Without it: `error: Error during "tree-sitter build": ... ENOENT ... 'tree-sitter'`
  on every parser, no syntax highlighting for any filetype.
