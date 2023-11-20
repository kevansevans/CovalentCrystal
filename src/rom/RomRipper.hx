package rom;

import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 * 
 * https://www.pokecommunity.com/showthread.php?t=286845
 * 
 * Overworld sprites: Bank 0x30 and 0x31, 512 sprites
 * Pokemon Sprites: 120000 (unconfirmed)
 * 
 * "IRREGULARITY In Gold and Silver and Crystal, bank 13 (4C000-4FFFF) is completely blank, there are graphics that point to this bank, but in reality, they're pointing to bank 1F. I have no idea why this is how it is."
 * "Another Irregularity is with the Unowns, they have a separate pointer bank, which is located at 7C000 their graphics are stored in the B8000-BBFFF bank, which is pointed to with 1F..."
 * 
 * https://github.com/LinusU/pokemon-sprite-compression/blob/main/src/gen2.rs
 */
class RomRipper 
{
	public static inline var bankoffset:Int = 0x4000;
	
	public static var rom:Bytes;
	public static var romdata:Array<Int>;
	
	public function new(_data:Bytes) 
	{
		rom = _data;
		romdata = cast rom.getData().copy();
		
		Sys.println('Dumping ROM assets...');
		Sys.println('Ripping overworld sprites');
		for (i in 0...512)
		{
			OverworldSprite.dumpOverworldSprites(0x30 * bankoffset, i);
		}
		
		new PokemonSprite();
	}
}