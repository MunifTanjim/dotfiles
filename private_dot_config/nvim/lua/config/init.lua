local color = require("config.color").dark

local highlights = {
  Search = { bg = color.yellow, fg = color.bg },
  IncSearch = { bg = color.orange, fg = color.bg },

  StatusLine = { bg = color.bg2, fg = color.fg1 },
  StatusLineNC = { bg = color.bg1, fg = color.fg4 },

  Error = { bg = color.red, bold = true },

  DiffDelete = { bg = color.red, fg = color.bg0 },
  DiffAdd = { bg = color.green, fg = color.bg0 },
  DiffChange = { bg = color.aqua, fg = color.bg0 },
  DiffText = { bg = color.yellow, fg = color.bg0 },

  --[[ treesitter ]]
  ["@annotation"] = { link = "PreProc" },
  ["@attribute"] = { link = "PreProc" },
  ["@boolean"] = { link = "Boolean" },
  ["@character"] = { link = "Character" },
  ["@comment"] = { link = "Comment" },
  ["@conditional"] = { link = "Conditional" },
  ["@constant"] = { link = "Constant" },
  ["@constant.builtin"] = { link = "Constant" },
  ["@constant.macro"] = { link = "Constant" },
  ["@constructor"] = { link = "Special" },
  ["@error"] = { fg = color.red, undercurl = true },
  ["@exception"] = { link = "Exception" },
  ["@field"] = { link = "Identifier" },
  ["@float"] = { link = "Float" },
  ["@function"] = { link = "Function" },
  ["@function.builtin"] = { link = "Function" },
  ["@function.macro"] = { link = "Macro" },
  ["@include"] = { link = "Include" },
  ["@keyword"] = { fg = color.red },
  ["@keyword.function"] = { fg = color.aqua },
  ["@keyword.operator"] = { link = "@operator" },
  ["@label"] = { link = "Label" },
  ["@method"] = { link = "Function" },
  ["@method.call"] = { link = "@method" },
  ["@namespace"] = { link = "Include" },
  -- ["@none"] = { link = nil },
  ["@number"] = { link = "Number" },
  ["@operator"] = { link = "Operator" },
  ["@parameter"] = { link = "Identifier" },
  ["@parameter.reference"] = { link = "@parameter" },
  ["@property"] = { fg = color.blue },
  ["@punctuation.bracket"] = { fg = color.fg3 },
  ["@punctuation.delimiter"] = { fg = color.fg3 },
  ["@punctuation.special"] = { fg = color.orange },
  ["@repeat"] = { link = "Repeat" },
  ["@string"] = { link = "String" },
  ["@string.regex"] = { link = "String" },
  ["@string.escape"] = { link = "SpecialChar" },
  ["@string.special"] = { link = "SpecialChar" },
  ["@symbol"] = { link = "Identifier" },
  ["@tag"] = { fg = color.green },
  ["@tag.attribute"] = { link = "@property" },
  ["@tag.delimiter"] = { link = "@punctuation.delimiter" },
  -- ["@text"] = { link = nil },
  ["@text.strong"] = { cterm = { bold = true }, bold = true },
  ["@text.emphasis"] = { cterm = { italic = true }, italic = true },
  ["@text.underline"] = { cterm = { underline = true }, underline = true },
  ["@text.strike"] = { cterm = { strikethrough = true }, strikethrough = true },
  ["@text.title"] = { link = "Title" },
  ["@text.literal"] = { link = "String" },
  ["@text.uri"] = { link = "Underlined" },
  ["@text.math"] = { link = "Special" },
  ["@text.reference"] = { link = "Constant" },
  ["@text.environment"] = { link = "Macro" },
  ["@text.environment.name"] = { link = "Type" },
  ["@text.note"] = { link = "SpecialComment" },
  ["@text.warning"] = { link = "WarningMsg" },
  ["@text.danger"] = { link = "ErrorMsg" },
  ["@type"] = { fg = color.aqua },
  ["@type.builtin"] = { link = "Type" },
  ["@variable"] = { fg = color.fg1 },
  ["@variable.builtin"] = { link = "Identifier" },
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

local function appearance_settings()
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
    group = vim.api.nvim_create_augroup("colorscheme_override", { clear = true }),
    callback = function()
      for name, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, hl)
      end
    end,
  })
end

appearance_settings()

require("config.lazy")
