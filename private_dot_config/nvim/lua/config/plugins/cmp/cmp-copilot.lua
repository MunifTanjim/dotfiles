local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:is_available()
  return vim.fn["copilot#Enabled"]() == 1
end

function source:get_debug_name()
  return "github copilot"
end

function source:complete(params, callback)
  vim.fn["copilot#Complete"](function(result)
    callback({
      isIncomplete = true,
      items = vim.tbl_map(function(item)
        local prefix = string.sub(
          params.context.cursor_before_line,
          item.range.start.character + 1,
          item.position.character
        )
        return {
          kind = 1,
          label = prefix .. item.displayText,
          score = item.score,
          textEdit = {
            range = item.range,
            newText = item.text,
          },
          data = {
            uuid = item.uuid,
          },
        }
      end, (result or {}).completions or {}),
    })
  end, function()
    callback({
      isIncomplete = true,
      items = {},
    })
  end)
end

local function deindent(text)
  local indent = string.match(text, "^%s*")
  if not indent then
    return text
  end
  return string.gsub(string.gsub(text, "^" .. indent, ""), "\n" .. indent, "\n")
end

function source:resolve(completion_item, callback)
  completion_item.documentation = {
    kind = "markdown",
    value = table.concat({
      "```" .. vim.bo.filetype,
      deindent(completion_item.textEdit.newText),
      "```",
    }, "\n"),
  }

  callback(completion_item)
end

function source:execute(completion_item, callback)
  if completion_item.data and completion_item.data.uuid then
    vim.fn["copilot#Request"]("notifyAccepted", { uuid = completion_item.data.uuid })
  end
  callback(completion_item)
end

return source
