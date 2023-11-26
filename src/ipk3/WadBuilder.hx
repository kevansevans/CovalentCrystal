package ipk3;

import sys.FileSystem;
import setup.ZipManager;

/**
 * ...
 * @author Kaelan
 */
class WadBuilder 
{

	public static function assemble()
	{
		if (!FileSystem.exists('./assets.zip'))
		{
			Main.ISSUE = "Assets folder is missing! Please re-download!";
			Main.error(Main.ISSUE);
		}
		ZipManager.extract('./assets.zip', './wad', false);
		
		if (!FileSystem.isDirectory('./wad')) FileSystem.createDirectory('./wad');
		else
		{
			clearFolder('./wad/srpites/pokemon/');
			clearFolder('./wad/srpites/overworld/');
			clearFolder('./wad/srpites/trainer/');
		}
		
		FileSystem.createDirectory('./wad/SPRITES');
		FileSystem.createDirectory('./wad/SPRITES/pokemon');
		FileSystem.createDirectory('./wad/SPRITES/overworld');
		FileSystem.createDirectory('./wad/SPRITES/trainer');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors/pokemon');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors/NPC');
	}
	
	static function clearFolder(_path:String)
	{
		var items = FileSystem.readDirectory(_path);
		if (items == null) return;
		
		for (item in items)
		{
			if (FileSystem.isDirectory(_path + '/$item'))
			{
				clearFolder(_path + '/$item');
				FileSystem.deleteDirectory(_path + '/$item');
				continue;
			}
			
			try
			{
				FileSystem.deleteFile(_path + '/$item');
			}
			catch (_result:String)
			{
				trace(_result);
			}
		}
	}
	
	public static function zipwad()
	{
		ZipManager.compress('./wad', './gzdoom/covalent.pk3');
	}
}