{ pkgs, ... }:
{
  programs.neovim = {
    extraLuaConfig = ''
      vim.lsp.
    '';
    plugins = with pkgs.vimPlugins; [
      # LSP setup
      {
        plugin = mason-nvim;
        type = "lua";
        config = ''
          require("mason").setup()
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

      {
        plugin = mason-lspconfig-nvim;
        type = "lua";
        config = ''
          require("mason-lspconfig").setup()
        '';
      }
      nvim-treesitter-parsers.latex
      {
        plugin = render-markdown-nvim;
        type = "lua";
        config = ''
          require('render-markdown').setup({
              completions = { lsp = { enabled = true } },
          })
        '';
      }

      # automatic omnifunc - code suggestion
      luasnip
      cmp-nvim-lsp

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

    ];
  };
}
