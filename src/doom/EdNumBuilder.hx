package doom;

import sys.io.File;
import haxe.io.Bytes;
import crystal.BasePokemonData;

/**
 * ...
 * @author Kaelan
 */
class EdNumBuilder 
{

	public function new() 
	{
		var output = "DoomEdNums\n{\n";
		var index = 10000;
		
		for (pk in BasePokemonData.info)
		{
			if (pk.name == "AASHITTY") continue;
			if (pk.name != "Unown")
			{
				output += '\t${index} = PK_${pk.name}\n';
			}
			++index;
		}
		
		output += '}';
		
		var out = File.write('./wad/MAPINFO.PokeEdNums');
		out.write(Bytes.ofString(output));
		out.close();
	}
	
}