{ pkgs, ... }:
{
  home.packages = [
    pkgs.pyright
  ];
  programs.neovim = {
    extraLuaConfig = ''
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
                behavior = cmp.SelectBehavior.Insert
              }),
              ['<C-p>'] = cmp.mapping.select_prev_item({
                behavior = cmp.SelectBehavior.Insert
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

        '';
      }

    ];

    extraPackages = [
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

        #install npm for mason
        pkgs.nodejs_22
    ];
  };
}
