package KeosTactics.products.structures 
{
	import starling.display.Sprite;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class AbstractPiege extends Sprite implements IPiege 
	{
		
		public function AbstractPiege() 
		{
			
		}		
		
		public function speech():void
		{
			trace(this);
		}		
		
	}

}