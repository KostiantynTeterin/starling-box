package screens 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import starlingBox.game.controller.VirtualJoystick;
	import starlingBox.SB;
	import starlingBox.Screen;
	import screens.Niveau1;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class TitleScreenFlashJack extends Screen 
	{
		[Embed(source = "../../media/title-screen.png")]
		private const TitleScreenClass:Class;
		private var bmp:Bitmap;
		
		public function TitleScreenFlashJack() 
		{
			bmp = new TitleScreenClass() as Bitmap;
			//bmp.y  = 5;
			SB.engine.starling.nativeOverlay.addChild( bmp );
			SB.engine.starling.nativeOverlay.addEventListener(MouseEvent.CLICK, _onClickTitleScreen );
		}
		
		private function _onClickTitleScreen(e:MouseEvent):void 
		{
			SB.engine.starling.nativeOverlay.removeEventListener(MouseEvent.CLICK, _onClickTitleScreen );
			TweenMax.to( bmp, 1, { autoAlpha:0 } );
			//
			SB.screen	= new Niveau1;
		}
		
	}

}