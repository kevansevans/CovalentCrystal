package;

import doom.LanguageBuilder;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import haxe.Json;
import rom.TextAndDialogue;
import sys.io.File;
import sys.FileSystem;

import macros.ManualAssets;

import ipk3.WadBuilder;
import doom.EdNumBuilder;
import doom.PatchBuilder;
import doom.ZScriptBuilder;
import rom.RomRipper;

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
 * 
 * Thank you JaaShooUhh!
 * 	https://github.com/pokemon-speedrunning/symfiles/blob/master/pokecrystal.sym
 * 
 * Drawing sprites on hud like a weapon:
 * 	Have class inherit from CustomInventory and use A_Overlay
 * 	https://forum.zdoom.org/viewtopic.php?f=3&t=54909
 */
class Main 
{
	public static inline var GAMEVERSION:String = "0.0.1";
	
	public static var USERCONFIG:Userconfig;
	public static var SYSTEM:String;
	
	public static var VERBOSE:Bool = false;
	public static var REPAIR:Bool = false;
	public static var VKDOOM:Bool = false;
	public static var IGNOREOS:Bool = false;
	public static var AUTOSTART:Bool = true;
	public static var WADONLY:Bool = false;
	
	public static var ROM:Bytes;
	
	public static var ISSUE:Null<String> = null;
	
	static function main()
	{
		new Main();
	}
	
	public function new()
	{
		initBuild();
		
		Sys.println('Finished!');
		
		#if debug
		Sys.println('For better or for worse...');
		
		Sys.command('gzdoom -file covalent.pk3 -warp 1');
		
		while (true)
		{
			var reset = Sys.stdin().readLine();
			initBuild(true);
		}
		
		#end
		
		Sys.exit(0);
	}
	
	public static function initBuild(_justRezip:Bool = false)
	{
		ManualAssets.buildZipAssets();
		
		Sys.println("////////////////////");
		Sys.println("Covalent Crystal " + GAMEVERSION);
		Sys.println("This is a free project made with love!");
		Sys.println("////////////////////");
		Sys.println("");
		
		if (!FileSystem.exists('./userconfig.json')) createUserProfile();
		else loadUserProfile();
		
		verifyProfile();
		
		if (!USERCONFIG.romextracted || REPAIR) 
		{
			Sys.println('Unpackaging assets...');
			WadBuilder.assemble();
			
			if (!_justRezip)
			{
				Sys.println('Extracting rom assets...');
				loadRom();
				new RomRipper(ROM);
				USERCONFIG.romextracted = true;
			}
			
			Sys.println('Constructing GZDoom data...');
			
			new ZScriptBuilder();
			new EdNumBuilder();
			new PatchBuilder();
			new LanguageBuilder();
			
			Sys.println('Zipping wad...');
			WadBuilder.zipwad();
			#if !debug
			Sys.println('Cleaning up...');
			WadBuilder.clearWadFolder();
			#end
		}
		
		saveConfig();
		
		error(ISSUE);
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
			romextracted : false,
		}
		
		USERCONFIG = config;
		
		saveConfig();
	}
	
	static function verifyProfile() 
	{
		#if debug
		USERCONFIG.romextracted = false; //always recompile
		#else
		if (!FileSystem.exists('./GZDoom/covalent.pk3') || REPAIR) USERCONFIG.romextracted = false;
		#end
	}
	
	public static function saveConfig()
	{
		var json = Json.stringify(USERCONFIG);
		writeFile('./userconfig.json', Bytes.ofString(json));
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
	var romextracted:Bool;
}