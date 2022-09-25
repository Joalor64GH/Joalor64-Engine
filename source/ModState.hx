package;

import openfl.utils.Assets;

class ModState extends MusicBeatState
{
    public var stateName:String;
    public function new(stateName:String) {
        this.stateName = stateName;
        var assets:String = 'assets/states/';
        var mods:String = 'mods/${Paths.currentModDirectory}/states/';
        #if MODS_ALLOWED
        if (Assets.exists('$mods/$states/$stateName.hscript'))
            PlayState.instance.addHscript('$mods/$states/$stateName.hscript');
        #else
        if (Assets.exists('$assets/$states/$stateName.hscript'))
            PlayState.instance.addHscript('$assets/$states/$stateName.hscript');
        #end
        super();
        // ONLY IF IT EXISTS!!!!
    }
    override function create()
    {
        PlayState.instance.callOnScripts('onCreate', []); // doin callOnScripts without groupin them because only hscript is gonna be added **maybe luas will be added in state..**

        super.create();
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        PlayState.instance.callOnScripts('onUpdate', []);
    }
    override function beatHit()
    {
        PlayState.instance.callOnScripts('onBeatHit', []);

        super.beatHit();
    }
    override function stepHit()
    {
        PlayState.instance.callOnScripts('onStepHit', []);

        super.stepHit();
    }
    #if (VIDEOS_ALLOWED && desktop)
	override function onFocus():Void
	{
		PlayState.instance.callOnScripts('onFocus', []);

		super.onFocus();
	}
	
	override function onFocusLost():Void
	{
		PlayState.instance.callOnScripts('onFocusLost', []);

		super.onFocusLost();
	}
	#end
}