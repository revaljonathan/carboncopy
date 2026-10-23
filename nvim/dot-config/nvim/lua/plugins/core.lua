return {
    -- ── Shared dependencies ────────────────────────────────────────────────
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ── Treesitter ─────────────────────────────────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        init = function()
            vim.filetype.add({ extension = { goon = "goon" } })
        end,
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({})

            -- Install desired parsers asynchronously
            local parsers = {
                "c", "lua", "vim", "vimdoc", "query",
                "go", "javascript", "nix", "php", "rust",
                "zig", "java", "python", "bash",
                "markdown", "markdown_inline",
            }
            pcall(ts.install, parsers)

            -- Enable treesitter highlighting automatically for supported buffers
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })

            -- Textobjects configuration (compatible with nvim-treesitter rewrite)
            local ok_to, textobjects = pcall(require, "nvim-treesitter-textobjects")
            if ok_to then
                textobjects.setup({
                    select = {
                        lookahead = true,
                    },
                })

                local select_to = require("nvim-treesitter-textobjects.select")
                vim.keymap.set({ "x", "o" }, "af", function()
                    select_to.select_textobject("@function.outer", "textobjects")
                end, { desc = "Select outer function" })
                vim.keymap.set({ "x", "o" }, "if", function()
                    select_to.select_textobject("@function.inner", "textobjects")
                end, { desc = "Select inner function" })
                vim.keymap.set({ "x", "o" }, "ac", function()
                    select_to.select_textobject("@class.outer", "textobjects")
                end, { desc = "Select outer class" })
                vim.keymap.set({ "x", "o" }, "ic", function()
                    select_to.select_textobject("@class.inner", "textobjects")
                end, { desc = "Select inner class" })
            end

            require("treesitter-context").setup({
                enable = true,
                max_lines = 1,
                trim_scope = "outer",
            })
        end,
    },

    -- ── Autocompletion ─────────────────────────────────────────────────────
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("blink.cmp").setup({
                enabled = function()
                    return not vim.g.blink_cmp_disabled
                        and vim.bo.buftype ~= "prompt"
                        and vim.b.completion ~= false
                end,

                keymap = {
                    preset        = "none",
                    ["<CR>"]      = { "accept", "fallback" },
                    ["<C-e>"]     = { "cancel", "fallback" },
                    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                    ["<C-n>"]     = { "select_next", "fallback" },
                    ["<C-p>"]     = { "select_prev", "fallback" },
                    ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
                    ["<C-u>"]     = { "scroll_documentation_up", "fallback" },
                    ["<Tab>"]     = { "select_next", "snippet_forward", "fallback" },
                    ["<S-Tab>"]   = { "select_prev", "snippet_backward", "fallback" },
                },

                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono",
                },

                completion = {
                    accept        = { auto_brackets = { enabled = true } },
                    list          = { selection = { preselect = true, auto_insert = false } },
                    menu          = {
                        border = "none",
                        winhighlight =
                        "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                        draw = {
                            columns = {
                                { "label",     "label_description", gap = 1 },
                                { "kind_icon", "kind",              gap = 1 },
                            },
                        },
                    },
                    documentation = {
                        auto_show          = true,
                        auto_show_delay_ms = 200,
                        window             = {
                            border       = "none",
                            winhighlight =
                            "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                        },
                    },
                },

                sources = {
                    default   = { "lsp", "path", "snippets", "buffer" },
                    providers = { buffer = { min_keyword_length = 3 } },
                },
            })
        end,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },

    {
        "nvim-telescope/telescope.nvim",
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        },
                    },
                },
            })

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files)
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
            vim.keymap.set("n", "<leader>fq", builtin.quickfix)
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fm", function()
                builtin.man_pages({ sections = { "ALL" } })
            end, { desc = "Man pages" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
            vim.keymap.set("n", "<leader>fg", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set("n", "<leader>fc", function()
                builtin.grep_string({ search = vim.fn.expand("%:t:r") })
            end, { desc = "Find current file" })
            vim.keymap.set("n", "<leader>fs", function()
                builtin.grep_string({})
            end, { desc = "Find current string" })
            vim.keymap.set("n", "<leader>fi", function()
                builtin.find_files({ cwd = "~/.config/nvim/" })
            end, { desc = "Find in nvim config" })
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

            -- Browse harpoon list in Telescope
            vim.keymap.set("n", "<leader>fl", function()
                local conf = require("telescope.config").values
                local themes = require("telescope.themes")
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                    table.insert(file_paths, item.value)
                end
                require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Working List" }), {
                    finder    = require("telescope.finders").new_table({ results = file_paths }),
                    previewer = conf.file_previewer({}),
                    sorter    = conf.generic_sorter({}),
                }):find()
            end, { desc = "Harpoon list (Telescope)" })
        end,
    },

    -- ── File explorer ──────────────────────────────────────────────────────
    {
        "nvim-tree/nvim-tree.lua",
        lazy         = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        init         = function()
            -- must disable netrw before nvim-tree loads
            vim.g.loaded_netrw       = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config       = function()
            require("nvim-tree").setup({
                sort     = { sorter = "case_sensitive" },
                view     = { width = 30 },
                renderer = { group_empty = true },
                filters  = { dotfiles = false },
            })

            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

            -- Auto-open tree when nvim is launched with a directory
            local function open_nvim_tree(data)
                local directory = vim.fn.isdirectory(data.file) == 1
                if not directory then return end

                -- create a new, empty buffer
                vim.cmd.enew()
                -- wipe the directory buffer
                vim.cmd.bw(data.buf)
                -- change to the directory
                vim.cmd.cd(data.file)
                -- open the tree
                require("nvim-tree.api").tree.open()
            end

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = open_nvim_tree,
            })
        end,
    },

    -- ── Utilities ──────────────────────────────────────────────────────────
    { "brenoprata10/nvim-highlight-colors", event = "VeryLazy",    opts = {} },
    { "tpope/vim-fugitive",                 cmd = { "Git", "G" } },
    { "mbbill/undotree",                    cmd = "UndotreeToggle" },
    { "ojroques/vim-oscyank",               event = "VeryLazy" },
    {
        "captbaritone/better-indent-support-for-php-with-html",
        ft = { "php", "html" },
    },

    -- ── Bufferline ─────────────────────────────────────────────────────────
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        config = function()
            local cc_ok, cc = pcall(require, "carboncopy")

            local highlights = {}
            if cc_ok then
                highlights = {
                    fill               = { bg = "NONE" },
                    background         = { bg = cc.bg, fg = cc.fg },
                    buffer_selected    = { fg = cc.bg, bg = cc.primary, bold = false, italic = false },
                    buffer_visible     = { bg = cc.bg, fg = cc.secondary },
                    separator          = { fg = cc.bg, bg = cc.bg },
                    separator_selected = { fg = cc.bg, bg = cc.primary },
                    separator_visible  = { fg = cc.bg, bg = cc.bg },
                    indicator_selected = { fg = cc.primary, bg = cc.primary },
                    modified           = { fg = cc.cursorline_bg, bg = cc.bg },
                    modified_visible   = { fg = cc.cursorline_bg, bg = cc.bg },
                    modified_selected  = { fg = cc.cursorline_bg, bg = cc.primary },
                }
            end

            require("bufferline").setup({
                options = {
                    themable                = false,
                    mode                    = "buffers",
                    offsets                 = {
                        { filetype = "NvimTree", text = "File Explorer", text_align = "left", separator = true },
                    },
                    color_icons             = true,
                    show_buffer_icons       = true,
                    show_buffer_close_icons = false,
                    show_close_icon         = false,
                    persist_buffer_sort     = true,
                    enforce_regular_tabs    = false,
                    always_show_bufferline  = false,
                    sort_by                 = "id",
                },
                highlights = highlights,
            })
        end,
    },

    -- ── Statusline ─────────────────────────────────────────────────────────
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local cc_ok, cc = pcall(require, "carboncopy")

            if not cc_ok then
                require("lualine").setup({ options = { theme = "auto" } })
                return
            end

            local NONE = "NONE"
            require("lualine").setup({
                options = {
                    theme                = {
                        normal   = {
                            a = { fg = cc.bg, bg = cc.primary, gui = "bold" },
                            b = { fg = cc.tree_indent_marker, bg = cc.darker },
                            c = { fg = cc.primary, bg = NONE },
                            x = { fg = cc.tree_indent_marker, bg = cc.darker },
                            y = { fg = cc.fg, bg = cc.darker },
                            z = { fg = cc.bg, bg = cc.primary },
                        },
                        insert   = {
                            a = { fg = cc.bg, bg = cc.tertiary, gui = "bold" },
                            b = { fg = cc.tree_indent_marker, bg = cc.darker },
                            c = { fg = cc.tertiary, bg = NONE },
                            x = { fg = cc.tree_indent_marker, bg = cc.darker },
                            y = { fg = cc.fg, bg = cc.darker },
                            z = { fg = cc.bg, bg = cc.tertiary },
                        },
                        visual   = {
                            a = { fg = cc.bg, bg = cc.fg, gui = "bold" },
                            b = { fg = cc.tree_indent_marker, bg = cc.darker },
                            c = { fg = cc.secondary, bg = NONE },
                            x = { fg = cc.tree_indent_marker, bg = cc.darker },
                            y = { fg = cc.fg, bg = cc.darker },
                            z = { fg = cc.bg, bg = cc.fg },
                        },
                        replace  = {
                            a = { fg = cc.bg, bg = cc.error, gui = "bold" },
                            b = { fg = cc.tree_indent_marker, bg = NONE },
                            c = { fg = cc.primary, bg = NONE },
                            x = { fg = cc.tree_indent_marker, bg = cc.darker },
                            y = { fg = cc.fg, bg = cc.darker },
                            z = { fg = cc.bg, bg = cc.error },
                        },
                        inactive = {
                            a = { fg = cc.fg, bg = cc.bg },
                            b = { fg = cc.tree_indent_marker, bg = cc.bg },
                            c = { fg = cc.primary, bg = NONE },
                            x = { fg = cc.tree_indent_marker, bg = cc.darker },
                            y = { fg = cc.fg, bg = cc.darker },
                            z = { fg = cc.fg, bg = cc.bg },
                        },
                    },
                    component_separators = { left = "|", right = "|" },
                    section_separators   = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        { "branch", color = { fg = cc.branch, bg = cc.darker } },
                        {
                            "filename",
                            path = 0,
                            color = { fg = cc.fg, bg = cc.darker },
                            symbols = { modified = "● ", readonly = "✘ ", unnamed = "[No Name]" }
                        },
                    },
                    lualine_c = {},
                    lualine_x = {
                        {
                            "fileformat",
                            color = { fg = cc.fg, bg = cc.darker },
                            symbols = { unix = "unix", dos = "DOS", mac = "Mac" }
                        },
                        { "filetype", color = { fg = cc.fg, bg = cc.darker } },
                        { "progress", color = { fg = cc.fg, bg = cc.darker } },
                    },
                    lualine_y = {},
                    lualine_z = { "location" },
                },
            })
        end,
    },
}
