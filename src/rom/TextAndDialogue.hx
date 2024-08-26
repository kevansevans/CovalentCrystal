package rom;

import haxe.io.Bytes;

/**
 * ...
 * @author Kaelan
 */
class TextAndDialogue 
{

	public function new() 
	{
		Sys.println("Ripping text and dialogue");
		ripTextAndDialogue();
	}
	
	function ripTextAndDialogue() 
	{
		
	}
	
	//will need to adapt this to better suit GZDoom
	static function getCharEncode(_value:Int):Null<UnicodeString>
	{
		var high:Int = (_value >> 4) & 0xF;
		var low:Int = _value & 0xF;
		
		var chars:Array<Null<UnicodeString>> = [];
		
		switch (high)
		{
			case 0:
				chars = ['?', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P'];
			case 1:
				chars = ['Q', 'R', 'S', 'T', ' ', ' ', ' ', 'X', 'Y', 'Z', '(', ')', ':', ';', '[', ' '];
			case 2:
				chars = ['q', 'r', ' ', ' ', ' ', ' ', 'w', 'x', 'y', 'z', ' ', ' ', ' ', ' ', ' ', ' '];
			case 3:
				//chars = ['Ä', 'Ö', 'Ü', 'ä', 'ö', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
			case 4:
				chars = ['Z', '(', ')', ':', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', '\'r', ' ', ' '];
			case 5:
				//These are control values. This case should never happen, but just in case:
				chars = [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
			case 6:
				//need special returns for this that are gzdoom compliant
				//chars = ['█', '▲', '🖁', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '];
		}
		
		return chars[low];
	}
}