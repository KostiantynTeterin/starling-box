package KeosTactics.products.structures 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Trou extends AbstractPiege
	{
		
		public function Trou() 
		{
			this.graphics.beginFill( 0x0 );
			this.graphics.drawCircle( 0,0, 48 );			
			this.graphics.endFill();
		}
		
	}

}