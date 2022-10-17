local function appearance_settings()
  -- enable truecolor
  if vim.fn.has("termguicolors") then
    vim.go.termguicolors = true
  end

  -- treesitter
  vim.schedule(function()
    vim.cmd([[
      hi! link @annotation PreProc
      hi! link @attribute PreProc
      hi! link @boolean Boolean
      hi! link @character Character
      hi! link @comment Comment
      hi! link @conditional Conditional
      hi! link @constant Constant
      hi! link @constant.builtin Constant
      hi! link @constant.macro Constant
      hi! link @constructor Special
      hi! link @error GruvboxRedUnderline
      hi! link @exception Exception
      hi! link @field Identifier
      hi! link @float Float
      hi! link @function Function
      hi! link @function.builtin Function
      hi! link @function.macro Macro
      hi! link @include Include
      hi! link @keyword GruvboxRed
      hi! link @keyword.function GruvboxAqua
      hi! link @keyword.operator @operator
      hi! link @label Label
      hi! link @method Function
      hi! link @method.call @method
      hi! link @namespace Include
      " hi! link @none
      hi! link @number Number
      hi! link @operator Operator
      hi! link @parameter Identifier
      hi! link @parameter.reference @parameter
      hi! link @property GruvboxBlue
      hi! link @punctuation.bracket GruvboxFg3
      hi! link @punctuation.delimiter GruvboxFg3
      hi! link @punctuation.special GruvboxOrange
      hi! link @repeat Repeat
      hi! link @string String
      hi! link @string.regex String
      hi! link @string.escape SpecialChar
      hi! link @string.special SpecialChar
      hi! link @symbol Identifier
      hi! link @tag GruvboxGreen
      hi! link @tag.attribute @property
      hi! link @tag.delimiter @punctuation.delimiter
      " hi! link @text
      hi! @text.strong term=bold cterm=bold gui=bold
      hi! @text.emphasis term=italic cterm=italic gui=italic
      hi! @text.underline term=underline cterm=underline gui=underline
      hi! @text.strike term=strikethrough cterm=strikethrough gui=strikethrough
      hi! link @text.title Title
      hi! link @text.literal String
      hi! link @text.uri Underlined
      hi! link @text.math Special
      hi! link @text.reference Constant
      hi! link @text.environment Macro
      hi! link @text.environment.name Type
      hi! link @text.note SpecialComment
      hi! link @text.warning WarningMsg
      hi! link @text.danger ErrorMsg
      hi! link @type GruvboxAqua
      hi! link @type.builtin Type
      hi! link @variable GruvboxFg1
      hi! link @variable.builtin Identifier
    ]])
  end)
end

require("config.plugins")

appearance_settings()
