package doom;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Bytes;
import rom.RomRipper;
import crystal.BaseOverworldData;
import crystal.BasePokemonData;
import enums.Overworld;
import enums.PokemonType;
import enums.DexNumber;

/**
 * ...
 * @author Kaelan
 */
class ZScriptBuilder 
{

	public function new() 
	{
		Sys.println('Building base overworld ZScript actors');
		buildOverworldActors();
		Sys.println('Building base pokemon ZScript actors');
		buildPokemonActors();
	}
	
	function buildOverworldActors() 
	{
		var include:String = File.read('./wad/ZSCRIPT.txt').readAll().toString();
		include += '#include "ZSCRIPT/ACTORS/NPC/PK_BaseNPC.zsc"\n';
		
		for (i in 0...Overworld.NUMOVERWORLDACTORS)
		{
			var actor = new OverworldActor(i);
			
			var zfile = actor.toZFile(i);
			var out = File.write('./wad/ZSCRIPT/actors/NPC/PK_OV${actor.info.name}.zsc');
			out.write(Bytes.ofString(zfile));
			include += '#include "ZSCRIPT/actors/NPC/PK_OV${actor.info.name}.zsc"\n';
			out.close();
		}
		
		var out = File.write('./wad/ZSCRIPT.txt');
		out.write(Bytes.ofString(include));
		out.close();
	}
	
	function buildPokemonActors() 
	{
		var include:String = File.read('./wad/ZSCRIPT.txt').readAll().toString();
		
		for (pk in 0...251)
		{
			if (pk == DexNumber.Unown) continue;
			
			var pokedata = RomRipper.getPokemonData(pk);
			var actor = new PokemonActor(pokedata);
			
			var out = File.write('./wad/ZSCRIPT/actors/Pokemon/PK_${StringTools.lpad('' + (pk + 1), "0", 3)}${actor.name}.zsc');
			out.write(Bytes.ofString(actor.toZFile()));
			out.close();
			
			include += '#include "ZSCRIPT/actors/Pokemon/PK_${StringTools.lpad('' + (pk + 1), "0", 3)}${actor.name}.zsc"\n';
		}
		
		var out = File.write('./wad/ZSCRIPT.txt');
		out.write(Bytes.ofString(include));
		out.close();
	}
	
}

class PokemonActor
{
	public var data:PokemonData;
	public var name:String = "MissingNo.";
	public function new(_data:PokemonData)
	{
		name = BasePokemonData.info[_data.dexnum] == null ? "MissingNo" + _data.dexnum : BasePokemonData.info[_data.dexnum].name;
		data = _data;
	}
	
	public function toZFile():String
	{
		var lumps = FileSystem.readDirectory('./wad/SPRITES/pokemon');
		var offset = ((data.dexnum - 1) * 2) + 1 - (data.dexnum > 200 ? 1 : 0);
		
		var output = 'Class PK_${name} : PK_BasePokemon\n';
		output += '{\n';
		output += '\tDefault\n';
		output += '\t{\n';
		output += '\t\tSpeed 1;\n';
		output += '\t\tPK_BasePokemon.normalColors "${name}Normal";\n';
		output += '\t\tPK_BasePokemon.shinyColors "${name}Shiny";\n';
		output += '\t\tPK_BasePokemon.attack ${data.atk};\n';
		output += '\t\tPK_BasePokemon.defense ${data.def};\n';
		output += '\t\tPK_BasePokemon.speed ${data.spd};\n';
		output += '\t\tPK_BasePokemon.specAttack ${data.sat};\n';
		output += '\t\tPK_BasePokemon.specDefense ${data.sdf};\n';
		output += '\t\tPK_BasePokemon.typeA ${getType(data.typeA)};\n';
		output += '\t\tPK_BasePokemon.typeB ${getType(data.typeB)};\n';
		output += '\t\t\n';
		output += '\t}\n';
		output += '\t\n';
		output += '\tStates\n';
		output += '\t{\n';
		output += '\t\tSpawn:\n';
		output += '\t\tFront:\n';
		output += '\t\t\t${lumps[offset].substr(0, 4)} A -1;\n';
		output += '\t\t\tStop;\n';
		output += '\t\tBack:\n';
		output += '\t\t\t${lumps[offset + 1].substr(0, 4)} A -1;\n';
		output += '\t\t\tStop;\n';
		output += '\t}\n';
		output += '}\n';
		
		
		return output;
	}
	
	public function getType(_type:Int):String
	{
		switch(_type)
		{
			default:
				return PokemonType.NoType;
			case 0x00:
				return PokemonType.Normal;
			case 0x01:
				return PokemonType.Fighting;
			case 0x02:
				return PokemonType.Flying;
			case 0x03:
				return PokemonType.Poison;
			case 0x04:
				return PokemonType.Ground;
			case 0x05:
				return PokemonType.Rock;
			case 0x07:
				return PokemonType.Bug;
			case 0x08:
				return PokemonType.Ghost;
			case 0x09:
				return PokemonType.Steel;
			case 0x16:
				return PokemonType.Grass;
			case 0x14:
				return PokemonType.Fire;
			case 0x15:
				return PokemonType.Water;
			case 0x17:
				return PokemonType.Electric;
			case 0x18:
				return PokemonType.Psychic_Type;
			case 0x19:
				return PokemonType.Ice;
			case 0x1A:
				return PokemonType.Dragon_Type;
			case 0x1B:
				return PokemonType.Dark;
		}
		
		return PokemonType.NoType;
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
		output += 'Class PK_OV${info.name} : PK_BaseNPC\n';
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