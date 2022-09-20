package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import Controls.Control;
import openfl.utils.Function;
import lime.utils.Assets;
import flixel.FlxG;
import hscript.Expr;
import hscript.Interp;
import hscript.Parser;
import hscript.ParserEx;
import hscript.InterpEx;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import openfl.utils.Assets as OpenFlAssets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
using StringTools;
import lime.app.Application;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import WiggleEffect.WiggleEffectType;
import openfl.filters.ShaderFilter;
import Shaders;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import PlayState;

class HaxeState
{
    public var interp:Interp;
    public var enabled:Bool = false;
    var script:Expr;

    var hscriptStates:Map<String, Interp> = [];
	var exInterp:InterpEx = new InterpEx();
	var haxeSprites:Map<String, FlxSprite> = [];

    public function new (usehaxe:String, path:String, filename:String)
    {
        #if sys
		if (FileSystem.exists(path))
		{
            try 
            {
                loadScript(path);
                enabled = true;
                setScriptVars();
                interp.execute(script);
                trace('Haxe State loaded Sucessfully. | ' + path);
            } 
            catch(e) 
            {
                trace(e.message);
            }
        }
        else 
        {
            trace("no file detected");
        }
        #end
    }
    public function call(tfisthis:String, shitToGoIn:Array<Dynamic>) 
    {
		if (interp.variables.exists(tfisthis)) //make sure it exists
        {
            if (shitToGoIn.length > 0)
                interp.variables.get(tfisthis)(shitToGoIn[0]);
            else
                interp.variables.get(tfisthis)(); //if function doesnt need an arg

        }

	}
    public function set(tfisthis:String, shitToGoIn:Dynamic)
    {
        interp.variables.set(tfisthis, shitToGoIn); //set a var
    }

    public function loadScript(path:String)
    {
        var parser = new ParserEx(); //dunno what the difference is with ex ver but tryin it anyway, think there something i can do with classes or something but idk theres barely any documentation on it
        #if sys
		var rawCode = File.getContent(path);
		#else
		var rawCode = Assets.getText(path);
		#end
        parser.allowTypes = true;
        parser.allowMetadata = true;
        parser.allowJSON = true;
        parser.resumeErrors = true;
        script = parser.parseString(rawCode); //load da shit
        interp = new Interp();       
        //trace(script);
    }

    #if true
	function callHscript(func_name:String, args:Array<Dynamic>, usehaxe:String) {
		// if function doesn't exist
		if (!hscriptStates.get(usehaxe).variables.exists(func_name)) {
			trace("Function doesn't exist, silently skipping...");
			return;
		}
		var method = hscriptStates.get(usehaxe).variables.get(func_name);
		switch(args.length) {
			case 0:
				method();
			case 1:
				method(args[0]);
		}
	}
	function callAllHScript(func_name:String, args:Array<Dynamic>) {
		for (key in hscriptStates.keys()) {
			callHscript(func_name, args, key);
		}
	}
	function setHaxeVar(name:String, value:Dynamic, usehaxe:String) {
		hscriptStates.get(usehaxe).variables.set(name,value);
	}
	function getHaxeVar(name:String, usehaxe:String):Dynamic {
		return hscriptStates.get(usehaxe).variables.get(name);
	}
	function setAllHaxeVar(name:String, value:Dynamic) {
		for (key in hscriptStates.keys())
			setHaxeVar(name, value, key);
	}
	function getHaxeActor(name:String):Dynamic {
		switch (name) {
			case "boyfriend" | "bf":
				return boyfriend;
			case "girlfriend" | "gf":
				return gf;
			case "dad":
				return dad;
			default:
				return strumLineNotes.members[Std.parseInt(name)];
		}
	}

    function makeHaxeState(usehaxe:String, path:String, filename:String) {
		trace("opening a haxe state (because we are cool :))");
		var parser = new ParserEx();
		#if sys
		var program = parser.parseString(File.getContent(path + filename));
		#else
		var program = parser.parseString(Assets.getText(path + filename));
		#end
		var interp = PluginManager.createSimpleInterp();
		// set vars
		interp.variables.set("BEHIND_GF", BEHIND_GF);
		interp.variables.set("BEHIND_BF", BEHIND_BF);
		interp.variables.set("BEHIND_DAD", BEHIND_DAD);
		interp.variables.set("BEHIND_ALL", BEHIND_ALL);
		interp.variables.set("BEHIND_NONE", 0);
		interp.variables.set("switchCharacter", switchCharacter);
		interp.variables.set("difficulty", storyDifficulty);
		interp.variables.set("bpm", Conductor.bpm);
		interp.variables.set("songData", SONG);
		interp.variables.set("curSong", SONG.song);
		interp.variables.set("scrollSpeed", daScrollSpeed);
		interp.variables.set("curStep", 0);
		interp.variables.set("curBeat", 0);
		interp.variables.set("camHUD", camHUD);

		interp.variables.set("setPresence", function (to:String) {
			#if (windows && cpp)
			customPrecence = to;
			updatePrecence();
			#else 
			FlxG.log.warn("Ignoring hscript setPresence as we aren't on windows");
			#end
		});

		interp.variables.set("showOnlyStrums", false);
		interp.variables.set("playerStrums", PlayState.playerStrums);
		interp.variables.set("enemyStrums", PlayState.enemyStrums);
		interp.variables.set("mustHit", false);
		interp.variables.set("strumLineY", PlayState.strumLine.y);
		interp.variables.set("hscriptPath", path);
		interp.variables.set("startShader", function (shader:String) { 
			return (new ShaderHandler(shader)); // wigglestuff
		});
		interp.variables.set("boyfriend", PlayState.boyfriend);
		interp.variables.set("gf", PlayState.gf);
		interp.variables.set("dad", PlayState.dad);
		interp.variables.set("vocals", PlayState.vocals);
		interp.variables.set("gfSpeed", PlayState.gfSpeed);
		interp.variables.set("tweenCamIn", PlayState.tweenCamIn);
		interp.variables.set("health", PlayState.health);
		interp.variables.set("healthChange", PlayState.healthChange);
		interp.variables.set("iconP1", PlayState.iconP1);
		interp.variables.set("iconP2", PlayState.iconP2);
		interp.variables.set("currentPlayState", PlayState.instance);
		interp.variables.set("PlayState", PlayState);
		interp.variables.set("paused", PlayState.paused);
		interp.variables.set("window", Lib.application.window);

		// give them access to save data, everything will be fine ;)
		interp.variables.set("isInCutscene", function () return inCutscene);
		trace("set vars");
		interp.variables.set("camZooming", false);
		interp.variables.set("scriptableCamera", 'false');
		interp.variables.set("scriptCamPos", scriptCamPos);
		// callbacks
		interp.variables.set("start", function (song) {});
		interp.variables.set("beatHit", function (beat) {});
		interp.variables.set("update", function (elapsed) {});
		interp.variables.set("stepHit", function(step) {});
		interp.variables.set("playerTwoTurn", function () {});
		interp.variables.set("playerTwoMiss", function () {});
		interp.variables.set("playerTwoSing", function () {});
		interp.variables.set("playerOneTurn", function() {});
		interp.variables.set("playerOneMiss", function() {});
		interp.variables.set("playerOneSing", function() { });
		interp.variables.set("noteHit", function(player1:Bool, note:Note, wasGoodHit:Bool) {});
		/*interp.variables.set("addSprite", function (sprite, position) {
			// sprite is a FlxSprite
			// position is a Int
			if (position & BEHIND_GF != 0)
				remove(gf);
			if (position & BEHIND_DAD != 0)
				remove(dad);
			if (position & BEHIND_BF != 0)
				remove(boyfriend);
			add(sprite);
			if (position & BEHIND_GF != 0)
				add(gf);
			if (position & BEHIND_DAD != 0)
				add(dad);
			if (position & BEHIND_BF != 0)
				add(boyfriend); 
		});*/
		interp.variables.set("add", PlayState.add);
		interp.variables.set("remove", PlayState.remove);
		interp.variables.set("insert", PlayState.insert);
		interp.variables.set("setDefaultZoom", function(zoom:Float){
			PlayState.defaultCamZoom = zoom;
			FlxG.camera.zoom = zoom;
		});
		interp.variables.set("removeSprite", function(sprite) {
			remove(sprite);
		});
		interp.variables.set("getHaxeActor", getHaxeActor);
		interp.variables.set("instancePluginClass", instanceExClass);
		interp.variables.set("scaleChar", function (char:String, amount:Float) {
			switch(char) {
				case 'boyfriend':
					remove(PlayState.boyfriend);
					PlayState.boyfriend.setGraphicSize(Std.int(PlayState.boyfriend.width * amount));
					PlayState.boyfriend.y *= amount;
					add(PlayState.boyfriend);
				case 'dad':
					remove(PlayState.dad);
					PlayState.dad.setGraphicSize(Std.int(PlayState.dad.width * amount));
					PlayState.dad.y *= amount;
					add(PlayState.dad);
				case 'gf':
					remove(PlayState.gf);
					PlayState.gf.setGraphicSize(Std.int(PlayState.gf.width * amount));
					PlayState.gf.y *= amount;
					add(PlayState.gf);
			}
		});

		//no sus here
		interp.variables.set("addCharacter", addCharacter);
		interp.variables.set('switchToChar', switchToChar);
		interp.variables.set("switchCharacter", switchCharacter);
		interp.variables.set("swapOffsets", swapOffsets);

		trace("set stuff");
		interp.execute(program);
		hscriptStates.set(usehaxe,interp);
		callHscript("start", [SONG.song], usehaxe);
		trace('executed');
	}

    function makeHaxeStateUI(usehaxe:String, path:String, filename:String) {
		trace("opening a haxe state (because we are cool :))");
		var parser = new ParserEx();
		var program = parser.parseString(FNFAssets.getText(path + filename));
		var interp = PluginManager.createSimpleInterp();
		// set vars
		interp.variables.set("difficulty", storyDifficulty);
	    interp.variables.set("Math", Math);
		interp.variables.set("Conductor", Conductor);
		interp.variables.set("songData", SONG);
		interp.variables.set("curSong", SONG.song);
		interp.variables.set("curStep", 0);
		interp.variables.set("curBeat", 0);
		interp.variables.set("duoMode", duoMode);
		interp.variables.set("opponentPlayer", opponentPlayer);
		interp.variables.set("demoMode", demoMode);
		interp.variables.set("disableScoreChange", function(funny:Bool) {disableScoreChange = funny;});
		interp.variables.set("camHUD", camHUD);
		interp.variables.set("downscroll", downscroll);
		interp.variables.set("playerStrums", playerStrums);
		interp.variables.set("enemyStrums", enemyStrums);
		interp.variables.set("changeNoteType", function(player, type, trans) {
			generateStaticArrows(player, type, trans);
		});
		interp.variables.set("strumLineY", strumLine.y);
		interp.variables.set("hscriptPath", path);
		interp.variables.set("health", health);
		interp.variables.set("scoreTxt", scoreTxt);
		interp.variables.set("difficTxt", difficTxt);
		interp.variables.set('useSongBar', useSongBar);
		interp.variables.set("songPosBG", songPosBG);
		interp.variables.set("songPosBar", songPosBar);
		interp.variables.set("songName", songName);
		interp.variables.set("NewBar", function (daX:Float, daY:Float, width:Int, height:Int, min:Float, max:Float, barColor:Bool = true) {
			var daBar = new FlxBar(daX, daY, LEFT_TO_RIGHT, width, height, this, 'songPositionBar', min, max);
			if (barColor) {
				var leftSideFill = opponentPlayer ? dad.opponentColor : dad.enemyColor;
				if (duoMode)
					leftSideFill = dad.opponentColor;
				var rightSideFill = opponentPlayer ? boyfriend.bfColor : boyfriend.playerColor;
				if (duoMode)
					rightSideFill = boyfriend.bfColor;
				daBar.createFilledBar(leftSideFill, rightSideFill);
			} else
				daBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
			return daBar;
		});
		interp.variables.set("healthBar", healthBar);
		interp.variables.set("healthBarBG", healthBarBG);
		//interp.variables.set("currentTimingShown", currentTimingShown);
		interp.variables.set("iconP1", iconP1);
		interp.variables.set("iconP2", iconP2);

		//funny numbers (how do I make them read only????????)
		interp.variables.set("songScore", songScore);
		interp.variables.set("songScoreDef", songScoreDef);
		interp.variables.set("nps", nps);
		interp.variables.set("accuracy", accuracy);
		interp.variables.set("combo", combo);

		interp.variables.set("start", function (song) {});
		interp.variables.set("update", function (elapsed) {});
		interp.variables.set("beatHit", function (beat) {});
		interp.variables.set("stepHit", function(step) {});
		interp.variables.set("playerTwoTurn", function () {});
		interp.variables.set("playerTwoMiss", function () {});
		interp.variables.set("playerTwoSing", function () {});
		interp.variables.set("playerOneTurn", function() {});
		interp.variables.set("playerOneMiss", function() {});
		interp.variables.set("playerOneSing", function() {});
		interp.variables.set("noteHit", function(player1:Bool, note:Note, wasGoodHit:Bool) {}); //this doesn't work :(
		interp.variables.set("addSprite", function (sprite) {add(sprite);});
		interp.variables.set("removeSprite", function(sprite) {remove(sprite);});
		interp.variables.set("replaceSprite", function(sprite, replaced) {replace(sprite, replaced);});
		interp.variables.set("PlayState", PlayState);
		interp.variables.set("HelperFunctions", HelperFunctions);
		interp.variables.set("instancePluginClass", instanceExClass);
		trace("set stuff");
		interp.execute(program);
		hscriptStates.set(usehaxe,interp);
		callHscript("start", [SONG.song], usehaxe);
		trace('executed');

	}

	function instanceExClass(classname:String, args:Array<Dynamic> = null) {
		return exInterp.createScriptClassInstance(classname, args);
	}
	function makeHaxeExState(usehaxe:String, path:String, filename:String)
	{
		trace("opening a haxe state (because we are cool :))");
		var parser = new ParserEx();
		var program = parser.parseModule(FNFAssets.getHscript(path + filename));
		trace("set stuff");
		exInterp.registerModule(program);

		trace('executed');
	}
    #end
}