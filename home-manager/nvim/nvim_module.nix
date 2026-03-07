{lib, config, pkgs, ...}:
{
    options.nvim = {
        enable = lib.mkEnableOption "Enable";
    };

    config = lib.mkIf config.nvim.enable {
        programs.neovim = { 
            enable = true;
            vimAlias = true;
            defaultEditor = true;
            extraLuaConfig = '' 
                vim.g.mapleader = ' '
                vim.o.clipboard = "unnamedplus"
                vim.opt.smartindent = false 
                vim.keymap.set('i', 'jj', '<Esc>') 

                vim.o.tabstop = 4 
                vim.o.shiftwidth = 4 
                vim.o.expandtab = true
                vim.o.number = true
            '';
            plugins = with pkgs.vimPlugins; [ 
                plenary-nvim
                telescope-fzf-native-nvim
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
                    plugin = nvim-dap-ui;
                    type = "lua";
                    config = ''
                    '';
                }

                {
                    plugin = guess-indent-nvim;
                    type = "lua";
                    config = ''
                    '';
                }

                {
                    plugin = multicursor-nvim;
                    type = "lua";
                    config = ''
                        local mc = require("multicursor-nvim").setup()
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