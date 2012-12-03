package KeosTactics.factory
{
	import KeosTactics.players.Player;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.products.units.Pretre;
	import KeosTactics.products.units.Scout;
	import KeosTactics.products.units.Sniper;
	import KeosTactics.Config;
	
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
			result.push(new Pretre(owner));
			
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