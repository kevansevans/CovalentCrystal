package rom;

import doom.Export;
import gameboy.GBSprite;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import crystal.BaseOverworldData;
import enums.Overworld;
import doom.Post;
import doom.Picture;
import sys.io.File;
import sys.FileSystem;

/**
 * ...
 * @author Kaelan
 */
class OverworldSprite 
{

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
		
		Export.writePicture(picture, './wad/SPRITES/overworld/O${StringTools.hex(_sprite, 3)}A0.lmp');
	}
}