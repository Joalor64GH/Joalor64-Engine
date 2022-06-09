--[[
	SCRIPT BY RALTYRO
	LAST MODIFIED TUESDAY JUNE 8 2022
	FIRST CREATED SUNDAY JUNE 5 2022
	
	if you delete this fuck you
--]]
local os = os

local gameWidth, gameHeight = 0, 0
local curLightEvent = -1
local curLight = -1
local inPhilly = false
local week7 = false

function string.startsWith(self, prefix) return self:find(prefix, 1, true) == 1 end
function string.endsWith(self, suffix) return self:find(suffix, 1, true) == #self - (#suffix - 1) end

function string.duplicate(s, i)
	local str = ""
	for i = 1, i do
		str = str .. s
	end
	return str
end

function table.find(table,v)
	for i,v2 in next,table do
		if v2 == v then
			return i
		end
	end
end

function math.clamp(x,min,max)return math.max(min,math.min(x,max))end
function math.lerp(from,to,i)return from+(to-from)*i end

local function from_hex(hexes, hex)
	local v = {string.match(hex, "^0x?" .. string.duplicate("(%w%w)", hexes or 3) .. "$")}
	for i in next, v do v[i] = tonumber(v[i], 16) end
    return unpack(v)
end

local function to_num(hexes, ...)
	return tonumber("0x" .. string.format(string.duplicate("%02X", hexes or 3), ...))
end

local function from_num(hexes, n)
	hexes = hexes or 3
	local v = string.format("%X", n)
	local l = #v - ((hexes * 2) - 1)
	local r = -(l - 1) / 2
	return (r > 0 and string.duplicate("00", r) or "") .. v:sub(l >= 1 and l or 1, #v)
end

local function colorBrightness(n, br) -- from number
	local r, g, b = from_hex(3, "0x" .. from_num(3, n))
	return to_num(3, math.ceil(r * br), math.ceil(g * br), math.ceil(b * br))
end

local phillyLightsColors = {0x31A2FD, 0x31FD8C, 0xFB33F5, 0xFD4531, 0xFBA633}
local curColor

local gradX, gradY = 0, 0
local hasSetPropertyEvent = false
local specialPsych = false
local yesCreated = false
local yesCreatePost = false
local checked = false
function onCreate()
	if (not checked) then
			-- LMAO DONT RUN THE SCRIPT TWICE!!
		for i = 0, getProperty("luaArray.length") - 1 do
			local scriptName = getPropertyFromGroup("luaArray", i, "scriptName"):reverse()
			scriptName = scriptName:sub(1, scriptName:find("/", 1, true) - 1):reverse()
			
			if (scriptName:lower() == "phillyglowlua.lua") then
				close(false)
				return
			end
		end
		checked = true
	end
	
	precacheImage("philly/window")
	precacheImage("philly/gradient")
	precacheImage("philly/particle")
	
	if (type(getProperty("gf.x")) ~= "number") then return end
	yesCreated = true
	
	hasSetPropertyEvent = getProperty("curLightEvent")
	hasSetPropertyEvent = type(hasSetPropertyEvent) == "number" and hasSetPropertyEvent == -1
	specialPsych = hasSetPropertyEvent
	
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
			
			-- after killing the og street, we remake it our own!! :D
			if (foundStreet) then
				makeLuaSprite("phillyStreet", "philly/street", type(x) == "number" and x or -50, type(y) == "number" and y or 50)
				addLuaSprite("phillyStreet")
			end
		end
	end
	
	makeLuaSprite("blammedLightsBlack", "", gameWidth * -.5, gameHeight * -.5)
	makeGraphic("blammedLightsBlack", gameWidth * 2, gameHeight * 2, "000000")
	scaleObject("blammedLightsBlack", 100, 100)
	setProperty("blammedLightsBlack.visible", false)
	addLuaSprite("blammedLightsBlack")
	setObjectOrder(
		"blammedLightsBlack",
		inPhilly and (week7 and getObjectOrder("phillyStreet") or 5) or getObjectOrder("gfGroup") - 2
	)
	if (not inPhilly) then setProperty("blammedLightsBlack.alpha", .95) end
	local order = getObjectOrder("blammedLightsBlack")
	
	if (inPhilly) then
		makeQSprite("phillyWindowEvent", "philly/window", phillyWindowX, phillyWindowY, .3, .3)
		setGraphicSize("phillyWindowEvent", math.floor(getProperty("phillyWindowEvent.width") * .85))
		updateHitbox("phillyWindowEvent")
		setProperty("phillyWindowEvent.visible", false)
		addLuaSprite("phillyWindowEvent")
		setObjectOrder("phillyWindowEvent", order + 1)
	end
	gradX, gradY = inPhilly and -400 or getProperty("gf.x") - 400, inPhilly and 225 or getProperty("gf.y")
	
	if (not inPhilly) then
		gradX, gradY = gradX + 400, gradY - 225
		
		gradX, gradY = gradX + (getProperty("gf.width") / 2), gradY + (getProperty("gf.height") / 2)
		local v = 1 / 3
		
		--[[
		gradX = math.lerp(gradX, getProperty("bf.x") + (getProperty("bf.width") / 2), v)
		gradY = math.lerp(gradY, getProperty("bf.y") + (getProperty("bf.height") / 2), v)
		
		gradX = math.lerp(gradX, getProperty("dad.x") + (getProperty("dad.width") / 2), v)
		gradY = math.lerp(gradY, getProperty("dad.y") + (getProperty("dad.height") / 2), v)
		]]
	end
	
	phillyGlowParticleMax = 2048 * (inPhilly and 3 or 4)
	
	makePhillyGlowGradient(gradX, gradY)
	setProperty("phillyGlowGradient.visible", false)
	setScrollFactor("phillyGlowGradient", 0.5, 0.5)
	addLuaSprite("phillyGlowGradient")
	setObjectOrder("phillyGlowGradient", order + 1)
	
	if (not inPhilly) then
		gradX, gradY = gradX - (3000 / 2), gradY - (100 / 2)
	end
end

function onCreatePost()
	if (not yesCreated) then
		onCreate()
	end
	yesCreatePost = true
	
	if (not hasSetPropertyEvent) then
		for i = 0, getProperty("luaArray.length") - 1 do
			local scriptName = getPropertyFromGroup("luaArray", i, "scriptName"):reverse()
			scriptName = scriptName:sub(1, scriptName:find("/", 1, true) - 1):reverse()
			
			if (scriptName:lower() == "set property.lua") then
				hasSetPropertyEvent = true
				break
			end
		end
	end
end

local function setColors(color, darkColor)
	if (inPhilly) then
		setProperty("phillyWindowEvent.color", color)
		
		setProperty("phillyStreet.color", darkColor)
		setProperty("phillyTrain.color", darkColor)
	else -- sigh..
		for i = getObjectOrder("phillyGlowGradient") + 1, getProperty("members.length") - 1 do
			local key = getPropertyFromGroup("members", i, "frame.parent.key")
			local isGroup = type(getPropertyFromGroup("members", i, "length")) == "number"
			
			if (
				not key:endsWith("philly/particle.png") and
				(
					type(getPropertyFromGroup("members", i, "color")) == "number" or
					(not isGroup or specialPsych)
				)
			) then
				if (key:endsWith("timeBar.png") or key:endsWith("NoteCombo.png")) then
					break
				end
				if (specialPsych and isGroup) then
					local group = "members[" .. tostring(i) .. "]"
					
					for i = 0, getProperty(group .. ".length") - 1 do
						setPropertyFromGroup(group .. ".members", i, "color", darkColor)
					end
				else
					--print(getPropertyFromGroup("members", i, "cameras"))
					setPropertyFromGroup("members", i, "color", darkColor)
				end
			end
		end
	end
	
	setProperty("boyfriend.color", color)
	setProperty("gf.color", color)
	setProperty("dad.color", color)
end

local function pickColor(color)
	if (color) then
		curColor = color
	else
		curLightEvent = getRandomInt(1, #phillyLightsColors, tostring(curLightEvent))
		curColor = phillyLightsColors[curLightEvent]
	end
end

local reqs = {
	turns = 0,
	on = false,
	color = nil,
	spawnPars = 0
}
local status = {
	turns = 0,
	on = false,
	color = nil,
	spawnPars = 0
}

function ev0()
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
		setProperty("phillyGlowGradient.visible", false)
		
		if (inPhilly) then
			setProperty("phillyWindowEvent.visible", false)
			--setProperty("phillyGlowParticles.visible", false)
		end
		
		despawnPhillyGlowParticles()
		
		pickColor(0xFFFFFF)
		setColors(curColor, curColor)
	end
end

function ev1()
	pickColor(reqs.color)
	local darkColor = colorBrightness(curColor, inPhilly and .5 or .2)
	
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
		setProperty("phillyGlowGradient.visible", true)
		if (inPhilly) then
			setProperty("phillyWindowEvent.visible", true)
			--setProperty("phillyGlowParticles.visible", true)
		end
		
		bopPhillyGlowGradient()
	elseif (getPropertyFromClass("ClientPrefs", "flashing")) then
		cameraFlash("game", "0x4cffffff", .5, true)
	end
	
	--[[
	for i, v in pairs(phillyGlowParticles) do
		setProperty(v .. ".color", curColor)
	end
	]]
	
	setProperty("phillyGlowGradient.color", curColor)
	setColors(curColor, darkColor)
end

function ev2()
	if (not getProperty("phillyGlowGradient.visible")) then return end
	
	if (not getPropertyFromClass("ClientPrefs", "lowQuality")) then
		local particlesNum = getRandomInt(8, 12) * (inPhilly and 1.6 or 1.85)
		local width = inPhilly and 2000 or 3000
		width = (width / particlesNum)
		
		for j = 0, inPhilly and 4 or 6 do
			for i = 0, particlesNum do
				coroutine.wrap(spawnPhillyGlowParticle)(
					gradX + (width * i + getRandomFloat(-width / 5, width / 5)),
					gradY + (phillyGlowGradientOriginY + 200 + (getRandomFloat(0, 125) + j * 40) + (inPhilly and -32 or 265)),
					curColor
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

function onEvent(n, v1, v2)
	if (inGameOver) then return end
	n = n:lower() or ""
	v1 = tostring(v1) or ""
	v2 = tostring(v2) or ""
	
	if (n == "phillyglowlua" or n == "philly glow") then
		local s, empty = false, v2 == "" or v2 == " "
		local ogV2 = v2
		
		v1 = tonumber(v1)
		
		local r, g, b
		if (v1 == 1 or v1 == 2 or v1 == 3) then
			v2 = ogV2:startsWith("0x") and ogV2:sub(3) or ogV2
			s, r, g, b = pcall(from_hex, 3, "0x" .. v2:sub(#v2 - 5, #v2))
			if (not s or (not r or not g or not b)) then
				v2 = nil if (not empty) then debugPrint("PhillyGlowLua Error! Value2 \"" .. ogV2 .. "\" cannot be setted") end
			else
				v2 = to_num(3, r, g, b)
			end
		end
		
		if (v1 == 0) then
			reqs.on = false
			reqs.turns = reqs.turns + 1
		elseif (v1 == 1) then -- turn on
			reqs.on = true
			reqs.turns = reqs.turns + 1
			reqs.color = v2
		elseif (v1 == 2) then -- spawn particles
			if (reqs.on and v2 ~= nil and reqs.color ~= v2) then
				reqs.turns = reqs.turns + 1
				reqs.color = v2
			end
			reqs.spawnPars = reqs.spawnPars + 1
		elseif (V1 == 3) then
			reqs.on = true
			reqs.turns = reqs.turns + 1
			reqs.color = v2
			reqs.spawnPars = reqs.spawnPars + 1
		end
	elseif (n == "set property" and not hasSetPropertyEvent) then
		setProperty(v1, tonumber(v2) or v2)
	end
end

local windowAlpha, lastWindowAlpha = 0, 0
function onBeatHit()
	if (inGameOver) then return end
	
	if (inPhilly and math.fmod(curBeat, 4) == 0) then		
		curLight = getRandomInt(1, #phillyLightsColors, tostring(curLight))
		local color = phillyLightsColors[curLight]
		
		setProperty("phillyWindow.color", color)
		windowAlpha = 1
	end
end

local camX, camY = 0, 0
function onUpdate(dt)
	if (not yesCreatePost) then onCreatePost() end
	
	if (inGameOver) then return end
	camX, camY = getProperty("camFollowPos.x"), getProperty("camFollowPos.y")
	
	if (reqs.turns ~= status.turns) then
		if (reqs.on) then
			ev1()
		else
			ev0()
		end
	end
	
	if (reqs.spawnPars ~= status.spawnPars) then
		ev2()
	end
	
	for i, v in next, reqs do status[i] = v end
	
	if (inPhilly) then
		windowAlpha = math.clamp(windowAlpha - ((crochet / 1000) * dt * 1.5), 0, 1)
		
		if (lastWindowAlpha ~= windowAlpha) then
			setProperty("phillyWindow.alpha", windowAlpha)
		end
		
		lastWindowAlpha = windowAlpha
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
phillyGlowParticleMax = 2048
if (true) then
	local unuseds = {}
	local i = 0
	local n = "PhillyGlowParticleLua"
	
	local timer = 0
	
	local lifetimes = {}
	local decays = {}
	local lastTimer = {}
	local colors = {}
	
	local alphas = {}
	local originalscales = {}
	
	local calmdownbro = 0
	function spawnPhillyGlowParticle(x, y, color)
		if (#phillyGlowParticles + calmdownbro > phillyGlowParticleMax) then return false end -- bro shits too much, need to stop
		if (
			not (
				x - camX > -gameWidth and
				y - camY > -gameHeight and
				x - camX < gameWidth * 1.2 and
				y - camY < gameHeight * 1.2
			)
		)
		then
			return false
		end
		
		local recycling = table.remove(unuseds, 1)
		local spr = recycling or n .. tostring(i)
		local random = math.random(0, 7) > 4
		
		lastTimer[spr] = timer
		
		lifetimes[spr] = inPhilly and getRandomFloat(.6, .9) or getRandomFloat(.75, 1.15)
		decays[spr] = getRandomFloat(.8, 1)
		
		alphas[spr] = 1
		originalscales[spr] = getRandomFloat(.75, 1)
		colors[spr] = color
		
		local s = (inPhilly and 1 or .5)
		if (recycling) then
			random = getRandomInt(0, 5) > 2
			
			setProperty(spr .. ".x", x); setProperty(spr .. ".y", y)
			
			if (random) then
				setScrollFactor(spr, getRandomFloat(.3, .75) * s, getRandomFloat(.65, .75) * s)
			end
		else
			makeQSprite(spr, "philly/particle", x, y, getRandomFloat(.3, .75) * s, getRandomFloat(.65, .75) * s, true)
		end
		scaleObject(spr, originalscales[spr], originalscales[spr])
		setProperty(spr .. ".color", color)
		
		if (random) then
			setProperty(spr .. ".velocity.x", getRandomFloat(-40, 40))
			setProperty(spr .. ".velocity.y", getRandomFloat(-175, -250))
			
			setProperty(spr .. ".acceleration.x", getRandomFloat(-10, 10))
		end
		if (not recycling) then setProperty(spr .. ".acceleration.y", 25) end
		
		addLuaSprite(spr)
		setObjectOrder(spr, getObjectOrder("phillyGlowGradient") + 1)
		
		table.insert(phillyGlowParticles, spr)
		i = i + 1
		
		calmdownbro = calmdownbro + 3
		return spr
	end
	
	function despawnPhillyGlowParticle(spr)
		removeLuaSprite(spr, false)
		
		local i = table.find(phillyGlowParticles, spr)
		if (i) then
			table.remove(phillyGlowParticles, i)
			table.insert(unuseds, spr)
			--lifetimes[spr] = nil
			--decays[spr] = nil
			--originalscales[spr] = nil
		end
	end
	
	function despawnPhillyGlowParticles()
		local spr
		for i = #phillyGlowParticles, 1, -1 do
			spr = phillyGlowParticles[i]
			
			removeLuaSprite(spr, false)
			
			table.remove(phillyGlowParticles, i)
			table.insert(unuseds, spr)
			--lifetimes[spr] = nil
			--decays[spr] = nil
			--originalscales[spr] = nil
		end
	end
	
	local maxUpdate = 1024
	local maxStuff = 1024 * 1.5
	local lastIUpdate
	function updatePhillyGlowParticles(dt)
		gDt = dt
		timer = timer + dt
		
		local dt, v, lifetime, alpha, prevAlpha
		local parUpdates = 0
		
		if (#phillyGlowParticles > maxStuff) then
			for i = #phillyGlowParticles, maxStuff, -1 do
				v = phillyGlowParticles[i]
				if (alphas[v] - (timer - lastTimer[v]) < .3) then
					despawnPhillyGlowParticle(v)
				end
			end
		end
		
		local br = false
		for i = lastIUpdate or #phillyGlowParticles, 1, -1 do
			parUpdates = parUpdates + 1
			
			v = phillyGlowParticles[i]
			
			dt = timer - lastTimer[v]
			alpha = alphas[v]
			prevAlpha = alpha
			
			lifetimes[v] = lifetimes[v] - dt
			lifetime = lifetimes[v]
			if (lifetime < 0) then
				alpha = alpha - (decays[v] * dt)
				
				lifetime = 0
			end
			
			alphas[v] = alpha
			
			if (alpha < 0) then
				despawnPhillyGlowParticle(v)
			else
				if (prevAlpha ~= alpha) then
					local originalScale = originalscales[v]
					
					setProperty(v .. ".alpha", alpha)
					scaleObject(v, originalScale * alpha, originalScale * alpha)
				end
				
				if (colors[v] ~= curColor) then
					colors[v] = curColor
					setProperty(v .. ".color", curColor)
				end
			end
			
			if (parUpdates > maxUpdate) then
				lastIUpdate = i
				br = true
				break
			end
			
			lastTimer[v] = timer
		end
		
		if (not br) then
			lastIUpdate = nil
		end
		
		calmdownbro = 0
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
		if (not inPhilly) then originalHeight = originalHeight + 500; y = y - 250 end
		
		madedPhillyGlowGradient = true
		
		makeQSprite("phillyGlowGradient", "philly/gradient", x, y, 0, .75)
		phillyGlowGradientOriginY = y
		originalY = y
		
		setGraphicSize("phillyGlowGradient", inPhilly and 2000 or 3000, originalHeight)
		updatePhillyGlowGradientHitbox()
	end
	
	local dontUpdate = true
	function updatePhillyGlowGradient(elapsed)
		if (dontUpdate) then return end
		local newHeight = math.floor((getProperty("phillyGlowGradient.height") - 1000 * elapsed) + .5)
		
		if (newHeight > 0) then
			dontUpdate = false
			
			setProperty("phillyGlowGradient.alpha", 1)
			setGraphicSize("phillyGlowGradient", inPhilly and 2000 or 3000, newHeight)
			setProperty(
				"phillyGlowGradient.y",
				originalY + (originalHeight - getProperty("phillyGlowGradient.height"))
			)
			updatePhillyGlowGradientHitbox()
		else
			if (not dontUpdate) then
				setProperty("phillyGlowGradient.alpha", 0)
				setProperty("phillyGlowGradient.y", -5000)
			end
			dontUpdate = true
		end
	end
	
	local x, y = 0, 0
	function updatePhillyGlowGradientHitbox()
		updateHitbox("phillyGlowGradient")
		local gx, gy = getProperty("phillyGlowGradient.x") + x, getProperty("phillyGlowGradient.y") + y
		if (not inPhilly) then
			x, y = (3000 / 2), (900 / 2)
			setProperty("phillyGlowGradient.x", gx - x)
			setProperty("phillyGlowGradient.y", gy - y)
		end
	end
	
	function bopPhillyGlowGradient()
		setGraphicSize("phillyGlowGradient", inPhilly and 2000 or 3000, originalHeight)
		--updatePhillyGlowGradientHitbox()
		updatePhillyGlowGradient(1/999)
		
		dontUpdate = false
	end
end











-- debyggin shits
if (false) then
	local function debugCall(n)
		local L = _G[n]
		return function(...)
			local s, w = pcall(L, ...)
			if not s then print(n, w, debug.getinfo(L)) end
		end
	end

	onCreate = debugCall("onCreate")
	onEvent = debugCall("onEvent")
	onUpdate = debugCall("onUpdate")
	onBeatHit = debugCall("onBeatHit")

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
end