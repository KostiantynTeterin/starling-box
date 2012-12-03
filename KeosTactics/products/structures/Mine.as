package KeosTactics.products.structures 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Mine extends AbstractPiege
	{
		
		public function Mine() 
		{
			this.graphics.beginFill( 0xCC0000 );
			this.graphics.drawCircle( 0,0, 48 );
			this.graphics.endFill();
		}
		
	}

}