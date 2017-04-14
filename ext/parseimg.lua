--- Parseimg, v0.1
--
-- A library for turning love2d ImageData into high-level datastructures.
--
-- MIT License
-- 
-- Copyright (c) 2017 Kyle McLamb <alloyed@tfwno.gf>
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local parseimg = {}

--- every function takes an opts table, which can define any of the fields
--  below. If you do not specify a field, then the default listed below is used.
--  no opts table is the same as an empty table
local default = {
   -- rects() only. this defines the direction the scanline algorithm operates
   -- in A horizontal direction will prioritise unbroken lines on the
   -- horizontal axis, where a vertical direction will do the same on the
   -- vertical axis.
   direction = "horizontal",
   -- A "threshold" function, which given two color tables determines whether
   -- or not they should be considered the same color.
   --
   -- This function should be symmetric, meaning the order of a and b shouldn't
   -- matter.
   --
   -- Also, it should be transitive, meaning that if F(a, b) and F(b, c) are
   -- both true then F(a, c) should be true. this means that
   --     a - b < epsilon
   -- is bad, but
   --     round(a) == round(b)
   -- is fine.
   threshold = function(a, b)
      return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
   end,
   -- When defined, instead of parsing the whole image, only parse the part of
   -- the image within rectangle {x, y, w, h}.
   scissor = {},
}

-- should this be an option?
local function transparent(color)
   return color[4] == 0
end

local function range(img, clip)
   local x0, y0 = clip[1] or 0, clip[2] or 0
   local x1, y1 = img:getDimensions()
   if clip[3] then
      x1 = clip[3] + x0
   end
   if clip[4] then
      y1 = clip[4] + y0
   end
   return x0, y0, x1, y1
end

--- Turns an ImageData object into sequence of axis-aligned rectangles, using a
--  scanline algorithm. the rectangles will never overlap, but multiple
--  rectangles can represent a single "island" of pixels if the shape of the
--  island isn't itself rectangular.
--  example output:
--    {
--      { color = { 172, 50,  50, 255 }, x = 13, y = 26, w = 1, h = 2 },
--      { color = { 106, 190, 48, 255 }, x = 13, y = 16, w = 3, h = 1 },
--      { color = { 172, 50,  50, 255 }, x = 15, y = 29, w = 1, h = 3 }
--    }
--      
function parseimg.rects(img, opts)
   -- FIXME: implementation of vertical direction is super hacky
   -- This code is a lot less clear than it could be
   opts = opts or {}
   local threshold = opts.threshold or default.threshold
   local direction = opts.direction or default.direction
   local clip      = opts.scissor or default.scissor

   -- impl
   local x0, y0, x1, y1 = range(img, clip)
   if direction == "vertical" then
      x0, y0 = y0, x0
      x1, y1 = y1, x1
   end
   local out  = {}
   local lines = {}
   local aabb = nil

   for y = y0, y1-1 do
      local x = x0-1
      while x < x1-1 do
         x = x + 1
         local pixel
         if direction == "vertical" then
            pixel = {img:getPixel(y, x)}
         else
            pixel = {img:getPixel(x, y)}
         end

         if not transparent(pixel) and not aabb then
            -- start line
            aabb = {
               x = x,
               y = y,
               h = 1,
               color = pixel
            }
         elseif aabb and not threshold(aabb.color, pixel) then
            -- end line
            x = x - 1 -- backtrack
            aabb.w = x + 1 - aabb.x
            local line = lines[aabb.x]
            if not line then
               -- start new box
               aabb.h = 1
               lines[aabb.x] = aabb
            elseif line.w == aabb.w and threshold(line.color, aabb.color) then
               -- continue box
               line.h = line.h + 1
            else
               -- replace box
               table.insert(out, line)
               lines[aabb.x] = aabb
            end
            aabb = nil
         end
      end

      if aabb then
         -- finish line if it goes to the edge
         aabb.w = x1 - aabb.x
         local line = lines[aabb.x]
         if not line then
            -- start new box
            aabb.h = 1
            lines[aabb.x] = aabb
         elseif line.w == aabb.w and threshold(line.color, aabb.color) then
            -- continue box
            line.h = line.h + 1
         else
            -- replace box
            --line.h = line.h - 1
            table.insert(out, line)
            lines[aabb.x] = aabb
         end
         aabb = nil
      end

      -- clean out lines that didn't get continued
      for k, line in pairs(lines) do
         if line.y + line.h - 1 < y then
            table.insert(out, line)
            lines[k] = nil
         end
      end
   end

   -- clean final lines
   for k, line in pairs(lines) do
      table.insert(out, line)
      lines[k] = nil
   end

   -- we actually operated on a rotated canvas, derotate for the real result
   if direction == "vertical" then
      for _, rect in ipairs(out) do
         rect.w, rect.h = rect.h, rect.w
         rect.x, rect.y = rect.y, rect.x
      end
   end

   return out
end

--- Turns a png image into a sequence of point-radius pairs, by finding islands
--  of pixels that are the same color.
--  For each island, a circle is returned that is the smallest circle that can
--  hold every pixel of the island inside itself. This means will always be one
--  circle per island, even if the island itself isn't circular or even convex.
--
--  This doubles as a "points" algorithm if you just ignore the radius: the
--  center of each circle is always the average of each pixel in the island.
--
--  example output:
--    
--    {
--      {
--        color = { 238, 195, 154, 255 },
--        r = 0.70710678118655,
--        x = 17.5,
--        y = 20.5
--      }, {
--        color = { 118, 66, 138, 255 },
--        r = 2.2360679774998,
--        x = 26,
--        y = 22
--      }, {
--        color = { 99, 155, 255, 255 },
--        r = 1.4252192813739,
--        x = 0.875,
--        y = 30.125
--      }, {
--        color = { 99, 155, 255, 255 },
--        r = 1.4252192813739,
--        x = 30.125,
--        y = 30.125
--      } 
--    }
function parseimg.circles(img, opts)
   opts = opts or {}
   local threshold = opts.threshold or default.threshold
   local clip      = opts.scissor or default.scissor
   local x0, y0, x1, y1 = range(img, clip)

   local grid = {}
   local islands = {[false] = nil}

   for y=y0, y1-1 do
      grid[y] = {}
      for x=x0, x1-1 do
         local pixel = {img:getPixel(x, y)}

         local islandN = grid[y-1] and grid[y-1][x] or false
         local islandE = grid[y][x-1] or false

         local pixelN  = islands[islandN]
         local pixelE  = islands[islandE]

         local island_id = false
         if not transparent(pixel) then
            if pixelN and threshold(pixelN, pixel) then
               island_id = islandN
            elseif pixelE and threshold(pixelE, pixel) then
               island_id = islandE
            else
               islands[#islands+1] = pixel
               island_id = #islands
            end
         end
         grid[y][x] = island_id
      end

      -- repeat, looking ahead
      for x=x0, x1-1 do
         local pixel = {img:getPixel(x, y)}

         local islandW = grid[y][x+1] or false

         local pixelW  = islands[islandW]

         local island_id = grid[y][x]
         if pixelW and threshold(pixelW, pixel) then
            island_id = islandW
         end
         grid[y][x] = island_id
      end
   end

   local circles = {}
   for id, color in ipairs(islands) do
      circles[id] = {color = color, avg = {x=0, y=0}, points = 0, r = 0}
   end

   for y=y0, y1-1 do
      for x=x0, x1-1 do
         if grid[y][x] then
            local circle = circles[grid[y][x]]
            circle.avg.x  = circle.avg.x + x
            circle.avg.y  = circle.avg.y + y
            circle.points = circle.points + 1
         end
      end
   end

   -- find midpoint
   for i=#circles, 1, -1  do
      local circle = circles[i]
      if circle.points > 0 then
         circle.x = circle.avg.x / circle.points
         circle.y = circle.avg.y / circle.points
         circle.avg = nil
         circle.points = nil
      end
   end

   -- find max distance between pixel and center
   for y=y0, y1-1 do
      for x=x0, x1-1 do
         local circle = grid[y][x] and circles[grid[y][x]]
         if circle then
            local dx, dy = circle.x-x, circle.y-y
            local dist2 = dx*dx+dy*dy
            if dist2 > circle.r then
               circle.r = dist2
            end
         end
      end
   end
   
   -- final step, sqrt final radiuses and remove empty circles, invalidates
   -- grid
   for i=#circles, 1, -1  do
      local circle = circles[i]
      if circle.points then
         table.remove(circles, i)
      else
         circle.r = math.sqrt(circle.r)
      end
   end

   return circles
end

local function fmt(color)
   return string.format("%d|%d|%d|%d", unpack(color))
end

--- Returns a simple sequence of all colors in the given imagedata in
--  undefined order
--  example output:
--      {
--        {0,   0,   0,   255},
--        {100, 200, 100, 255},
--        {172, 50,  50,  255}
--      }
function parseimg.palette(img, opts)
   opts = opts or {}
   -- FIXME: we don't respect threshold
   local threshold = opts.threshold or default.threshold
   local clip      = opts.scissor or default.scissor
   local x0, y0, x1, y1 = range(img, clip)

   local colors = {}
   local cset   = {}

   for y=y0, y1-1 do
      for x=x0, x1-1 do
         local color = {img:getPixel(x, y)}

         if not transparent(color) then
            local key = fmt(color)
            if not cset[key] then
               table.insert(colors, color)
               cset[key] = true
            end
         end
      end
   end

   return colors
end

return parseimg
