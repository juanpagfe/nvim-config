return {
    {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")

        -- Install parsers (no-op if already installed)
        ts.install({
            "c", "lua", "vim", "vimdoc", "javascript", "typescript",
            "python", "rust", "html", "go", "toml", "markdown", "json",
            "yaml", "bash"})

        -- Enable treesitter highlighting and indentation via FileType autocmd
        vim.api.nvim_create_autocmd("FileType", {
            callback = function(ev)
                local buf = ev.buf
                local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

                -- Skip highlighting for html
                if lang == "html" then
                    return
                end

                -- Skip large files for performance
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    vim.notify(
                        "File larger than 100KB treesitter disabled for performance",
                        vim.log.levels.WARN,
                        {title = "Treesitter"}
                    )
                    return
                end

                -- Enable treesitter highlighting
                pcall(vim.treesitter.start, buf, lang)

                -- Enable treesitter-based indentation
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })

        -- Enable additional vim regex highlighting for markdown
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown" },
            callback = function()
                vim.bo.syntax = "on"
            end,
        })

        -- Register custom templ parser
        require("nvim-treesitter.parsers").templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")
    end
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require'treesitter-context'.setup{
                enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                multiwindow = false, -- Enable multiwindow support.
                max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to show for a single context
                trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
                separator = nil,
                zindex = 20, -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    }
}
