package KeosTactics.factory 
{
	import KeosTactics.factory.IRaceFactory;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.Config;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class StangFactory extends AbstractRaceFactory
	{
		public function StangFactory()
		{
			_race = Config.RACE_STANG;
			_nomRace = "Stang";		
		}
	
	}

}