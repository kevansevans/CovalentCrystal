package doom;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class Export 
{
	static inline var PICHEADERSIZE:Int = 8;
	
	public static function writePicture(_pic:Picture, _path:String)
	{
		var picturebytes:BytesOutput = new BytesOutput();
		
		picturebytes.writeInt16(_pic.width);
		picturebytes.writeInt16(_pic.height);
		picturebytes.writeInt16(_pic.xoffset);
		picturebytes.writeInt16(_pic.yoffset);
		
		var offset = (4 * _pic.width) + PICHEADERSIZE;
		
		var columns:Array<Array<Post>> = [];
		
		for (post in _pic.posts)
		{
			if (columns[post.xoffset] == null) columns[post.xoffset] = new Array();
			columns[post.xoffset].push(post);
		}
		
		var postbytes:BytesOutput = new BytesOutput();
		
		for (column in columns)
		{
			var subbytes:BytesOutput = new BytesOutput();
			
			for (post in column)
			{
				subbytes.writeByte(post.yoffset);
				subbytes.writeByte(post.length);
				subbytes.writeByte(0xFB);
				
				for (pixel in post.pixels)
				{
					#if debug
					subbytes.writeByte(pixel + 249);
					#else
					subbytes.writeByte(pixel - 1);
					#end
				}
				
				subbytes.writeByte(0xFB);
			}
			
			subbytes.writeByte(0xFF);
			
			picturebytes.writeInt32(offset);
			offset += subbytes.length;
			
			var result = subbytes.getBytes();
			postbytes.writeFullBytes(result, 0, result.length);
		}
		
		var imagedata:Bytes = postbytes.getBytes();
		picturebytes.writeFullBytes(imagedata, 0, imagedata.length);
		picturebytes.writeByte(0x00);
		
		File.saveBytes(_path, picturebytes.getBytes());
	}
	
}