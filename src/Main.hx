package;

import doom.EdNumBuilder;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import haxe.Json;
import sys.io.File;
import sys.FileSystem;

import setup.GZDoom;
import doom.PatchBuilder;
import doom.ZScriptBuilder;
import rom.RomRipper;
import ipk3.WadBuilder;

import macros.ManualAssets;

/**
 * ...
 * @author Kaelan
 * 
 * To do: Kev, clean up the throws. You knoow you're better than this.
 * To do: Make HXML file so HaxeDevelop isn't needed
 * 
 * Credits:
 * 	Pokemon Crystal Disassembly: https://github.com/pret/pokecrystal
 * 	PRET Discord: https://discord.gg/d5dubZ3
 */
class Main 
{
	public static inline var GAMEVERSION:String = "0.0.1";
	
	public static inline var GZDIR:String = 'gzdoom';
	public static inline var VKDIR:String = 'vkdoom';
	
	public static var USERCONFIG:Userconfig;
	public static var SYSTEM:String;
	
	public static var VERBOSE:Bool = false;
	public static var REPAIR:Bool = false;
	public static var VKDOOM:Bool = false;
	public static var IGNOREOS:Bool = false;
	public static var AUTOSTART:Bool = true;
	
	public static var ROM:Bytes;
	
	public static var ISSUE:Null<String> = null;
	
	static function main()
	{
		ManualAssets.buildZipWad(0);
		
		Sys.println("////////////////////");
		Sys.println("Covalent Crystal " + GAMEVERSION);
		Sys.println("This is a free project made with love!");
		Sys.println("////////////////////");
		Sys.println("");
		
		if (!FileSystem.exists('./userconfig.json')) createUserProfile();
		else loadUserProfile();
		
		parseArgs(Sys.args());
		
		verifyProfile();
		
		if (!USERCONFIG.sourceport) 
		{
			Sys.println('Downloading latest Doom source port...');
			GZDoom.download();
		}
		if (!USERCONFIG.romextracted) 
		{
			Sys.println('Unpackaging assets...');
			WadBuilder.assemble();
			
			Sys.println('Extracting rom assets...');
			loadRom();
			new RomRipper(ROM);
			new ZScriptBuilder();
			new EdNumBuilder();
			new PatchBuilder();
			
			Sys.println('Zipping wad...');
			WadBuilder.zipwad();
			
			USERCONFIG.romextracted = true;
		}
		
		error(ISSUE);
		
		new Main();
	}
	
	public function new()
	{
		if (USERCONFIG.autostart) launchGame();
		
		Sys.exit(0);
	}
	
	public static function error(_error:Null<String>)
	{
		if (_error == null) return;
		
		Sys.println(_error);
		
		while (true) {};
	}
	
	static function loadRom() 
	{
		var files = FileSystem.readDirectory('./');
		
		for (file in files)
		{
			if (FileSystem.isDirectory(file)) continue;
			
			var index:Null<Int> = file.lastIndexOf('.gbc');
			if (index == -1) continue;
			
			var hex = Md5.make(File.getBytes('./${file}')).toHex();
			
			switch (hex)
			{
				case CrystalHashes.ROM_JAPAN | CrystalHashes.ROM_USAEUROPE | CrystalHashes.ROM_USAEUROPE_REV:
					ROM = File.getBytes('./${file}');
					return;
				default:
					
			}
		}
		
		ISSUE = "Failed to located a valid Pokemon Crystal rom...";
		error(ISSUE);
	}
	
	static function launchGame() 
	{
		Sys.setCwd(VKDOOM == true ? VKDIR : GZDIR);
		
		#if debug
		Sys.command('${VKDOOM ? VKDIR : GZDIR} -File covalent.pk3');
		#else
		Sys.command('${VKDOOM ? VKDIR : GZDIR} -Iwad covalent.pk3');
		#end
	}
	
	static function loadUserProfile() 
	{
		var input = File.getBytes('./userconfig.json');
		var config:Userconfig = cast Json.parse(input.toString());
		USERCONFIG = config;
	}
	
	static function createUserProfile() 
	{
		if (VERBOSE) Sys.println('Created new user profile...');
		
		var config:Userconfig =
		{
			autostart : true,
			romextracted : false,
			sourceport : false,
			usevkdoom : false
		}
		
		USERCONFIG = config;
		
		saveConfig();
	}
	
	static function verifyProfile() 
	{
		#if debug
		USERCONFIG.romextracted = false; //always recompile
		#else
		if (!FileSystem.exists('./GZDoom/covalent.ipk3') || REPAIR) USERCONFIG.romextracted = false;
		#end
		
		if (!FileSystem.exists('./gzdoom/gzdoom.pk3') || REPAIR) USERCONFIG.sourceport = false;
	}
	
	public static function saveConfig()
	{
		var json = Json.stringify(USERCONFIG);
		writeFile('./userconfig.json', Bytes.ofString(json));
	}
	
	public static function parseArgs(_args:Array<String>)
	{
		if (_args.length == 0) return;
		
		for (arg in _args)
		{
			switch (arg.toUpperCase())
			{
				case '-VERBOSE':
					VERBOSE = true;
					Sys.println('Verbose debugging enabled, this will take longer!');
				case '-NOAUTOSTART':
					AUTOSTART = false;
				case '-VKDOOM':
					var os:String = Sys.systemName();
					if (os.toUpperCase() != "WINDOWS" && !IGNOREOS)
					{
						ISSUE = "VKDoom is currently a windows only download. Use the command -IGNOREOS if a native build is present in ./vkdoom";
						error(ISSUE);
					}
					VKDOOM = true;
					USERCONFIG.usevkdoom = true;
				case '-REPAIR':
					REPAIR = true;
				default:
					Sys.println('Unrecognized command: ${arg}!');
			}
		}
	}
	
	public static function writeFile(_path:String, _data:Bytes)
	{
		var out = File.write(_path);
		out.write(_data);
		out.close();
		
		if (VERBOSE) Sys.println('Saved ${_path}');
	}
}

enum abstract CrystalHashes(String) from String to String
{
	var ROM_JAPAN:String = "9c3ae66bffb28ea8ed2896822da02992";
	var ROM_USAEUROPE:String = "9f2922b235a5eeb78d65594e82ef5dde";
	var ROM_USAEUROPE_REV:String = "301899b8087289a6436b0a241fbbb474";
}

typedef Userconfig =
{
	var autostart:Bool;
	var romextracted:Bool;
	var sourceport:Bool;
	var usevkdoom:Bool;
}