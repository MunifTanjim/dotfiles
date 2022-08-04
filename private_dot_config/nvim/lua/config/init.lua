local function appearance_settings()
  -- enable truecolor
  if vim.fn.has("termguicolors") then
    vim.go.termguicolors = true
  end

  -- treesitter
  vim.schedule(function()
    vim.cmd([[
      " hi! link TSAnnotation
      " hi! link TSAttribute
      hi! link TSBoolean Boolean
      hi! link TSCharacter Character
      hi! link TSComment Comment
      " hi! link TSConstructor
      hi! link TSConditional Conditional
      hi! link TSConstant Constant
      hi! link TSConstBuiltin Constant
      hi! link TSConstMacro Constant
      " hi! link TSConstructor
      hi! link TSError GruvboxRedUnderline
      hi! link TSException Exception
      " hi! link TSField
      hi! link TSFloat Float
      hi! link TSFunction Function
      hi! link TSFuncBuiltin Function
      " hi! link TSFuncMacro
      hi! link TSInclude Include
      hi! link TSKeyword GruvboxRed
      hi! link TSKeywordFunction GruvboxAqua
      hi! link TSKeywordOperator TSOperator
      hi! link TSLabel Label
      " hi! link TSMethod
      " hi! link TSNamespace
      " hi! link TSNone
      hi! link TSNumber Number
      " hi! link TSOperator
      " hi! link TSParameter
      " hi! link TSParameterReference
      hi! link TSProperty GruvboxBlue
      hi! link TSPunctBracket GruvboxFg1
      hi! link TSPunctDelimiter GruvboxFg1
      " hi! link TSPunctSpecial
      hi! link TSRepeat Repeat
      hi! link TSString String
      " hi! link TSStringRegex
      " hi! link TSStringEscape
      " hi! link TSSymbol
      hi! link TSTag GruvboxGreen
      " hi! link TSTagDelimiter
      " hi! link TSText
      hi! TSStrong term=bold cterm=bold gui=bold
      hi! TSEmphasis term=italic cterm=italic gui=italic
      hi! TSUnderline term=underline cterm=underline gui=underline
      hi! TSStrike term=strikethrough cterm=strikethrough gui=strikethrough
      " hi! link TSTitle
      " hi! link TSLiteral
      " hi! link TSURI
      " hi! link TSMath
      " hi! link TSTextReference
      " hi! link TSEnviroment
      " hi! link TSEnviromentName
      " hi! link TSNote
      hi! link TSWarning WarningMsg
      hi! link TSDanger ErrorMsg
      hi! link TSType GruvboxAqua
      hi! link TSTypeBuiltin Type
      hi! link TSVariable GruvboxFg1
      hi! link TSVariableBuiltin Identifier
    ]])
  end)
end

require("config.plugins")

appearance_settings()
