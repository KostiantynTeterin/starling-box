package KeosTactics.factory 
{
	import factory.IRaceFactory;
	import products.structures.AbstractStructure;
	import products.structures.Nexus;
	import products.units.AbstractUnit;
	import products.units.Zealot;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class LennFactory extends AbstractRaceFactory
	{
		public function LennFactory()
		{
			_race = Config.RACE_LENN;
			_nomRace = "Lenn";		
		}
		
	}

}