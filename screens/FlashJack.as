package screens 
{
	import starlingBox.SB;
	import starlingBox.Screen;

	/**
	 * ...
	 * @author YopSolo
	 * level design
	 * tilemap
	 * bonus
	 * animation hero
	 * physique du saut
	 * controle virtual stick
	 * controle clavier
	 * monstres
	 * HUD
	 * points
	 * ruse pour extruder les blocs du level :)
	 *   ____
	 *  /____\
	 * |______|
	 */
	public class FlashJack extends Screen 
	{
		
		public function FlashJack() 
		{
			super(false);
			SB.console.addMessage( this, "== FLASHJACK SCREEN ==");
		}
		
		override public function begin():void
		{
			SB.console.addMessage( this, "== FLASH-JACK SCREEN :: BEGIN ==");
		}			
		
		override public function destroy():void 
		{			
			//trace("poulet");
			super.destroy();
		}
		
		override public function end():void
		{
			super.end();
		}		
		
	}

}