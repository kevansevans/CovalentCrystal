package doom;

import sys.io.File;
import haxe.io.Bytes;
import crystal.BasePokemonData;
import crystal.BaseOverworldData;

/**
 * ...
 * @author Kaelan
 */
class EdNumBuilder 
{

	public function new() 
	{
		var output = "DoomEdNums\n{\n";
		
		var pkindex = 10000;
		var ovindex = 20000;
		
		for (pk in BasePokemonData.info)
		{
			if (pk.name == "AASHITTY") continue;
			if (pk.name != "Unown")
			{
				output += '\t${pkindex} = PK_${pk.name}\n';
			}
			++pkindex;
		}
		
		for (ov in BaseOverworldData.info)
		{
			output += '\t${ovindex} = PK_${ov.name}NPC\n';
			++ovindex;
		}
		
		output += '}';
		
		var out = File.write('./wad/MAPINFO.EdNums');
		out.write(Bytes.ofString(output));
		out.close();
	}
	
}