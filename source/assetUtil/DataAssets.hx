/*
 * Apache License, Version 2.0
 *
 * Copyright (c) 2021 MasterEric
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

/*
 * DataAssets.hx
 * Contains static utility functions used for interacting with either
 * JSON data or line text files.
 */
package assetUtil;

import Paths;
import openfl.Assets as OpenFlAssets;
import tjson.TJSON;

using hx.strings.Strings;

class DataAssets
{
	/**
	 * Given a text file path, load the file, clean it up, and split it into individual lines.
	 * @param path The text file path to load.
	 * @return A list of lines from that file.
	 */
	public static function loadLinesFromFile(path:String):Array<String>
	{
		if (!LibraryAssets.textExists(path))
		{
			Debug.logError('Could not load data from non-existant file ${path}');
			return [];
		}
		var rawText:String = OpenFlAssets.getText(path);
		var result:Array<String> = rawText.trim().split('\n');

		for (i in 0...result.length)
		{
			result[i] = result[i].trim();
		}

		return result;
	}

	/**
	 * List all the data JSON files under a given subdirectory.
	 * @param path The path to look under.
	 * @return The list of JSON files under that path.
	 */
	public static function listJSONsInPath(path:String)
	{
		// We need to query OpenFlAssets, not the file system, because of Polymod.
		var dataAssets = OpenFlAssets.list(TEXT);

		var queryPath = 'data/${path}';

		var results:Array<String> = [];

		for (data in dataAssets)
		{
			if (data.indexOf(queryPath) != -1 && data.endsWith('.json'))
			{
				var suffixPos = data.indexOf(queryPath) + queryPath.length;
				results.push(data.substr(suffixPos).replaceAll('.json', ''));
			}
		}

		return results;
	}

	public static function loadJSON(key:String, ?library:String):Dynamic
	{
		var rawJson:String = null;
		try
		{
			rawJson = OpenFlAssets.getText(Paths.json(key, library)).trim();
		}
		catch (e)
		{
			Debug.logError('AN ERROR OCCURRED trying to read a JSON file (${library}:${key}). It probably does not exist.');
			Debug.logError(e.message);
			return null;
		}

		// Perform cleanup on files that have bad data at the end.
		while (rawJson != null && rawJson.length > 0 && !rawJson.endsWith("}"))
		{
			rawJson = rawJson.substr(0, rawJson.length - 1);
		}

		try
		{
			// Attempt to parse and return the JSON data.
			// Use TJSON, which is much more flexible (allows comments and missing commas).
			return TJSON.parse(rawJson);
		}
		catch (e)
		{
			Debug.logError('AN ERROR OCCURRED parsing a JSON file (${library}:${key}).');
			Debug.logError(e.message);

			// Return null.
			return null;
		}
	}
}