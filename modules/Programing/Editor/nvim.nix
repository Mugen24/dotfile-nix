{config, pkgs, user, ...}:
{
  environment.systemPackages = with pkgs; [
      xsel
      # clip
  ];

  services.upower.enable = true;
  home-manager.users.${user} = {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
      extraConfig = '' 
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set number

        " disable safewrite https://github.com/rollup/rollup/issues/1666
        set backupcopy=yes

        " set noautoindent
        " set nosmartindent
        " set nocindent

        filetype indent off
      '';
      extraLuaConfig = '' 
        vim.g.mapleader = ' '
        vim.o.clipboard = "unnamedplus"
        vim.opt.smartindent = false
        vim.keymap.set('i', 'jj', '<Esc>')
      '' + (builtins.readFile ./terminal_modules.lua);
      plugins = with pkgs.vimPlugins; [
        {
          plugin = dracula-nvim;
          type = "lua";
          config = "
            vim.cmd[[colorscheme dracula]]
          ";
        }

        # if nvim keeps reinstalling or having problem
        # run this rm -rf ~/.local/share/nvim/*
        # https://old.reddit.com/r/neovim/comments/110x08m/treesitter_keeps_recompiling_parsers/
        # or run this to find what to remove
        # find . -name nvim

        # Remove cached file: https://github.com/folke/lazy.nvim/issues/582#issuecomment-1439540455
        
        # Needs to have parser_install_dir to be ~/.config/nvim or it will install parser every run
        # If an error occurs with smth delimiter. Run :TSUpdate first to bring the parser up-to-date with treesitter
        {
            plugin = nvim-treesitter;
            type = "lua";
            config = ''
              require('nvim-treesitter.configs').setup({
                 -- ensure_installed = "all",
                 -- has to be this
                 parser_install_dir = "~/.config/nvim",
                 highlight = {
                   enable = true,
                   disable = {"help"}
                 },
                 indent = {
                   enable = false
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
          plugin = telescope-fzf-native-nvim;
          type = "lua";
        }

        {
          plugin = telescope-file-browser-nvim;
          type = "lua";
          config = ''
            local telescope = require('telescope')
            local utils = require('telescope.utils')
            vim.keymap.set('n', '<leader>fe', telescope.extensions.file_browser.file_browser, {
              desc = "Root cwd"
            })

            vim.keymap.set('n', '<leader>fr', 
              function()
                telescope.extensions.file_browser.file_browser(
                  {
                    path=utils.buffer_dir()
                  }
                )
              end
            , {
              desc = "Root cwd"
            })
          '';
        }

        {
          plugin = telescope-nvim;
          type = "lua";
          config = ''
            require('telescope').setup({
              defaults = {
                wrap_results = true,
              },
              extensions = {
                file_browser = {
                  theme = "ivy",
                  -- disables netrw and use telescope-file-browser in its place
                  hijack_netrw = true,
                  auto_depth = 5,
                  use_fd = true,
                  mappings = {
                    ["i"] = {
                      -- your custom insert mode mappings
                    },
                    ["n"] = {
                      -- your custom normal mode mappings
                    },
                  },
                },
                
                fzf = {
                  fuzzy = true,                    -- false will only do exact matching
                  override_generic_sorter = true,  -- override the generic sorter
                  override_file_sorter = true,     -- override the file sorter
                  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                                   -- the default case_mode is "smart_case"
                },

              },
            })
            local builtin = require('telescope.builtin')
            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require('telescope').load_extension('fzf')
            local utils = require('telescope.utils')

            -- Find files
            vim.keymap.set('n', '<leader>ff', 
              function()
                builtin.find_files({
                  -- cwd=utils.buffer_dir(),
                  -- no_ignore=true
                })
              end
            , { desc = 'Telescope find files' })
            -- Find string in Files
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

            vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'Telescope list definition on cursor'})
            -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Telescope list definition on cursor'})
            vim.keymap.set('n', 'gr', builtin.lsp_references, { desc = 'Telescope list references on cursor'})

            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open error under cursor'})
            vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Try to fix error with code'})
            vim.keymap.set('n', '<leader>s', vim.lsp.buf.type_definition, { desc = 'Open signature to function'})

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

        # {
        #   plugin = nvim-tree-lua;
        #   type = "lua";
        #   config = ''
        #     require("nvim-tree").setup()
        #     local nvim_tree = require("nvim-tree.api")
        #     vim.keymap.set("n", "<leader>z", nvim_tree.tree.toggle)
        #   '';
        # }
        {
          plugin = nvim-colorizer-lua;
          type = "lua";
          config = ''
            require("colorizer").setup()
          '';
        }

        {
          plugin = nvim-treesitter-parsers.latex;
          type = "lua";
          config = ''
          '';
        }

        {
          plugin = render-markdown-nvim;
          type = "lua";
          config = ''
          require('render-markdown').setup({
            completions = { lsp = { enabled = true } },
          })
          '';
        }

        {
          plugin = nvim-dap-ui;
          type = "lua";
          config = ''
          '';
        }
        

      ];

      
      extraPackages = [

        pkgs.tree-sitter-grammars.tree-sitter-markdown
        pkgs.tree-sitter-grammars.tree-sitter-markdown-inline
        # pkgs.tree-sitter-grammars.tree-sitter-latex
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
        pkgs.python313Packages.pylatexenc

        pkgs.gcc 
        pkgs.curl
        pkgs.git
        pkgs.cargo
        pkgs.ripgrep
        pkgs.python311Packages.flake8
        pkgs.luajit
        pkgs.fd
        pkgs.shellcheck
        pkgs.shfmt
        pkgs.pyright
        pkgs.nil
        pkgs.ast-grep
        pkgs.bash-language-server

        #clipboard support
        pkgs.xsel
        # pkgs.clip
      ];
    };
  };
}

# Plugins that might be interesting
# trouble.nvim: list all errors in a sidebar

