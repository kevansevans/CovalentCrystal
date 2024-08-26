package gameboy;

import haxe.PosInfos;
import haxe.ds.Vector;
import rom.RomRipper;

/**
 * ...
 * @author Kaelan
 */
class GBSprite 
{
	static var reverselookup:Array<Int> = 
	[
		0,  128, 64, 192, 32, 160,  96, 224, 16, 144, 80, 208, 48, 176, 112, 240,
		8,  136, 72, 200, 40, 168, 104, 232, 24, 152, 88, 216, 56, 184, 120, 248,
		4,  132, 68, 196, 36, 164, 100, 228, 20, 148, 84, 212, 52, 180, 116, 244,
		12, 140, 76, 204, 44, 172, 108, 236, 28, 156, 92, 220, 60, 188, 124, 252,
		2,  130, 66, 194, 34, 162,  98, 226, 18, 146, 82, 210, 50, 178, 114, 242,
		10, 138, 74, 202, 42, 170, 106, 234, 26, 154, 90, 218, 58, 186, 122, 250,
		6,  134, 70, 198, 38, 166, 102, 230, 22, 150, 86, 214, 54, 182, 118, 246,
		14, 142, 78, 206, 46, 174, 110, 238, 30, 158, 94, 222, 62, 190, 126, 254,
		1,  129, 65, 193, 33, 161,  97, 225, 17, 145, 81, 209, 49, 177, 113, 241,
		9,  137, 73, 201, 41, 169, 105, 233, 25, 153, 89, 217, 57, 185, 121, 249,
		5,  133, 69, 197, 37, 165, 101, 229, 21, 149, 85, 213, 53, 181, 117, 245,
		13, 141, 77, 205, 45, 173, 109, 237, 29, 157, 93, 221, 61, 189, 125, 253,
		3,  131, 67, 195, 35, 163,  99, 227, 19, 147, 83, 211, 51, 179, 115, 243,
		11, 139, 75, 203, 43, 171, 107, 235, 27, 155, 91, 219, 59, 187, 123, 251,
		7,  135, 71, 199, 39, 167, 103, 231, 23, 151, 87, 215, 55, 183, 119, 247,
		15, 143, 79, 207, 47, 175, 111, 239, 31, 159, 95, 223, 63, 191, 127, 255
	];
	
	public var data:Vector<Int>;
	public function new(_data:Array<Int>, ?_pos:PosInfos) 
	{
		//A (8x8 GameBoy 2 bits per pixel) sprite takes up 64 bytes when decompressed.
		//If provided array of bytes is not divisible by 64, the sprite data is incomple/wrong
		
		if (_data.length != 64) throw 'Sprite data is not 64 units! ${_data.length}, ${_data.length % 64}\n' + _pos;
		
		data = new Vector(64);
		for (i in 0...64)
		{
			data[i] = _data[i];
		}
	}
	
	public static var emptySprite(get, null):GBSprite;
	static function get_emptySprite():GBSprite 
	{
		var data:Array<Int> = [];
		for (i in 0...64) 
		{
			data.push(i % 2 == 0 ? 120 : 210);
		}
		
		return new GBSprite(data);
	}
	
	public function getVerticalStrip(_column:Int, ?_pos:PosInfos):Array<Int>
	{
		//Sprites are 8x8. This function is needed for converting GB sprites to Doom compatible patches.
		if (_column >= 8) throw 'Column ${_column} does not exist. Column requests need to be from 0 to 7.\n' + _pos ;
		
		var result:Array<Int> = [];
		
		for (a in 0...8) result.push(data[(a * 8) + _column]);
		
		return result;
	}
	
	public static function spritesFromData(_2bpp:Array<Int>, _alpha:Bool = false, ?_pos:PosInfos):Array<GBSprite>
	{
		//A interlaced GB sprite is 16 bytes. Each row is 2 bytes long. If not divisible by 16, sprite data is incomplete.
		if (_2bpp.length % 16 != 0) throw 'provided 2bpp data is not of expected size! ${_2bpp.length}, ${_2bpp.length % 16} \n' + _pos;
		
		var numsprites:Int = Std.int(_2bpp.length / 16);
		var data:Array<Int> = unmask(_2bpp);
		
		if (_alpha)
		{
			for (i in 0...data.length) data[i] += 1;
		}
		
		var sprites:Array<GBSprite> = [];
		
		for (sp in 0...numsprites)
		{
			var slice = data.slice((64 * sp), (64 * sp) + 64);
			sprites.push(new GBSprite(slice));
		}
		
		return sprites;
	}
	
	public static function unmask(_data:Array<Null<Int>>):Array<Int>
	{
		var data:Array<Int> = [];
		
		var index:Int = 0;
		while (true)
		{
			if (_data[index] == null) break;
			
			for (y in 0...8)
			{
				var cur = [0, 0, 0, 0, 0, 0, 0, 0];
				
				for (b in 0...2)
				{
					for (i in 0...8)
					{
						var mask = 1 << i;
						cur[7 - i] |= ((_data[index + (y * 2) + b] & mask) >> i) << b;
					}
				}
				
				for (num in cur) data.push(num);
			}
			
			index += 16;
		}
		
		return data;
	}
	
	public static function decompress(_offset:Int):Array<Int>
	{
		var result:Array<Int> = [];
		var rom:Array<Int> = RomRipper.romdata;
		var pos:Int = _offset;
		
		while (true)
		{
			var byte:Int = rom[pos];
			
			if (byte == 0xFF)
			{
				break;
			}
			
			var cmd:Int = byte >> 5;
			var count:Int = byte & 0x1F;
			
			pos += 1;
			
			if (cmd == 7)
			{
				cmd = (count >> 2);
				count = ((count & 3) << 8) | rom[pos];
				++pos;
				if (cmd == count) 
				{
					throw "command same a count failure";
				}
			}
			
			count += 1;
			
			switch (cmd)
			{
				default:
					throw "Unknow command failure: " + cmd;
				case 0:
					result = result.concat(rom.slice(pos, pos + count));
					pos += count;
				
				case 1:
					for (a in 0...count)
					{
						result.push(rom[pos]);
					}
					pos += 1;
				
				case 2:
					for (a in 0...count)
					{
						result.push(rom[pos + (a % 2)]);
					}
					pos += 2;
				
				case 3:
					for (a in 0...count)
					{
						result.push(0);
					}
				
				case 4:
					var start:Int = 0;
					
					if (rom[pos] & 0x80 == 0)
					{
						start = (rom[pos] << 8) | (rom[pos + 1]);
						pos += 2;
					}
					else
					{
						start = result.length - (rom[pos] & 0x7F) - 1;
						pos += 1;
					}
					
					for (a in 0...count)
					{
						result.push(result[start + a]);
					}
				
				case 5:
					
					var start:Int = 0;
					
					if (rom[pos] & 0x80 == 0)
					{
						start = (rom[pos] << 8) | (rom[pos + 1]);
						pos += 2;
					}
					else
					{
						start = result.length - (rom[pos] & 0x7F) - 1;
						pos += 1;
					}
					
					for (a in start...(start + count))
					{
						result.push(reverselookup[result[a]]);
					}
					
				case 6:
					var start:Int = 0;
					
					if (rom[pos] & 0x80 == 0)
					{
						start = (rom[pos] << 8) | (rom[pos + 1]);
						pos += 2;
					}
					else
					{
						start = result.length - (rom[pos] & 0x7F) - 1;
						pos += 1;
					}
					
					for (a in 0...count)
					{
						result.push(result[start - a]);
					}
			}
		}
		
		return result;
	}
}