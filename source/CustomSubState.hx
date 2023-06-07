package;

#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import Controls.Control;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import haxe.Exception;
import openfl.Lib;
import openfl.utils.Assets as OpenFlAssets;
#if sys
import sys.io.File;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
#end
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import ModsMenuState;

using StringTools;

class CustomSubState extends MusicBeatSubstate
{
	public var name:String;

	var isMenuState:Bool;
	var menuState:MainMenuState;

	public static var filesPushed:Array<String> = [];

	public static var interp:Interp;

	public function new(name:String = "", isMenuState:Bool = false)
	{
		super();

		this.name = name;
		this.isMenuState = isMenuState;
	}

	override public function create()
	{
		filesPushed = [];

		var folders:Array<String> = [Paths.getPreloadPath('custom_substates/')];
		folders.insert(0, Paths.modFolder('custom_substates/'));
		for (folder in folders)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.hx') && !filesPushed.contains(file))
					{
						var expr = File.getContent(Paths.substate(file));
						var parser = new hscript.Parser();
						parser.allowTypes = true;
						parser.allowJSON = true;
						parser.allowMetadata = true;
						interp = new Interp();
						var ast = parser.parseString(expr);
						interp.variables.set("add", add);
						interp.variables.set("update", function(elapsed:Float)
						{
						});
						interp.variables.set("create", function()
						{
						});
						interp.variables.set("import", function(classToResolve:String)
						{
							interp.variables.set(classToResolve.replace(" ", ""), Type.resolveClass(classToResolve.replace(" ", "")));
							var trimmedClass = "";
							if (classToResolve.contains("."))
							{
								for (i in 0...classToResolve.split(".").length)
								{
									if (i != classToResolve.split(".").length - 1)
									{
										trimmedClass = classToResolve.replace(classToResolve.split(".")[i], "");
									}
									else
									{
										var alphabet = "abcdefghijklmnopqrstuvwusyz";
										for (alphachar in alphabet.split(""))
										{
											if (trimmedClass.contains("." + alphachar.toUpperCase()))
											{
												trimmedClass = trimmedClass.replace(trimmedClass.split("." + alphachar.toUpperCase())[0], "");
											}
										}
										interp.variables.set(trimmedClass.replace(" ", "").replace(".", ""),
											Type.resolveClass(classToResolve.replace(" ", "")));
									}
								}
							}
						});
						interp.variables.set("state", this);
						interp.variables.set("remove", remove);
						name = file;

						interp.execute(ast);

						filesPushed.push(file);
					}
				}
			}
		}

		callOnHscript("create");

		super.create();
	}

	override public function update(elapsed:Float)
	{
		callOnHscript("update", [elapsed]);

		super.update(elapsed);

		if (controls.BACK)
		{
			close();
		}
	}

	public function callOnHscript(functionToCall:String, ?params:Array<Any>):Dynamic
	{
		if (interp == null)
		{
			return null;
		}
		if (interp.variables.exists(functionToCall))
		{
			var functionH = interp.variables.get(functionToCall);
			if (params == null)
			{
				var result = null;
				result = functionH();
				return result;
			}
			else
			{
				var result = null;
				result = Reflect.callMethod(null, functionH, params);
				return result;
			}
		}
		return null;
	}
}