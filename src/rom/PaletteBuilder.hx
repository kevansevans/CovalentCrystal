package rom;

import sys.io.File;
import haxe.io.Bytes;
import crystal.BasePokemonData;
import enums.DexNumber;

/**
 * ...
 * @author Kaelan
 */
class PaletteBuilder 
{
	public static inline var POKEMONCOLORS:Int = 0xA8D6;
	
	var translations:String = '';

	public function new() 
	{
		Sys.println("Ripping Pokemon Palettes");
		getPokemonColors();
		
	}
	
	function getPokemonColors() 
	{
		for (pk in 0...251)
		{
			var baseinfo:PokemonInfo = BasePokemonData.info[pk + 1];
			var palette:PokePalette = getPokemonPalette(pk);
			
			if (baseinfo != null) {
				translations += '${baseinfo.name}Normal = "1:1=[${rgbConversion(palette.normal.indexB.R)}, ${rgbConversion(palette.normal.indexB.G)}, ${rgbConversion(palette.normal.indexB.B)}]:[${rgbConversion(palette.normal.indexB.R)}, ${rgbConversion(palette.normal.indexB.G)}, ${rgbConversion(palette.normal.indexB.B)}]", ';
				translations += '"2:2=[${rgbConversion(palette.normal.indexC.R)}, ${rgbConversion(palette.normal.indexC.G)}, ${rgbConversion(palette.normal.indexC.B)}]:[${rgbConversion(palette.normal.indexC.R)}, ${rgbConversion(palette.normal.indexC.G)}, ${rgbConversion(palette.normal.indexC.B)}]", ';
				translations += '"3:3=[0, 0, 0]:[0, 0, 0]", ';
				translations += '"4:4=[255, 255, 255]:[255, 255, 255]"\n';
			}
		}
		
		var out = File.write('./wad/TRNSLATE.txt');
		out.write(Bytes.ofString(translations));
		out.close();
	}
	
	static inline function rgbConversion(_input:Int):Int
	{
		return Std.int(_input * 8 + (Math.floor(_input / 4)));
	}
	
	public static function getPokemonPalette(_dex:Int):PokePalette
	{
		var rom = RomRipper.romdata;
		

		var bytes = rom.slice(POKEMONCOLORS + (8 *_dex), POKEMONCOLORS + (8 *_dex) + 8);
		
		var colorA = bytes[0] + (bytes[1] << 8); 
		var colorB = bytes[2] + (bytes[3] << 8); 
		var colorC = bytes[4] + (bytes[5] << 8); 
		var colorD = bytes[6] + (bytes[7] << 8); 
		
		var palette:PokePalette =
		{
			//fucking BGR format, who the fuck...?
			normal :
				{
					indexA :
						{
							R : 255,
							G : 255,
							B : 255,
						},
					indexB :
						{
							B : (colorA >> 10) & 0x1F,
							G : (colorA >> 5) & 0x1F,
							R : colorA & 0x1F
						},
					indexC :
						{
							B : (colorB >> 10) & 0x1F,
							G : (colorB >> 5) & 0x1F,
							R : colorB & 0x1F
						},
					indexD :
						{
							R : 0,
							G : 0,
							B : 0,
						}
				},
			shiny :
				{
					indexA :
						{
							R : 255,
							G : 255,
							B : 255,
						},
					indexB :
						{
							B : (colorC >> 10) & 0x1F,
							G : (colorC >> 5) & 0x1F,
							R : colorC & 0x1F
						},
					indexC :
						{
							B : (colorD >> 10) & 0x1F,
							G : (colorD >> 5) & 0x1F,
							R : colorD & 0x1F
						},
					indexD :
						{
							R : 0,
							G : 0,
							B : 0,
						}
				}
		}
		
		return palette;
	}
	
}

typedef PokePalette =
{
	var normal:Palette;
	var shiny:Palette;
}
typedef Palette =
{
	var indexA:ColorRGB;
	var indexB:ColorRGB;
	var indexC:ColorRGB;
	var indexD:ColorRGB;
}
typedef ColorRGB =
{
	var R:Int;
	var G:Int;
	var B:Int;
}