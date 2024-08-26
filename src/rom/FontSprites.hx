package rom;
import doom.Picture;
import doom.Post;
import gameboy.GBSprite;
import doom.Export;
import sys.FileSystem;


/**
 * ...
 * @author Kaelan
 */
class FontSprites 
{
	//The font used, to no surprise, is stored as sprites.
	//Thankfully these are just 8x8 assets, so should be simply to extract
	
	static inline var FONTOFFSET:Int = 0xAA5AD;
	
	public function new() 
	{
		Sys.println('Ripping font sprites...');
		FileSystem.createDirectory('./wad/FONTS/PKFONT');
		ripFontSprites();
	}
	
	function ripFontSprites() 
	{
		var offset = FONTOFFSET;
		var sprites = GBSprite.spritesFromData(RomRipper.romdata.slice(offset, offset + 64));
		var posts:Array<Post> = [];
		
		for (c in 0...16)
		{
			var set:Array<Int> = [];
			
			if (c < 8)
			{
				set = set.concat(sprites[0].getVerticalStrip(c));
				set = set.concat(sprites[2].getVerticalStrip(c));
			}
			else
			{
				set = set.concat(sprites[1].getVerticalStrip(c - 8));
				set = set.concat(sprites[3].getVerticalStrip(c - 8));
			}
			
			posts = posts.concat(Export.pixelsToPosts(set, c));
		}
		
		var picture:Picture =
		{
			width : 16,
			height : 16,
			xoffset : 8,
			yoffset : 16,
			posts : posts.copy()
		}
		
		Export.writePicture(picture, './wad/FONTS/PKFONT/test.lmp');
	}
	
}