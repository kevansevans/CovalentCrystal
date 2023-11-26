package rom;

import haxe.io.Bytes;

import crystal.BasePokemonData;

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
	public static inline var POKEMONDATA:Int = 0x51424;
	
	public static var romdata:Array<Int>;
	
	public function new(_data:Bytes) 
	{
		romdata = cast _data.getData().copy();
		
		Sys.println('Dumping ROM assets...');
		
		new OverworldSprite();
		
		new PokemonSprite();
		
		new PaletteBuilder();
	}
	
	public static function getPokemonData(_dexnum:Int):PokemonData
	{
		var rom = RomRipper.romdata;
		var offset = POKEMONDATA + (_dexnum * 32);
		
		return cast 
		{
			dexnum : rom[offset],
			hp : rom[offset + 1],
			atk : rom[offset + 2],
			def : rom[offset + 3],
			spd : rom[offset + 4],
			sat : rom[offset + 5],
			sdf : rom[offset + 6],
			typeA : rom[offset + 7],
			typeB : rom[offset + 8],
			catchrate : rom[offset + 9],
			basexp : rom[offset + 10],
			itemA : rom[offset + 11],
			itemB : rom[offset + 12],
			gender : rom[offset + 13],
			unknown1 : rom[offset + 14],
			steps : rom[offset + 15],
			unknow2 : rom[offset + 16],
			spritesize : rom[offset + 17],
		}
	}
}