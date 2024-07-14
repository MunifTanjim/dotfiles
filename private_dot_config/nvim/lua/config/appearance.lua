local color = require("config.color").dark
local faded = require("config.color").faded

local highlights = {
  Search = { bg = color.yellow, fg = color.bg },
  CurSearch = { bg = color.orange, fg = color.bg },
  IncSearch = { link = "CurSearch" },

  StatusLine = { bg = color.bg2, fg = color.fg1 },
  StatusLineNC = { bg = color.bg1, fg = color.fg4 },

  QuickFixLine = { bg = color.bg1, bold = true, italic = true },

  Error = { bg = color.red, bold = true },

  DiffDelete = { bg = color.red, fg = color.bg0 },
  DiffAdd = { bg = color.green, fg = color.bg0 },
  DiffChange = { bg = color.aqua, fg = color.bg0 },
  DiffText = { bg = color.yellow, fg = color.bg0 },

  WinSeparator = { fg = color.bg3 },

  NormalFloat = { bg = color.bg2 },
  FloatBorder = { link = "WinSeparator" },

  LspInlayHint = { fg = color.gray, italic = true },
  LspReferenceText = { bg = color.bg1 },
  LspReferenceRead = { link = "LspReferenceText" },
  LspReferenceWrite = { link = "LspReferenceText" },

  --[[ treesitter ]]
  ["@annotation"] = { link = "PreProc" },
  ["@attribute"] = { link = "PreProc" },
  ["@boolean"] = { link = "Boolean" },
  ["@character"] = { link = "Character" },
  ["@comment"] = { link = "Comment" },
  ["@comment.error"] = { link = "ErrorMsg" },
  ["@comment.info"] = { link = "SpecialComment" },
  ["@comment.warning"] = { link = "WarningMsg" },
  ["@constant"] = { link = "Constant" },
  ["@constant.builtin"] = { link = "Constant" },
  ["@constant.comment"] = { link = "Constant" },
  ["@constant.macro"] = { link = "Constant" },
  ["@constructor"] = { link = "Special" },
  ["@error"] = { fg = color.red, undercurl = true },
  ["@function"] = { link = "Function" },
  ["@function.builtin"] = { link = "Function" },
  ["@function.macro"] = { link = "Macro" },
  ["@function.method"] = { link = "Function" },
  ["@function.method.call"] = { link = "@method" },
  ["@keyword"] = { fg = color.red },
  ["@keyword.conditional"] = { link = "Conditional" },
  ["@keyword.exception"] = { link = "Exception" },
  ["@keyword.function"] = { fg = color.aqua },
  ["@keyword.import"] = { link = "Include" },
  ["@keyword.operator"] = { link = "@operator" },
  ["@keyword.repeat"] = { link = "Repeat" },
  ["@label"] = { link = "Label" },
  ["@markup.heading"] = { link = "Title" },
  ["@markup.italic"] = { cterm = { italic = true }, italic = true },
  ["@markup.link"] = { link = "Constant" },
  ["@markup.link.label"] = { link = "SpecialChar" },
  ["@markup.link.url"] = { link = "@string.special.url" },
  ["@markup.list"] = { fg = color.orange },
  ["@markup.raw"] = { link = "String" },
  ["@markup.strikethrough"] = { cterm = { strikethrough = true }, strikethrough = true },
  ["@markup.strong"] = { cterm = { bold = true }, bold = true },
  ["@markup.underline"] = { cterm = { underline = true }, underline = true },
  ["@markup.environment"] = { link = "Macro" },
  ["@markup.math"] = { link = "Special" },
  ["@module"] = { link = "Include" },
  -- ["@none"] = { link = nil },
  ["@number"] = { link = "Number" },
  ["@number.float"] = { link = "Float" },
  ["@operator"] = { link = "Operator" },
  ["@parameter.reference"] = { link = "@variable.parameter" },
  ["@property"] = { fg = color.blue },
  ["@punctuation.bracket"] = { fg = color.fg3 },
  ["@punctuation.delimiter"] = { fg = color.fg3 },
  ["@punctuation.special"] = { fg = color.orange },
  ["@string"] = { link = "String" },
  ["@string.escape"] = { link = "SpecialChar" },
  ["@string.regexp"] = { link = "String" },
  ["@string.special.symbol"] = { link = "Identifier" },
  ["@string.special.url"] = { link = "Underlined" },
  ["@tag"] = { fg = color.green },
  ["@tag.attribute"] = { link = "@property" },
  ["@tag.delimiter"] = { link = "@punctuation.delimiter" },
  -- ["@text"] = { link = nil },
  ["@type"] = { fg = color.aqua },
  ["@type.builtin"] = { link = "Type" },
  ["@variable"] = { link = "Identifier" },
  ["@variable.builtin"] = { link = "Identifier" },
  ["@variable.member"] = { link = "@property" },
  ["@variable.parameter"] = { link = "Identifier" },

  --[[ treesitter: language specific ]]
  ["@keyword.jsdoc"] = { link = "Constant" },
  ["@include.tsx"] = { link = "@keyword" },

  --[[ lsp semantic tokens ]]
  ["@lsp.mod.documentation"] = { link = "Constant" },
  ["@lsp.type.class"] = { link = "@constructor" },
  ["@lsp.type.comment"] = { link = "Comment" },
  ["@lsp.type.decorator"] = { link = "Function" },
  ["@lsp.type.enum"] = { link = "Type" },
  ["@lsp.type.enumMember"] = { link = "Constant" },
  ["@lsp.type.function"] = { link = "@function" },
  ["@lsp.type.interface"] = { link = "Structure" },
  ["@lsp.type.keyword"] = { link = "@keyword" },
  ["@lsp.type.macro"] = { link = "Macro" },
  ["@lsp.type.method"] = { link = "@method" },
  ["@lsp.type.namespace"] = { link = "Structure" },
  ["@lsp.type.parameter"] = { link = "@variable.parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.struct"] = { link = "Structure" },
  ["@lsp.type.type"] = { link = "@type" },
  ["@lsp.type.typeParameter"] = { link = "@type" },
  ["@lsp.type.variable"] = { link = "@variable" },
  ["@lsp.typemod.string.static"] = { link = "@string" },
  ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },

  --[[ flash.nvim ]]
  FlashLabel = { bg = color.purple, fg = color.bg, italic = true },

  --[[ indent-blankline.nvim ]]
  IblIndent = { fg = color.bg1, nocombine = true },
  IblScope = { fg = faded.purple, nocombine = true },

  --[[ lazy.nvim ]]
  LazyNormal = { link = "Normal" },

  --[[ mason.nvim ]]
  MasonNormal = { link = "Normal" },

  --[[ neo-tree.nvim ]]
  NeoTreeFloatNormal = { link = "Normal" },
  NeoTreeFloatBorder = { link = "NeoTreeFloatNormal" },

  --[[ nvim-treesitter-context ]]
  TreesitterContext = { link = "CursorLine" },
  TreesitterContextLineNumber = { link = "CursorLine" },

  --[[ vim-fugitive ]]
  fugitiveUntrackedModifier = { fg = color.yellow },
  fugitiveUnstagedModifier = { fg = color.orange },
  fugitiveStagedModifier = { fg = color.aqua },

  --[[ which-key.nvim ]]
  WhichKeyNormal = { link = "Normal" },
}

local guicursor = {
  blink_off = table.concat({
    "n-v-c-sm:block",
    "i-ci-ve:ver25",
    "r-cr-o:hor20",
  }, ","),
  blink_on = table.concat({
    "n-v-c-sm:block-blinkon1",
    "i-ci-ve:ver25-blinkon1",
    "r-cr-o:hor20-blinkon1",
  }, ","),
}

-- enable truecolor
if vim.fn.has("termguicolors") then
  vim.go.termguicolors = true
end

vim.go.guicursor = guicursor.blink_on
vim.api.nvim_create_user_command("ToggleCursorBlink", function()
  if vim.go.guicursor ~= guicursor.blink_off then
    vim.go.guicursor = guicursor.blink_off
  else
    vim.go.guicursor = guicursor.blink_on
  end
end, {
  desc = "[gui] toggle cursor blink",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "gruvbox",
  group = vim.api.nvim_create_augroup("colorscheme_override", { clear = true }),
  callback = function()
    for name, hl in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, hl)
    end
  end,
})
