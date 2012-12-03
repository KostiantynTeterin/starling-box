package KeosTactics.factory 
{
	import products.units.AbstractUnit;
	import products.units.Scout;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class DourFactory extends AbstractRaceFactory
	{
		
		public function DourFactory() { 
			_race = Config.RACE_DOUR;
			_nomRace = "Dour";
		}
		
	}

}