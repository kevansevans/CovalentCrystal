package setup;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.io.BytesOutput;
import haxe.Http;
import ipk3.WadBuilder;

/**
 * ...
 * @author Kaelan
 */
class Freedoom 
{

	public static function download()
	{
		var apiurl:String = "https://api.github.com/repos/freedoom/freedoom/releases/latest";
		var request = new Http(apiurl);
		
		request.onData = function(_packet:String)
		{
			var data:Dynamic = Json.parse(_packet);
			var downloads:Array<Dynamic> = data.assets;
			
			for (item in downloads)
			{
				if (item.name.indexOf("freedoom") != -1 && item.content_type == "application/zip")
				{
					downloadPackage(item.browser_download_url);
				}
			}
		}
		
		request.setHeader('User-Agent', 'CovalentCrystal');
		request.request();
		
		if (Main.VERBOSE) Sys.println('Requesting latest Freedoom from https://api.github.com/repos/freedoom/freedoom/releases/latest');
	}
	
	static function downloadPackage(_durl:String) 
	{
		if (Main.VERBOSE) Sys.println('Downloading latest Freedoom from https://api.github.com/repos/freedoom/freedoom/releases/latest');
		
		var request:Http = new Http(_durl);
		request.setHeader('User-Agent', 'CovalentCrystal');
		
		var filebytes:BytesOutput;
		
		request.onData = function(_data)
		{
			var filerequest = new Http(request.responseHeaders['Location']);
			filerequest.setHeader('User-Agent', 'CovalentCrystal');
			filebytes = new BytesOutput();
			
			filerequest.customRequest(false, filebytes);
			
			while (filebytes == null) {}
			
			File.saveBytes('./freedoom.zip', filebytes.getBytes());
			FileSystem.createDirectory('./freetemp');
			ZipManager.extract('./freedoom.zip', './freetemp', true);
			readDir('./freetemp');
			WadBuilder.deleteFiles('./freetemp');
			
			Main.USERCONFIG.freedoom = true;
			Main.saveConfig();
		}
		
		request.request();
		
		while (filebytes == null) {}
	}
	
	static function readDir(_path:String)
	{
		var items = FileSystem.readDirectory(_path);
		
		for (file in items)
		{
			if (FileSystem.isDirectory(_path + '/$file'))
			{
				readDir(_path + '/$file');
				continue;
			}
			
			File.copy(_path + '/$file', './GZDoom/$file');
		}
	}
}