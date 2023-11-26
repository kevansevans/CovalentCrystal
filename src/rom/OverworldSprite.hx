package rom;

import doom.Export;
import gameboy.GBSprite;
import doom.Post;
import doom.Picture;

/**
 * ...
 * @author Kaelan
 */
class OverworldSprite 
{
	public static inline var bankoffset:Int = 0x4000;
	
	public function new()
	{
		Sys.println('Ripping overworld sprites...');
		for (i in 0...512)
		{
			if (Main.VERBOSE) Sys.println('Extracting overworld sprite ${i + 1}/512...');
			dumpOverworldSprites(0x30 * bankoffset, i);
		}
	}

	public static function dumpOverworldSprites(_offset:Int, _sprite:Int = 0)
	{
		var offset = _offset + (_sprite * 16 * 4);
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
		
		if (Main.VERBOSE) Sys.println('Writing overworld sprite as O${StringTools.hex(_sprite, 3)}A0.lmp...');
		Export.writePicture(picture, './wad/SPRITES/overworld/O${StringTools.hex(_sprite, 3)}A0.lmp');
	}
}