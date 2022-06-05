--[[
	SCRIPT BY RALTYRO
	LAST MODIFIED JUNE 6 2022
	FIRST CREATED JUNE 5 2022
--]]

local gameWidth, gameHeight = 0, 0
local curLightEvent = -1
local curLight = -1
local inPhilly = false
local week7 = false

function string.startsWith(self, prefix) return self:find(prefix, 1, true) == 1 end
function string.endsWith(self, suffix) return self:find(suffix, 1, true) == #self - (#suffix - 1) end

function table.find(table,v)
	for i,v2 in next,table do
		if v2 == v then
			return i
		end
	end
end

local phillyLightsColors = {-13524227, -13501044, -314379, -178895, -285133}
local function from_hex(hex)
    local a, r, g, b = string.match(hex, "^0x?(%w%w)(%w%w)(%w%w)(%w%w)$")
    return tonumber(a, 16), tonumber(r, 16),
        tonumber(g, 16), tonumber(b, 16)
end

local function colorBrightness(n, br) -- from number
	local a, r, g, b = from_hex("0x" .. string.format("%X", n):sub(9))
	local hex = "0x" .. string.format("%02X%02X%02X", math.ceil(r * br), math.ceil(g * br), math.ceil(b * br))
	return tonumber(hex)
end

function onCreate()
	gameWidth, gameHeight = screenWidth, screenHeight
	local phillyWindowX, phillyWindowY = 0, 0
	
	inPhilly = type(getProperty("phillyTrain.x")) == "number" -- Check if it's in Philly Stage
	week7 = inPhilly and type(getProperty("phillyStreet.x")) == "number" -- Check if the user Psych Engine has Official Week 7
	
	
	
	-- Stage Here
	if (inPhilly) then
		if (week7) then
			phillyWindowX, phillyWindowY = getProperty("phillyWindow.x"), getProperty("phillyWindow.y")
			
			phillyLightsColors = getProperty("phillyLightsColors")
		else -- shit...
			local foundStreet, foundCity = false, false
			local cityX, cityY = 0, 0
			local x, y = 0, 0
			
			for i = 0, getProperty("members.length") - 1 do
				local key = getPropertyFromGroup("members", i, "graphic.key")
				
				local isStreet =
					key:endsWith("philly/street.png")
				
				local isCity =
					key:endsWith("philly/city.png")
				
				local kill = false
				if (isStreet) then -- WE FOUND IT!!...... kill it.
					foundStreet = true
					
					kill = true
					x = getPropertyFromGroup("members", i, "x")
					y = getPropertyFromGroup("members", i, "y")
				elseif (isCity) then
					foundCity = true
					
					cityX = getPropertyFromGroup("members", i, "x")
					cityY = getPropertyFromGroup("members", i, "y")
				end
				
				if (kill) then
					setPropertyFromGroup("members", i, "alive", false)
					setPropertyFromGroup("members", i, "exists", false)
					setPropertyFromGroup("members", i, "visible", false)
					setPropertyFromGroup("members", i, "alpha", 0)
				end
				
				if (foundCity and foundStreet) then
					break
				end
			end
			
			for i = 0, getProperty("phillyCityLights.length") - 1 do
				setPropertyFromGroup("phillyCityLights", i, "alive", false)
				setPropertyFromGroup("phillyCityLights", i, "exists", false)
				setPropertyFromGroup("phillyCityLights", i, "visible", false)
				setPropertyFromGroup("phillyCityLights", i, "alpha", 0)
			end
			
			makeQSprite(
				"phillyWindow",
				"philly/window",
				type(cityX) == "number" and cityX or -10,
				type(cityY) == "number" and cityY or 0,
				.3,
				.3
			)
			setGraphicSize("phillyWindow", math.floor(getProperty("phillyWindow.width") * .85))
			updateHitbox("phillyWindow")
			addLuaSprite("phillyWindow")
			setObjectOrder("phillyWindow", getObjectOrder("phillyTrain") - 1)
			setProperty("phillyWindow.alpha", 0)
			
			-- after killing the og street, we remake it our own!! :D
			if (foundStreet) then
				makeLuaSprite("phillyStreet", "philly/street", type(x) == "number" and x or -50, type(y) == "number" and y or 50)
				addLuaSprite("phillyStreet")
			end
		end
	end
	
	makeLuaSprite("blammedLightsBlack", "", gameWidth * -.5, gameHeight * -.5)
	makeGraphic("blammedLightsBlack", gameWidth * 2, gameHeight * 2, "000000")
	setProperty("blammedLightsBlack.visible", false)
	addLuaSprite("blammedLightsBlack")
	setObjectOrder(
		"blammedLightsBlack",
		inPhilly and (week7 and getObjectOrder("phillyStreet") or 5) or getObjectOrder("gfGroup") - 1
	)
	local order = getObjectOrder("blammedLightsBlack")
	
	if (inPhilly) then
		makeQSprite("phillyWindowEvent", "philly/window", phillyWindowX, phillyWindowY, .3, .3)
		setGraphicSize("phillyWindowEvent", math.floor(getProperty("phillyWindowEvent.width") * .85))
		updateHitbox("phillyWindowEvent")
		setProperty("phillyWindowEvent.visible", false)
		addLuaSprite("phillyWindowEvent")
		setObjectOrder("phillyWindowEvent", order + 1)
	end
	
	makePhillyGlowGradient(-400, inPhilly and 225 or 272)
	setProperty("phillyGlowGradient.visible", false)
	if (not inPhilly) then setScrollFactor("phillyGlowGradient", 0.25, 0.25) end
	addLuaSprite("phillyGlowGradient")
	setObjectOrder("phillyGlowGradient", order + 1)
	
	precacheImage("philly/particle")
end

function onEvent(n, v1, v2)
	if (inGameOver) then return end
	
	if (n == "PhillyGlowLua" or n == "Philly Glow") then
		v1 = tonumber(v1)
		
		local color = 0xFFFFFF
		if (v1 == 0) then
			if (getProperty("phillyGlowGradient.visible")) then
				cameraFlash("game", "ffffff", .15, true)
				setPropertyFromClass(
					"flixel.FlxG",
					"camera.zoom",
					getPropertyFromClass("flixel.FlxG", "camera.zoom") + .5 + (
						getPropertyFromClass("ClientPrefs", "camZooms") and .1 or 0
					)
				)
				
				setProperty("blammedLightsBlack.visible", false)
				setProperty("phillyWindowEvent.visible", false)
				setProperty("phillyGlowGradient.visible", false)
				--setProperty("phillyGlowParticles.visible", false)
				
				despawnPhillyGlowParticles()
				
				setProperty("boyfriend.color", color)
				setProperty("gf.color", color)
				setProperty("dad.color", color)
				setProperty("phillyStreet.color", color)
			end
		elseif (v1 == 1) then -- turn on
			curLightEvent = getRandomInt(1, #phillyLightsColors, tostring(curLightEvent))
			color = phillyLightsColors[curLightEvent]
			
			if (not getProperty("phillyGlowGradient.visible")) then
				cameraFlash("game", "ffffff", .15, true)
				setPropertyFromClass(
					"flixel.FlxG",
					"camera.zoom",
					getPropertyFromClass("flixel.FlxG", "camera.zoom") + .5 + (
						getPropertyFromClass("ClientPrefs", "camZooms") and .1 or 0
					)
				)

				setProperty("blammedLightsBlack.visible", true)
				setProperty("blammedLightsBlack.alpha", 1)
				setProperty("phillyWindowEvent.visible", true)
				setProperty("phillyGlowGradient.visible", true)
				--setProperty("phillyGlowParticles.visible", true)
			elseif (getPropertyFromClass("ClientPrefs", "flashing")) then
				cameraFlash("game", "0x4cffffff", .5, true)
			end
			
			for i, v in pairs(phillyGlowParticles) do
				setProperty(v .. ".color", color)
			end
			
			setProperty("boyfriend.color", color)
			setProperty("gf.color", color)
			setProperty("dad.color", color)
			
			setProperty("phillyGlowGradient.color", color)
			setProperty("phillyWindowEvent.color", color)
			setProperty("phillyStreet.color", colorBrightness(color, .5))
		elseif (v1 == 2) then -- spawn particles
			if (not getPropertyFromClass("ClientPrefs", "lowQuality")) then
				local particlesNum = getRandomInt(8, 12)
				local width = (2000 / particlesNum)
				local color = phillyLightsColors[curLightEvent]
				
				for j = 0, 3 do
					for i = 0, particlesNum do
						spawnPhillyGlowParticle(
							-400 + width * i + getRandomFloat(-width / 5, width / 5),
							phillyGlowGradientOriginY + 200 + (getRandomFloat(0, 125) + j * 40),
							color
						)
						
						--[[
						(
							-400 + width * i + FlxG.random.float(-width / 5, width / 5),
							phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40),
							color
						);
						]]
					end
				end
			end
			bopPhillyGlowGradient()
		end
	elseif (n == "Set Property" and not week7) then
		setProperty(v1, tonumber(v2) or v2)
	end
end

function onBeatHit()
	if (inGameOver) then return end
	
	if (inPhilly and math.fmod(curBeat, 4) == 0) then
		curLight = getRandomInt(1, #phillyLightsColors, tostring(curLight))
		local color = phillyLightsColors[curLight]
		
		setProperty("phillyWindow.color", color)
		setProperty("phillyWindow.alpha", 1)
	end
end

function onUpdate(dt)
	if (inGameOver) then return end
	
	if (inPhilly) then
		setProperty("phillyWindow.alpha", getProperty("phillyWindow.alpha") - ((crochet / 1000) * dt * 1.5))
	end
	
	updatePhillyGlowGradient(dt)
	updatePhillyGlowParticles(dt)
end



-- QSprite
function makeQSprite(tag, img, x, y, xscroll, yscroll, active)
	makeLuaSprite(tag, img, x, y)
	setScrollFactor(tag, xscroll, yscroll)
	
	if (not active) then
		setProperty(tag .. ".active", false)
	end
end

-- phillyGlowParticle
phillyGlowParticles = {}
if (true) then
	local i = 0
	local n = "PhillyGlowParticleLua"
	
	local lifetimes = {}
	local decays = {}
	
	local alphas = {}
	local originalscales = {}
	
	function spawnPhillyGlowParticle(x, y, color)
		local spr = n .. tostring(i)
		
		lifetimes[spr] = getRandomFloat(.6, .9)
		decays[spr] = getRandomFloat(.8, 1)
		
		alphas[spr] = 1
		originalscales[spr] = getRandomFloat(.75, 1)
		
		local s = (inPhilly and 1 or .25)
		makeQSprite(spr, "philly/particle", x, y, getRandomFloat(.3, .75) * s, getRandomFloat(.65, .75) * s, true)
		scaleObject(spr, originalscales[spr], originalscales[spr])
		setProperty(spr .. ".color", color)
		
		setProperty(spr .. ".velocity.x", getRandomFloat(-40, 40))
		setProperty(spr .. ".velocity.y", getRandomFloat(-175, -250))
		
		setProperty(spr .. ".acceleration.x", getRandomFloat(-10, 10))
		setProperty(spr .. ".acceleration.y", 25)
		
		addLuaSprite(spr)
		setObjectOrder(spr, getObjectOrder("phillyGlowGradient") + 1)
		
		table.insert(phillyGlowParticles, spr)
		i = i + 1
	end
	
	function despawnPhillyGlowParticle(spr)
		removeLuaSprite(spr, true)
		
		local i = table.find(phillyGlowParticles, spr)
		if (i) then
			table.remove(phillyGlowParticles, i)
			lifetimes[spr] = nil
			decays[spr] = nil
			originalscales[spr] = nil
		end
	end
	
	function despawnPhillyGlowParticles()
		local spr
		for i = #phillyGlowParticles, 1, -1 do
			spr = phillyGlowParticles[i]
			
			removeLuaSprite(spr, true)
			
			table.remove(phillyGlowParticles, i)
			lifetimes[spr] = nil
			decays[spr] = nil
			originalscales[spr] = nil
		end
	end
	
	function updatePhillyGlowParticles(dt)
		local v, lifetime, alpha
		for i = #phillyGlowParticles, 1, -1 do
			v = phillyGlowParticles[i]
			
			alpha = alphas[v]
			
			lifetimes[v] = lifetimes[v] - dt
			lifetime = lifetimes[v]
			if (lifetime < 0) then
				alpha = alpha - (decays[v] * dt)
				
				lifetime = 0
				
				if (alpha > 0) then
					local originalScale = originalscales[v]
					scaleObject(v, originalScale * alpha, originalScale * alpha)
				end
			end
			
			alphas[v] = alpha
			
			if (alpha < 0) then
				despawnPhillyGlowParticle(v)
			else
				--print(v, alpha)
				setProperty(v .. ".alpha", alpha)
			end
		end
	end
end

-- phillyGlowGradient
phillyGlowGradientOriginY = 0
if (true) then
	local madedPhillyGlowGradient = false
	
	local originalY
	local originalHeight = 400
	
	function makePhillyGlowGradient(x, y)
		if (madedPhillyGlowGradient) then return error("Cannot Create another phillyGlowGradient!") end
		madedPhillyGlowGradient = true
		
		makeQSprite("phillyGlowGradient", "philly/gradient", x, y, 0, .75)
		phillyGlowGradientOriginY = y
		originalY = y
		
		setGraphicSize("phillyGlowGradient", 2000, originalHeight)
		updateHitbox("phillyGlowGradient")
	end
	
	function updatePhillyGlowGradient(elapsed)
		local newHeight = math.floor((getProperty("phillyGlowGradient.height") - 1000 * elapsed) + .5)
		
		if (newHeight > 0) then
			setProperty("phillyGlowGradient.alpha", 1)
			setGraphicSize("phillyGlowGradient", 2000, newHeight)
			updateHitbox("phillyGlowGradient")
			setProperty(
				"phillyGlowGradient.y",
				originalY + (originalHeight - getProperty("phillyGlowGradient.height"))
			)
		else
			setProperty("phillyGlowGradient.alpha", 0)
			setProperty("phillyGlowGradient.y", -5000)
		end
	end
	
	function bopPhillyGlowGradient()
		setGraphicSize("phillyGlowGradient", 2000, originalHeight)
		updateHitbox("phillyGlowGradient")
		setProperty("phillyGlowGradient.y", originalY)
		setProperty("phillyGlowGradient.alpha", 1)
	end
end











-- debyggin shits
local L = onCreate
function onCreate(...)
	local s, w = pcall(L, ...)
	if not s then print(w, debug.getinfo(L)) end
end

local L = onEvent
function onEvent(...)
	local s, w = pcall(L, ...)
	if not s then print(w, debug.getinfo(L)) end
end

local L = onUpdate
function onUpdate(...)
	local s, w = pcall(L, ...)
	if not s then print(w, debug.getinfo(L)) end
end

-- stuff omg
function _G.strThing(s,i)
	local str = ""
	for i = 1,i do
		str = str .. s
	end
	return str
end

local function approriateStr(str,isIndex)
	if isIndex then
		local wrap = false

		if str:find(' ') or str:find('	') or str:find('"') or str:find("'") then wrap = true end
		local c = approriateStr(str)

		return wrap and "["..c..(string.sub(c,#c,#c) == "]" and " ]" or "]") or str
	else
		local v = '"'

		if str:find(v) then
			v = "'"
			if str:find(v) then
				v = "[["
				if str:find("]]") then
					v = nil
				end
			end
		end

		if v ~= nil then
			return v..str..(v == "[[" and "]]" or v)
		end
	end
end

local tableToStr = nil
tableToStrLIMITTABLES = 4
function tableToStr(t,cln,x)
	if type(x) == "number" and (x or 0) >= tableToStrLIMITTABLES then return "Limited" end
	local count,indexNumber = 0,true
	for i,v in pairs(t) do
		count = count + 1
		if type(i) ~= "number" or type(v) == "table" then indexNumber = false end
	end
	if count < 8 and indexNumber then cln = false end
	
	local a = 1+(type(x) == "number" and x or 0)
	local str = --[[(cln and strThing("	",a-1) or "")..]]"{"..(cln and "\n" or "")
	
	for i,v in pairs(t) do
		if cln then str = str..strThing("	",a) end
		if type(i) == "string" then
			str = str..approriateStr(i,true)..' = '
		end
		if type(v) == "table" then
			str = str..tableToStr(v,cln,a)
		else
			str = str..(type(v) == "string" and (approriateStr(v) or "") or tostring(v))
		end
		
		str = str..(cln and ",\n" or ",")
	end
	if count > 0 then str = str:sub(1,#str-(cln and 2 or 1)) else if cln then str = str:sub(1,#str-1) end end

	str = str..((cln and count and "\n" or "")..(cln and strThing("	",a-1) or "").."}")
	return str
end

ogprint = print
local ogprint = ogprint
function print(...)
	local rst = ""
	for i,v in pairs({...}) do
		if i > 1 then rst = rst..", " end
		if type(v) == "table" then
			rst = rst..tostring(v).." - "..tableToStr(v,true)
		else
			rst = rst..tostring(v)
		end
	end
	ogprint(rst)
end
--