package starlingBox.game.controller
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	
	/**
	 * <p>Games often need to get the current state of various keys in order to respond to user input. 
	 * This is not the same as responding to key down and key up events, but is rather a case of discovering 
	 * if a particular key is currently pressed.</p>
	 * 
	 * <p>isDown and isUp methods, taking a key code as a parameter and returning a Boolean.</p>
	 */
	 
	 
	public class Keypad
	{
		private var states:ByteArray;
		private var dispObj:DisplayObject;
		
		/**
		 * Constructor
		 * 
		 * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
		 */
		public function Keypad( displayObj:DisplayObject )
		{
			states = new ByteArray();
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			dispObj = displayObj;
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener );
			dispObj.addEventListener( Event.ACTIVATE, activateListener );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener );
		}
		
		public function destroy():void
		{
			dispObj.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownListener );
			dispObj.removeEventListener( KeyboardEvent.KEY_UP, keyUpListener );
			dispObj.removeEventListener( Event.ACTIVATE, activateListener );
			dispObj.removeEventListener( Event.DEACTIVATE, deactivateListener );			
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
		}
		
		private function keyUpListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
		}
		
		private function activateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 8; ++i )
			{
				states[ i ] = 0;
			}
		}

		private function deactivateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 8; ++i )
			{
				states[ i ] = 0;
			}
		}
		
		/**
		 * To test whether a key is down.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is down, false otherwise.
		 *
		 * @see isUp
		 */
		public function isDown( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
		}
		
		/**
		 * To test whetrher a key is up.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is up, false otherwise.
		 *
		 * @see isDown
		 */
		public function isUp( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
		}
	}
}