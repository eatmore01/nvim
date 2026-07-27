# nvim config

Personal Neovim config built on [lazy.nvim](https://github.com/folke/lazy.nvim), tuned for DevOps work
(Terraform, Kubernetes/YAML, Go, Bash, Docker).

## Structure

```
init.lua               -- options, base keymaps, entry point
lua/replace.lua         -- custom "replace from cursor to EOF" command (not a plugin spec)
lua/plugins/*.lua       -- one file per plugin/feature, loaded via require("lazy").setup("plugins")
lazy-lock.json          -- pinned plugin commits (auto-managed by lazy.nvim, don't hand-edit)
```

Leader key is `<Space>`.

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
- **nvim-treesitter** (branch `master`) — syntax highlighting/indent for hcl, terraform, yaml, go, dockerfile, bash, json, lua, markdown
- **conform.nvim** — formatting
- **nvim-lint** — linting
- **nvim-cmp** + **LuaSnip** — completion/snippets
- **telescope.nvim** — fuzzy finder
- **nvim-tree.lua** — file explorer
- **bufferline.nvim** — buffer tabs
- **lualine.nvim** — statusline (mode, git branch/diff, diagnostics, filename, filetype, LSP client, location)
- **mini.comment** — commenting

## Known external dependencies

Some tools are installed outside Mason because Mason's package requires a newer runtime than the
system default:

- **yamllint** — install via `brew install yamllint` (Mason's package needs Python ≥3.10; macOS
  system Python is 3.9.6). Not in `mason-tool-installer`'s `ensure_installed` for this reason.
- **yaml-language-server** — needs `node` on `$PATH`. If `yamlls` fails to attach, check `node -v`
  works in the shell Neovim was launched from.
