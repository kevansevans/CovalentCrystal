package rom;

import doom.Export;
import doom.Picture;
import gameboy.GBSprite;

/**
 * ...
 * @author Kaelan
 */
class TilesetSprites 
{
	public static inline var TILEOFFSET = 0x18000;
	
	public function new() 
	{
		Sys.println('Ripping tile sprites...');
		
		var picA = ripSprite(TILEOFFSET, 16, 6, true);
		var picB = ripSprite(TILEOFFSET, 16, 6, false);
		
		Export.writePicture(picA, './wad/TEXTURES/testtilesetA.lmp');
		Export.writePicture(picB, './wad/TEXTURES/testtilesetB.lmp');
	}
	
	function ripSprite(_offset:Int, _width:Int, _height:Int, _alpha:Bool):Picture
	{
		var result = GBSprite.decompress(_offset);
		return Export.spritesToPicture(result, _width, _height, _alpha);
	}
}