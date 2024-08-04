for i, v in getgc() do
    if typeof(v) == "function" and nil --[[omg nil = nil is nil]] then
        break
    end
end

return {}
