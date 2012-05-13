package screens
{
	import alienfleet.Vaisseau;
	import flash.geom.Point;
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingBox.SB;
	import starlingBox.Screen;
	import fr.kouma.starling.utils.Stats;	
	import screens.Jeu;
	
	public class Intro extends Screen
	{
		
		public function Intro()
		{
			super(false);
			SB.console.addMessage( this, "== INTRO SCREEN ==");
		}
		
		override public function begin():void
		{
			stage.addEventListener(TouchEvent.TOUCH, _onTouchThis );
			
			// var btn:Button = new Button();			
		}		
		
		private function _onTouchThis(e:TouchEvent):void 
		{
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(stage);
			if (touch.phase == TouchPhase.ENDED ) {
				SB.screen = new Jeu;
			}
		}
		
		override public function destroy():void 
		{			
			//trace("poulet");
			super.destroy();
		}
		
		override public function end():void
		{
			stage.removeEventListener(TouchEvent.TOUCH, _onTouchThis );
			super.end();
		}
		
	}

}