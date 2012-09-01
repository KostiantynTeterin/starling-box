package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import screens.Intro;
	import starlingBox.Engine;
	import starlingBox.SB;
	
	
	//ludum
	[SWF(width="600",height="800",frameRate="60",backgroundColor="#000000")]	
	public class Startup extends Engine
	{
		public function Startup()
		{
			//super(550, 400, Main, 0, false);
			super(600, 800, Main, 0, false);
		}
	}

}