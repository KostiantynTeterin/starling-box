package screens 
{
	import starling.animation.Tween;
	import starlingBox.game.effects.TypeWriter;
	import starlingBox.Screen;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class TypeWriterTest extends Screen 
	{
		private var _tw:TypeWriter;
		
		public function TypeWriterTest() 
		{
			var text:String = "import starlingBox.game.effects.TypeWriter;public class TypeWriterTest extends Screen.";
			
			_tw = new TypeWriter();
			_tw.init( 1, text );			
			_tw.start();
			
			addChild( _tw );			
		}
		
	}

}