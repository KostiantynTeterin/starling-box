package screens 
{
	
	import starlingBox.game.controller.VirtualJoystick;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	public class AirStick extends Screen
	{
		private var joy:VirtualJoystick;
		
		public function AirStick() 
		{
			addChild( new VirtualJoystick(500, 300) );		
			SB.addConsole();
		}
		
	}

}