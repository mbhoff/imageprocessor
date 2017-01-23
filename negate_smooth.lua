--[[

  * * * * negate_smooth.lua * * * *

Lua image processing program: performs image negation and smoothing.
Menu routines are in example2.lua, IP routines are negate_smooth.lua.

Author: John Weiss, Ph.D.
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local il = require "il"

-----------------
-- IP routines --
-----------------





-- negate/invert image 
-- written by Dr. Weiss
local function negate1( img )
  local nrows, ncols = img.height, img.width

  -- for each pixel in the image
  for r = 0, nrows-1 do
    for c = 0, ncols-1 do
      -- negate each RGB channel
      for ch = 0, 2 do
        img:at(r,c).rgb[ch] = 255 - img:at(r,c).rgb[ch]
      end
    end
  end

  -- return the negated image
  -- note: input image was modified (did not make a copy)
  return img
end

-- negate/invert image using mapPixels
-- written by Dr. Weiss
local function negate2( img )
  return img:mapPixels(function( r, g, b )
      return 255 - r, 255 - g, 255 - b
    end
  )
end

-----------------


-- grayscale image using mapPixels
-- written by Dr. Weiss
local function grayscale( img )
  return img:mapPixels(function( r, g, b )
      local temp = r * .30 + g * .59 + b * .11
      return temp, temp, temp
    end
  )
end


local function bthreshold( img, threshold )
  return img:mapPixels(function( r, g, b )
    local temp = r * .30 + g * .59 + b * .11

    
      if temp > threshold
        then temp = 100
      else thresh = 0
    end
    
      return temp, temp, temp
    end
    )
end


local function posterize( img, levels )
  return img:mapPixels(function( r, g, b)
      
      
      local delta = 255 / levels
      print(delta)
      a = {}
      for i = 1, levels do a[i] = i*delta end
      
      local count = 1
      while r > a[count]
      do count = count + 1
      end
      
      local red = a[count]
      
      
      count = 1
      while g > a[count]
      do count = count + 1
      end
        
      local blue = a[count]
      
      
      count = 1
      while b > a[count]
      do count = count + 1
      end
      
      local green = a[count]
      
      return red, green, blue
    end
  )
  end







-- 3x3 smoothing
local function smooth( img )
  local nrows, ncols = img.height, img.width

  -- convert image from RGB to YIQ
  img = il.RGB2YIQ( img )

  -- make a local copy of the image
  local res = img:clone()

  -- use pixel iterator over image, instead of nested loops
  -- for r = 1,nrows-2 do for c = 1,ncols-2 do ...
  for r, c in img:pixels(1) do
    -- sum 3x3 neighborhood pixel intensities
    local sum = 0
    for i = -1, 1 do
      for j = -1, 1 do
        sum = sum + img:at(r+i,c+j).y     -- .y is more concise than .rgb[0]
      end
    end
    -- store the neighborhood average
    res:at(r,c).y = sum / 9
  end

  -- convert smoothed image from YIQ to RGB and return the smoothed image
  -- note: input image was not modified (made a copy)
  return il.YIQ2RGB( res )
end

------------------------------------
-------- exported routines ---------
------------------------------------

return {
  grayscale = grayscale,
  bthreshold = bthreshold,
  posterize = posterize,
  
  negate1 = negate1,
  negate2 = negate2,
  smooth = smooth,
}
