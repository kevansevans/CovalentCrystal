package gameboy;
import haxe.PosInfos;
import haxe.ds.Vector;

/**
 * ...
 * @author Kaelan
 */
class GBSprite 
{
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
		for (i in 0...64) data.push(5);
		
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
	
	public static function spritesFromData(_2bpp:Array<Int>, ?_pos:PosInfos):Array<GBSprite>
	{
		//A interlaced GB sprite is 16 bytes. Each row is 2 bytes long. If not divisible by 16, sprite data is incomplete.
		if (_2bpp.length % 16 != 0) throw 'provided 2bpp data is not of expected size! ${_2bpp.length}, ${_2bpp.length % 16} \n' + _pos;
		
		var numsprites:Int = Std.int(_2bpp.length / 16);
		var data:Array<Int> = unmask(_2bpp);
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
}