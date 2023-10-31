package setup;

import haxe.Json;
import sys.FileSystem;
import haxe.zip.Reader;
import sys.io.File;
import haxe.io.BytesOutput;
import haxe.Http;

/**
 * ...
 * @author Kaelan
 */
class GZDoom 
{
	public static function download()
	{
		var apiurl:String = "https://api.github.com/repos/ZDoom/gzdoom/releases/latest";
		var request = new Http(apiurl);
		
		request.onData = function(_packet:String)
		{
			var data:Dynamic = Json.parse(_packet);
			var downloads:Array<Dynamic> = data.assets;
			
			for (item in downloads)
			{
				var durl:String = item.browser_download_url;
				if (durl.indexOf("Windows-64bit.zip") != -1) 
				{
					downloadPackage(durl);
					break;
				}
			}
		}
		
		request.onStatus = function(_status)
		{
			trace(_status);
		}
		
		request.setHeader('User-Agent', 'CovalentCrystal');
		request.request();
	}
	
	static function downloadPackage(_durl:String) 
	{
		var request:Http = new Http(_durl);
		request.setHeader('User-Agent', 'CovalentCrystal');
		request.onData = function(_data)
		{
			var filerequest = new Http(request.responseHeaders['Location']);
			filerequest.setHeader('User-Agent', 'CovalentCrystal');
			var filebytes:BytesOutput = new BytesOutput();
			
			filerequest.customRequest(false, filebytes);
			
			while (filebytes == null) {}
			
			File.saveBytes('./gzdoom.zip', filebytes.getBytes());
			
			extractFiles();
		}
		
		request.request();
	}
	
	static function extractFiles() 
	{
		var zip = File.read('./gzdoom.zip');
		var entries = Reader.readZip(zip);
		zip.close();
		
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
					FileSystem.createDirectory("./GZDoom/" + path);
					path += "/";
				}
				
				if (file == "")
				{
					continue;
				}
				
				path += file;
				Sys.println("Created " + path);
				
				var data = Reader.unzip(entry);
				var f = File.write("./GZDoom/" + path, true);
				f.write(data);
				f.close();
			}
		}
		
		FileSystem.deleteFile('./gzdoom.zip');
	}
}