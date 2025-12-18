local bxor = {}

function bxor:_xor(data, key)
    local out = table.create(#data)
    local keyLen = #key

    for i = 1, #data do
        local d = string.byte(data, i)
        local k = string.byte(key, ((i - 1) % keyLen) + 1)
        out[i] = string.char(bit32.bxor(d, k))
    end

    return table.concat(out)
end

function bxor:encrypt(data, key)
    return self:_xor(data, key)
end

function bxor:decrypt(data, key)
    return self:_xor(data, key)
end

return bxor
