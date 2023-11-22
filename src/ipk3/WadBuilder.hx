package ipk3;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Bytes;

import haxe.zip.Entry;
import haxe.zip.Writer;

/**
 * ...
 * @author Kaelan
 */
class WadBuilder 
{

	public static function assemble()
	{
		#if debug
		//Perform "fresh install" of assets
		
		Sys.println("Clearing out icky wad");
		
		clearFolder('./wad');
		
		Sys.setCwd('..');
		copyFilesOver('iwad', '');
		Sys.setCwd('./bin');
		
		#end
		
		
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
	}
	
	#if debug
	static function copyFilesOver(_path:String, _localpath:String) 
	{
		var wadfiles = FileSystem.readDirectory('./' + _path);
		if (wadfiles == null) return;
		
		for (item in wadfiles)
		{
			if (FileSystem.isDirectory(_path + '/' + item))
			{
				FileSystem.createDirectory('./bin/wad/' + _localpath + '/' + item);
				copyFilesOver(_path + '/' + item, _localpath + '/' + item);
				continue;
			}
			
			File.copy(_path + '/' + item, './bin/wad/' + _localpath + '/' + item);
		}
	}
	#end
	
	public static function clearFolder(_path:String)
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
		var zipfile = buildZip('wad/');
		
		var out = File.write('./GZDoom/covalent.pk3', true);
		var zip = new Writer(out);
		
		zip.write(zipfile);
		out.close();
	}
	
	static function buildZip(_path:String, _entries:List<Entry> = null, _inDir:Null<Int> = null)
	{
		if (_entries == null) _entries = new List();
		if (_inDir == null) _inDir = _path.length;
		
		for (file in getItems(_path))
		{
			var path = haxe.io.Path.join([_path, file]);
			if (isFolder(path))
			{
				buildZip(path, _entries, _inDir);
				continue;
			}
			
			var bytes = getFileBytes(path);
			var filename = path.substring(_inDir - 2); //Path.join doesn't return the expected string, so this needs to be adjusted by 2
			
			var entry:Entry =
			{
				fileName : filename,
				fileSize : bytes.length,
				fileTime : Date.now(),
				compressed : false,
				dataSize : FileSystem.stat(path).size,
				data : bytes,
				crc32 : null
			};
			
			_entries.push(entry);
		}
		
		return _entries;
	}
	
	static function getItems(_path:String):Array<String>
	{
		return FileSystem.readDirectory(_path);
	}
	
	static function isFolder(_path:String):Bool
	{
		return FileSystem.isDirectory(_path);
	}
	
	static function getFileBytes(_path:String):Bytes
	{
		return Bytes.ofData(File.getBytes(_path).getData());
	}
}