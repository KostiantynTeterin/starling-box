package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import screens.Intro;
	import starlingBox.Engine;
	import starlingBox.SB;
	
	[SWF(width = "800", height = "640", frameRate = "60", backgroundColor = "#000000")]
	public class Startup extends Engine
	{
		
		// pour être multiscreen
		// travailler sur un ratio de 1.667 pour la zone active (1280 / 768 )
		// et mettre du decor jusqu'en 4/3 
		private const MOBILE:Boolean = true;
		private const DESKTOP:Boolean = false;
		
		public function Startup()
		{
			super(800, 640, Main, MOBILE, 0, false);			
		}
	}

}