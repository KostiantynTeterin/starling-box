package KeosTactics.factory
{
	import KeosTactics.players.Player;
	import KeosTactics.products.structures.Mine;
	import KeosTactics.products.structures.Mur;
	import KeosTactics.products.structures.Trou;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.products.structures.AbstractPiege;
	import KeosTactics.products.units.Tank;
	import KeosTactics.products.units.Scout;
	import KeosTactics.products.units.Sniper;
	import KeosTactics.Config;
	import KeosTactics.products.units.Tank;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	
	public class AbstractRaceFactory implements IRaceFactory
	{
		protected var _race:int;
		protected var _nomRace:String;
		
		public function AbstractRaceFactory()
		{
			_race = Config.RACE_DEFAUT;
			_nomRace = "Race par defaut";
		}
		
		public function createStartingUnits(owner:Player):Vector.<AbstractUnit>
		{
			var result:Vector.<AbstractUnit> = new Vector.<AbstractUnit>;
			result.push(new Scout(owner));
			result.push(new Sniper(owner));
			result.push(new Tank(owner));
			
			return result;
		
		}
		
		public function createStartingPieges(owner:Player):Vector.<AbstractPiege>
		{
			var result:Vector.<AbstractPiege> = new Vector.<AbstractPiege>;
			result.push(new Trou(owner));
			result.push(new Mur(owner));
			result.push(new Mine(owner));
			
			return result;			
		}
		
		public function get race():int 
		{
			return _race;
		}
		
		public function get nomRace():String 
		{
			return _nomRace;
		}
	
	}

}