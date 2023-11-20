package rom;

import doom.Export;
import pokemon.BasePokemonData;

/**
 * ...
 * @author Kaelan
 */
class PokemonSprite 
{
	public static inline var POKEMONPOINTER:Int = 0x120000;
	public static inline var UNOWNPOINTER:Int = 0x124000;
	public static inline var POKEMONDATA:Int = 0x51424;
	
	public function new() 
	{
		var rom = RomRipper.romdata;
		
		Sys.println('Ripping pokemon sprites');
		for (pk in 0...251)
		{
			if (pk == 200) continue; //unowns have their own tables
			
			var frontbank = rom[POKEMONPOINTER + (pk * 6)] + 0x35;
			var frontoffset = (rom[POKEMONPOINTER + (pk * 6) + 2] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 1];
			var frontpos = (frontbank * 0x4000) + frontoffset;
			
			var backbank = rom[POKEMONPOINTER + (pk * 6) + 3] + 0x35;
			var backoffset = (rom[POKEMONPOINTER + (pk  * 6) + 5] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 4];
			var backpos = (backbank * 0x4000) + backoffset;
			
			var pokedata = getPokemonData(pk);
			
			var spname:String = "P" + StringTools.hex(pk, 4);
			
			var frontpic = PictureSprites.ripSprite(frontpos, pokedata.spritesize >> 4, pokedata.spritesize >> 4);
			var backpic = PictureSprites.ripSprite(backpos, 6, 6);
			
			Export.writePicture(frontpic, './wad/SPRITES/pokemon/${spname}A0.lmp');
			Export.writePicture(backpic, './wad/SPRITES/pokemon/${spname}B0.lmp');
		}
		
		Sys.println('Ripping unown sprites');
		for (un in 0...26)
		{
			var frontbank = rom[UNOWNPOINTER + (un * 6)] + 0x35;
			var frontoffset = (rom[UNOWNPOINTER + (un * 6) + 2] * 0x100) + rom[UNOWNPOINTER + (un * 6) + 1];
			var frontpos = (frontbank * 0x4000) + frontoffset;
			
			var backbank = rom[UNOWNPOINTER + (un * 6) + 3] + 0x35;
			var backoffset = (rom[UNOWNPOINTER + (un  * 6) + 5] * 0x100) + rom[UNOWNPOINTER + (un * 6) + 4];
			var backpos = (backbank * 0x4000) + backoffset;
			
			var pokedata = getPokemonData(200);
			
			var spname:String = "U" + StringTools.hex(un, 4);
			
			var frontpic = PictureSprites.ripSprite(frontpos, pokedata.spritesize >> 4, pokedata.spritesize >> 4);
			var backpic = PictureSprites.ripSprite(backpos, 6, 6);
			
			Export.writePicture(frontpic, './wad/SPRITES/pokemon/${spname}A0.lmp');
			Export.writePicture(backpic, './wad/SPRITES/pokemon/${spname}B0.lmp');
		}
	}
	
	public function getPokemonData(_dexnum:Int):BasePokemonData
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