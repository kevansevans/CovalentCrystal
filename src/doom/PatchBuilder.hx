package doom;

import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class PatchBuilder 
{

	public var output:String = '';
	
	public function new() 
	{
		buildSpritePatches();
	}
	
	function buildSpritePatches()
	{
		var pk_sprites = FileSystem.readDirectory('./wad/SPRITES/pokemon');
		
		for (item in pk_sprites)
		{
			if (FileSystem.isDirectory('./wad/PATCHES/pokemon/${item}')) continue;
			
			var filename = item.substr(0, 6);
			if (FileSystem.exists('./wad/PATCHES/pokemon/${filename}_p.lmp')) makepatch(filename, getSize(File.getBytes('./wad/SPRITES/pokemon/${item}')));
		}
		
		var out = File.write('./wad/TEXTURES.txt');
		out.write(Bytes.ofString(output));
		out.close();
	}
	
	function makepatch(filename:String, _size:ImageWH) 
	{
		output += 'sprite ${filename}, ${_size.width}, ${_size.height}\n';
		output += '{\n';
		output += '\tOffset ${Std.int(_size.width / 2)}, ${_size.height}\n';
		output += '\tPatch ${filename}, 0, 0\n';
		output += '\tPatch ${filename}_P, 0, 0\n';
		output += '}\n';
	}
	
	public static function getSize(_file:Bytes):ImageWH
	{
		return cast {
			width : _file.getUInt16(0),
			height : _file.getUInt16(2),
		}
	}
}

typedef ImageWH =
{
	var width:Int;
	var height:Int;
}