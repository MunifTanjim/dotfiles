if exists('b:current_syntax')
  finish
end

lua require('plugins.ui.quickfix').syntax()

let b:current_syntax = 'qf'
