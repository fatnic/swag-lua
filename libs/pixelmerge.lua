-- lifted and modified from https://love2d.org/forums/viewtopic.php?f=5&t=8021
local PixelMerge = {}

function PixelMerge.parse(idata)

    local img_width = idata:getWidth()
    local img_height = idata:getHeight()

    local rectangles = {}

    local function isAlpha(x, y)
        local r, g, b, a = idata:getPixel(x, y)
        return a > 0
    end

    for x = 0, img_width - 1 do
        local start_y
        local end_y

        for y = 0, img_height - 1 do

            if isAlpha(x, y) then
                if not start_y then
                    start_y = y
                end
                end_y = y

            elseif start_y then

                local overlaps = {}

                for _, r in ipairs(rectangles) do
                    if (r.end_x == x - 1) and (start_y <= r.start_y) and (end_y >= r.end_y) then
                        table.insert(overlaps, r)
                    end
                end

                table.sort(overlaps, function (a, b) return a.start_y < b.start_y end)

                for _, r in ipairs(overlaps) do
                    if start_y < r.start_y then
                        local new_rect = { start_x = x, start_y = start_y, end_x = x, end_y = r.start_y - 1 }
                        table.insert(rectangles, new_rect)
                        start_y = r.start_y
                    end

                    if start_y == r.start_y then
                        r.end_x = r.end_x + 1

                        if end_y == r.end_y then
                            start_y = nil
                            end_y = nil
                        elseif end_y > r.end_y then
                            start_y = r.end_y + 1
                        end

                    end
                end

                if start_y then
                    local new_rect = { start_x = x, start_y = start_y, end_x = x, end_y = end_y }
                    table.insert(rectangles, new_rect)
                    start_y = nil
                    end_y = nil
                end
            end
        end

        if start_y then
            local new_rect = { start_x = x, start_y = start_y, end_x = x, end_y = end_y }
            table.insert(rectangles, new_rect)
            start_y = nil
            end_y = nil
        end

    end

    local final = {}
    for _, r in pairs(rectangles) do
        table.insert(final, { x = r.start_x, y = r.start_y, width = r.end_x - r.start_x, height = r.end_y - r.start_y })
    end

    return final
end

return PixelMerge
