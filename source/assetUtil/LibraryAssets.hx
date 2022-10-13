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
 * LibraryAssets.hx
 * Contains static utility functions used for metadata about asset libraries,
 * such as whether an asset or library exists.
 */
package assetUtil;

import openfl.Assets as OpenFlAssets;

class LibraryAssets
{
	public static function assetExists(path:String, type:openfl.utils.AssetType)
	{
		if (type == null)
		{
			Debug.logError('Don\'t specify a null AssetType when querying for assets! ${path}');
			return false;
		}
		return OpenFlAssets.exists(path, type);
	}

	public static function binaryExists(path:String)
	{
		return assetExists(path, BINARY);
	}

	public static function soundExists(path:String)
	{
		if (path == null || path == "")
			return false;
		return assetExists(path, SOUND) || assetExists(path, MUSIC);
	}

	public static inline function textExists(path:String)
	{
		return assetExists(path, TEXT);
	}

	public static function imageExists(key:String, ?library:String):Bool
	{
		return assetExists(Paths.image(key, library), IMAGE);
	}
}