local ls = require("luasnip")
local f = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix

local mod = {
  postfix = {},
}

mod.postfix.increment = postfix({
  trig = "++",
  hidden = true,
}, {
  f(function(_, parent)
    return string.format("%s = %s + 1", parent.snippet.env.POSTFIX_MATCH, parent.snippet.env.POSTFIX_MATCH)
  end, {}),
})

mod.postfix.decrement = postfix({
  trig = "--",
  hidden = true,
}, {
  f(function(_, parent)
    return string.format("%s = %s - 1", parent.snippet.env.POSTFIX_MATCH, parent.snippet.env.POSTFIX_MATCH)
  end, {}),
})

return mod
