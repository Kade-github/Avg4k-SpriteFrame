# SpriteFrame
A mod framework for Average4K on manipulating text/sprites.

## Setup

Make sure your file is like this 
```lua
function create()
    -- This dofile runs spriteFrame
    dofile(formCompletePath("spriteFrame.lua"))

    SpriteFrame.create() -- this inits the classes
end

function update(beat) -- Updates our sprites
    SpriteFrame.update()
end
```

You can include ModFrame with this as well.

## How to use

Unlike [ModFrame](https://github.com/KadeDev/Avg4k-ModFrame), SpriteFrame is class based.

> Creating a sprite

```lua
-- creates a sprite at 200,200 named "mySprite" with the file "sprite.png" in the mod folder
local sprite = Sprite:new('mySprite','sprite',200,200)
```

You can then modify the sprite by setting its properties, like:
```lua
-- Set the sprites position to 2,2
sprite.x = 2
sprite.y = 2
-- Set its scale to 0.6x
sprite.scale = 0.6
-- Print the sprites width and height
consolePrint(tostring(sprite.width) .. ', ' .. tostring(sprite.height))
```

> Creating text

```lua
local text = Text:new('myText','arial','hello world', 24, 20, 20)
```

You can also modify it using the same type of method
```lua
-- Set the text to 2,2
text.x = 2
text.y = 2
-- Print details about this text object
consolePrint(text.font .. ', ' .. tostring(text.size))
-- Set the text of this text object
text.text = "goodbye world"
-- Remove the text object (only for text stuff)
text:free()
```

> Custom fonts

You can set the current font folder to read from by using `setFontFolder`,

Example:
```lua
-- reads fonts from mod/test/
setFontFolder('test')
```
