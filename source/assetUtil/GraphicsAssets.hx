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
 * GraphicsAssets.hx
 * Contains static utility functions used for interacting with graphics,
 * including images and spritesheets.
 */
package assetUtil;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import Paths;
import openfl.Assets as OpenFlAssets;

using hx.strings.Strings;

class GraphicsAssets
{
	static var flxImageCache:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();
	static var flxAnimationCache:Map<String, FlxFramesCollection> = new Map<String, FlxFramesCollection>();

	/**
	 * List all the music files in the `songs` folder, so we can precache them all.
	 */
	public static function listImageFilesToCache(prefixes:Array<String>)
	{
		// We need to query OpenFlAssets, not the file system, because of Polymod.
		var graphicsAssets = OpenFlAssets.list(MUSIC).concat(OpenFlAssets.list(SOUND));

		var graphicsNames = [];

		for (graphic in graphicsAssets)
		{
			// Parse end-to-beginning to support mods.
			var path = graphic.split('/');
			path.reverse();

			// TODO: Fix this logic!

			// var graphicsName = '';
			// Remove duplicates.
			// if (graphicsNames.indexOf(songName) != -1)
			//   continue;
			//
			// graphicsNames.push(songName);
		}

		return graphicsNames;
	}

	public static function cacheImage(key:String, graphic:FlxGraphic)
	{
		graphic.persist = true;
		graphic.destroyOnNoUse = false;

		flxImageCache.set(key, graphic);
	}

	/**
	 * Given a list of keys in the graphics cache, unload those graphics.
	 * This is useful to free up memory if you know the graphic won't be used for a while.
	 * @param keys A list of filenames relative to `./assets/images` to remove from the cache.
	 */
	public static function purgeCachedImages(keys:Array<String>)
	{
		for (key in keys)
		{
			flxImageCache.remove(key);
		}
	}

	/**
	 * Add an animation to the cache. When loading from `fromSparrowAtlas`, it will check here first.
	 * @param key The filename to store the atlas under, relative to `./assets/images/`.
	 * @param frames The frame data to place in the cache.
	 */
	public static function cacheAnimation(key:String, frames:FlxFramesCollection)
	{
		flxAnimationCache.set(key, frames);
	}

	/**
	 * Given a list of keys in the animation cache, unload those animations.
	 * This is useful to free up memory if you know the animation won't be used for a while.
	 * @param keys A list of filenames relative to `./assets/images` to remove from the cache.
	 */
	public static function purgeCachedAnimations(keys:Array<String>)
	{
		for (key in keys)
		{
			flxAnimationCache.remove(key);
		}
	}

	/**
	 * List all the image files under a given subdirectory.
	 * @param path The path to look under.
	 * @return The list of image files under that path.
	 */
	public static function listImagesInPath(path:String)
	{
		// We need to query OpenFlAssets, not the file system, because of Polymod.
		var imageAssets = OpenFlAssets.list(IMAGE);

		var queryPath = 'images/${path}';

		var results:Array<String> = [];

		for (image in imageAssets)
		{
			// Parse end-to-beginning to support mods.
			var path = image.split('/');
			if (image.indexOf(queryPath) != -1)
			{
				var suffixPos = image.indexOf(queryPath) + queryPath.length;
				results.push(image.substr(suffixPos).replaceAll('.json', ''));
			}
		}

		return results;
	}

	/**
	 * For a given key and library for an image, returns the corresponding BitmapData.
	 * Includes handling for cache and modded content.
	 * @param key 
	 * @param library 
	 * @return FlxGraphic
	 */
	public static function loadImage(key:String, ?library:String, ?shouldCache:Bool = false):FlxGraphic
	{
		if (flxImageCache != null)
		{
			if (flxImageCache.exists(key))
			{
				// Debug.logTrace('Loading image from image cache: $key');
				// Get data from cache.
				return flxImageCache.get(key);
			}
		}

		if (LibraryAssets.imageExists(key, library))
		{
			// If you get annoyed by how much this print call is triggering,
			// try CACHING YOUR DAMN IMAGES.
			Debug.logTrace('Loading image ${library == null ? '' : '${library}:'}${key}');
			var bitmap = OpenFlAssets.getBitmapData(Paths.image(key, library));
			var graphic = FlxGraphic.fromBitmapData(bitmap);
			if (shouldCache)
			{
				cacheImage(key, graphic);
			}
			return graphic;
		}
		else
		{
			Debug.logWarn('Could not find image at $library:$key');
			return null;
		}
	}

	/**
	 * If there's a sprite file associated with the image, it's animated.
	 * Otherwise, it isn't, and we shouldn't try to load it as a sparrow atlas.
	 */
	public static function isAnimated(key:String, ?library:String)
	{
		return LibraryAssets.textExists(Paths.file('images/$key.xml', library));
	}

	/**
	 * Loads an image, along with a Sparrow v2 spritesheet file with the matching name,
	 * and uses the spritesheet to split the image into a collection of named frames.
	 * @param shouldCache Whether the associated graphic and animation should be cached.
	 *   Use this if you're storing the animation statically. If you try to access an unloaded image, you'll crash the game.
	 * @returns An FlxFramesCollection
	 */
	public static function loadSparrowAtlas(key:String, ?library:String, ?shouldCache = false):Null<FlxFramesCollection>
	{
		// Check the animation cache first, we might just get to skip all of this.
		if (flxAnimationCache != null)
		{
			if (flxAnimationCache.exists(key))
			{
				// Debug.logTrace('Loading animation from animation cache: $key');
				// Get data from cache.
				return flxAnimationCache.get(key);
			}
		}

		if (!LibraryAssets.textExists(Paths.file('images/$key.xml', library)))
		{
			Debug.logWarn('Image ${key} has no spritesheet data! Were you expecting some?');
			return null;
		}

		// loadImage will check the cache first.
		var image:FlxGraphic = loadImage(key, library);
		if (shouldCache)
		{
			cacheImage(key, image);
		}

		Debug.logTrace('Loading animation from Sparrow atlas: $key');
		var frames:FlxFramesCollection = FlxAtlasFrames.fromSparrow(image, Paths.file('images/$key.xml', library));
		if (frames == null)
		{
			Debug.logError('Could not load animation from atlas: $key');
			return null;
		}

		if (shouldCache)
			cacheAnimation(key, frames);

		return frames;
	}

	/**
	 * Loads an image, along with a Packer spritesheet file with the matching name,
	 * and uses the spritesheet to split the image into a collection of named frames.
	 * Senpai in Thorns uses this instead of Sparrow and IDK why.
	 * @returns An FlxFramesCollection
	 */
	public static inline function loadPackerAtlas(key:String, ?library:String, ?isCharacter:Bool = false)
	{
		if (isCharacter)
		{
			return FlxAtlasFrames.fromSpriteSheetPacker(loadImage('characters/$key', library), Paths.file('images/characters/$key.txt', library));
		}
		return FlxAtlasFrames.fromSpriteSheetPacker(loadImage(key, library), Paths.file('images/$key.txt', library));
	}
}