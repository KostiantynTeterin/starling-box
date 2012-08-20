package screens 
{
	import starlingBox.Screen;
	import starlingBox.SB;	
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Test extends Screen 
	{
		
		override public function Test() 
		{
			SB.console.addMessage(this, "== TEST :: CONSTRUCT ==");
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== TEST :: BEGIN ==");
			
			super.begin();
		}
		
	}

}