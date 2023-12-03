package rom;

import doom.Export;
import crystal.BasePokemonData;
import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;
import enums.DexNumber;
import enums.PokemonType;
import doom.Picture;
import gameboy.GBSprite;

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
			
			if (Main.VERBOSE) Sys.println('Extracting # ${StringTools.lpad("" + (pk + 1), "0", 3)}/251 front and back sprites...');
			
			var frontbank = rom[POKEMONPOINTER + (pk * 6)] + 0x35;
			var frontoffset = (rom[POKEMONPOINTER + (pk * 6) + 2] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 1];
			var frontpos = (frontbank * 0x4000) + frontoffset;
			
			var backbank = rom[POKEMONPOINTER + (pk * 6) + 3] + 0x35;
			var backoffset = (rom[POKEMONPOINTER + (pk  * 6) + 5] * 0x100) + rom[POKEMONPOINTER + (pk * 6) + 4];
			var backpos = (backbank * 0x4000) + backoffset;
			
			var pokedata = RomRipper.getPokemonData(pk);
			
			var spname:String = "P" + StringTools.hex(pk, 3);
			
			var frontpic = ripSprite(frontpos, pokedata.spritesize >> 4, pokedata.spritesize >> 4);
			var backpic = ripSprite(backpos, 6, 6);
			
			if (Main.VERBOSE) Sys.println('Writing front #${StringTools.lpad("" + (pk + 1), "0", 3)}/251 as ./wad/SPRITES/pokemon/${spname}A0.lmp...');
			Export.writePicture(frontpic, './wad/SPRITES/pokemon/${spname}A0.lmp');
			if (Main.VERBOSE) Sys.println('Writing back #${StringTools.lpad("" + (pk + 1), "0", 3)}/251 as ./wad/SPRITES/pokemon/${spname}B0.lmp...');
			Export.writePicture(backpic, './wad/SPRITES/pokemon/${spname}B0.lmp');
		}
		
		Sys.println('Ripping unown sprites');
		var alphabet:Array<String> = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
		for (un in 0...26)
		{
			if (Main.VERBOSE) Sys.println('Extracting #${StringTools.lpad("" + (un + 1), "0", 2)}/26 front and back sprites...');
			
			var frontbank = rom[UNOWNPOINTER + (un * 6)] + 0x35;
			var frontoffset = (rom[UNOWNPOINTER + (un * 6) + 2] * 0x100) + rom[UNOWNPOINTER + (un * 6) + 1];
			var frontpos = (frontbank * 0x4000) + frontoffset;
			
			var backbank = rom[UNOWNPOINTER + (un * 6) + 3] + 0x35;
			var backoffset = (rom[UNOWNPOINTER + (un  * 6) + 5] * 0x100) + rom[UNOWNPOINTER + (un * 6) + 4];
			var backpos = (backbank * 0x4000) + backoffset;
			
			var pokedata = RomRipper.getPokemonData(200);
			
			var spnameA:String = "UNOA" + alphabet[un];
			var spnameB:String = "UNOB" + alphabet[un];
			
			var frontpic = ripSprite(frontpos, pokedata.spritesize >> 4, pokedata.spritesize >> 4);
			var backpic = ripSprite(backpos, 6, 6);
			
			if (Main.VERBOSE) Sys.println('Writing front #${StringTools.lpad("" + (un + 1), "0", 2)}/26 as ./wad/SPRITES/pokemon/${spnameA}0.lmp...');
			Export.writePicture(frontpic, './wad/SPRITES/pokemon/${spnameA}0.lmp');
			if (Main.VERBOSE) Sys.println('Writing back #${StringTools.lpad("" + (un + 1), "0", 2)}/26 as ./wad/SPRITES/pokemon/${spnameB}0.lmp...');
			Export.writePicture(backpic, './wad/SPRITES/pokemon/${spnameB}0.lmp');
		}
	}
	
	function ripSprite(_offset:Int, _width:Int, _height:Int):Picture
	{
		var result = GBSprite.decompress(_offset);
		return Export.spritesToPicture(result, _width, _height);
	}
}