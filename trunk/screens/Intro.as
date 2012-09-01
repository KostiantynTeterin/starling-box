package screens
{
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	public class Intro extends Screen
	{
		private var _tf:TextField;
		
		public function Intro()
		{
			super(false);
			SB.console.addMessage( this, "== INTRO SCREEN ==");
		}
		
		override public function begin():void
		{
			_tf = new TextField(150, 70, "CLICK ME !", "Verdana", 16, 0xFFFFFF );
			_tf.x = (600 - 150) / 2;
			_tf.y = 150;
			_tf.border = true;
			_tf.useHandCursor = true;
			_tf.addEventListener(TouchEvent.TOUCH, _onTouchThis );
			addChild( _tf );
		}		
		
		private function _onTouchThis(e:TouchEvent):void 
		{
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(stage);
			if (touch.phase == TouchPhase.BEGAN ) {
				SB.screen = new TypeWriterTest;
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_tf.removeEventListeners();
			_tf.dispose();
		}
		
	}

}