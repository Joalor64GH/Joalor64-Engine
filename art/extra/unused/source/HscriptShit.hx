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
import Shaders.HSVEffect;
import Shaders.HSVShader;
import Shaders.RayMarchEffect;
import Shaders.RayMarchShader;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class HscriptShit //funni modcharts
{
    public var interp:Interp;
    public var enabled:Bool = false;
    var script:Expr;

    public function new (freeplayPath:String, path:String = '', inCharacterState:Bool = false)
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
                trace('HScript loaded Sucessfully. | ' + path);
            } 
            catch(e) 
            {
                trace(e.message);
            }
        }
        else if (FileSystem.exists(freeplayPath))
        {
            try 
            {
                loadScript(freeplayPath);
                enabled = true;
                if (!inCharacterState)
                    setScriptVars();
                else 
                    setCharVars(path);
                interp.execute(script);
                trace('HScript loaded Sucessfully. | ' + freeplayPath);
            } catch(e) { trace(e.message); }
        }
        else if (CacheShit.modcharts[path] != null && PlayState.modcharts)
        {
            loadScript(path);
            enabled = true;
            setScriptVars();
            interp.execute(script);
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

    function setCharVars(char:String)
    {
        var Level_NotAHoe = 0;
	    var Level_Boogie = 1;
	    var Level_Sadness = 2;
	    var Level_Sing = 3;
		interp.variables.set("hscriptPath", 'assets/images/custom_chars/' + char + '/');
		interp.variables.set("charName", char);
		interp.variables.set("Level_NotAHoe", Level_NotAHoe);
		interp.variables.set("Level_Boogie", Level_Boogie);
		interp.variables.set("Level_Sadness", Level_Sadness);
		interp.variables.set("Level_Sing", Level_Sing);
		interp.variables.set("portraitOffset", [0, 0]);
		interp.variables.set("dadVar", 4.0);
		interp.variables.set("isPixel", false);
		interp.variables.set("colors", [FlxColor.CYAN]);
        interp.variables.set("scriptableCamera", 'false');
        interp.variables.set("dance", function (char:Character) {});

        interp.variables.set("init", function (char:Character) {}); //this one function is causing so many problems.
        interp.variables.set("loadColor", function (character:Character) {});

        interp.variables.set("onCharChange", function (char:Character) {}); 
		//interp.execute(program);
		//trace(interp);
		//return interp;
    }

    function setScriptVars()
    {
        interp.variables.set("loadScript", function () {});
        interp.variables.set("dialogueGenerated", function () {});
        interp.variables.set("endScript", function () {});
		interp.variables.set("startSong", function (song) {});
        interp.variables.set("onPlayStateCreated", function () {}); //left this here cuz i used it before, just use onStateCreated
        interp.variables.set("onCamZoom", function () {});
        interp.variables.set("CircleNotes", function (cicle:Bool) {});
        interp.variables.set("onStateCreated", function () {});
        interp.variables.set("endSong", function () {});
		interp.variables.set("update", function (elapsed) {});
		interp.variables.set("stepHit", function(step) {});
        interp.variables.set("beatHit", function (beat) {});
        interp.variables.set("P1NoteHit", function (note:Note) {});
        interp.variables.set("P2NoteHit", function (note:Note) {});
        interp.variables.set("P1NoteMiss", function (note:Note) {});
        interp.variables.set("P2NoteMiss", function (note:Note) {});
        interp.variables.set("P1MissPress", function (direction:Int) {});
        interp.variables.set("P2MissPress", function (direction:Int) {});
        interp.variables.set("P1CpuNoteHit", function (note:Note) {});
        interp.variables.set("P2CpuNoteHit", function (note:Note) {});
        interp.variables.set("P3CpuNoteHit", function (note:Note) {}); //event notes
        interp.variables.set("P1NoteSpawned", function (note:Note) {}); //3.5 seconds before strumtime
        interp.variables.set("P2NoteSpawned", function (note:Note) {}); 
        interp.variables.set("P3NoteSpawned", function (note:Note) {});
        interp.variables.set("P1NoteNowOnScreen", function (note:Note) {}); //when you can see them on screen
        interp.variables.set("P2NoteNowOnScreen", function (note:Note) {});
        interp.variables.set("P3NoteNowOnScreen", function (note:Note) {});
        interp.variables.set("characterMade", function (character:Character) {});
        interp.variables.set("onManiaChange", function (mania:Int) {});
        interp.variables.set("onGameOver", function () {}); 
        interp.variables.set("exitPauseMenu", function () {}); 
        interp.variables.set("onGitarooPause", function () {}); 
        interp.variables.set("onPauseMenu", function () {}); 
        
        //modding+ things

        interp.variables.set("scriptableCamera", 'false');
        interp.variables.set("dance", function (char:String) {});

        interp.variables.set("init", function (char:Character) {}); //this one function is causing so many problems.
        interp.variables.set("loadColor", function (character:Character) {});

        interp.variables.set("onCharChange", function (char:Character) {}); 
      //  interp.variables.set("onStrumsGenerated", function (strums:StrumLineGroup) {});
        //interp.variables.set("StrumOffsets", function (strum:BabyArrow) {});
       // interp.variables.set("NoteOffsets", function (note:Note) {});

        interp.variables.set("instance", PlayState.instance); //dont think this works but who cares
        interp.variables.set("PlayState", PlayState);
        interp.variables.set("Note", Note);
       // interp.variables.set("BabyArrow", BabyArrow);
      //  interp.variables.set("StrumLineGroup", StrumLineGroup);
        interp.variables.set("Math", Math);
        interp.variables.set("FlxG", FlxG); //plz dont do bad thing with this, you have too much power
        interp.variables.set("FlxMath", FlxMath);
        interp.variables.set("FlxAngle", FlxAngle);
       // interp.variables.set("ModchartUtil", ModchartUtil); //might need to rename this lol
        interp.variables.set("Conductor", Conductor);
        interp.variables.set("Character", Character);
        interp.variables.set("Boyfriend", Boyfriend);
        interp.variables.set("FlxEase", FlxEase);
        interp.variables.set("FlxTween", FlxTween);
        interp.variables.set("FlxSprite", FlxSprite);
        interp.variables.set("FlxTimer", FlxTimer);
        interp.variables.set("StringTools", StringTools);
        interp.variables.set("curStep", 0);
        interp.variables.set("curBeat", 0);
        interp.variables.set("stepCrochet", Conductor.stepCrochet);
        interp.variables.set("crochet", Conductor.crochet);
        interp.variables.set("bpm", Conductor.bpm);
        interp.variables.set("HealthIcon", HealthIcon);
        interp.variables.set("NoteSplash", NoteSplash);
        interp.variables.set("Std", Std);
        interp.variables.set("Paths", Paths);
        interp.variables.set("WiggleEffect", WiggleEffect);
        interp.variables.set("CoolUtil", CoolUtil);
        interp.variables.set("FlxTrail", FlxTrail);
    //    interp.variables.set("CacheShit", CacheShit); //not sure about this one, you could clear the cache i guess
        interp.variables.set("MainMenuState", MainMenuState);
        interp.variables.set("Controls", Controls);
        interp.variables.set("FlxText", FlxText);
        interp.variables.set("FlxSound", FlxSound);
        interp.variables.set("FlxFlicker", FlxFlicker);
        interp.variables.set("FlxTypedGroup", FlxTypedGroup);
        interp.variables.set("Main", Main);
        interp.variables.set("TitleState", TitleState);
    //    interp.variables.set("ColorPresets", ColorPresets);
        interp.variables.set("SaveData", KadeEngineData);
        interp.variables.set("Application", Application);
        interp.variables.set("ShaderFilter", ShaderFilter);
        interp.variables.set("HSVEffect", HSVEffect);
        interp.variables.set("HSVShader", HSVShader);
        interp.variables.set("RayMarchEffect", RayMarchEffect);
        interp.variables.set("RayMarchShader", RayMarchShader);



        interp.variables.set("add", function(obj:FlxBasic) 
        {
            FlxG.state.add(obj);
        });
        interp.variables.set("remove", function(obj:FlxBasic) 
        {
            FlxG.state.remove(obj);
        });

        /*interp.variables.set("P1Health", PlayState.instance.P1Stats.health); //apparently these dont wanna work, can access directly through playstate though
        interp.variables.set("StrumLineStartY", PlayState.StrumLineStartY);
        interp.variables.set("playerStrums", PlayState.playerStrums);
        interp.variables.set("cpuStrums", PlayState.cpuStrums);
        interp.variables.set("gfStrums", PlayState.gfStrums);*/

        /*interp.variables.set("changeValue", function (varToUpdate:String, value:Dynamic) //waste of time lol
        {
            /*for (vars in interp.variables.keys())
            {
                if (!functionList.contains(interp.variables[vars])) //dont do this with function
                {
                }
            }
            trace("bruh");
            var split:Array<String> = varToUpdate.split(".");
            var shit:Dynamic = null;
            if (split.length < 1)
                Reflect.setProperty(PlayState.instance, varToUpdate, value); //just do playstate cuz it easier
            else
            {
                //do this at some point
            }
        });*/
    }
}