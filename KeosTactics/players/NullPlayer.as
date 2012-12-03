package KeosTactics.players 
{
	import factory.StangFactory;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class NullPlayer extends Player 
	{
		
		public function NullPlayer() 
		{
			super( new StangFactory() );
		}
		
	}

}