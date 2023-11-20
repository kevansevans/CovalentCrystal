package ipk3;

import sys.FileSystem;

/**
 * ...
 * @author Kaelan
 */
class WadBuilder 
{

	public static function assemble()
	{
		#if !debug
		
		if (!FileSystem.isDirectory('./wad')) FileSystem.createDirectory('./wad');
		else
		{
			clearFolder('./wad/');
		}
		
		FileSystem.createDirectory('./wad/SPRITES');
		FileSystem.createDirectory('./wad/SPRITES/pokemon');
		FileSystem.createDirectory('./wad/SPRITES/overworld');
		FileSystem.createDirectory('./wad/SPRITES/trainer');
		
		#else
		
		trace("Remember to compile as release to clear deprecated directories and files");
		
		#end
	}
	
	public static function clearFolder(_path:String)
	{
		var items = FileSystem.readDirectory(_path);
		
		for (item in items)
		{
			if (FileSystem.isDirectory(_path + '/$item'))
			{
				clearFolder(_path + '/$item');
				FileSystem.deleteDirectory(_path + '/$item');
				continue;
			}
			
			FileSystem.deleteFile(_path + '/$item');
		}
	}
	
}