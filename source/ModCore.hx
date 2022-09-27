package;

import flixel.FlxG;
import polymod.*;
import polymod.Polymod;
import polymod.Polymod.ModMetadata;
import polymod.Polymod.PolymodError;
import polymod.format.ParseRules;
#if FEATURE_MODCORE
import polymod.backends.OpenFLBackend;
import polymod.backends.PolymodAssets.PolymodAssetType;
import polymod.format.ParseRules.LinesParseFormat;
import polymod.format.ParseRules.TextFileFormat;
#end

/**
 * Class based off of Kade Engine, Enigma Engine, and ChainSaw Engine.
 * Credits: KadeDev, MasterEric, MAJigsaw77.
 */
class ModCore
{
	/**
	 * The current API version.
	 * Must be formatted in Semantic Versioning v2; <MAJOR>.<MINOR>.<PATCH>.
	 * 
	 * Remember to increment the major version if you make breaking changes to mods!
	 */
	static final API_VERSION:String = "1.5.2";
	static final MOD_DIRECTORY:String = "polymods";

	private static final modExtensions:Map<String, PolymodAssetType> = [
		'mp3' => AUDIO_GENERIC,
		'ogg' => AUDIO_GENERIC,
		'wav' => AUDIO_GENERIC,
		'png' => IMAGE,
		'txt' => TEXT,
		'xml' => TEXT,
		'json' => TEXT,
		'jsonc' => TEXT,
		'frag' => SHADER,
		'vert' => SHADER,
		'ttf' => FONT,
		'otf' => FONT,
		'webm' => VIDEO,
		'mp4' => VIDEO,
		'swf' => VIDEO,
		'py' => SCRIPT,
		'hxs' => SCRIPT,
		'hx' => SCRIPT,
		'hscript' => SCRIPT
		//'hsc' => HARDCODE
		//'hhx' => HARDCODE
	];

	public static function loadAllMods()
	{
		#if FEATURE_MODCORE
		Debug.logInfo("Initializing ModCore (using all mods)...");
		loadModsById(getAllModIds());
		#else
		Debug.logInfo("ModCore not initialized; not supported on this platform.");
		#end
	}

	public static function loadConfiguredMods()
	{
		#if FEATURE_MODCORE
		Debug.logInfo("Initializing ModCore (using user config)...");
		Debug.logTrace('  User mod config: ${FlxG.save.data.modConfig}');
		var userModConfig = getConfiguredMods();
		loadModsById(userModConfig);
		#else
		Debug.logInfo("ModCore not initialized; not supported on this platform.");
		#end
	}

	/**
	 * If the user has configured an order of mods to load, returns the list of mod IDs in order.
	 * Otherwise, returns a list of ALL installed mods in alphabetical order.
	 * @return The mod order to load.
	 */
	public static function getConfiguredMods():Array<String>
	{
		var rawSaveData = FlxG.save.data.modConfig;

		if (rawSaveData != null)
		{
			var modEntries = rawSaveData.split('~');
			return modEntries;
		}
		else
		{
			// Mod list not in save!
			return null;
		}
	}

	public static function saveModList(loadedMods:Array<String>)
	{
		Debug.logInfo('Saving mod configuration...');
		var rawSaveData = loadedMods.join('~');
		Debug.logTrace(rawSaveData);
		FlxG.save.data.modConfig = rawSaveData;
		var result = FlxG.save.flush();
		if (result)
			Debug.logInfo('Mod configuration saved successfully.');
		else
			Debug.logWarn('Failed to save mod configuration.');
	}

	public static function loadModsById(ids:Array<String>)
	{
		#if FEATURE_MODCORE
		if (ids.length == 0)
		{
			Debug.logWarn('You attempted to load zero mods.');
		}
		else
		{
			Debug.logInfo('Attempting to load ${ids.length} mods...');
		}
		var loadedModList = polymod.Polymod.init({
			modRoot: MOD_DIRECTORY,
			dirs: ids,
			framework: CUSTOM,
			apiVersion: API_VERSION,
			errorCallback: onPolymodError,
			extensionMap: modExtensions,
			frameworkParams: buildFrameworkParams(),
			customBackend: ModCoreBackend,
			ignoredFiles: Polymod.getDefaultIgnoreList()
			parseRules: buildParseRules(),

			frameworkParams: buildFrameworkParams(),

			// Use a custom backend so we can get a picture of what's going on,
			// or even override behavior ourselves.
			customBackend: ModCoreBackend,

			// List of filenames to ignore in mods. Use the default list to ignore the metadata file, etc.
			ignoredFiles: Polymod.getDefaultIgnoreList(),

			// Parsing rules for various data formats.
			parseRules: buildParseRules(),
		});

		if (loadedModList == null)
		{
			Debug.logError('Mod loading failed, check above for a message from Polymod explaining why.');
		}
		else
		{
			if (loadedModList.length == 0)
			{
				Debug.logInfo('Mod loading complete. We loaded no mods / ${ids.length} mods.');
			}
			else
			{
				Debug.logInfo('Mod loading complete. We loaded ${loadedModList.length} / ${ids.length} mods.');
			}
		}

		for (mod in loadedModList)
			Debug.logTrace('  * ${mod.title} v${mod.modVersion} [${mod.id}]');

		var fileList = Polymod.listModFiles("IMAGE");
		Debug.logInfo('Installed mods have replaced ${fileList.length} images.');
		for (item in fileList)
			Debug.logTrace('  * $item');

		fileList = Polymod.listModFiles("TEXT");
		Debug.logInfo('Installed mods have replaced ${fileList.length} text files.');
		for (item in fileList)
			Debug.logTrace('  * $item');

		fileList = Polymod.listModFiles("MUSIC");
		Debug.logInfo('Installed mods have replaced ${fileList.length} music files.');
		for (item in fileList)
			Debug.logTrace('  * $item');

		fileList = Polymod.listModFiles("SOUNDS");
		Debug.logInfo('Installed mods have replaced ${fileList.length} sound files.');
		for (item in fileList)
			Debug.logTrace('  * $item');
		#else
		Debug.logWarn("Attempted to load mods when Polymod was not supported!");
		#end
	}

	/**
	 * Returns true if there are mods to load in the mod folder,
	 * and false if there aren't (or mods aren't supported).
	 * @return A boolean value.
	 */
	public static function hasMods():Bool
	{
		#if FEATURE_MODCORE
		return getAllMods().length > 0;
		#else
		return false;
		#end
	}

	public static function getAllMods():Array<ModMetadata>
	{
		Debug.logInfo('Scanning the mods folder...');
		var modMetadata = Polymod.scan(MOD_DIRECTORY);
		Debug.logInfo('Found ${modMetadata.length} mods when scanning.');
		return modMetadata;
	}

	public static function getAllModIds():Array<String>
	{
		var modIds = [for (i in getAllMods()) i.id];
		return modIds;
	}

	#if FEATURE_MODCORE
	static function buildParseRules():polymod.format.ParseRules
	{
		var output = polymod.format.ParseRules.getDefault();
		// Ensure TXT files have merge support.
		output.addType("txt", TextFileFormat.LINES);
		// Ensure script files have merge support.
		output.addType("hscript", TextFileFormat.PLAINTEXT);

		// You can specify the format of a specific file, with file extension.
		// output.addFile("data/introText.txt", TextFileFormat.LINES)
		return output;
	}

	static inline function buildFrameworkParams():polymod.FrameworkParams
	{
		return {
			assetLibraryPaths: [
				"default" => "./preload", // ./preload
				"songs" => "./songs",
				"shared" => "./",
				"tutorial" => "./tutorial",
				"week1" => "./week1",
				"week2" => "./week2",
				"week3" => "./week3",
				"week4" => "./week4",
				"week5" => "./week5",
				"week6" => "./week6",
			]
		}
	}

	public static function getParseRules():ParseRules
	{
		var output = ParseRules.getDefault();
		output.addType("txt", TextFileFormat.LINES);
		return output;
	}

	static function onPolymodError(error:PolymodError):Void
	{
		// Perform an action based on the error code.
		switch (error.code)
		{
			case MOD_LOAD_PREPARE:
				Debug.logInfo(error.message, null);
			case MOD_LOAD_DONE:
				Debug.logInfo(error.message, null);
			// case MOD_LOAD_FAILED:
			case MISSING_ICON:
				Debug.logWarn('A mod is missing an icon, will just skip it but please add one: ${error.message}', null);
			// case "parse_mod_version":
			// case "parse_api_version":
			// case "parse_mod_api_version":
			// case "missing_mod":
			// case "missing_meta":
			// case "missing_icon":
			// case "version_conflict_mod":
			// case "version_conflict_api":
			// case "version_prerelease_api":
			// case "param_mod_version":
			// case "framework_autodetect":
			// case "framework_init":
			// case "undefined_custom_backend":
			// case "failed_create_backend":
			// case "merge_error":
			// case "append_error":
			default:
				// Log the message based on its severity.
				switch (error.severity)
				{
					case NOTICE:
						Debug.logInfo(error.message, null);
					case WARNING:
						Debug.logWarn(error.message, null);
					case ERROR:
						Debug.logError(error.message, null);
				}
		}
	}
	#end
}

#if FEATURE_MODCORE
class ModCoreBackend extends OpenFLBackend
{
	public function new()
	{
		super();
		Debug.logTrace('Initialized custom asset loader backend.');
	}

	public override function clearCache()
	{
		super.clearCache();
		Debug.logWarn('Custom asset cache has been cleared.');
	}

	public override function exists(id:String):Bool
	{
		Debug.logTrace('Call to ModCoreBackend: exists($id)');
		return super.exists(id);
	}

	public override function getBytes(id:String):lime.utils.Bytes
	{
		Debug.logTrace('Call to ModCoreBackend: getBytes($id)');
		return super.getBytes(id);
	}

	public override function getText(id:String):String
	{
		Debug.logTrace('Call to ModCoreBackend: getText($id)');
		return super.getText(id);
	}

	public override function list(type:PolymodAssetType = null):Array<String>
	{
		Debug.logTrace('Listing assets in custom asset cache ($type).');
		return super.list(type);
	}
}
#end