package KeosTactics.products.structures 
{
	import flash.display.Sprite;
	import products.structures.IStructure;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Mur extends AbstractPiege
	{
		
		public function Mur() 
		{
			this.graphics.beginFill( 0x0 );
			this.graphics.drawRect(-24,-12,48,24)
			this.graphics.endFill();		
			
		}
		
	}

}