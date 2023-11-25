package rom;

import doom.Export;
import crystal.BasePokemonData;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;
import enums.DexNumber;
import enums.PokemonType;

/**
 * ...
 * @author Kaelan
 */
class PokemonSprite 
{
	public static inline var POKEMONPOINTER:Int = 0x120000;
	public static inline var UNOWNPOINTER:Int = 0x124000;
	
	public function new() 
	{
		var rom = RomRipper.romdata;
		
		Sys.println('Ripping pokemon sprites');
		for (pk in 0...251)
		{
			if (pk == 200) continue;
			
			var frontbank = rom[POKEMONPOINTER + (pk * 6)] + 0x35;
			var frontoffset = (rom[POKEMONPOINTER + (pk * 6) + 2] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 1];
			var frontpos = (frontbank * 0x4000) + frontoffset;
			
			var backbank = rom[POKEMONPOINTER + (pk * 6) + 3] + 0x35;
			var backoffset = (rom[POKEMONPOINTER + (pk  * 6) + 5] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 4];
			var backpos = (backbank * 0x4000) + backoffset;
			
			var pokedata = RomRipper.getPokemonData(pk);
			
			var spname:String = "P" + StringTools.hex(pk, 3);
			
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
			
			var pokedata = RomRipper.getPokemonData(200);
			
			var spname:String = "U" + StringTools.hex(un, 3);
			
			var frontpic = PictureSprites.ripSprite(frontpos, pokedata.spritesize >> 4, pokedata.spritesize >> 4);
			var backpic = PictureSprites.ripSprite(backpos, 6, 6);
			
			Export.writePicture(frontpic, './wad/SPRITES/pokemon/${spname}A0.lmp');
			Export.writePicture(backpic, './wad/SPRITES/pokemon/${spname}B0.lmp');
		}
	}
}