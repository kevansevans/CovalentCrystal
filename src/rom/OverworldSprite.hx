package rom;

import doom.Export;
import gameboy.GBSprite;
import haxe.io.Bytes;
import haxe.io.BytesOutput;
import pokemon.BaseOverworldData;
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
	
	public static function buildZScript()
	{
		//new BaseOverworldData();
		
		var include:String = File.read('./wad/ZSCRIPT.txt').readAll().toString();
		include += '#include "ZSCRIPT/ACTORS/NPC/PK_BaseNPC.zsc"\n';
		
		for (i in 0...Overworld.NUMOVERWORLDACTORS)
		{
			var actor = new OverworldActor(i);
			
			var zfile = actor.toZFile(i);
			var out = File.write('./wad/ZSCRIPT/actors/NPC/PK_${actor.info.name}.zsc');
			out.write(Bytes.ofString(zfile));
			include += '#include "ZSCRIPT/actors/NPC/PK_${actor.info.name}.zsc"\n';
			out.close();
		}
		
		var out = File.write('./wad/ZSCRIPT.txt');
		out.write(Bytes.ofString(include));
		out.close();
	}
}

class OverworldActor
{
	static var offsettracker:Int = 0;
	
	public var info:OverworldInfo;
	
	public function new(_index:Int)
	{
		info = BaseOverworldData.info[_index];
	}
	
	public function toZFile(_index:Int):String
	{
		if (info == null)
		{
			info = cast
			{
				name : 'Undefined_${_index}',
				facemode : 0,
				numsprites : 0
			}
			
			return "//Undefined actor";
		}
		
		var lumps = FileSystem.readDirectory('./wad/SPRITES/overworld');
		
		var output:String = '';
		output += 'Class PK_${info.name} : PK_BaseNPC\n';
		output += '{\n';
		output += '\tDefault\n';
		output += '\t{\n';
		output += '\t\tPK_BaseActor.FaceMode ${info.facemode};\n';
		if (info.facemode == 0)
		{
			output += '\t\tPK_BaseActor.FaceSouth "${lumps[OverworldActor.offsettracker].substr(0, 4)}";\n';
		}
		else
		{
			output += '\t\tPK_BaseActor.FaceSouth "${lumps[OverworldActor.offsettracker].substr(0, 4)}";\n';
			output += '\t\tPK_BaseActor.FaceNorth "${lumps[OverworldActor.offsettracker + 1].substr(0, 4)}";\n';
			output += '\t\tPK_BaseActor.FaceEastWest "${lumps[OverworldActor.offsettracker + 2].substr(0, 4)}";\n';
		}
		output += '\t}\n';
		output += '\t\n';
		output += '\tStates\n';
		output += '\t{\n';
		if (info.facemode == 0)
		{
			output += '\t\tSpawn:\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker].substr(0, 4)} A 0;\n';
			output += '\t\tIdle:\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker].substr(0, 4)} A -1;\n';
			output += '\t\t\tStop;\n';
		}
		else
		{
			output += '\t\tSpawn:\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker].substr(0, 4)} A 0;\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker + 1].substr(0, 4)} A 0;\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker + 2].substr(0, 4)} A 0;\n';
			output += '\t\tIdle:\n';
			output += '\t\t\t${lumps[OverworldActor.offsettracker].substr(0, 4)} A -1;\n';
			output += '\t\t\tStop;\n';
		}
		output += '\t}\n';
		output += '}\n';
		
		OverworldActor.offsettracker += info.numsprites;
		
		return output;
	}
}