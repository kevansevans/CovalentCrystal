package rom;

import doom.Export;
import gameboy.GBSprite;
import doom.Picture;
import rom.RomRipper;
/**
 * ...
 * @author Kaelan
 */
class TrainerSprites 
{
	
	public static inline var TRAINEROFFSETS:Int = 0x128000;
	
	public function new() 
	{
		var rom = RomRipper.romdata;
		
		for (tr in 0...34)
		{
			trace(tr);
			var picbank = rom[TRAINEROFFSETS + (tr * 6)] + 0x35;
			var picoffset = (rom[TRAINEROFFSETS + (tr * 6) + 2] * 0x100) + rom[TRAINEROFFSETS + (tr * 6) + 1];
			var picpos = (picbank * 0x4000) + picoffset;
			trace(StringTools.hex(TRAINEROFFSETS + (tr * 6)));
			trace(StringTools.hex(picpos));
			var trainer = ripSprite(picpos, 7, 7);
			var name:String = StringTools.hex(tr, 3);
			trace(name);
			Export.writePicture(trainer, './wad/SPRITES/trainer/T${name}A0.lmp');
		}
	}
	
	function ripSprite(_offset:Int, _width:Int, _height:Int):Picture
	{
		var result = GBSprite.decompress(_offset);
		return Export.spritesToPicture(result, _width, _height);
	}
}