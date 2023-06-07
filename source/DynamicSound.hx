import flixel.system.FlxAssets.FlxSoundAsset;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
/**
 * FlxSound that automatically handles loading sound dynamically. 
 */
class DynamicSound extends FlxSound {
    override public function loadEmbedded(EmbeddedSound:FlxSoundAsset, Looped:Bool = false, AutoDestroy:Bool = false, ?OnComplete:() -> Void):FlxSound {
        if ((EmbeddedSound is String)) {
            var goodSound = FNFAssets.getSound(EmbeddedSound);
            return super.loadEmbedded(goodSound, Looped, AutoDestroy, OnComplete);
        }
        return super.loadEmbedded(EmbeddedSound, Looped, AutoDestroy, OnComplete);
    }
} 