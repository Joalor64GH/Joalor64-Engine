package;

import MusicBeatState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import Alphabet;
import haxe.Json;

typedef ModData =
{
	name:String,
	icon:String,
	description:String,
	tags:Array<String>,
	authors:Array<String>,
	loadingImage:String,
	loadingBarColor:Array<FlxColor>,
}

/**
	* people have been asking and stuff so here it is
	* this is gonna be slooow to finish though, as I already need to finish the offset and chart editors
	* but here it is, I will need a lot of help, but here it is!

	* quick reminder, i'm not a very good programmer, but I will try my very best -gabi
	* no, I have NO ideas for this.
**/
class PolymodsMenuState extends MusicBeatState
{
	// look I don't feel like commenting specific lines on a MODS menu.
	#if MODS_ALLOWED
	var bg:FlxSprite;
	var fg:FlxSprite;
	var infoText:FlxText;

	private static var curSelection:Int = -1;

	var grpMenuMods:FlxTypedGroup<Alphabet>;

	var modList:Array<String> = ['NONE'];

	var isEnabled = true;

	override function create()
	{
		super.create();

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xCE64DF;
		add(bg);

		fg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		fg.alpha = 0;
		fg.scrollFactor.set();
		add(fg);

		var text:FlxText = new FlxText(0, 0, 0, '- MODS MENU -');
		text.setFormat(Paths.font('vcr.ttf'), 36, FlxColor.WHITE);
		text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		text.antialiasing = true;
		text.screenCenter(X);
		add(text);

		grpMenuMods = new FlxTypedGroup<Alphabet>();
		add(grpMenuMods);

		for (i in 0...modList.length)
		{
			var alphabet:Alphabet = new Alphabet(0, 70 * i, modList[i], true);
			alphabet.isMenuItem = true;
			alphabet.screenCenter(X);
			alphabet.targetY = i;
			alphabet.disableX = true;
			grpMenuMods.add(alphabet);

			if (curSelection == -1)
				curSelection = i;
		}

		FlxTween.tween(fg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		updateSelection();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			Main.switchState(this, new MainMenuState());
		}
		if (controls.UI_UP_P)
			updateSelection(-1);
		if (controls.UI_DOWN_P)
			updateSelection(1);
	}

	function updateSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelection += change;

		if (curSelection < 0)
			curSelection = modList.length - 1;
		if (curSelection >= modList.length)
			curSelection = 0;

		var bullShit:Int = 0;
		for (item in grpMenuMods.members)
		{
			item.targetY = bullShit - curSelection;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				if (isEnabled)
					item.alpha = 1;
				else
					item.alpha = 0.6;
			}
		}
	}
	#end
}