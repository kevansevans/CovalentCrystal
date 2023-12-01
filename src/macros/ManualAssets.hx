package macros;

import haxe.io.Bytes;
import haxe.macro.Expr;
import haxe.zip.Entry;
import haxe.zip.Writer;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class ManualAssets 
{

	public macro static function buildZipAssets()
	{
		if (FileSystem.exists('./bin/wad')) deleteFiles('./bin/wad');
		if (FileSystem.exists('./bin/gzdoom')) deleteFiles('./bin/gzdoom');
		
		if (!FileSystem.isDirectory('./bin')) FileSystem.createDirectory('./bin');
		compress('./iwad/', './bin/assets.zip');
		return macro null;
	}
	
	static function deleteFiles(_path:String)
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
	
	public static function compress(_path:String, _desitnation:String)
	{
		var zipfile = buildZip(_path);
		var out = File.write(_desitnation, true);
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