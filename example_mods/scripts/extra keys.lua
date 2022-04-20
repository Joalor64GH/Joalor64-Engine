---Extra keys Script---

--Creds

--TheZoroForce240 - coded this fuckin mess
--ShadowMario - used code from play with mouse script
--bbPanzu - used code from the Taiko script from holiday mod
--srPerez - made the original extra keys stuff for the shaggy mod


--simple warning for anyone editing this, if you edit something and you cant hit notes or something similar then
--it usually means theres an error somewhere, its really annoying because it doesnt say where the error is

controls = { --set your controls here :), make sure its all uppercase
	{},
	{'SPACE'},
	{'LEFT', 'RIGHT'},
	{'LEFT', 'SPACE', 'RIGHT'},
	{'LEFT', 'DOWN', 'UP', 'RIGHT'},
	{'LEFT', 'DOWN','SPACE', 'UP', 'RIGHT'},
	{'S', 'D', 'F', 'J', 'K', 'L'},
	{'S', 'D', 'F','SPACE', 'J', 'K', 'L'},
	{'A', 'S', 'D', 'F', 'H', 'J', 'K', 'L'},
	{'A', 'S', 'D', 'F', 'SPACE', 'H', 'J', 'K', 'L'}
}


function goodNoteHit(id, direction, noteType, isSustainNote) --add note type stuff here

	if string.find(string.lower(noteType), 'your note type name here') then --do string.find + string.lower to automatically pick up space and extra versions
		--make sure the note type name in the string is lowercase!!!!!!
	end

end

function onCreate()
	-- triggered when the lua file is started, some variables weren't created yet
end

p1DefX = {0,0,0,0,0,0,0,0,0}
p2DefX = {0,0,0,0,0,0,0,0,0}

p1DefY = {0,0,0,0,0,0,0,0,0}
p2DefY = {0,0,0,0,0,0,0,0,0}

local splashAnims1 = {'note splash purple 1','note splash blue 1','note splash green 1','note splash red 1','note splash white 1','note splash yellow 1','note splash violet 1','note splash darkred 1','note splash dark 1'}
local splashAnims2 = {'note splash purple 2','note splash blue 2','note splash green 2','note splash red 2','note splash white 2','note splash yellow 2','note splash violet 2','note splash darkred 2','note splash dark 2'}

local sDir = {'singLEFT','singDOWN','singUP','singRIGHT','singUP','singLEFT','singDOWN','singUP','singRIGHT'} -- anim names for strums

local statics = {'arrowLEFT','arrowDOWN','arrowUP','arrowRIGHT','arrowSPACE','arrowLEFT','arrowDOWN','arrowUP','arrowRIGHT'}; -- anim names for strums
local presses = {'purple press','blue press','green press','red press','white press','yellow press','violet press','darkred press','dark press'};
local confirms = {'purple confirm','blue confirm','green confirm','red confirm','white confirm','yellow confirm','violet confirm','darkred confirm','dark confirm'};



--local left = getPropertyFromClass('ClientPrefs', 'keyBinds["note_left"][0]')


local controlsManiaConvert = { --mania changes are built in, so doing this to auto convert controls to correct positions for the arrays, dont mess with this unless you know what youre doing
	{'', '', '', '', '', '', '', '', ''},
	{'', '', '', '', controls[1 + 1][0 + 1],'', '', '', '', },
	{controls[2 + 1][0 + 1], '', '', controls[2 + 1][1 + 1],'', '', '', '', '', },
	{controls[3 + 1][0 + 1], '', '', controls[3 + 1][2 + 1], controls[3 + 1][1 + 1], '', '', '', '', },
	{controls[4 + 1][0 + 1], controls[4 + 1][1 + 1], controls[4 + 1][2 + 1], controls[4 + 1][3 + 1], '', '', '', '', '', },
	{controls[5 + 1][0 + 1], controls[5 + 1][1 + 1], controls[5 + 1][3 + 1], controls[5 + 1][4 + 1], controls[5 + 1][2 + 1],'','','','',},
	{controls[6 + 1][0 + 1], controls[6 + 1][4 + 1], controls[6 + 1][1 + 1], controls[6 + 1][2 + 1], '', controls[6 + 1][3 + 1], '', '', controls[6 + 1][5 + 1]},
	{controls[7 + 1][0 + 1], controls[7 + 1][5 + 1], controls[7 + 1][1 + 1], controls[7 + 1][2 + 1], controls[7 + 1][3 + 1], controls[7 + 1][4 + 1], '', '', controls[7 + 1][6 + 1]},
	{controls[8 + 1][0 + 1], controls[8 + 1][1 + 1], controls[8 + 1][2 + 1], controls[8 + 1][3 + 1], '',controls[8 + 1][4 + 1], controls[8 + 1][5 + 1], controls[8 + 1][6 + 1], controls[8 + 1][7 + 1]},
	{controls[9 + 1][0 + 1],controls[9 + 1][1 + 1],controls[9 + 1][2 + 1],controls[9 + 1][3 + 1],controls[9 + 1][4 + 1],controls[9 + 1][5 + 1],controls[9 + 1][6 + 1],controls[9 + 1][7 + 1],controls[9 + 1][8 + 1]}
}

local maniaSwitchPositions = {
	{-1, -1, -1, -1, -1, -1, -1, -1, -1}, -- -1 = hidden strum
	{-1, -1, -1, -1, 0, -1, -1, -1, -1}, -- number is the data it should be for positioning
	{0, -1, -1, 1, -1, -1, -1, -1, -1},
	{0, -1, -1, 2, 1, -1, -1, -1, -1},
	{0, 1, 2, 3, -1, -1, -1, -1, -1},
	{0, 1, 3, 4, 2, -1, -1, -1, -1},
	{0, 4, 1, 2, -1, 3, -1, -1, 5},
	{0, 5, 1, 2, 3, 4, -1, -1, 6},
	{0, 1, 2, 3, -1, 4, 5, 6, 7},
	{0, 1, 2, 3, 4, 5, 6, 7, 8}
}

maxAmmount = 9


active = false


p1strums = {};
p2strums = {};
p1curMania = 4;
p2curMania = 4;

noteScales = {0.7,0.7,0.7,0.7,0.7,0.65,0.6,0.55,0.55,0.5};
noteWidths = {140,140,126,119,112,91,84,77,70,66.5};
posRest  = {0, 0, 0, 0, 0, 0, 35, 50, 60, 70};

p1curScale = noteScales[p1curMania + 1];
p1curWidth = noteWidths[p1curMania + 1];

p2curScale = noteScales[p2curMania + 1];
p2curWidth = noteWidths[p2curMania + 1];

scaleMulti = 1 -- for pixel notes

local isPixel = false

local splashCount = 1
local removedSplashCount = 0

local ratingCount = 1
local removedRatingCount = 0


function onCreatePost()
	-- end of "create"


	if getPropertyFromClass('PlayState', 'isPixelStage') then 
		scaleMulti = 8.57 --number from (1 / 0.7) * 6, default scale for reg notes is 0.7, pixel notes dont use 0.7, instead only use pixel zoom, so basically 1 * 6
		isPixel = true
	end

	makeAnimatedLuaSprite('load Splash', 'sploosh', 0,0);
	addAnimationByPrefix('load Splash', 'splash', 'note splash blue 1', 24, false);
	objectPlayAnimation('load Splash', 'splash');
	setProperty('load Splash.alpha', 0);
	addLuaSprite('load Splash');
	removeLuaSprite('load Splash');


	if middlescroll then 
		noteStartPos = -278;
	end

	for i = 0,8 do --generate static arrows
		makeStrum(0,i);
	end
	for i = 0,8 do
		makeStrum(1,i);
	end

	--enable(9);

	if active then 
		for i = 0,3 do
			setPropertyFromGroup('opponentStrums', i, 'visible',false)
		end
		for i = 0,3 do
			setPropertyFromGroup('playerStrums', i, 'visible',false)
		end
	end

	--debugPrint(left)


	

	
end


function disable()
	if active then 
		for i = 0,3 do
			setPropertyFromGroup('opponentStrums', i, 'visible',true)
		end
		for i = 0,3 do
			setPropertyFromGroup('playerStrums', i, 'visible',true)
		end
		changeMania(0, 1, false)
		changeMania(0, 0, false)
		active = false
	end
end

function enable(mania)
	if not active then 
		for i = 0,3 do
			setPropertyFromGroup('opponentStrums', i, 'visible',false)
		end
		for i = 0,3 do
			setPropertyFromGroup('playerStrums', i, 'visible',false)
		end
		changeMania(mania, 1, false)
		changeMania(mania, 0, false)
		active = true
	end

end

noteStartPos = 42


p2strumAlpha = 1.0


function makeStrum(player, data)
	local strumy = 50;

	if downscroll then 
		strumy = screenHeight - 150;
	end

	if middlescroll then 
		p2strumAlpha = 0.35;
	end

	local strumname = data + (maxAmmount * player);
	local staticname = statics[data + 1]; --+1 for some reason????? it fixes it????, ok thats just how lua works ig, weird lol
	local pressname = presses[data + 1];
	local confirmname = confirms[data + 1];
	local xpos = 0
	local ypos = 0

	--debugPrint(strumname);

	p1curWidth = noteWidths[p1curMania + 1];
	p1curScale = noteScales[p1curMania + 1] * scaleMulti;

	p2curWidth = noteWidths[p2curMania + 1];
	p2curScale = noteScales[p2curMania + 1] * scaleMulti;

	local curScale = 0.7

	local position = maniaSwitchPositions[p1curMania + 1][data + 1]
	--debugPrint(staticname);
	if player == 1 then
		position = maniaSwitchPositions[p1curMania + 1][data + 1]
		p1DefX[data + 1] = noteStartPos + 50 + (1280 / 2) + (p1curWidth * position) - posRest[p1curMania + 1];
		p1DefY[data + 1] = strumy;
		xpos = p1DefX[data + 1]
		ypos = p1DefY[data + 1]
		curScale = p1curScale
	else 
		position = maniaSwitchPositions[p2curMania + 1][data + 1]
		p2DefX[data + 1] = noteStartPos + 50 + (p2curWidth * position) - posRest[p2curMania + 1];
		if middlescroll then 
			p2DefX[data + 1] = 42 + 50 + (p2curWidth * position) - posRest[p2curMania + 1];
			if position >= math.floor((p2curMania + 0.5) / 2) then 
				p2DefX[data + 1] = 42 + 50 + (p2curWidth * position) - posRest[p2curMania + 1] + (screenWidth / 2 + 25);
			end
		end
		p2DefY[data + 1] = strumy;
		xpos = p2DefX[data + 1]
		ypos = p2DefY[data + 1]
		curScale = p2curScale
	end


	local path = 'ek' 
	local pressFrameRate = 24
	if isPixel then 
		path = 'pixelUI/full'
		pressFrameRate = 12
	end

	

	makeAnimatedLuaSprite(strumname, path, xpos, ypos);
	addAnimationByPrefix(strumname, 'static', staticname, 24, false);
	addAnimationByPrefix(strumname, 'press', pressname, pressFrameRate, false);
	addAnimationByPrefix(strumname, 'confirm', confirmname, 24, false);
	scaleObject(strumname, curScale, curScale);
	updateHitbox(strumname);
	objectPlayAnimation(strumname, 'static');
	setObjectCamera(strumname, 'camHUD');
	setScrollFactor(strumname, 0, 0);
	addLuaSprite(strumname);
	if position == -1 or not active then 
		setProperty(strumname..'.visible', false)
	end

	if isPixel then 
		setProperty(strumname..'.antialiasing', false)
	end

	--quick guide about da naming id thing
	--in strums tables, the name is 0 to (keyAmmount-1), example, 4k = 3
	--for the lua sprite its 0 to (keyAmmount * 2) - 1, example 4k = 7
	-- wait half this is irrelevant lol, its always 0-8 is oppenent strums, 9-17 is player strums, i forgot mania changes are always active

	--for half of lua sprite ids are oppenent strums, rest are for the player
	--you can do "data + (maxAmmount * player)" to convert strumtable id or for loop i to lua sprite id

	if player == 1 then 
		p1strums[data..'.curID'] = position;
		p1strums[data..'.x'] = p1DefX[data + 1];
		p1strums[data..'.y'] = p1DefY[data + 1];
		p1strums[data..'.held'] = false;
		p1strums[data..'.press'] = false;
		p1strums[data..'.release'] = false;
		p2strums[data..'.resetAnim'] = 0;
		if position ~= -1 and active then 
			setProperty(strumname..'.y', p1DefY[data + 1] + 10);
			setProperty(strumname..'.alpha', 0);
			runTimer(strumname..'tweenTimer', 0.2 + (0.2 * ((p1strums[data..'.curID'] * 4) / p1curMania)), 1)
		else 
			setProperty(strumname..'.x', xpos);
		end
	else 
		p2strums[data..'.curID'] = position;
		p2strums[data..'.x'] = p2DefX[data + 1];
		p2strums[data..'.y'] = p2DefY[data + 1];
		p2strums[data..'.held'] = false;
		p2strums[data..'.press'] = false;
		p2strums[data..'.release'] = false;
		p2strums[data..'.resetAnim'] = 0;
		if position ~= -1 and active then 
			setProperty(strumname..'.y', p2DefY[data + 1] + 10);
			setProperty(strumname..'.alpha', 0);
			runTimer(strumname..'tweenTimer', 0.2 + (0.2 * ((p2strums[data..'.curID'] * 4) / p2curMania)), 1)
		else 
			setProperty(strumname..'.x', xpos);
			setProperty(strumname..'.alpha', p2strumAlpha);
		end
	end
end

function onDestroy()
	-- triggered when the lua file is ended (Song fade out finished)
end


-- Gameplay/Song interactions
function onBeatHit()
	-- triggered 4 times per section
end

function onStepHit()
	-- triggered 16 times per section
end

function onUpdate(elapsed)
	-- start of "update", some variables weren't updated yet
end



function onUpdatePost(elapsed)
	-- end of "update"

    --using playing with mouse code as a base
	noteCount = getProperty('notes.length');

	if active then 
		setProperty('boyfriend.stunned', true); --stop boyfriend from hitting notes normally
	
		for i = 0,8 do --set bools for controls
			if controlsManiaConvert[p1curMania + 1][i + 1] == '' then 
				p1strums[i..'.press'] = false
				p1strums[i..'.release'] = false
				p1strums[i..'.held'] = false
			else 
				p1strums[i..'.press'] = getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..controlsManiaConvert[p1curMania + 1][i + 1]);
				p1strums[i..'.release'] = getPropertyFromClass('flixel.FlxG', 'keys.released.'..controlsManiaConvert[p1curMania + 1][i + 1]);
				p1strums[i..'.held'] = getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..controlsManiaConvert[p1curMania + 1][i + 1]);
			end
		end
	
		--debugPrint(controlsManiaConvert[curMania + 1][1])
	
		songPos = getSongPosition();
	
		for i=0,8 do 
			local name = i + (maxAmmount * 1);
			if p1strums[i..'.held'] and getProperty(name..'.animation.curAnim.name') ~= 'confirm' and getProperty(name..'.animation.curAnim.name') ~= 'press' then 
				doStrumAnim(1, i, 'press');
			elseif p1strums[i..'.release'] then 
				doStrumAnim(1, i, 'static');
			end

			--setProperty(name..'.y', p1DefY[i + 1] + 50 * math.sin((i + 1) + getSongPosition() * 0.005) * math.pi)

		end
	
		for i=0,8 do 
			local name = i + (maxAmmount * 0);	
			--[[if p2strums[i..'.resetAnim'] > 0 then
				p2strums[i..'.resetAnim'] = p2strums[i..'.resetAnim'] - elapsed;
				if(p2strums[i..'.resetAnim'] <= 0) then
					doStrumAnim(0, i, 'static');
					p2strums[i..'.resetAnim'] = 0;
				end
			end]]--
			if getProperty(name..'.animation.curAnim.name') == 'confirm' and getProperty(name..'.animation.curAnim.finished') then 
				doStrumAnim(0, i, 'static');
			end
		end

		--[[sortedNotes = {}
		unsortedNotes = {}
		for i = 0, noteCount-1 do
			table.insert(unsortedNotes, i, getPropertyFromGroup('notes', i, 'strumTime'))
		end

		for key, _ in pairs(unsortedNotes) do
			table.insert(sortedNotes, key, unsortedNotes[key + 1])
			--debugPrint(sortedNotes[1])
		end
		
		--table.sort(sortedNotes, function(a, b) return unsortedNotes[a] > unsortedNotes[b] end)

		sortedNotesIdxs = {}


		--[[for i = 0, noteCount-1 do
			for key, _ in pairs(sortedNotes) do
				if sortedNotes[key + 1] == getPropertyFromGroup('notes', i, 'strumTime') then 
					table.insert(sortedNotesIdxs, key, i)
					--debugPrint("fuck you")
				end
			end
		end]]--

		--[[for key, _ in pairs(sortedNotesIdxs) do
			local i = key
			if getPropertyFromGroup('notes', i, 'mustPress') then
				--noteX = getPropertyFromGroup('notes', i, 'x');
				--noteY = getPropertyFromGroup('notes', i, 'y');
				isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
				noteData = getPropertyFromGroup('notes', i, 'noteData');
				noteType = getPropertyFromGroup('notes', i, 'noteType');
				canBeHit = getPropertyFromGroup('notes', i, 'canBeHit');
				tooLate = getPropertyFromGroup('notes', i, 'tooLate');
				wasGoodHit = getPropertyFromGroup('notes', i, 'wasGoodHit');
				strumTime = getPropertyFromGroup('notes', i, 'strumTime');
				hitHealth = getPropertyFromGroup('notes', i, 'hitHealth');
				--debugPrint("fuck")

			end
		end]]--]]--

		if (getProperty('boyfriend.holdTimer') > stepCrochet * 0.001 * getProperty('boyfriend.singDuration')) and string.find(string.lower(getProperty('boyfriend.animation.curAnim.name')), 'sing') and not string.find(string.lower(getProperty('boyfriend.animation.curAnim.name')), 'miss') then 
			characterDance('boyfriend');
		end


		for i = 0,8 do 
			noteCount = getProperty('notes.length');
			if p1strums[i..'.press'] then
				keyPress(i)
			end
		end

		local holding = false
		for i = 0,8 do 
			if p1strums[i..'.held'] then
				holding = true
			end
		end
		
		for i = 0, noteCount-1 do
			if getPropertyFromGroup('notes', i, 'mustPress') then
				setPropertyFromGroup('notes', i, 'copyX', false); --so it doesnt fuck with it
				--setPropertyFromGroup('notes', i, 'copyY', false);
				noteX = getPropertyFromGroup('notes', i, 'x');
				noteY = getPropertyFromGroup('notes', i, 'y');
				isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
				noteData = getPropertyFromGroup('notes', i, 'noteData');
				noteType = getPropertyFromGroup('notes', i, 'noteType');
				canBeHit = getPropertyFromGroup('notes', i, 'canBeHit');
				tooLate = getPropertyFromGroup('notes', i, 'tooLate');
				wasGoodHit = getPropertyFromGroup('notes', i, 'wasGoodHit');
				strumTime = getPropertyFromGroup('notes', i, 'strumTime');
				hitHealth = getPropertyFromGroup('notes', i, 'hitHealth');
				noAnim = getPropertyFromGroup('notes', i, 'noAnimation');
				gfNote = getPropertyFromGroup('notes', i, 'gfNote');

				noteData = dataConvertFromType(noteType, noteData);
				
				noteX = getProperty(noteData + (maxAmmount * 1)..'.x');
	
				setPropertyFromGroup('notes', i, 'x', noteX + getPropertyFromGroup('notes', i, 'offsetX')); --set note x to match with strum

				local yOffset = p1DefY[noteData + 1] - getProperty(noteData + (maxAmmount * 1)..'.y')
				setPropertyFromGroup('notes', i, 'y', noteY - yOffset); --match y val properly

				if not isSustainNote then
					setPropertyFromGroup('notes', i, 'angle', getProperty(noteData + (maxAmmount * 1)..'.angle')); --match angle
				end
	
				if not isSustainNote then 
					setPropertyFromGroup('notes', i, 'scale.x', p1curScale)
					setPropertyFromGroup('notes', i, 'scale.y', p1curScale) -- dont mess with scale y of sustains
				else 
					setPropertyFromGroup('notes', i, 'scale.x', p1curScale)
				end
	
				setPropertyFromGroup('notes', i, 'width', math.abs(getPropertyFromGroup('notes', i, 'scale.x')) * getPropertyFromGroup('notes', i, 'frameWidth'));    --all of this mess is the updatehitbox code
				setPropertyFromGroup('notes', i, 'height', math.abs(getPropertyFromGroup('notes', i, 'scale.y')) * getPropertyFromGroup('notes', i, 'frameHeight'));	--it fixes the offset anyway :)
	
				setPropertyFromGroup('notes', i, 'offset.x', (-0.5 * (getPropertyFromGroup('notes', i, 'width') - getPropertyFromGroup('notes', i, 'frameWidth'))));
				setPropertyFromGroup('notes', i, 'offset.y', (-0.5 * (getPropertyFromGroup('notes', i, 'height') - getPropertyFromGroup('notes', i, 'frameHeight'))));
	
				setPropertyFromGroup('notes', i, 'origin.x', getPropertyFromGroup('notes', i, 'frameWidth') * 0.5);
				setPropertyFromGroup('notes', i, 'origin.y', getPropertyFromGroup('notes', i, 'frameHeight') * 0.5);
					
				if isSustainNote and canBeHit and p1strums[noteData..'.held'] then
					setPropertyFromGroup('notes', i, 'wasGoodHit',true)
					setProperty('vocals.volume', 1);
					--setProperty('health', getProperty('health') + hitHealth);
					--removeFromGroup('notes', i);
					noteHit(i, noteData, noteType, isSustainNote,noAnim,gfNote);
				end
	
	
			else 
				setPropertyFromGroup('notes', i, 'copyX', false); --so it doesnt fuck with it
				--setPropertyFromGroup('notes', i, 'copyY', false);
				noteX = getPropertyFromGroup('notes', i, 'x');
				noteY = getPropertyFromGroup('notes', i, 'y');
				isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
				noteData = getPropertyFromGroup('notes', i, 'noteData');
				noteType = getPropertyFromGroup('notes', i, 'noteType');
				canBeHit = getPropertyFromGroup('notes', i, 'canBeHit');
				tooLate = getPropertyFromGroup('notes', i, 'tooLate');
				wasGoodHit = getPropertyFromGroup('notes', i, 'wasGoodHit');
				strumTime = getPropertyFromGroup('notes', i, 'strumTime');
				hitHealth = getPropertyFromGroup('notes', i, 'hitHealth');
	
				noteData = dataConvertFromType(noteType, noteData);
	
				noteX = getProperty(noteData + (maxAmmount * 0)..'.x');
	
				setPropertyFromGroup('notes', i, 'x', noteX + getPropertyFromGroup('notes', i, 'offsetX')); --set note x to match with strum

				local yOffset = p2DefY[noteData + 1] - getProperty(noteData + (maxAmmount * 0)..'.y')
				setPropertyFromGroup('notes', i, 'y', noteY - yOffset); --match y val properly

				if not isSustainNote then
					setPropertyFromGroup('notes', i, 'angle', getProperty(noteData + (maxAmmount * 0)..'.angle')); -- match angle
				end
	
				if not isSustainNote then 
					setPropertyFromGroup('notes', i, 'scale.x', p2curScale)
					setPropertyFromGroup('notes', i, 'scale.y', p2curScale) -- dont mess with scale y of sustains
				else 
					setPropertyFromGroup('notes', i, 'scale.x', p2curScale)
				end

				setPropertyFromGroup('notes', i, 'width', math.abs(getPropertyFromGroup('notes', i, 'scale.x')) * getPropertyFromGroup('notes', i, 'frameWidth'));    --all of this mess is the updatehitbox code because i cant run it from a group normally
				setPropertyFromGroup('notes', i, 'height', math.abs(getPropertyFromGroup('notes', i, 'scale.y')) * getPropertyFromGroup('notes', i, 'frameHeight'));	--it fixes the offset anyway :)
	
				setPropertyFromGroup('notes', i, 'offset.x', (-0.5 * (getPropertyFromGroup('notes', i, 'width') - getPropertyFromGroup('notes', i, 'frameWidth'))));
				setPropertyFromGroup('notes', i, 'offset.y', (-0.5 * (getPropertyFromGroup('notes', i, 'height') - getPropertyFromGroup('notes', i, 'frameHeight'))));
	
				setPropertyFromGroup('notes', i, 'origin.x', getPropertyFromGroup('notes', i, 'frameWidth') * 0.5);
				setPropertyFromGroup('notes', i, 'origin.y', getPropertyFromGroup('notes', i, 'frameHeight') * 0.5);
			end
	
		end
	else 
		for i = 0, noteCount-1 do
			setPropertyFromGroup('notes', i, 'copyX', true)
			setPropertyFromGroup('notes', i, 'copyY', true);
		end
		setProperty('boyfriend.stunned', false);
	end

	for ii = removedSplashCount, splashCount - 1 do --start from removed count to current active count
		if getProperty(ii..'sploosh.animation.curAnim.finished') then 
			removeLuaSprite(ii..'sploosh');
			removedSplashCount = ii;
		end
	end
	
end

function dataConvertFromType(noteType, noteData)

	if string.find(string.lower(noteType), "extra") then 
		noteData = noteData + 5
	elseif string.find(string.lower(noteType), "space") then
		noteData = 4		
	end

	return noteData
end


function noteHit(i, noteData, noteType, isSustainNote, noAnim, GFnote)
	setProperty('vocals.volume', 1);
	local char = 'boyfriend'
	if GFnote then 
		char = 'gf'
	end

	if not noAnim then 
		if string.find(string.lower(noteType), 'hurt note') then
			characterPlayAnim(char, 'hurt', true);
		else
	
	
			local daAlt = ''
			if string.find(string.lower(noteType), 'alt anim') then 
				daAlt = '-alt'
			end
			local animToPlay = sDir[noteData + 1]..daAlt
			characterPlayAnim(char, animToPlay, true);
			setProperty(char..'.holdTimer', 0)
	
		end
	
		if string.find(string.lower(noteType), 'hey!') then
			characterPlayAnim('boyfriend', 'hey', true);
			setProperty('boyfriend.heyTimer', 0.6);
			characterPlayAnim('gf', 'hey', true);
			setProperty('gf.heyTimer', 0.6);
		end
	end


	doStrumAnim(1, noteData, 'confirm')


	--[[local luaArrayLength = getProperty('luaArray.length')

	for i = 0, luaArrayLength - 1 do 
		local ret = setProperty('luaArray', i, 'call(event, args)');
	end]]--

	--[[for (i in 0...luaArray.length) {
		var ret:Dynamic = luaArray[i].call(event, args);
		if(ret != FunkinLua.Function_Continue) {
			returnVal = ret;
		}
	}]]--

	goodNoteHit(i, noteData, noteType, isSustainNote);
end


function keyPress(data) --took a lot of tries to get this input right, i think its good rn
	for i = 0, noteCount-1 do
		if getPropertyFromGroup('notes', i, 'mustPress') then
			isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
			noteData = getPropertyFromGroup('notes', i, 'noteData');
			noteType = getPropertyFromGroup('notes', i, 'noteType');
			canBeHit = getPropertyFromGroup('notes', i, 'canBeHit');
			tooLate = getPropertyFromGroup('notes', i, 'tooLate');
			wasGoodHit = getPropertyFromGroup('notes', i, 'wasGoodHit');
			strumTime = getPropertyFromGroup('notes', i, 'strumTime');
			hitHealth = getPropertyFromGroup('notes', i, 'hitHealth');
			missHealth = getPropertyFromGroup('notes', i, 'missHealth');
			causesMiss = getPropertyFromGroup('notes', i, 'hitCausesMiss');

			noAnim = getPropertyFromGroup('notes', i, 'noAnimation');
			gfNote = getPropertyFromGroup('notes', i, 'gfNote');

			noteData = dataConvertFromType(noteType, noteData);

			if canBeHit and not tooLate and not wasGoodHit and not isSustainNote and noteData == data then 
				local hittingcorrectNote = true --sorting strumtime with lua is way too complex so using this system to check if theres a note in front of the note it trying to hit first
				for ii = 0, noteCount-1 do
					if getPropertyFromGroup('notes', ii, 'mustPress') then
						noteData2 = getPropertyFromGroup('notes', ii, 'noteData');
						noteType2 = getPropertyFromGroup('notes', ii, 'noteType');
						hitHealth2 = getPropertyFromGroup('notes', ii, 'hitHealth');
						missHealth2 = getPropertyFromGroup('notes', ii, 'missHealth');
						causesMiss2 = getPropertyFromGroup('notes', ii, 'hitCausesMiss');
						noAnim2 = getPropertyFromGroup('notes', i, 'noAnimation');
						gfNote2 = getPropertyFromGroup('notes', i, 'gfNote');

						noteData2 = dataConvertFromType(noteType2, noteData2);

						strumTime2 = getPropertyFromGroup('notes', ii, 'strumTime');
						if strumTime2 < strumTime and not getPropertyFromGroup('notes', ii, 'isSustainNote') and noteData == noteData2 then --fix jacks cuz strumtime isnt getting sorted in order
							addScore(350);
							addHits(1);
							setPropertyFromGroup('notes', ii, 'wasGoodHit',true)
							
							doStrumAnim(1, noteData2, 'confirm');
							doNoteRating(strumTime2, noteData2);
							setProperty('health', getProperty('health') + (hitHealth2 * healthGainMult));		
							noteHit(ii, noteData2, noteType2, getPropertyFromGroup('notes', ii, 'isSustainNote'), noAnim2, gfNote2);
							hittingcorrectNote = false	
							removeFromGroup('notes', ii);
							if causesMiss2 then 

								addMisses(1)
								if not practice then 
									addScore(-10)
								end
								setProperty('health', getProperty('health') - (missHealth2 * healthLossMult));
								setProperty('vocals.volume', 0);
								setProperty('combo', 0);

								local char = 'boyfriend'
								if gfNote2 then 
									char = 'gf'
								end
			
			
								if getProperty(char..'.hasMissAnimations') and not noAnim2 then 
									local daAlt = ''
									if string.find(string.lower(noteType2), 'alt anim') then 
										daAlt = '-alt'
									end
									local animToPlay = sDir[noteData + 1]..'miss'..daAlt
									characterPlayAnim(char, animToPlay, true);
								end
							end			
						end
					end
				end

				if hittingcorrectNote then
					addScore(350);
					addHits(1);
					setPropertyFromGroup('notes', i, 'wasGoodHit',true)
					doNoteRating(strumTime, noteData);
					setProperty('health', getProperty('health') + (hitHealth * healthGainMult));
					noteHit(i, noteData, noteType, isSustainNote,noAnim, gfNote);
					removeFromGroup('notes', i);
				end



				if causesMiss then 

					addMisses(1)
					if not practice then 
						addScore(-10)
					end
					setProperty('health', getProperty('health') - (missHealth * healthLossMult));
					setProperty('vocals.volume', 0);
					setProperty('combo', 0);


					local char = 'boyfriend'
					if gfNote then 
						char = 'gf'
					end

					if getProperty(char..'.hasMissAnimations') and not noAnim then 
						local daAlt = ''
						if string.find(string.lower(noteType), 'alt anim') then 
							daAlt = '-alt'
						end
						local animToPlay = sDir[noteData + 1]..'miss'..daAlt
						characterPlayAnim(char, animToPlay, true);
					end
				end
				
			end
		end
	end
end



function doNoteRating(strum, data)
	noteDiff = math.abs(strumTime - getSongPosition() + getPropertyFromClass('ClientPrefs','ratingOffset'));
	rating = judgeNote(noteDiff)
	if rating == 'sick' then
		setProperty('sicks',getProperty('sicks')+1)
		setProperty('totalNotesHit',getProperty('totalNotesHit')+1)
		spawnNoteSplash(data);
	elseif rating == 'good' then
		setProperty('goods',getProperty('goods')+1)
		setProperty('totalNotesHit',getProperty('totalNotesHit')+0.75)
	elseif rating == 'bad' then
		setProperty('bads',getProperty('bads')+1)
		setProperty('totalNotesHit',getProperty('totalNotesHit')+0.5)
	elseif rating == 'shit' then
		setProperty('shits',getProperty('shits')+1)
	end

	setProperty('totalPlayed',getProperty('totalPlayed')+1)
	setProperty('combo',getProperty('combo')+1)
	if getProperty('combo') > 9999 then 
		setProperty('combo', 9999)
	end

	popUpScore(rating);

end

function judgeNote(diff) --sorry i steal code bb

	timingWindows = {getPropertyFromClass('ClientPrefs','sickWindow'), getPropertyFromClass('ClientPrefs','goodWindow'), getPropertyFromClass('ClientPrefs','badWindow')};
	windowNames = {'sick', 'good', 'bad'}
	
	for i=1, 4 do
		if diff <= timingWindows[round(math.min(i, 4))] then
		
			return windowNames[i];
		end
	end
	return 'shit';
end
function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end




function spawnNoteSplash(data)

	if getPropertyFromClass('ClientPrefs', 'noteSplashes') then

		local splashName = splashCount..'sploosh'
		local strumname = data + (maxAmmount * 1);
		local animName = splashAnims1[data + 1]
		local alt = getRandomBool(50)
		if alt then 
			animName = splashAnims2[data + 1]
		end
		local frameRate = 24 --+ getRandomInt(-2, 2) //no fps change cuz it desyncs it and will never remove the splash

		makeAnimatedLuaSprite(splashName, 'sploosh', getProperty(strumname..'.x') - p1curWidth * 0.95, getProperty(strumname..'.y') - p1curWidth);
		addAnimationByPrefix(splashName, 'splash', animName, frameRate, false);
		scaleObject(splashName, (p1curScale / 0.7) * 0.7, (p1curScale / 0.7) * 0.7);
		updateHitbox(splashName);
		objectPlayAnimation(splashName, 'splash');
		setObjectCamera(splashName, 'camHUD');
		setScrollFactor(splashName, 0, 0);
		setProperty(splashName..'.alpha', 0.6);
		setProperty(splashName..'.offset.x', 10 + (p1curMania * 5) - 20); --calculate offset based on mania
		setProperty(splashName..'.offset.y', 10 + (p1curMania * 5) - 20);
		addLuaSprite(splashName);
		splashCount = splashCount + 1;
	end
end



function popUpScore(rating) --all of this is pretty much just the same code from playstate but recoded with lua instead

	if getPropertyFromClass('ClientPrefs', 'scoreZoom') then
		doScoreZoom();
	end


	local pixelShitPart1 = "";
	local pixelShitPart2 = '';

	if isPixel then
		pixelShitPart1 = 'pixelUI/';
		pixelShitPart2 = '-pixel';
	end

	local xpos = screenWidth * 0.35
	local ypos = (screenHeight / 2) - (32 / 2)


	local sprName = 'rating'..ratingCount;

	makeLuaSprite(sprName, pixelShitPart1..rating..pixelShitPart2, xpos, ypos)
	setObjectCamera(sprName, 'camHUD');

	screenCenter(sprName);
	setProperty(sprName..'.x', getProperty(sprName..'.x') - 40)
	setProperty(sprName..'.y', getProperty(sprName..'.y') - 60)
	setProperty(sprName..'.acceleration.y', 550)
	setProperty(sprName..'.velocity.y', getProperty(sprName..'.velocity.y') - getRandomInt(140, 175))
	setProperty(sprName..'.velocity.x', getProperty(sprName..'.velocity.x') - getRandomInt(0, 10))
	setProperty(sprName..'.visible', not getPropertyFromClass('ClientPrefs', 'hideHud'))

	local offset = getPropertyFromClass('ClientPrefs', 'comboOffset') --i dont think this works, but it doesnt cause any errors so uhhh

	--debugPrint(offset[0])

	setProperty(sprName..'.x', getProperty(sprName..'.x') - offset[1])
	setProperty(sprName..'.y', getProperty(sprName..'.y') - offset[2])

	addLuaSprite(sprName, false);

	if not isPixel then 
		scaleObject(sprName, 0.7, 0.7)
		setProperty(sprName..'.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
	else 
		scaleObject(sprName, 6 * 0.85, 6 * 0.85)
		setProperty(sprName..'.antialiasing', false)
	end

	updateHitbox(sprName);


	local comboShit = 1
	local combo = getProperty('combo');
	local scores = {}

	if combo >= 1000 then 
		comboShit = 4
		scores[4] = combo % 10				-- do like this to fix ordering
		scores[3] = math.floor(combo / 10) % 10
		scores[2] = math.floor(combo / 100) % 10
		scores[1] = math.floor(combo / 1000) % 10
	elseif combo >= 100 then 
		comboShit = 3
		scores[3] = combo % 10
		scores[2] = math.floor(combo / 10) % 10
		scores[1] = math.floor(combo / 100) % 10
	elseif combo >= 10 then 
		comboShit = 2
		scores[2] = combo % 10
		scores[1] = math.floor(combo / 10) % 10
	else 
		scores[1] = combo -- just to fix it
	end

	


	

	for i = 0, comboShit - 1 do
		local comboName = (i + 1)..'combo'..ratingCount
		makeLuaSprite(comboName, pixelShitPart1..'num'..scores[i + 1]..pixelShitPart2, 0, 0)
		setObjectCamera(comboName, 'camHUD');

		screenCenter(comboName);
		setProperty(comboName..'.x', xpos + (43 * i) - 90)
		setProperty(comboName..'.y', getProperty(comboName..'.y') + 80)
		setProperty(comboName..'.x', getProperty(comboName..'.x') - offset[1])
		setProperty(comboName..'.y', getProperty(comboName..'.y') - offset[2])

		if not isPixel then 
			scaleObject(comboName, 0.5, 0.5)
			setProperty(comboName..'.antialiasing', getPropertyFromClass('ClientPrefs', 'globalAntialiasing'))
		else 
			scaleObject(comboName, 6, 6)
			setProperty(comboName..'.antialiasing', false)
		end
		updateHitbox(comboName);

		setProperty(comboName..'.acceleration.y', getRandomInt(200, 300))
		setProperty(comboName..'.velocity.y', getProperty(comboName..'.velocity.y') - getRandomInt(140, 160))
		setProperty(comboName..'.velocity.x', getRandomInt(-5, 5))
		setProperty(comboName..'.visible', not getPropertyFromClass('ClientPrefs', 'hideHud'))


		if combo >= 10 or combo == 0 then 
			addLuaSprite(comboName, false)
		end
	end

	
	


	runTimer(sprName, crochet * 0.001, 1)
	runTimer('combo'..ratingCount, crochet * 0.002, 1)
	ratingCount = ratingCount + 1

end

function doScoreZoom()

	setProperty('scoreTxt.scale.x', 1.075)
	setProperty('scoreTxt.scale.y', 1.075)
	doTweenX('scoreX', 'scoreTxt.scale', 1, 0.2, 'linear')
	doTweenY('scoreY', 'scoreTxt.scale', 1, 0.2, 'linear')
end

function doStrumAnim(player, data, animname)
	local name = data + (maxAmmount * player);
	objectPlayAnimation(name, animname);
	--debugPrint(getNoteTag(player, data));

	if not isPixel then
		setProperty(name..'.offset.x', (getProperty(name..'.frameWidth') - getProperty(name..'.width') * 0.5)); --same code as center offsets
		setProperty(name..'.offset.y', (getProperty(name..'.frameHeight') - getProperty(name..'.height') * 0.5));
		updateHitbox(name);
		setProperty(name..'.offset.x', getProperty(name..'.frameWidth') / 2);
		setProperty(name..'.offset.y', getProperty(name..'.frameHeight') / 2);
	
		local curScale = p1curScale
		if player == 0 then
			curScale = p2curScale
		end
	
		setProperty(name..'.offset.x', getProperty(name..'.offset.x') - (56 / 0.7) * (curScale)); --shitty offset code
		setProperty(name..'.offset.y', getProperty(name..'.offset.y') - (56 / 0.7) * (curScale));
	end

end

function getStrum(id, player)
	return id + (curMania * 1);
end


function changeMania(newAmmo, player, animated)

	if player == 1 then 
		p1curMania = newAmmo
		p1curWidth = noteWidths[p1curMania + 1];
		p1curScale = noteScales[p1curMania + 1] * scaleMulti;

		for i = 0,8 do 
			local xpos = 0
			position = maniaSwitchPositions[p1curMania + 1][i + 1]
			p1DefX[i + 1] = noteStartPos + 50 + (1280 / 2) + (p1curWidth * position) - posRest[p1curMania + 1];
			xpos = p1DefX[i + 1]
	
			local name = i + (maxAmmount * 1);
			objectPlayAnimation(name, 'static');
			scaleObject(name, p1curScale, p1curScale);
			updateHitbox(name);
			p1strums[i..'.x'] = p1DefX[i + 1];
			setProperty(name..'.x', xpos);
			p1strums[i..'.curID'] = position;
			if position == -1 then 
				setProperty(name..'.visible', false)
			else 
				setProperty(name..'.visible', true)
			end
			if animated and position ~= -1 then 
				setProperty(name..'.y', p1DefY[i + 1] + 50);
				setProperty(name..'.alpha', 0);
				runTimer(name..'tweenTimer', 0.2 + (0.2 * ((p1strums[i..'.curID'] * 4) / p1curMania)), 1)
			else 
				setProperty(name..'.x', xpos);
			end
			
		end
	else 
		p2curMania = newAmmo
		p2curWidth = noteWidths[p2curMania + 1];
		p2curScale = noteScales[p2curMania + 1] * scaleMulti;
		for i = 0,8 do 
			local xpos = 0
			position = maniaSwitchPositions[p2curMania + 1][i + 1]
			p2DefX[i + 1] = noteStartPos + 50 + (p2curWidth * position) - posRest[p2curMania + 1];
			if middlescroll then 
				p2DefX[i + 1] = 42 + 50 + (p2curWidth * position) - posRest[p2curMania + 1];
				if position >= math.floor((p2curMania + 0.5) / 2) then 
					p2DefX[i + 1] = 42 + 50 + (p2curWidth * position) - posRest[p2curMania + 1] + (screenWidth / 2 + 25);
				end
	
			end
			xpos = p2DefX[i + 1]
	
			local name = i + (maxAmmount * 0);
			scaleObject(name, p2curScale, p2curScale);
			updateHitbox(name);
			objectPlayAnimation(name, 'static');
			p2strums[i..'.x'] = p1DefX[i + 1];
			setProperty(name..'.x', xpos);
			p2strums[i..'.curID'] = position;
			if position == -1 then 
				setProperty(name..'.visible', false)
			else 
				setProperty(name..'.visible', true)
			end
			if animated and position ~= -1 then 
				setProperty(name..'.y', p2DefY[i + 1] + 50);
				setProperty(name..'.alpha', 0);
				runTimer(name..'tweenTimer', 0.2 + (0.2 * ((p2strums[i..'.curID'] * 4) / p2curMania)), 1)
			else 
				setProperty(name..'.x', xpos);
				setProperty(name..'.alpha', p2strumAlpha);
			end
		end
	end

	triggerEvent('Update Strum Values',0,0)


end



function onTimerCompleted(tag, loops, loopsLeft)

	if tag == '0tweenTimer' then 
		doTweenY('0tweenY', '0', p2DefY[0 + 1], 0.5, 'circOut') --start anim stuff
		doTweenAlpha('0tweenAlpha', '0', p2strumAlpha, 0.5, 'circOut')
		doTweenX('0tweenX', '0', p2DefX[0 + 1], 0.5, 'circOut')
	elseif tag == '1tweenTimer' then 
		doTweenY('1tweenY', '1', p2DefY[1 + 1], 0.5, 'circOut')
		doTweenAlpha('1tweenAlpha', '1', p2strumAlpha, 0.5, 'circOut')
		doTweenX('1tweenX', '1', p2DefX[1 + 1], 0.5, 'circOut')
	elseif tag == '2tweenTimer' then 
		doTweenY('2tweenY', '2', p2DefY[2 + 1], 0.5, 'circOut')
		doTweenAlpha('2tweenAlpha', '2', p2strumAlpha, 0.5, 'circOut')
		doTweenX('2tweenX', '2', p2DefX[2 + 1], 0.5, 'circOut')
	elseif tag == '3tweenTimer' then 
		doTweenY('3tweenY', '3', p2DefY[3 + 1], 0.5, 'circOut')
		doTweenAlpha('3tweenAlpha', '3', p2strumAlpha, 0.5, 'circOut')
		doTweenX('3tweenX', '3', p2DefX[3 + 1], 0.5, 'circOut')
	elseif tag == '4tweenTimer' then 
		doTweenY('4tweenY', '4', p2DefY[4 + 1], 0.5, 'circOut')
		doTweenAlpha('4tweenAlpha', '4', p2strumAlpha, 0.5, 'circOut')
		doTweenX('4tweenX', '4', p2DefX[4 + 1], 0.5, 'circOut')
	elseif tag == '5tweenTimer' then 
		doTweenY('5tweenY', '5', p2DefY[5 + 1], 0.5, 'circOut')
		doTweenAlpha('5tweenAlpha', '5', p2strumAlpha, 0.5, 'circOut')
		doTweenX('5tweenX', '5', p2DefX[5 + 1], 0.5, 'circOut')
	elseif tag == '6tweenTimer' then 
		doTweenY('6tweenY', '6', p2DefY[6 + 1], 0.5, 'circOut')
		doTweenAlpha('6tweenAlpha', '6', p2strumAlpha, 0.5, 'circOut')
		doTweenX('6tweenX', '6', p2DefX[6 + 1], 0.5, 'circOut')
	elseif tag == '7tweenTimer' then 
		doTweenY('7tweenY', '7', p2DefY[7 + 1], 0.5, 'circOut')
		doTweenAlpha('7tweenAlpha', '7', p2strumAlpha, 0.5, 'circOut')
		doTweenX('7tweenX', '7', p2DefX[7 + 1], 0.5, 'circOut')
	elseif tag == '8tweenTimer' then 
		doTweenY('8tweenY', '8', p2DefY[8 + 1], 0.5, 'circOut')
		doTweenAlpha('8tweenAlpha', '8', p2strumAlpha, 0.5, 'circOut')
		doTweenX('8tweenX', '8', p2DefX[8 + 1], 0.5, 'circOut')
	elseif tag == '9tweenTimer' then 
		doTweenY('9tweenY', '9', p1DefY[0 + 1], 0.5, 'circOut')
		doTweenAlpha('9tweenAlpha', '9', 1, 0.5, 'circOut')
		doTweenX('9tweenX', '9', p1DefX[0 + 1], 0.5, 'circOut')
	elseif tag == '10tweenTimer' then 
		doTweenY('10tweenY', '10', p1DefY[1 + 1], 0.5, 'circOut')
		doTweenAlpha('10tweenAlpha', '10', 1, 0.5, 'circOut')
		doTweenX('10tweenX', '10', p1DefX[1 + 1], 0.5, 'circOut')
	elseif tag == '11tweenTimer' then 
		doTweenY('11tweenY', '11', p1DefY[2 + 1], 0.5, 'circOut')
		doTweenAlpha('11tweenAlpha', '11', 1, 0.5, 'circOut')
		doTweenX('11tweenX', '11', p1DefX[2 + 1], 0.5, 'circOut')
	elseif tag == '12tweenTimer' then 
		doTweenY('12tweenY', '12', p1DefY[3 + 1], 0.5, 'circOut')
		doTweenAlpha('12tweenAlpha', '12', 1, 0.5, 'circOut')
		doTweenX('12tweenX', '12', p1DefX[3 + 1], 0.5, 'circOut')
	elseif tag == '13tweenTimer' then 
		doTweenY('13tweenY', '13', p1DefY[4 + 1], 0.5, 'circOut')
		doTweenAlpha('13tweenAlpha', '13', 1, 0.5, 'circOut')
		doTweenX('13tweenX', '13', p1DefX[4 + 1], 0.5, 'circOut')
	elseif tag == '14tweenTimer' then 
		doTweenY('14tweenY', '14', p1DefY[5 + 1], 0.5, 'circOut')
		doTweenAlpha('14tweenAlpha', '14', 1, 0.5, 'circOut')
		doTweenX('14tweenX', '14', p1DefX[5 + 1], 0.5, 'circOut')
	elseif tag == '15tweenTimer' then 
		doTweenY('15tweenY', '15', p1DefY[6 + 1], 0.5, 'circOut')
		doTweenAlpha('15tweenAlpha', '15', 1, 0.5, 'circOut')
		doTweenX('15tweenX', '15', p1DefX[6 + 1], 0.5, 'circOut')
	elseif tag == '16tweenTimer' then 
		doTweenY('16tweenY', '16', p1DefY[7 + 1], 0.5, 'circOut')
		doTweenAlpha('16tweenAlpha', '16', 1, 0.5, 'circOut')
		doTweenX('16tweenX', '16', p1DefX[7 + 1], 0.5, 'circOut')
	elseif tag == '17tweenTimer' then 
		doTweenY('17tweenY', '17', p1DefY[8 + 1], 0.5, 'circOut')
		doTweenAlpha('17tweenAlpha', '17', 1, 0.5, 'circOut')
		doTweenX('17tweenX', '17', p1DefX[8 + 1], 0.5, 'circOut')
	end


	if string.find(tag, 'rating') then --find rating timers
		doTweenAlpha(tag, tag, 0, 0.2, 'linear')
	end
	if string.find(tag, 'combo') then --find rating timers
		doTweenAlpha('1'..tag, '1'..tag, 0, 0.2, 'linear')
		doTweenAlpha('2'..tag, '2'..tag, 0, 0.2, 'linear')
		doTweenAlpha('3'..tag, '3'..tag, 0, 0.2, 'linear')
		doTweenAlpha('4'..tag, '4'..tag, 0, 0.2, 'linear')
	end
end

-- Tween/Timer hooks
function onTweenCompleted(tag)
	-- A tween you called has been completed, value "tag" is it's tag
	if string.find(tag, 'rating') then 
		removeLuaSprite(tag) --remove that shit
	end
	if string.find(tag, 'combo') then 
		removeLuaSprite(tag) --remove that shit
	end
end

function updateValues()
	triggerEvent('getP1Mania', p1curMania)
	triggerEvent('getP1Width', p1curWidth)
	triggerEvent('getP1Scale', p1curScale)
	triggerEvent('getP1DefPos0', p1DefX[1], p1DefY[1])
	triggerEvent('getP1DefPos1', p1DefX[2], p1DefY[2])
	triggerEvent('getP1DefPos2', p1DefX[3], p1DefY[3])
	triggerEvent('getP1DefPos3', p1DefX[4], p1DefY[4])
	triggerEvent('getP1DefPos4', p1DefX[5], p1DefY[5])
	triggerEvent('getP1DefPos5', p1DefX[6], p1DefY[6])
	triggerEvent('getP1DefPos6', p1DefX[7], p1DefY[7])
	triggerEvent('getP1DefPos7', p1DefX[8], p1DefY[8])
	triggerEvent('getP1DefPos8', p1DefX[9], p1DefY[9])

	triggerEvent('getP2Mania', p2curMania)
	triggerEvent('getP2Width', p2curWidth)
	triggerEvent('getP2Scale', p2curScale)
	triggerEvent('getP2DefPos0', p2DefX[1], p2DefY[1])
	triggerEvent('getP2DefPos1', p2DefX[2], p2DefY[2])
	triggerEvent('getP2DefPos2', p2DefX[3], p2DefY[3])
	triggerEvent('getP2DefPos3', p2DefX[4], p2DefY[4])
	triggerEvent('getP2DefPos4', p2DefX[5], p2DefY[5])
	triggerEvent('getP2DefPos5', p2DefX[6], p2DefY[6])
	triggerEvent('getP2DefPos6', p2DefX[7], p2DefY[7])
	triggerEvent('getP2DefPos7', p2DefX[8], p2DefY[8])
	triggerEvent('getP2DefPos8', p2DefX[9], p2DefY[9])
end


function onStartCountdown()
	-- countdown started, duh
	-- return Function_Stop if you want to stop the countdown from happening (Can be used to trigger dialogues and stuff! You can trigger the countdown with startCountdown())
	return Function_Continue;
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
end

function onSongStart()
	-- Inst and Vocals start playing, songPosition = 0
end

function onEndSong()
	-- song ended/starting transition (Will be delayed if you're unlocking an achievement)
	-- return Function_Stop to stop the song from ending for playing a cutscene or something.
	return Function_Continue;
end


-- Substate interactions
function onPause()
	-- Called when you press Pause while not on a cutscene/etc
	-- return Function_Stop if you want to stop the player from pausing the game
	return Function_Continue;
end

function onResume()
	-- Called after the game has been resumed from a pause (WARNING: Not necessarily from the pause screen, but most likely is!!!)
end

function onGameOver()
	-- You died! Called every single frame your health is lower (or equal to) zero
	-- return Function_Stop if you want to stop the player from going into the game over screen
	return Function_Continue;
end

function onGameOverConfirm(retry)
	-- Called when you Press Enter/Esc on Game Over
	-- If you've pressed Esc, value "retry" will be false
end


-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(line)
	-- triggered when the next dialogue line starts, dialogue line starts with 1
end

function onSkipDialogue(line)
	-- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end




function opponentNoteHit(id, direction, noteType, isSustainNote)
	-- Works the same as goodNoteHit, but for Opponent's notes being hit
	local data = direction 
	data = dataConvertFromType(noteType, data);

	doStrumAnim(0, data, 'confirm');
	local name = data + (maxAmmount * 0);
	p2strums[direction..'.resetAnim'] = 0.15;
	if isSustainNote then 
		p2strums[direction..'.resetAnim'] = p2strums[direction..'.resetAnim'] + 0.15;
	end
end

function noteMissPress(direction)
	-- Called after the note press miss calculations
	-- Player pressed a button, but there was no note to hit (ghost miss)
end

function noteMiss(id, direction, noteType, isSustainNote)
	-- Called after the note miss calculations
	-- Player missed a note by letting it go offscreen
end


-- Other function hooks
function onRecalculateRating()
	-- return Function_Stop if you want to do your own rating calculation,
	-- use setRatingPercent() to set the number on the calculation and setRatingString() to set the funny rating name
	-- NOTE: THIS IS CALLED BEFORE THE CALCULATION!!!
	return Function_Continue;
end


-- Event notes hooks
function onEvent(name, value1, value2)
	-- event note triggered
	-- triggerEvent() does not call this function!!

	-- print('Event triggered: ', name, value1, value2);
	if name == 'Change P1 Mania' then 
		if not active then 
			enable(value1)
		else 
			changeMania(value1, 1, value2)
		end
	elseif name == 'Change P2 Mania' then 
		if not active then 
			enable(value1)
		else 
			changeMania(value1, 0, value2)
		end	
	elseif name == 'Activate extra keys' then
		enable(value1)
	elseif name == 'Disable extra keys' then
		disable(value1)
	elseif name == 'Update Strum Values' then 
		updateValues() --best way i could come up with transfering stuff to other scripts for modcharting
	end
end

function eventEarlyTrigger(name)
	--[[
	Here's a port of the Kill Henchmen early trigger but on Lua instead of Haxe:
	if name == 'Kill Henchmen'
		return 280;
	This makes the "Kill Henchmen" event be triggered 280 miliseconds earlier so that the kill sound is perfectly timed with the song
	]]--

	-- write your shit under this line, the new return value will override the ones hardcoded on the engine
end


