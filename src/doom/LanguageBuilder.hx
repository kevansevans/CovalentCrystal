package doom;

import haxe.DynamicAccess;
import haxe.Json;
import haxe.io.Bytes;

import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Kaelan
 */
class LanguageBuilder 
{
	static var debug_defaults:Array<DialogueDef> =
	[
		{
			name : "DEBUG_NPC_GENERIC",
			lines :
				[
					"I dont have any dialog",
					"Please fix!",
					"This isnt very goober of you kev!"
				]
		},
		{
			name : "DEBUG_NPC_TRAINER",
			lines :
				[
					"We locked eyes!",
					"That means we have to fight!",
					"No I dont have anything important to say..."
				]
		},
		{
			name : "DEBUG_NPC_PKMN",
			lines :
				[
					"Woof! Im a cat!"
				]
		}
	];
	

	public function new() 
	{
		buildLanguageLumps();
	}
	
	function buildLanguageLumps() 
	{
		buildDebugLanguage();
	}
	
	function buildDebugLanguage() 
	{
		
		var object:DynamicAccess<Dynamic> = {};
		var output = '[enu default]\n';
		
		for (i in 0...debug_defaults.length)
		{
			output += parse(debug_defaults[i]);
			if (i != debug_defaults.length - 1) output += "\n";
		}
		
		var file = File.write('./wad/LANGUAGE.debug');
		file.writeString(output);
		file.close();
	}
	
	//example format: DEBUG_TEST = "{\"length\":\"4\",\"line_0\":\"Message one\",\"line_1\":\"Message two\",\"line_2\":\"Message three\",\"line_3\":\"Message four\"}";
	
	function parse(_dialog:DialogueDef):String
	{
		var value:String = '';
		value += _dialog.name + ' = "{\\"length\\" : \\"${_dialog.lines.length}\\", ';
		
		for (i in 0..._dialog.lines.length)
		{
			value += '\\"line_${i}\\" : \\"${_dialog.lines[i]}\\"';
			if (i != _dialog.lines.length - 1) value += ', ';
		}
		
		value += '}";';
		return value;
	}
	
}

typedef DialogueDef =
{
	var name:String;
	var lines:Array<String>;
}