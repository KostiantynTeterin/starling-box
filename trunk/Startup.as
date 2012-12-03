package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import screens.Intro;
	import starlingBox.Engine;
	import starlingBox.SB;
	
	[SWF(width = "1080", height = "1047", frameRate = "60", backgroundColor = "#DEDEDE")]
	public class Startup extends Engine
	{
		
		// pour être multiscreen
		// travailler sur un ratio de 1.667 pour la zone active (1280 / 768 )
		// et mettre du decor jusqu'en 4/3 
		private const MOBILE:Boolean = true;
		private const DESKTOP:Boolean = false;
		
		public function Startup()
		{
			super(1080, 1047, Main, MOBILE, 0, false);			
		}
	}

}