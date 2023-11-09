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
		if (_data.length != 64) throw 'Sprite data is not 64 units! ${_data.length}, ${_data.length % 64}\n' + _pos;
		
		data = new Vector(64);
		for (i in 0...64)
		{
			data[i] = _data[i];
		}
	}
	
	public function getVerticalStrip(_column:Int, ?_pos:PosInfos):Array<Int>
	{
		if (_column >= 8) throw "This shouldn't happen, why is this happening? Gameboy sprites are 8x8, you're asking for a column that doesn't exist! " + _pos ;
		
		var result:Array<Int> = [];
		
		for (a in 0...8) result.push(data[(a * 8) + _column]);
		
		return result;
	}
	
	public static function spritesFromData(_2bpp:Array<Int>, ?_pos:PosInfos):Array<GBSprite>
	{
		if (_2bpp.length % 16 != 0) throw 'provided 2bpp data is not of expected size! ${_2bpp.length}, ${_2bpp.length % 16} \n' + _pos;
		
		var numsprites:Int = Std.int(_2bpp.length / 16);
		var sprites:Array<GBSprite> = [];
		var data:Array<Int> = unmask(_2bpp);
		
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