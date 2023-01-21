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

> Animation

Animation example with a horizontal sprite sheet (only one that works, except for sparrow. which is kind of the same as the defined version in the avg4k mod docs)

```lua
local sprite = Sprite:new("explosion", "explosion", 20, 20)
sprite.loop = true
sprite.fps = 24
sprite:setSheet(64)
-- start at frame 0, end at frame 17
sprite.sheetAnims["explode"] = {0, 17}
-- You can add as many as you want, just remember to set their start and end frames correctly
-- example: sprite.sheetAnims["explode2"] = {18, 35}
-- then you would call sprite:playAnim("explode2") etc
sprite:playAnim("explode")
```

Sprite Sheet: 

![explosion](https://user-images.githubusercontent.com/26305836/213835433-b1cce86e-72cb-4d9f-9373-70dc0d3885a6.png)

Final Product: 

![explosion example](https://user-images.githubusercontent.com/26305836/213835425-fe7eacfb-6ce7-4aaa-ac32-628b73d0d986.gif)

> Creating text

```lua
-- Create a new text object named "myText", with the font "arial", with the initial text of "hello world", and the size of 24.
-- Also position the text to 20,20
local text = Text:new('myText','arial','hello world', 24, 20, 20)
```

Avaliable fonts are located at *assets/graphical/fonts/* in the Average4K folder

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

-- It is recommended to do any text/sprite moving in the update(beat) function.
-- as that will actually move it. lol
```
