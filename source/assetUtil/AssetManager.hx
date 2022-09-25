/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2022 MemeHoovy
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *     http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package assetUtil;

import flixel.FlxG;
// import hscript.Parser; // could this possibly be needed tho?
import openfl.utils.Assets;

/**
 * Just checks for what engine your character is importing from.
 * Also adapted from Forever Engine.
 */
@:enum abstract CharacterType(String) to String
{
    var FNF;
    var FNF_VANILLA;
    // var FOREVER;
    // var YOSHICRAFTER;
    var PSYCH;
}

/**
 * The type of asset your attempting to use.
 */
@:enum abstract AssetType(String) to String
{
    var JSON = '.json';
    var HSCRIPT = '.hscript';
    var IMAGE = '.png';
    var SOUND = '.ogg';
    var SPARROW = '.xml';
    var LUA = '.lua';
    var PYTHON = '.py';
    var VIDEO = '.mp4';
    var SHADER = '.frag';
    var TEXT = '.txt';
}

class EngineType
{
    public var extensions(get, never):String;
    function get_extensions():String {
        return Type.enumParameters(AssetType);
    }

    /**
     * [Description] Filters out an file with the given extension.
     * @param directory Returns the directory containing the file.
     * @param type The type of the file the extension is to be filtered out.
     * @return String Returns the file with the given extension.
     */
    public function filterExtensions(directory:String, type:String):String {
        if (!Assets.exists(directory){
            var fileExtenions:Array<String> = [];
            switch (type) {
				case IMAGE:
					extensions = ['.png'];
				case JSON:
					extensions = ['.json', '.jsonc'];
				case SPARROW:
					extensions = ['.xml'];
				case SOUND:
					extensions = ['.ogg', '.wav', '.mp3'];
				case FONT:
					extensions = ['.ttf', '.otf'];
				case HSCRIPT:
					extensions = ['.hxs', '.hx', '.hscript'];
                                case LUA:
					extensions = ['.lua'];
                                case PYTHON:
					extensions = ['.py'];
                                case VIDEO:
					extensions = ['.mp4', '.swf', '.webm'];
                                case SHADER:
					extensions = ['.frag', '.vert'];
                                case TEXT:
					extensions = ['.txt'];
            }    
        }
    }
    // I'm just gonna borrow this from forever engine :trollface:
	/**
     * Returns an Asset based on the parameters and groups given.
     * @param directory The asset directory, from within the assets folder (excluding 'assets/')
     * @param group The asset group used to index the asset, like IMAGES or SONGS
     * @return Dynamic
     */
    public static function getAsset(directory:String, ?type:AssetType = DIRECTORY, ?group:String):Dynamic
    {
        var gottenPath = getPath(directory, group, type);
        switch (type)
        {
            case JSON:
                return Assets.getText(gottenPath);
            case IMAGE:
                return returnGraphic(gottenPath, false);
            case SPARROW:
                var graphicPath = getPath(directory, group, IMAGE);
                // trace('sparrow graphic path $graphicPath');
                var graphic:FlxGraphic = returnGraphic(graphicPath, false);
                // trace('sparrow xml path $gottenPath');
                return FlxAtlasFrames.fromSparrow(graphic, Assets.getText(gottenPath));
            default:
                // trace('returning directory $gottenPath');
                return gottenPath;
        }
        trace('returning null for $gottenPath');
        return null;
    }
}
