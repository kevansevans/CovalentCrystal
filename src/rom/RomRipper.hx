package rom;

import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class RomRipper 
{
	static inline var bankoffset:Int = 0x4000;
	
	public static var rom:Bytes;
	
	public function new(_data:Bytes) 
	{
		rom = _data;
		
		Sys.println('Dumping ROM assets...');
		Sys.println('Ripping overworld sprites');
		for (i in 0...256)
		{
			OverworldSprite.dumpOverworldSprites(0x30 * bankoffset, i);
		}
	}
	
	
}