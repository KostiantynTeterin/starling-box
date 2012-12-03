package KeosTactics.factory 
{
	import products.units.AbstractUnit;
	import products.units.Pretre;
	import products.units.Scout;
	import products.units.Sniper;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class GwazhFactory extends AbstractRaceFactory
	{
		public function GwazhFactory() { 
			_race = Config.RACE_GWAZH;
			_nomRace = "Gwazh";			
		}
		
		
		
	}

}