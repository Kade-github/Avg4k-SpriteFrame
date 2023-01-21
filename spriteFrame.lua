-- Class.lua (https://github.com/jonstoler/class.lua)

Class = {}

-- default (empty) constructor
function Class:init(...) end

-- create a subclass
function Class:extend(obj)
	local obj = obj or {}

	local function copyTable(table, destination)
		local table = table or {}
		local result = destination or {}

		for k, v in pairs(table) do
			if not result[k] then
				if type(v) == "table" and k ~= "__index" and k ~= "__newindex" then
					result[k] = copyTable(v)
				else
					result[k] = v
				end
			end
		end

		return result
	end

	copyTable(self, obj)

	obj._ = obj._ or {}

	local mt = {}

	-- create new objects directly, like o = Object()
	mt.__call = function(self, ...)
		return self:new(...)
	end

	-- allow for getters and setters
	mt.__index = function(table, key)
		local val = rawget(table._, key)
		if val and type(val) == "table" and (val.get ~= nil or val.value ~= nil) then
			if val.get then
				if type(val.get) == "function" then
					return val.get(table, val.value)
				else
					return val.get
				end
			elseif val.value then
				return val.value
			end
		else
			return val
		end
	end

	mt.__newindex = function(table, key, value)
		local val = rawget(table._, key)
		if val and type(val) == "table" and ((val.set ~= nil and val._ == nil) or val.value ~= nil) then
			local v = value
			if val.set then
				if type(val.set) == "function" then
					v = val.set(table, value, val.value)
				else
					v = val.set
				end
			end
			val.value = v
			if val and val.afterSet then val.afterSet(table, v) end
		else
			table._[key] = value
		end
	end

	setmetatable(obj, mt)

	return obj
end

-- set properties outside the constructor or other functions
function Class:set(prop, value)
	if not value and type(prop) == "table" then
		for k, v in pairs(prop) do
			rawset(self._, k, v)
		end
	else
		rawset(self._, prop, value)
	end
end

-- create an instance of an object with constructor parameters
function Class:new(...)
	local obj = self:extend({})
	if obj.init then obj:init(...) end
	return obj
end


function class(attr)
	attr = attr or {}
	return Class:extend(attr)
end

-- Spriteframe code

SpriteFrame = {}

SpriteFrame.sprites = {

}

SpriteFrame.texts = {

}

function SpriteFrame.create()
    Object = class()
    Object:set{
        x = 0,
        y = 0,
        rX = 0,
        rY = 0,
        name = "",
        alpha = 1,
    }
    Sprite = Object:extend()
    Sprite:set{
        width = 0,
        height = 0,
        spritesheet = false,
        --[[
            Structure:

            startFrame
            endFrame
        ]]--
        sheetAnims = {},
        sparrow = false,
        curAnim = "",
        frame = 0,
        loop = false,
        fps = 0,
        playing = false,
        scale = {
            value = 1,
            set = function(self, n, o)
                setSpriteMod(self.name, 'mini', (1.5 - n))
                return n
            end
        }
    }

    Text = Sprite:extend()
    Text:set{
        font = "",
        size = 0,
        text = {
            value = "",
            set = function(self, n, o) 
                setText(self.name, n)
                return n
            end
        }
    }


    function Text:free()
        local index = 0
        for i = 1, #SpriteFrame.texts do
            if SpriteFrame.texts[i].name == self.name then
                index = i
            end
        end
        if index ~= 0 then
            table.remove(SpriteFrame.texts, index)
        end
    end

    function Text:init(name, font, initialText, size, x, y)
        createText(name, font, initialText, size, x, y)
        self.name = name
        self.x = x
        self.y = y
        self.size = size
        self.font = font
        table.insert(SpriteFrame.texts, self)
    end

    function Sprite:init(name, path, x, y)
        createSprite(path, name, x, y)
        self.name = name
        self.x = x
        self.y = y
        self.rX = x
        self.rY = y
        self.width = getSpriteWidth(name)
        self.height = getSpriteHeight(name)
        table.insert(SpriteFrame.sprites, self)
    end

    function Sprite:playAnim(anim)
        self.curAnim = anim
        self.frame = 0
        self.playing = true
        if self.sparrow then
            setSpriteProperty(self.name, "anim", anim)
        else
            setSpriteProperty(self.name, "anim", "anim")
        end
    end

    function Sprite:setSparrow(xml)
        if xml == nil then
            self.sparrow = false
            return
        end
        self.sparrow = true
        self.spritesheet = false
        setSpriteProperty(self.name, "sparrow", tostring(xml))
        setSpriteProperty(self.name, "loop", tostring(self.loop))
        setSpriteProperty(self.name, "fps", tostring(self.fps))
    end

    function Sprite:setSheet(frameWidth)
        self.sparrow = false
        self.spritesheet = true
        setSpriteProperty(self.name, "sheet", tostring(frameWidth))
        setSpriteProperty(self.name, "loop", tostring(self.loop))
        setSpriteProperty(self.name, "fps", tostring(self.fps))
    end


    consolePrint("SpriteFrame Loaded! Created by Kade :)")
end

function SpriteFrame.update()
    for index, s in ipairs(SpriteFrame.sprites) do
        setSpriteMod(s.name, 'movex', s.x - s.rX)
        setSpriteMod(s.name, 'movey', s.y - s.rY)
        setSpriteMod(s.name, 'stealth', math.abs(s.alpha - 1))
        local animated = s.sparrow or s.spritesheet
        if animated then
            if s.playing then
                s.frame = getSpriteFrame(s.name)
            end
            if getSpriteFinished(s.name) then
                s.playing = false
            end

            if s.spritesheet and #s.sheetAnims > 0 then
                local anim = s.sheetAnims[s.curAnim]
                local s = anim[1]
                local e = anim[2]

                setSpriteProperty(s.name, "rangeMin", s)
                setSpriteProperty(s.name, "rangeMax", e)
            end
        end
    end
    for index, t in ipairs(SpriteFrame.texts) do
        setTextPos(t.name, t.x, t.y)
    end
end
