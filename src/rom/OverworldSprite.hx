package rom;

import doom.Export;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

import doom.Post;
import doom.Picture;

/**
 * ...
 * @author Kaelan
 */
class OverworldSprite 
{

	public static function dumpOverworldSprites(_offset:Int, _sprite:Int = 0)
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
						cur[7 - i] |= ((RomRipper.rom.get(_offset + ((sp + (_sprite * 4)) * 16) + (y * 2) + b) & mask) >> i) << b;
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
		
		var posts:Array<Post> = [];
		var setindex:Int = 0;
		
		for (set in table)
		{
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
				
				}
				else if (pixel == 0 && inPixels)
				{
					var post:Post =
					{
						xoffset : setindex,
						yoffset : alphoffset,
						length : data.length,
						pixels : data.copy(),
					}
					
					alphoffset += data.length;
					posts.push(post);
					
					data = new Array();
					
					inPixels = false;
					
				}
				
				++offset;
			}
			
			if (alphoffset != 0 && data.length == 0)
			{
				++setindex;
				continue;
			}
			
			var post:Post =
			{
				xoffset : setindex,
				yoffset : alphoffset,
				length : data.length,
				pixels : data.copy(),
			}
			
			posts.push(post);
			
			++setindex;
		}
		
		var picture:Picture =
		{
			width : 16,
			height : 16,
			xoffset : 8,
			yoffset : 16,
			posts : posts.copy()
		}
		
		Export.writePicture(picture, './wad/SPRITES/rips/overworld/O${StringTools.hex(_sprite, 3)}A0.lmp');
	}
	
}