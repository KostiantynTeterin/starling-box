package Ludum24 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starling.text.TextField;	 
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Evo extends Screen 
	{
		private var _oldState:BitmapData;
		
		public function Evo( oldState:BitmapData ) 
		{
			_oldState = oldState;
			
			var bmp:Bitmap = new Bitmap( _oldState );
			SB.nativeStage.addChild(bmp);
			TweenLite.to(bmp, .6, { autoAlpha:0 } );
		}
		
		override public function begin():void
		{
			var todo:TextField = new TextField(450, 120, "= W.I.P =", EmbedFonts.instance.geo, 60, 0xFFFFFF );			
			todo.x = (stage.stageWidth - todo.width) >> 1;
			todo.y = 100;
			todo.touchable = false;			
			addChild( todo );
		}
		
		override public function destroy():void
		{
			_oldState.dispose();
			_oldState = null;
			
			super.destroy();
		}
		
	}

}