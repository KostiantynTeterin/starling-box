package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import screens.Intro;
	import starlingBox.Engine;
	import starlingBox.SB;
	
	public class Startup extends Engine
	{
		public function Startup()
		{
			super(550, 400, Main, 0, false);
			//super(955, 640, Main, 0, true);
		}
	}

}