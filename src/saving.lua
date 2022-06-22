local currentSaving = nil

local formats = {}

---@param name string
---@param signature string
---@param encoder function|nil
---@param decoder function
function CreateFormat(name, signature, encoder, decoder)
    formats[name] = {
        signature = signature,
        encode = encoder,
        decode = decoder,
    }
end

---@param format nil|string
function SaveGrid(format)
    format = format or currentSaving

    if type(format) == "string" then
        if type(formats[format].encode) == "function" then
            output('Encoding with ' .. format .. '...')
            return formats[format].encode(Grid)
        else
            output('Format ' .. format .. ' has no encoder.')
            return nil
        end
    else
        return nil
    end
end

---@param string string String is string
function DecodeGrid(string)
    for format, formatData in pairs(formats) do
        if string:sub(1, #(formatData.signature)) == formatData.signature then
            output('Decoding with ' .. format .. '...')
            return formatData.decode(string)
        end
    end
end

BindCommand("save-level", function(args)
    local format = args[1] or currentSaving

    if format == nil then
        print("No level saving format is installed.")
    else
        local s = SaveGrid(format)
        if s then print(s) end
    end
end)