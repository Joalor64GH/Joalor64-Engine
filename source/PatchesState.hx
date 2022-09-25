package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class PatchesState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var patchesStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -75;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Patches List", null);
		#end
                
                #if sys
		ArtemisIntegration.setGameState ("menu");
		ArtemisIntegration.resetModName ();
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if(FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if(leMods.length > 1 && leMods[0].length > 0) {
					var modSplit:Array<String> = leMods[i].split('|');
					if(!Paths.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if(modSplit[1] == '1')
							pushModPatchesToList(modSplit[0]);
						else
							modsAdded.push(modSplit[0]);
					}
				}
			}
		}

		var arrayOfFolders:Array<String> = Paths.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModPatchesToList(folder);
		}
		#end

		var pisspoop:Array<Array<String>> = [ //Patch - Icon name - Changelog - Link to Version - BG Color
			['Patch Notes'],
			['V1.5.1',         'life',             'UNRELEASED',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.5.1',  'FF66CF'],
			['V1.5.0',         'life',             'Support for Haxe and Hscript Stages, Custom Menu Hscripts Support (WIP),\nAdded Missing Credits Again, Openfl-Webm,\nUpdated SWF to 3.1.0, and a lot more.',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.5.0',  'FF66CF'],
			['V1.4.2',         'stamina',             'Full Support for Haxe, HaxeScript, and Python Scripts,\nSupport for Haxe Modcharts, Changed my Profile Link Again,\nand just a bit more.',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.4.2',  'FEE8FF'],
			['V1.4.1',         'stamina',             'Fully Compatible Hscript Support, Crossfades,\nFixed a thing in OutdatedState,\nand just a bit more.',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.4.1',  'FEE8FF'],
			['V1.4.0',         'stamina',             'More Polymod Folders, Logs, FIXED MODS CRASHING (at a cost),\nWindows-Exclusive Python Support, Renamed the Executable Files,\nand some more stuff.',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.4.0',  'FEE8FF'],
			['V1.4.0b-HOTFIX',         'stamina',             'Simply Prevented the Outdated Screen from Showing Up',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.4.0b-HOTFIX',  'FEE8FF'],
			['V1.4.0b',         'stamina',             'Too much to list',                                  		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.4.0b',  'FEE8FF'],
			['V1.3.0',              'widol',             'Polymod Support, STAGE EDITOR, DVD State,\nImproved Hscript Support, HaxeScript Support,\nSScript, Balls Mod Folder (Joke),\nAnd a bit more.',                                     	    'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.3.0',            '1C9C20'],
			['V1.2.0',             'tidol',             'Extension Webm, Systools, Debug Workflow,\nNew Stages for Weeks 3, 5, and 6, Rain Script (By me!!),\nNoteskins, Replay System,\nAnd a tiny bit more.',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.2.0',          'B3FF00'],
			['V1.1.1',             'speed',             'Readded the Notestyles Folder, TitleState Watermark,\nOne Project.xml Change, Update for VS. Code Tasks,\nBugfix String for Main Menu,\nSome Missing Credits',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.1.1',          'F09800'],
			['V1.1.0',             'speed',             'Too much to List',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.1.0',          'F09800'],
			['V1.0.0e',             'torb',             'Too much to List',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.0.0e',          '00FF08'],
			['V1.0.0e-beta',             'horb',             'Noob, Expert, and Insane Difficulties, Achievevements,\nWinning Icon Support, Test Noob Chart,\nBetter Bopeebo and Test Instrumentals, Project.xml Changes,\nand a tiny bit more.',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.0.0e-beta',          '0099FF'],
			['V1.0.0',             'dorb',             'Initial Release',                       		'https://github.com/Joalor64GH/Joalor64-Engine/releases/tag/v1.0.0',          '6600FF'],
			[''],
			[''],
			[''],
			[''],
			[''],
			['hi',										'dorb',			'this is the end of the list',					'https://adobearchive.org/',			'6600FF']
		];
		
		for(i in pisspoop){
			patchesStuff.push(i);
		}
	
		for (i in 0...patchesStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, patchesStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(patchesStuff[i][5] != null)
				{
					Paths.currentModDirectory = patchesStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('patches/' + patchesStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = getCurrentBGColor();
		intendedColor = bg.color;
                #if sys
		ArtemisIntegration.setBackgroundFlxColor (intendedColor);
		#end
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(patchesStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT) {
				CoolUtil.browserLoad(patchesStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.isBold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = patchesStuff.length - 1;
			if (curSelected >= patchesStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int =  getCurrentBGColor();
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
                        #if sys
			ArtemisIntegration.setBackgroundFlxColor (intendedColor);
			#end
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = patchesStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	function pushModPatchesToList(folder:String)
	{
		if(modsAdded.contains(folder)) return;

		var patchesFile:String = null;
		if(folder != null && folder.trim().length > 0) patchesFile = Paths.mods(folder + '/data/patches.txt');
		else patchesFile = Paths.mods('data/patches.txt');

		if (FileSystem.exists(patchesFile))
		{
			var firstarray:Array<String> = File.getContent(patchesFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				patchesStuff.push(arr);
			}
			patchesStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end

	function getCurrentBGColor() {
		var bgColor:String = patchesStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	private function unselectableCheck(num:Int):Bool {
		return patchesStuff[num].length <= 1;
	}
}
