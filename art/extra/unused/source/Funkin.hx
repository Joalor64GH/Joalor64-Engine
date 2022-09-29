Package;


import flixel.Flxg;
import flixelanim.Animate;
import PlayState;

using StringTools;

class Funkin extends MusicBeatStrate 
{
  
  public function OneSong(){
    
    PlayState.playsong("Score");
  }
}