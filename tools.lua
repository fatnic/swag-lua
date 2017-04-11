local tools = {}

function tools.ternary(cond, t, f)
    if cond then return t else return f end
end

return tools
