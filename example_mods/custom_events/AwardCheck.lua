function onCreate() --FUCKING SHIT FUCK FUCK FUCKITY FUCKING SPAGHETTI CODE FUCKING SHIT BALLS SHIT CRAP PISS FUCKING SHIT
	makeLuaSprite('AwardBG', 'empty', 10, 10)
	makeGraphic('AwardBG', 337.5, 112.5, '000000')
	setObjectCamera('AwardBG', 'other')
	
	makeAnimatedLuaSprite('AwardIcon', 'AwardSheet', 10, 10)
	addAnimationByPrefix('AwardIcon', 'AwardFC', 'AwardFC', 24, false)
	scaleObject('AwardIcon', 0.75, 0.75)
	setObjectCamera('AwardIcon', 'other')
	
	makeLuaText('AwardTitle', 'Sample Text', 200, 125, 20)
	makeLuaText('AwardSub', 'Sample Text', 200, 125, 40)
	setTextAlignment('AwardSub', 'left')
	setTextAlignment('AwardTitle', 'left')
	
	doTweenAlpha('TextHide', 'AwardTitle', 0, 0.1, 'linear')
	doTweenAlpha('SubTextHide', 'AwardSub', 0, 0.1, 'linear')
	doTweenAlpha('AwardIconHide', 'AwardIcon', 0, 0.1, 'linear')
	doTweenAlpha('AwardBGHide', 'AwardBG', 0, 0.1, 'linear')
	
	addLuaSprite('AwardBG', true)
	addLuaSprite('AwardIcon', true)
	addLuaText('AwardTitle',true)
	addLuaText('AwardSub', true)
	
	--this fucking layering issue is making me have a stroke so fuck it, opacity bandaid fix
end

function onEvent(name, value1, value2)
	-- event note triggered
	-- triggerEvent() does not call this function!!
	if name == 'AwardCheck' then
		if value1 == 'fc' then
			if getProperty('songMisses') < 1 then
				--text shit
				setTextString('AwardTitle', 'Award - FC')
				setTextString('AwardSub', 'Clear a song with 0 misses.')
				
				--makes the shit appear
				doTweenAlpha('AwardIconShow', 'AwardIcon', 1, 0.1, 'linear')
				doTweenAlpha('AwardBGShow', 'AwardBG', 0.5, 0.1, 'linear')
				doTweenAlpha('AwardTitleShow', 'AwardTitle', 1, 0.1, 'linear')
				doTweenAlpha('AwardSubShow', 'AwardSub', 1, 0.1, 'linear')
				
				--misc shit
				playSound('award', 1)
				characterPlayAnim('bf', 'hey')
			end
		end
	end
	-- print('Event triggered: ', name, value1, value2);
end

function onTweenCompleted(tag) --so the player can read the acheivement
	if tag == 'AwardIconShow' then 
		runTimer('AwardWait', 5, 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft) --used to fade out the thingy
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if tag == 'AwardWait' then
		doTweenAlpha('AwardBGFade', 'AwardBG', 0, 3, 'linear')
		doTweenAlpha('AwardIconFade', 'AwardIcon', 0, 3, 'linear')
		doTweenAlpha('AwardSubFade', 'AwardSub', 0, 3, 'linear')
		doTweenAlpha('AwardTitleFade', 'AwardTitle', 0, 3, 'linear')
	end
end