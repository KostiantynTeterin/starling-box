package KeosTactics.factory 
{
	import factory.IRaceFactory;
	import products.units.AbstractUnit;
	import products.units.Pretre;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class GwernFactory extends AbstractRaceFactory
	{
		public function GwernFactory() {
			_race = Config.RACE_GWERN;
			_nomRace = "Gwern";			
		}
		
	}

}