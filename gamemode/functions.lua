function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function placeholder()
    print("Generic Placeholder")
end

function sec_to_min(seconds)
    local minutes = math.floor(seconds / 60)
    local remaining_seconds = seconds % 60
    return string.format("%02d:%02d", minutes, remaining_seconds)
end