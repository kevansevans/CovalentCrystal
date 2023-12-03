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
	public static inline var TILEOFFSET = 0x18001;
	
	public function new() 
	{
		Sys.println('Ripping tile sprites...');
		
		var pic = ripSprite(TILEOFFSET, 16, 6);
		Export.writePicture(pic, './wad/TEXTURES/text.lmp');
	}
	
	function ripSprite(_offset:Int, _width:Int, _height:Int):Picture
	{
		var result = GBSprite.decompress(_offset);
		return Export.spritesToPicture(result, _width, _height);
	}
}