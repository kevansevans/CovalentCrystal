package;

////////////////////////////////////////////////////////////////////////////////////////////////////
//Covalent Crystal builder tool thing
////////////////////////////////////////////////////////////////////////////////////////////////////
import haxe.crypto.Md5;
import ipk3.WadBuilder;
import rom.Pointers;
import rom.RomRipper;
import sys.FileSystem;
import sys.io.File;
import setup.GZDoom;

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
	
	static function main() 
	{
		Sys.println("////////////////////");
		Sys.println("Covalent Crystal " + GAMEVERSION);
		Sys.println("This is a free project made with love!");
		Sys.println("////////////////////");
		
		new Pointers();
		
		new Main();
	}
	
	public function new()
	{
		if (FileSystem.exists('./Covalent.ipk3') && FileSystem.exists("./GZDoom/GZDoom.pk3"))
		{
			launchGame();
		}
		else
		{
			runSetup();
		}
	}
	
	function launchGame() 
	{
		
	}
	
	function runSetup() 
	{
		#if !debug
		trace("Hey fuck face, you still need to replace me with vkDoom!");
		#end
		
		Sys.println("Running first time setup");
		if (!FileSystem.exists("./GZDoom")) 
		{
			Sys.println("Downloading latest GZDoom...");
			FileSystem.createDirectory('./GZDoom');
			GZDoom.download();
		}
		
		WadBuilder.assemble();
		
		var files = FileSystem.readDirectory('./');
		var romfound:Bool = false;
		var rompaths:Map<String, String> = new Map();
		
		for (file in files)
		{
			if (file.lastIndexOf('.gbc') != -1) 
			{
				romfound = true;
				
				var filebytes = File.getBytes('./' + file);
				var hash = Md5.make(filebytes);
				
				rompaths[hash.toHex()] = file;
			}
		}
		
		if (!romfound)
		{
			throw "Covalent Crystal needs a valid Pokemon Crystal ROM in order to work!";
		}
		
		if (rompaths[CrystalHashes.ROM_USAEUROPE_REV] != null) extractRom(rompaths[CrystalHashes.ROM_USAEUROPE_REV], CrystalHashes.ROM_USAEUROPE_REV);
		if (rompaths[CrystalHashes.ROM_USAEUROPE] != null) extractRom(rompaths[CrystalHashes.ROM_USAEUROPE], CrystalHashes.ROM_USAEUROPE);
		if (rompaths[CrystalHashes.ROM_JAPAN] != null) extractRom(rompaths[CrystalHashes.ROM_JAPAN], CrystalHashes.ROM_JAPAN);
	}
	
	function extractRom(_path:String, _ver:CrystalHashes)
	{
		switch (_ver)
		{
			case CrystalHashes.ROM_JAPAN:
				Sys.println(_ver);
				Sys.println("Pocket Monsters - Crystal Version (Japan)");
			case CrystalHashes.ROM_USAEUROPE:
				Sys.println(_ver);
				Sys.println("Pokemon - Crystal Version (USA, Europe)");
			case CrystalHashes.ROM_USAEUROPE_REV:
				Sys.println(_ver);
				Sys.println("Pokemon - Crystal Version (USA, Europe) (Rev A)");
		}
		
		new RomRipper(File.getBytes('./' + _path));
	}
	
}

enum abstract CrystalHashes(String) from String to String
{
	var ROM_JAPAN:String = "9c3ae66bffb28ea8ed2896822da02992";
	var ROM_USAEUROPE:String = "9f2922b235a5eeb78d65594e82ef5dde";
	var ROM_USAEUROPE_REV:String = "301899b8087289a6436b0a241fbbb474";
}