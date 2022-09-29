package;

import flixel.FlxG;
import PlayState;

using StringTools;

class Funkin extends MusicBeatState 
{ 
  public function OneSong(){    
    PlayState.playsong("Score");
  }
}