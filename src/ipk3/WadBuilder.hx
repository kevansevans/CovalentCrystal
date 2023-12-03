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
		
		FileSystem.createDirectory('./wad/SPRITES');
		FileSystem.createDirectory('./wad/SPRITES/pokemon');
		FileSystem.createDirectory('./wad/SPRITES/overworld');
		FileSystem.createDirectory('./wad/SPRITES/trainer');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors/pokemon');
		FileSystem.createDirectory('./wad/ZSCRIPT/actors/NPC');
	}
	
	public static function clearWadFolder()
	{
		if (FileSystem.exists('./wad')) deleteFiles('./wad');
	}
	
	public static function deleteFiles(_path:String)
	{
		var items = FileSystem.readDirectory(_path);
		
		for (file in items)
		{
			if (FileSystem.isDirectory(_path + '/$file')) {
				deleteFiles(_path + '/$file');
				continue;
			}
			
			FileSystem.deleteFile(_path + '/$file');
		}
		
		FileSystem.deleteDirectory(_path);
	}
	
	public static function zipwad()
	{
		if (!Main.WADONLY) ZipManager.compress('./wad', './gzdoom/covalent.pk3');
		else ZipManager.compress('./wad', './covalent.pk3');
	}
}