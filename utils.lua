local utils = {}

function utils.copyTable(obj)
    if type(obj) ~= 'table' then return obj end
    local res = {}
    for k, v in pairs(obj) do res[copyTable(k)] = copyTable(v) end
    return res
end

function utils.hslToRgb(h, s, l, a)
    local r, g, b

    if s == 0 then
        r, g, b = l, l, l -- achromatic
    else
        function hue2rgb(p, q, t)
            if t < 0   then t = t + 1 end
            if t > 1   then t = t - 1 end
            if t < 1/6 then return p + (q - p) * 6 * t end
            if t < 1/2 then return q end
            if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
            return p
        end

        local q
        if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
        local p = 2 * l - q

        r = hue2rgb(p, q, h + 1/3)
        g = hue2rgb(p, q, h)
        b = hue2rgb(p, q, h - 1/3)
    end

    return r, g, b, a
end

return utils