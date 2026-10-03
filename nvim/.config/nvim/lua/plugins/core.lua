return {
    -- ── Shared dependencies ────────────────────────────────────────────────
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- ── Treesitter ─────────────────────────────────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
        },
        init = function()
            vim.filetype.add({ extension = { goon = "goon" } })
        end,
        opts = {
            ensure_installed = {
                "c", "lua", "vim", "vimdoc", "query",
                "go", "javascript", "nix", "php", "rust",
                "zig", "java", "python", "bash",
                "markdown", "markdown_inline",
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)

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
                    preset    = "none",
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
                    accept = { auto_brackets = { enabled = true } },
                    list   = { selection = { preselect = true, auto_insert = false } },
                    menu   = {
                        border = "none",
                        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                        draw = {
                            columns = {
                                { "label", "label_description", gap = 1 },
                                { "kind_icon", "kind",          gap = 1 },
                            },
                        },
                    },
                    documentation = {
                        auto_show          = true,
                        auto_show_delay_ms = 200,
                        window = {
                            border      = "none",
                            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                        },
                    },
                },

                sources = {
                    default   = { "lsp", "path", "snippets", "buffer" },
                    providers = { buffer = { min_keyword_length = 3 } },
                },
            })

            -- Carboncopy highlight groups for blink.cmp / cmp compatibility
            local cc_ok, M = pcall(require, "carboncopy")
            if not cc_ok then return end

            local hl = vim.api.nvim_set_hl
            hl(0, "Pmenu",      { bg = M.darker, fg = M.fg })
            hl(0, "PmenuSel",   { bg = M.telescope_selection_bg, fg = M.fg })
            hl(0, "PmenuSbar",  { bg = M.darker })
            hl(0, "PmenuThumb", { bg = M.secondary })

            hl(0, "BlinkCmpMenu",            { bg = M.darker, fg = M.fg })
            hl(0, "BlinkCmpMenuBorder",      { fg = M.secondary, bg = M.darker })
            hl(0, "BlinkCmpMenuSelection",   { bg = M.telescope_selection_bg, fg = M.fg })
            hl(0, "BlinkCmpLabel",           { fg = M.fg })
            hl(0, "BlinkCmpLabelDeprecated", { fg = M.cursorline_fg, strikethrough = true })
            hl(0, "BlinkCmpLabelMatch",      { fg = M.primary, bold = true })
            hl(0, "BlinkCmpKind",            { fg = M.secondary })
            hl(0, "BlinkCmpDoc",             { bg = M.darker, fg = M.fg })
            hl(0, "BlinkCmpDocBorder",       { fg = M.secondary, bg = M.darker })

            hl(0, "CmpNormal",             { link = "BlinkCmpMenu" })
            hl(0, "CmpBorder",             { link = "BlinkCmpMenuBorder" })
            hl(0, "CmpSel",                { link = "BlinkCmpMenuSelection" })
            hl(0, "CmpItemAbbr",           { link = "BlinkCmpLabel" })
            hl(0, "CmpItemAbbrDeprecated", { link = "BlinkCmpLabelDeprecated" })
            hl(0, "CmpItemAbbrMatch",      { link = "BlinkCmpLabelMatch" })
            hl(0, "CmpItemAbbrMatchFuzzy", { link = "BlinkCmpLabelMatch" })
            hl(0, "CmpItemKind",           { link = "BlinkCmpKind" })
            hl(0, "CmpDoc",                { link = "BlinkCmpDoc" })
            hl(0, "CmpDocBorder",          { link = "BlinkCmpDocBorder" })

            for _, kind in ipairs({
                "Text", "Method", "Function", "Constructor", "Field", "Variable", "Class",
                "Interface", "Module", "Property", "Unit", "Value", "Enum", "Keyword",
                "Snippet", "Color", "File", "Reference", "Folder", "EnumMember",
                "Constant", "Struct", "Event", "Operator", "TypeParameter", "Copilot",
            }) do
                hl(0, "BlinkCmpKind" .. kind, { link = "BlinkCmpKind" })
                hl(0, "CmpItemKind"  .. kind, { link = "BlinkCmpKind" })
            end
        end,
    },

    -- ── Autopairs ──────────────────────────────────────────────────────────
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },

    -- ── Telescope ──────────────────────────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
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
            vim.keymap.set("n", "<leader>fh", builtin.help_tags,   { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fm", function()
                builtin.man_pages({ sections = { "ALL" } })
            end, { desc = "Man pages" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers,     { desc = "Buffers" })
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

    -- ── Harpoon ────────────────────────────────────────────────────────────
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()

            vim.keymap.set("n", "<leader>a",  function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-e>",      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-p>",      function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-n>",      function() harpoon:list():next() end)

            -- Browse harpoon list in Telescope
            vim.keymap.set("n", "<leader>fl", function()
                local conf = require("telescope.config").values
                local themes = require("telescope.themes")
                local file_paths = {}
                for _, item in ipairs(harpoon:list().items) do
                    table.insert(file_paths, item.value)
                end
                require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Working List" }), {
                    finder   = require("telescope.finders").new_table({ results = file_paths }),
                    previewer = conf.file_previewer({}),
                    sorter   = conf.generic_sorter({}),
                }):find()
            end, { desc = "Harpoon list (Telescope)" })
        end,
    },

    -- ── File explorer ──────────────────────────────────────────────────────
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            -- must disable netrw before nvim-tree loads
            vim.g.loaded_netrw       = 1
            vim.g.loaded_netrwPlugin = 1
        end,
        config = function()
            require("nvim-tree").setup({
                sort     = { sorter = "case_sensitive" },
                view     = { width = 30 },
                renderer = { group_empty = true },
                filters  = { dotfiles = false },
            })

            vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

            local cc_ok, cc = pcall(require, "carboncopy")
            if cc_ok and cc.bg then
                vim.api.nvim_set_hl(0, "NvimTreeStatuslineNc", { fg = cc.bg, bg = cc.bg })
                vim.api.nvim_set_hl(0, "NvimTreeStatusLine",   { fg = cc.bg, bg = cc.bg })
            end
        end,
    },

    -- ── Utilities ──────────────────────────────────────────────────────────
    { "brenoprata10/nvim-highlight-colors", event = "VeryLazy", opts = {} },
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
                    fill                 = { bg = "NONE" },
                    background           = { bg = cc.bg,      fg = cc.fg },
                    buffer_selected      = { fg = cc.bg,      bg = cc.primary, bold = true, italic = false },
                    buffer_visible       = { bg = cc.bg,      fg = cc.secondary },
                    separator            = { fg = cc.bg,      bg = cc.bg },
                    separator_selected   = { fg = cc.bg,      bg = cc.primary },
                    separator_visible    = { fg = cc.bg,      bg = cc.bg },
                    indicator_selected   = { fg = cc.primary, bg = cc.primary },
                    modified             = { fg = cc.cursorline_bg, bg = cc.bg },
                    modified_visible     = { fg = cc.cursorline_bg, bg = cc.bg },
                    modified_selected    = { fg = cc.cursorline_bg, bg = cc.primary },
                }
            end

            require("bufferline").setup({
                options = {
                    themable               = false,
                    mode                   = "buffers",
                    offsets                = {
                        { filetype = "NvimTree", text = "File Explorer", text_align = "left", separator = true },
                    },
                    color_icons            = true,
                    show_buffer_icons      = true,
                    show_buffer_close_icons = false,
                    show_close_icon        = false,
                    persist_buffer_sort    = true,
                    enforce_regular_tabs   = false,
                    always_show_bufferline = false,
                    sort_by                = "id",
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
                    theme = {
                        normal   = {
                            a = { fg = cc.bg,  bg = cc.primary,   gui = "bold" },
                            b = { fg = cc.primary,  bg = cc.darker },
                            c = { fg = cc.primary,  bg = NONE },
                            x = { fg = cc.primary,  bg = cc.darker },
                            y = { fg = cc.fg,        bg = cc.darker },
                            z = { fg = cc.bg,        bg = cc.primary },
                        },
                        insert   = {
                            a = { fg = cc.bg,        bg = cc.tertiary, gui = "bold" },
                            b = { fg = cc.tertiary,  bg = cc.darker },
                            c = { fg = cc.tertiary,  bg = NONE },
                            x = { fg = cc.tertiary,  bg = cc.darker },
                            y = { fg = cc.fg,         bg = cc.darker },
                            z = { fg = cc.bg,         bg = cc.tertiary },
                        },
                        visual   = {
                            a = { fg = cc.bg,        bg = cc.fg,       gui = "bold" },
                            b = { fg = cc.secondary, bg = cc.darker },
                            c = { fg = cc.secondary, bg = NONE },
                            x = { fg = cc.secondary, bg = cc.darker },
                            y = { fg = cc.fg,         bg = cc.darker },
                            z = { fg = cc.bg,         bg = cc.fg },
                        },
                        replace  = {
                            a = { fg = cc.bg,        bg = cc.error,  gui = "bold" },
                            b = { fg = cc.error,     bg = NONE },
                            c = { fg = cc.primary,   bg = NONE },
                            x = { fg = cc.primary,   bg = cc.darker },
                            y = { fg = cc.fg,         bg = cc.darker },
                            z = { fg = cc.bg,         bg = cc.error },
                        },
                        inactive = {
                            a = { fg = cc.fg, bg = cc.bg },
                            b = { fg = cc.fg, bg = cc.bg },
                            c = { fg = cc.primary, bg = NONE },
                            x = { fg = cc.primary, bg = cc.darker },
                            y = { fg = cc.fg,       bg = cc.darker },
                            z = { fg = cc.fg,       bg = cc.bg },
                        },
                    },
                    component_separators = { left = "|", right = "|" },
                    section_separators   = { left = "",  right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        { "branch",   color = { fg = cc.branch, bg = cc.darker } },
                        { "filename", path = 0, color = { fg = cc.fg, bg = cc.darker },
                          symbols = { modified = "●", readonly = "✘", unnamed = "[No Name]" } },
                    },
                    lualine_c = {},
                    lualine_x = {
                        { "fileformat", color = { fg = cc.fg, bg = cc.darker },
                          symbols = { unix = "unix", dos = "DOS", mac = "Mac" } },
                        { "filetype",   color = { fg = cc.fg, bg = cc.darker } },
                        { "progress",   color = { fg = cc.fg, bg = cc.darker } },
                    },
                    lualine_y = {},
                    lualine_z = { "location" },
                },
            })
        end,
    },
}
