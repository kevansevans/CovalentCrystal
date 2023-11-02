package rom;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class RomRipper 
{
	static inline var bankoffset:Int = 0x4000;
	
	var rom:Bytes;
	
	public function new(_data:Bytes) 
	{
		rom = _data;
		
		Sys.println('Dumping ROM assets...');
		
		var amount = 8 * 32;
		
		for (i in 0...512)
		{
			Sys.println('Ripping overworld sprite ${i + 1}/512');
			dumpOverworldSprites(0x30 * bankoffset, i);
		}
	}
	
	function dumpOverworldSprites(_offset:Int, _sprite:Int = 0)
	{
		var data:Array<Int> = new Array();
		
		for (sp in 0...4)
		{
			var set:Array<Int> = [];
			for (y in 0...8)
			{
				var cur = [0, 0, 0, 0, 0, 0, 0, 0];
				for (b in 0...2)
				{
					for (i in 0...8)
					{
						var mask = 1 << i;
						cur[7 - i] |= ((rom.get(_offset + ((sp + (_sprite * 4)) * 16) + (y * 2) + b) & mask) >> i) << b;
					}
				}
				
				for (num in cur) data.push(num);
			}
		}
		
		var table:Array<Array<Int>> = [[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]];
		var index = 0;
		
		for (pixel in data)
		{
			var pos = index % 8;
			
			if ((index >= 64 && index < 128) || (index >= 192))
			{
				pos += 8;
			}
			
			table[pos].push(pixel);
			++index;
		}
		
		var sets:Array<Array<Post>> = [];
		var setindex:Int = 0;
		for (set in table)
		{
			if (sets[setindex] == null) sets[setindex] = new Array();
			
			var inPixels:Bool = false;
			var offset:Int = 0;
			var alphoffset:Int = 0;
			var data:Array<Int> = [];
			
			for (pixel in set)
			{
				if (pixel != 0)
				{
					if (!inPixels) alphoffset = offset;
					inPixels = true;
					data.push(pixel);
				}
				else if (pixel == 0 && !inPixels)
				{
					//do nothing
				}
				else if (pixel == 0 && inPixels)
				{
					var post:Post =
					{
						offset : alphoffset,
						pixels : data.copy()
					}
					sets[setindex].push(post);
					
					data = new Array();
					
					inPixels = false;
				}
				
				++offset;
			}
			
			if (sets[setindex].length == 0)
			{
				sets[setindex].push({
					offset : alphoffset,
					pixels : data.copy()
				});
				
				data = new Array();
				
				inPixels = false;
			}
			
			++setindex;
		}
		
		var filebytes:BytesOutput = new BytesOutput();
		filebytes.writeInt16(16);
		filebytes.writeInt16(16);
		filebytes.writeInt16(8);
		filebytes.writeInt16(16);
		
		var offset = 4 * 16 + filebytes.length;
		
		var postbytes:BytesOutput = new BytesOutput();
		
		for (posts in sets)
		{
			var bytes:BytesOutput = new BytesOutput();
			for (post in posts)
			{
				bytes.writeByte(post.offset);
				bytes.writeByte(post.pixels.length);
				bytes.writeByte(0xBF);
				for (pixel in post.pixels)
				{
					bytes.writeByte(pixel);
				}
				bytes.writeByte(0xBF);
			}
			bytes.writeByte(0xFF);
			
			filebytes.writeInt32(offset);
			offset += bytes.length;
			
			var result:Bytes = bytes.getBytes();
			postbytes.writeFullBytes(result, 0, result.length);
		}
		
		var endbytes = postbytes.getBytes();
		filebytes.writeFullBytes(endbytes, 0, endbytes.length);
		
		File.saveBytes('./wad/SPRITES/rips/overworld/${StringTools.hex(_sprite, 4)}A0.lmp', filebytes.getBytes());
	}
}

typedef Post =
{
	var offset:Int;
	var pixels:Array<Int>;
}