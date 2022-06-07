forceLua = false -- shit going to be real

local inPhilly = false
local week7 = false

function onCreate()
	inPhilly = type(getProperty("phillyTrain.x")) == "number" -- Check if it's in Philly Stage
	week7 = inPhilly and type(getProperty("phillyStreet.x")) == "number" -- Check if the user Psych Engine has Official Week 7
	
	if (not week7 or forceLua) then
		if (addLuaScript) then
			addLuaScript("custom_events/PhillyGlowLua")
		else
			debugPrint("Cannot Run Philly Glow! try Replacing \"Philly Glow\" Events with \"PhillyGlowLua\"")
			close(false)
		end
	else
		close(false)
	end
end