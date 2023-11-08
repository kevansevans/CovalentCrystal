package rom;

/**
 * ...
 * @author Kaelan
 */
class BattleSprites 
{
	
	static inline var ROMOFFSET:Int = 0x120000;
	
	public static function dumpBattleSprites(_offset:Int)
	{
		var frontbank = RomRipper.rom.get(ROMOFFSET + (_offset * 3));
		var backbank = RomRipper.rom.get(ROMOFFSET + ((_offset + 3) * 3));
		var frontoffset = RomRipper.rom.getUInt16(ROMOFFSET + (_offset * 3) + 1);
		var backoffset = RomRipper.rom.getUInt16(ROMOFFSET + ((_offset + 3) * 3) + 1);
		
		trace(_offset, frontbank, frontoffset, backbank, backoffset);
	}
	
}