local comboOffsetW = {0, 0, 0, 0} -- defining it with some premade stuff just incase

function onCreatePost()
	comboOffsetW = getPropertyFromClass('ClientPrefs', 'comboOffset') -- getting the array
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if not isSustainNote and getProperty('combo') > 10 then
		makeLuaSprite('combo' .. getProperty('combo'), 'combo', 485 + comboOffsetW[3], 360 - comboOffsetW[4])
		setObjectCamera('combo' .. getProperty('combo'), 'hud')
		scaleObject('combo' .. getProperty('combo'), 0.55, 0.55)
		addLuaSprite('combo' .. getProperty('combo'), true)
		setProperty('combo' .. getProperty('combo') .. '.velocity.y', 600)
		setProperty('combo' .. getProperty('combo') .. '.velocity.y', -150)
		doTweenAlpha('tweenCombo3' .. getProperty('combo'), 'combo' .. getProperty('combo'), 0, 0.35, 'quartIn')
	end
end
