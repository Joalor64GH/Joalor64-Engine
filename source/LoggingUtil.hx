package;

import flixel.FlxG;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class LoggingUtil extends MusicBeatState
{
	public static var currentLog:String;
	public static var contentsArray:Array<String> = [];

	public static function makeLogFile()
	{
		if (FlxG.save.data.logsAllowed)
		{
			File.write('logs/' + Sys.time() + '.log', false);
			currentLog = 'logs/' + Sys.time() + '.log';
		}
	}

	public static function writeToLogFile(message:String)
	{
		if (FlxG.save.data.logsAllowed)
		{
			contentsArray.push("[" + Date.now() + "] " + message);
			File.saveContent(currentLog, contentsArray.join("\n") + "\n");
		}
	}
}