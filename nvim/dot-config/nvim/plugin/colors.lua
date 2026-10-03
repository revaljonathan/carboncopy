vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "carboncopy"

local cc_ok, cc = pcall(require, "carboncopy")
if not cc_ok or type(cc) ~= "table" then
    return
end

local hl = vim.api.nvim_set_hl

hl(0, "Normal",       { fg = cc.fg, bg = "NONE" })
hl(0, "NormalFloat",  { fg = cc.fg, bg = "NONE" })
hl(0, "FloatBorder",  { fg = cc.telescope_border or cc.primary, bg = "NONE" })
hl(0, "FloatTitle",   { fg = cc.primary, bold = true })
hl(0, "SignColumn",   { bg = "NONE" })
hl(0, "Directory",    { fg = cc.tree_folder or cc.syn_func, bg = "NONE", bold = true })
hl(0, "ColorColumn",  { bg = cc.cursorline_bg })
hl(0, "MatchParen",   { fg = cc.primary, bold = true })

if cc.cursorline_bg then
    hl(0, "CursorLine", { bg = cc.cursorline_bg })
end
hl(0, "CursorLineNr", { fg = cc.primary, bold = true })
hl(0, "LineNr",       { fg = cc.telescope_border, bg = "NONE" })

local visual_opts = { bg = cc.visual_bg or cc.darker }
if cc.visual_fg then
    visual_opts.fg = cc.visual_fg
end
hl(0, "Visual",    visual_opts)
hl(0, "VisualNOS", visual_opts)

hl(0, "Search",    { fg = cc.bg, bg = cc.secondary })
hl(0, "IncSearch", { fg = cc.bg, bg = cc.primary })
hl(0, "CurSearch", { fg = cc.bg, bg = cc.primary })

hl(0, "WinSeparator", { fg = cc.cursorline_bg, bg = "NONE" })
hl(0, "VertSplit",    { fg = cc.cursorline_bg, bg = "NONE" })
hl(0, "StatusLine",   { fg = cc.fg, bg = cc.darker })
hl(0, "StatusLineNC", { fg = cc.telescope_border, bg = cc.darker })

hl(0, "Pmenu",      { bg = cc.darker, fg = cc.fg })
hl(0, "PmenuSel",   { bg = cc.telescope_selection_bg or cc.cursorline_bg, fg = cc.fg })
hl(0, "PmenuSbar",  { bg = cc.darker })
hl(0, "PmenuThumb", { bg = cc.secondary })

if cc.telescope_border then
    hl(0, "TelescopeBorder",       { fg = cc.telescope_border })
    hl(0, "TelescopePromptBorder", { fg = cc.telescope_prompt_border or cc.primary })
    hl(0, "TelescopePromptTitle",  { fg = cc.telescope_prompt_title or cc.primary, bold = true })
    hl(0, "TelescopeSelection",    { bg = cc.telescope_selection_bg, fg = cc.telescope_selection_fg })
end

if cc.tree_folder then
    hl(0, "NvimTreeFolderName",       { fg = cc.tree_folder, bold = true })
    hl(0, "NvimTreeOpenedFolderName", { fg = cc.tree_folder_open or cc.tree_folder, bold = true })
    hl(0, "NvimTreeIndentMarker",     { fg = cc.tree_indent_marker or cc.cursorline_bg })
    hl(0, "NvimTreeRootFolder",       { fg = cc.tree_root or cc.error, bold = true })
    hl(0, "NvimTreeStatuslineNc",     { fg = cc.bg, bg = cc.bg })
    hl(0, "NvimTreeStatusLine",       { fg = cc.bg, bg = cc.bg })
end

if cc.darker then
    hl(0, "RenderMarkdownCode",       { bg = cc.darker })
    hl(0, "RenderMarkdownCodeInline", { bg = cc.darker })
end

hl(0, "DiagnosticError",          { fg = cc.error })
hl(0, "DiagnosticWarn",           { fg = cc.syn_constant })
hl(0, "DiagnosticInfo",           { fg = cc.syn_func })
hl(0, "DiagnosticHint",           { fg = cc.secondary })
hl(0, "DiagnosticUnderlineError", { sp = cc.error, undercurl = true })
hl(0, "DiagnosticUnderlineWarn",  { sp = cc.syn_constant, undercurl = true })
hl(0, "DiagnosticUnderlineInfo",  { sp = cc.syn_func, undercurl = true })
hl(0, "DiagnosticUnderlineHint",  { sp = cc.secondary, undercurl = true })

-- Git / Diff
hl(0, "DiffAdd",    { fg = cc.syn_string or cc.branch })
hl(0, "DiffChange", { fg = cc.secondary })
hl(0, "DiffDelete", { fg = cc.error })
hl(0, "DiffText",   { fg = cc.syn_func })

-- snacks
hl(0, "SnacksDashboardHeader", { fg = cc.primary, bold = true })
hl(0, "SnacksDashboardDesc",   { fg = cc.fg })                   
hl(0, "SnacksDashboardIcon",   { fg = cc.syn_constant })            
hl(0, "SnacksDashboardKey",    { fg = cc.syn_constant })         

-- Syntax Highlighting
local c = {
    comment  = cc.syn_comment,
    constant = cc.syn_constant,
    string   = cc.syn_string,
    type     = cc.syn_type,
    variable = cc.syn_variable,
    func     = cc.syn_func,
    keyword  = cc.syn_keyword,
    operator = cc.syn_operator,
    special  = cc.syn_special,
}

local syntax_groups = {
    -- Standard Vim syntax
    Comment        = { fg = c.comment, italic = true },
    Constant       = { fg = c.constant },
    String         = { fg = c.string },
    Character      = { fg = c.string },
    Number         = { fg = c.constant },
    Boolean        = { fg = c.constant },
    Float          = { fg = c.constant },
    Identifier     = { fg = c.variable },
    Function       = { fg = c.func },
    Statement      = { fg = c.keyword },
    Conditional    = { fg = c.keyword },
    Repeat         = { fg = c.keyword },
    Label          = { fg = c.keyword },
    Operator       = { fg = c.operator },
    Keyword        = { fg = c.keyword },
    Exception      = { fg = c.keyword },
    PreProc        = { fg = c.special },
    Include        = { fg = c.keyword },
    Define         = { fg = c.special },
    Macro          = { fg = c.special },
    PreCondit      = { fg = c.special },
    Type           = { fg = c.type },
    StorageClass   = { fg = c.keyword },
    Structure      = { fg = c.type },
    Typedef        = { fg = c.type },
    Special        = { fg = c.special },
    SpecialChar    = { fg = c.special },
    Tag            = { fg = c.func },
    Delimiter      = { fg = c.operator },
    SpecialComment = { fg = c.comment, italic = true },
    Debug          = { fg = c.special },

    -- Treesitter syntax
    ["@comment"]               = { fg = c.comment, italic = true },
    ["@comment.documentation"] = { fg = c.comment, italic = true },
    ["@string"]                = { fg = c.string },
    ["@string.regex"]          = { fg = c.special },
    ["@string.escape"]         = { fg = c.special },
    ["@string.special"]        = { fg = c.special },
    ["@character"]             = { fg = c.string },
    ["@character.special"]     = { fg = c.special },
    ["@number"]                = { fg = c.constant },
    ["@number.float"]          = { fg = c.constant },
    ["@boolean"]               = { fg = c.constant },
    ["@constant"]              = { fg = c.constant },
    ["@constant.builtin"]      = { fg = c.constant },
    ["@constant.macro"]        = { fg = c.constant },
    ["@function"]              = { fg = c.func },
    ["@function.builtin"]      = { fg = c.func },
    ["@function.call"]         = { fg = c.func },
    ["@function.method"]       = { fg = c.func },
    ["@function.method.call"]  = { fg = c.func },
    ["@function.macro"]        = { fg = c.func },
    ["@constructor"]           = { fg = c.func },
    ["@keyword"]               = { fg = c.keyword },
    ["@keyword.function"]      = { fg = c.keyword },
    ["@keyword.return"]        = { fg = c.keyword },
    ["@keyword.conditional"]   = { fg = c.keyword },
    ["@keyword.repeat"]        = { fg = c.keyword },
    ["@keyword.import"]        = { fg = c.keyword },
    ["@keyword.coroutine"]     = { fg = c.keyword },
    ["@keyword.operator"]      = { fg = c.keyword },
    ["@type"]                  = { fg = c.type },
    ["@type.builtin"]          = { fg = c.type },
    ["@type.definition"]       = { fg = c.type },
    ["@type.qualifier"]        = { fg = c.keyword },
    ["@variable"]              = { fg = c.variable },
    ["@variable.builtin"]      = { fg = c.special },
    ["@variable.parameter"]    = { fg = c.variable },
    ["@variable.member"]       = { fg = c.variable },
    ["@property"]              = { fg = c.variable },
    ["@field"]                 = { fg = c.variable },
    ["@operator"]              = { fg = c.operator },
    ["@punctuation.delimiter"] = { fg = c.operator },
    ["@punctuation.bracket"]   = { fg = c.operator },
    ["@punctuation.special"]   = { fg = c.special },
    ["@tag"]                   = { fg = c.func },
    ["@tag.attribute"]         = { fg = c.type },
    ["@tag.delimiter"]         = { fg = c.operator },
}

for name, opts in pairs(syntax_groups) do
    hl(0, name, opts)
end

_G.reload_colorscheme = function()
    package.loaded["carboncopy"] = nil
    pcall(dofile, vim.fn.stdpath("config") .. "/plugin/colors.lua")
end

vim.api.nvim_create_user_command("ColorschemeReload", function()
    _G.reload_colorscheme()
    vim.notify("Carboncopy colors reloaded", vim.log.levels.INFO)
end, { desc = "Reload Carboncopy colorscheme" })
