package setup;

import haxe.io.Bytes;
import haxe.io.Output;
import haxe.zip.Entry;
import haxe.zip.Reader;
import haxe.zip.Writer;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class ZipManager 
{

	public function new() 
	{
		
	}
	
	public static function extract(_path:String, _destination:String, _deleteZip:Bool) 
	{
		var zip = File.read(_path);
		var entries = Reader.readZip(zip);
		zip.close();
		
		if (!FileSystem.isDirectory(_destination)) FileSystem.createDirectory(_destination);
		
		for (entry in entries)
		{
			var filename = entry.fileName;
			if (filename.charAt(0) != "/" && filename.charAt(0) != "\\" && filename.split("..").length <= 1)
			{
				var dirs = ~/[\/\\]/g.split(filename);
				
				var path = "";
				var file = dirs.pop();
				for (d in dirs)
				{
					path += d;
					FileSystem.createDirectory('./${_destination}/' + path);
					path += "/";
				}
				
				if (file == "")
				{
					continue;
				}
				
				path += file;
				
				if (Main.VERBOSE) Sys.println("Extracted " + path);
				
				var data = Reader.unzip(entry);
				var f = File.write('./${_destination}/' + path, true);
				f.write(data);
				f.close();
			}
		}
		
		if (_deleteZip) FileSystem.deleteFile(_path);
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
			if (!checkExtension(file)) continue;
			
			var path = haxe.io.Path.join([_path, file]);
			if (isFolder(path))
			{
				buildZip(path, _entries, _inDir);
				continue;
			}
			
			var bytes = getFileBytes(path);
			var filename = path.substring(_inDir - 2); //Path.join (see above) doesn't return the expected string, so this needs to be adjusted by 2
			
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
	
	static function checkExtension(_input:String):Bool
	{
		var blacklist:Array<String> = ['.dbs', '.backup1', '.backup2', '.backup3'];
		
		for (item in blacklist)
		{
			if (_input.lastIndexOf(item) != -1) return false; 
		}
		
		return true;
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
		var file = File.read(_path);
		var bytes = file.readAll();
		file.close();
		return bytes;
	}
}