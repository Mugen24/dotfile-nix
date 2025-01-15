{config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    extraConfig = '' 
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set number
      " set noautoindent
      " set nosmartindent
      " set nocindent
      filetype indent off


    '';
    extraLuaConfig = '' 
      vim.g.mapleader = ' '
    '' + (builtins.readFile ./terminal_modules.lua);
    plugins = with pkgs.vimPlugins; [
      {
        plugin = dracula-nvim;
        type = "lua";
        config = "
          vim.cmd[[colorscheme dracula]]
        ";
      }
      {
        plugin = nvim-treesitter;
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            ensure_installed = "all",
            parser_install_dir = "~/.config/nvim",
            highlight = {
              enable = true,
            },
          })
        '';
      }
      {
        # Shows line indent
        plugin = indent-blankline-nvim;
        type = "lua";
        config = '' 
          local highlight = {
          "RainbowRed",
          "RainbowYellow",
          "RainbowBlue",
          "RainbowOrange",
          "RainbowGreen",
          "RainbowViolet",
          "RainbowCyan",
          }

          local hooks = require "ibl.hooks"
          -- create the highlight groups in the highlight setup hook, so they are reset
          -- every time the colorscheme changes
          hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
              vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
              vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
              vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
              vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
              vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
              vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
              vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
          end)

          require("ibl").setup { indent = { highlight = highlight } }
        '';
      }

      {
        plugin = plenary-nvim;
        type = "lua";
        # config = '' ''
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require('telescope').setup({
            defaults = {
              wrap_results = true,
            }
          })
          local builtin = require('telescope.builtin')
          -- Find files
          vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
          -- Find string in Files
          vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
          vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
          vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

          vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Telescope list definition on cursor'})
          vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Telescope list references on cursor'})

          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open error under cursor'})

          vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Try to fix error with code'})
        '';
      }

      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        # config = '' ''
      }

      # LSP setup
      {
        plugin = mason-nvim;
        type = "lua";
        config = ''
          require("mason").setup()
        '';
      }

      {
        plugin = mason-lspconfig-nvim;
        type = "lua";
        config = ''
          require("mason-lspconfig").setup({
            ensure_installed = {
              "nil_ls",
              "pyright",
              "eslint",
              "ast_grep"
            }
          })
          -- Fetch default config
          -- local configs = require("lspconfig.configs")


          require("mason-lspconfig").setup_handlers({
              -- The first entry (without a key) will be the default handler
              -- and will be called for each installed server that doesn't have
              -- a dedicated handler.
              function (server_name) -- default handler (optional)
                  if server_name == "pyright" then
                    require("lspconfig")["pyright"].setup({
                      settings = {
                         python = {
                            analysis = {
                              autoSearchPaths = true,
                              diagnosticMode = "openFilesOnly",
                              useLibraryCodeForTypes = true,
                              autoImportCompletions = true,
                              typeCheckingMode = "strict",
                            }
                         }
                      }
                    })
                  else 
                    require("lspconfig")[server_name].setup {}
                  end


              end
          })
        '';
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          -- Enable inline type hint
          -- https://neovim.io/doc/user/lsp.html#_lua-module:-vim.lsp.inlay_hint
          -- vim.lsp.inlay_hint.enable(true)

        '';
      }

      # Linter
      {
        plugin = nvim-lint;
        type = "lua";
        config = ''
        require('lint').linters_by_ft = {
          nix = {'nix'},
          python = {'flake8'},
        }

        require('lint').linters.flake8.args = {
          '--doctests',
          '--max-complexity 15',
        }

        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
          callback = function()
            -- try_lint without arguments runs the linters defined in `linters_by_ft`
            -- for the current filetype
            require("lint").try_lint()
          end,
        })
        '';
      }

      # automatic omnifunc - code suggestion
      {
        plugin = luasnip;
        type = "lua";
        config = '''';
      }

      {
        plugin = cmp-nvim-lsp;
        type = "lua";
        config = '''';
      }

      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              expand = function(args) 
                require("luasnip").lsp_expand(args.body)
              end
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
              ['<C-n>'] = cmp.mapping.select_next_item({
                behavior = cmp.SelectBehavior.Select
              }),
              ['<C-p>'] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Select
              }),

            }),

            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              -- { name = 'vsnip' }, -- For vsnip users.
              { name = 'luasnip' }, -- For luasnip users.
              -- { name = 'ultisnips' }, -- For ultisnips users.
              -- { name = 'snippy' }, -- For snippy users.
              }, {
                { name = 'buffer' },
            })
          })

          local capabilities = require('cmp_nvim_lsp').default_capabilities()
          local mason_lspconfig = require('mason-lspconfig')

          -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
          local installed_server = mason_lspconfig.get_installed_servers()
          for i, v in ipairs(installed_server) do
            require('lspconfig')[v].setup {
              capabilities = capabilities
            } 
          end
          '';
      }

      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
        '';
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
          local nvim_tree = require("nvim-tree.api")
          vim.keymap.set("n", "<leader>z", nvim_tree.tree.toggle)
        '';
      }

    ];

    
    extraPackages = [
      pkgs.gcc 
      pkgs.curl
      pkgs.git
      pkgs.cargo
      pkgs.ripgrep
      pkgs.python311Packages.flake8
    ];
  };
}

# Plugins that might be interesting
# trouble.nvim: list all errors in a sidebar

