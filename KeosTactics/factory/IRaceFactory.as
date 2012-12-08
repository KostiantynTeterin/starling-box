package KeosTactics.factory 
{
	import KeosTactics.players.Player;
	import KeosTactics.products.structures.AbstractPiege;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.factory.IRaceFactory;
	/**
	 * ...
	 * @author YopSolo
	 */
	public interface IRaceFactory
	{
		function get race():int;
		function get nomRace():String;
		function createStartingUnits(owner:Player):Vector.<AbstractUnit>;
		function createStartingPieges(owner:Player):Vector.<AbstractPiege>;
		
	}

}