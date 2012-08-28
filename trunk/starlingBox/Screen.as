package starlingBox
{
	import flash.utils.getAliasName;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Screen extends Sprite
	{
		protected var _updateLoop:Boolean;
		
		public function Screen(updateLoop:Boolean = false)
		{
			SB.console.addMessage(this, "DEFAULT SCREEN CONSTRUCTOR");
			_updateLoop = updateLoop;
			addEventListener(Event.ADDED_TO_STAGE, _onAdded );
		}
		
		private function _onAdded(e:Event):void {
			SB.console.addMessage(this, "DEFAULT SCREEN ONADDED");
			removeEventListener(Event.ADDED_TO_STAGE, _onAdded );
			
			begin();
			if (_updateLoop)
				startOEF();			
		}
		
		// --
		public function begin():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN BEGIN");
		}
		
		public function end():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN END");
			removeEventListeners();
			stopOEF();
			destroy();
			removeChildren();
		}
		
		public function destroy():void
		{
			stopOEF();
			SB.console.addMessage(this, "DEFAULT SCREEN DESTROY");
		}
		
		// -- Update Loop
		public function startOEF():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN START_OEF");
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function stopOEF():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN STOP_OEF");
			if ( hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		
		public function update(e:Event):void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN UPDATE");
		}
		
		public function pause():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN PAUSE");
			SB.soundBox.pauseBGM();
			stopOEF();
		}
		
		public function resume():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN RESUME");
			SB.soundBox.resumeBGM();
			if (_updateLoop)
				startOEF();
		}
	
	}

}

// BASIC TEMPLATE
/*
   package Screens
   {
	   public class TestScreen extends Screen
	   {
		   public function TestScreen() {
			super(false, false);
		   }
		   override public function begin():void{}
		   override public function update(e:Event):void {}
	   }
   }
 */