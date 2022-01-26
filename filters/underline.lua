-- Filter underline with this function if the target format is LaTeX.
if FORMAT:match 'latex' then
  function Underline (elem)
    -- Replace \underline with \ul from package soul in LaTeX.
    local output = { pandoc.RawInline('latex', '\\ul{') }
    for _, child in ipairs(elem.content) do
      table.insert(output, child)
    end
    table.insert(output, pandoc.RawInline('latex', '}'))
    return output
  end
end
