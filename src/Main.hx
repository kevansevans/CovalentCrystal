package;

import sys.FileSystem;

import setup.GZDoom;

/**
 * ...
 * @author Kaelan
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
		Sys.println("Running first time setup");
		Sys.println("Downloading latest GZDoom...");
		FileSystem.createDirectory('./GZDoom');
		GZDoom.download();
		if (!FileSystem.isDirectory('./wad'))
		{
			throw "Missing wad folder. Did you download the game correctly?";
		}
	}
	
}