package setup;

import haxe.Json;
import sys.FileSystem;
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
		if (!FileSystem.exists('./GZDoom')) FileSystem.createDirectory('./GZDoom');
		
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
		
		request.setHeader('User-Agent', 'CovalentCrystal');
		request.request();
		
		if (Main.VERBOSE) Sys.println('Requesting latest GZDoom from https://api.github.com/repos/ZDoom/gzdoom/releases/latest');
	}
	
	static function downloadPackage(_durl:String) 
	{
		if (Main.VERBOSE) Sys.println('Downloading latest GZDoom from https://api.github.com/repos/ZDoom/gzdoom/releases/latest');
		
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
			
			File.saveBytes('./gzdoom.zip', filebytes.getBytes());
			
			ZipManager.extract('./gzdoom.zip', './gzdoom', true);
			
			Main.USERCONFIG.sourceport = true;
			Main.saveConfig();
		}
		
		request.request();
		
		while (filebytes == null) {}
	}
	
	
}