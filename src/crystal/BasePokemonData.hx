package crystal;

/**
 * @author Kaelan
 */
class BasePokemonData
{
	public static var info:Array<PokemonInfo> =
	[
		{name : "AASHITTY"},
		{name : "Bulbasaur"},
		{name : "Ivysaur"},
		{name : "Venusaur"},
		{name : "Charmander"},
		{name : "Charmeleon"},
		{name : "Charizard"},
		{name : "Squirtle"},
		{name : "Wartortle"},
		{name : "Blastoise"},
		{name : "Caterpie"},
		{name : "Metapod"},
		{name : "Butterfree"},
		{name : "Weedle"},
		{name : "Kakuna"},
		{name : "Beedrill"},
		{name : "Pidgey"},
		{name : "Pidgeotto"},
		{name : "Pidgeot"},
		{name : "Rattata"},
		{name : "Raticate"},
		{name : "Spearow"},
		{name : "Fearow"},
		{name : "Ekans"},
		{name : "Arbok"},
		{name : "Pikachu"},
		{name : "Raichu"},
		{name : "Sandshrew"},
		{name : "Sandslash"},
		{name : "NidoranF"},
		{name : "Nidorina"},
		{name : "Nidoqueen"},
		{name : "NidoranM"},
		{name : "Nidorino"},
		{name : "Nidoking"},
		{name : "Clefairy"},
		{name : "Clefable"},
		{name : "Vulpix"},
		{name : "Ninetales"},
		{name : "Jigglypuff"},
		{name : "Wigglytuff"},
		{name : "Zubat"},
		{name : "Golbat"},
		{name : "Oddish"},
		{name : "Gloom"},
		{name : "Vileplume"},
		{name : "Paras"},
		{name : "Parasect"},
		{name : "Venonat"},
		{name : "Venomoth"},
		{name : "Diglett"},
		{name : "Dugtrio"},
		{name : "Meowth"},
		{name : "Persian"},
		{name : "Psyduck"},
		{name : "Golduck"},
		{name : "Mankey"},
		{name : "Primeape"},
		{name : "Growlithe"},
		{name : "Arcanine"},
		{name : "Poliwag"},
		{name : "Poliwhirl"},
		{name : "Poliwrath"},
		{name : "Abra"},
		{name : "Kadabra"},
		{name : "Alakazam"},
		{name : "Machop"},
		{name : "Machoke"},
		{name : "Machamp"},
		{name : "Bellsprout"},
		{name : "Weepinbell"},
		{name : "Victreebel"},
		{name : "Tentacool"},
		{name : "Tentacruel"},
		{name : "Geodude"},
		{name : "Graveler"},
		{name : "Golem"},
		{name : "Ponyta"},
		{name : "Rapidash"},
		{name : "Slowpoke"},
		{name : "Slowbro"},
		{name : "Magnemite"},
		{name : "Magneton"},
		{name : "Farfetchd"},
		{name : "Doduo"},
		{name : "Dodrio"},
		{name : "Seel"},
		{name : "Dewgong"},
		{name : "Grimer"},
		{name : "Muk"},
		{name : "Shellder"},
		{name : "Cloyster"},
		{name : "Gastly"},
		{name : "Haunter"},
		{name : "Gengar"},
		{name : "Onix"},
		{name : "Drowzee"},
		{name : "Hypno"},
		{name : "Krabby"},
		{name : "Kingler"},
		{name : "Voltorb"},
		{name : "Electrode"},
		{name : "Exeggcute"},
		{name : "Exeggutor"},
		{name : "Cubone"},
		{name : "Marowak"},
		{name : "Hitmonlee"},
		{name : "Hitmonchan"},
		{name : "Lickitung"},
		{name : "Koffing"},
		{name : "Weezing"},
		{name : "Rhyhorn"},
		{name : "Rhydon"},
		{name : "Chansey"},
		{name : "Tanmgela"},
		{name : "Kangaskhan"},
		{name : "Horsea"},
		{name : "Seadra"},
		{name : "Goldeen"},
		{name : "Seaking"},
		{name : "Staryu"},
		{name : "Starmie"},
		{name : "MrMime"},
		{name : "Scyther"},
		{name : "Jynx"},
		{name : "Electabuzz"},
		{name : "Magmar"},
		{name : "Pinsir"},
		{name : "Tauros"},
		{name : "Magikarp"},
		{name : "Gyrados"},
		{name : "Lapras"},
		{name : "Ditto"},
		{name : "Eevee"},
		{name : "Vaporeon"},
		{name : "Jolteon"},
		{name : "Flareon"},
		{name : "Porygon"},
		{name : "Omanyte"},
		{name : "Omastar"},
		{name : "Kabuto"},
		{name : "Kabutops"},
		{name : "Aerodactyl"},
		{name : "Snorlax"},
		{name : "Articuno"},
		{name : "Zapdos"},
		{name : "Moltres"},
		{name : "Dratini"},
		{name : "Dragonair"},
		{name : "Dragonite"},
		{name : "Mewtwo"},
		{name : "Mew"},
	];
}
typedef PokemonInfo =
{
	var name:String;
}
typedef PokemonData =
{
	var dexnum:Int;
	var hp:Int;
	var atk:Int;
	var def:Int;
	var spd:Int;
	var sat:Int;
	var sdf:Int;
	var typeA:Int;
	var typeB:Int;
	var catchrate:Int;
	var baseexp:Int;
	var itemA:Int;
	var itemB:Int;
	var gender:Int;
	var unknow1:Int;
	var steps:Int;
	var unknow2:Int;
	var spritesize:Int;
	var growth:Int;
	var eggA:Int;
	var eggB:Int;
}