package starlingBox.game.controller 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class VirtualButton extends Sprite
	{
		public var isDown:Boolean = false;
		
		private var _button:Image;
		
		public function VirtualButton(x:int, y:int, scale:Number = 1) 
		{
			this.x = x;
			this.y = y;
			this.scaleX = this.scaleY = scale;
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );				
		}
		
		private function _onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );	
			
			_button = new Image( Texture.fromBitmapData( new JoyButton ) );
			_button.pivotX = _button.width >> 1;
			_button.pivotY = _button.height >> 1;
			_button.addEventListener(TouchEvent.TOUCH, _onTouch);
			addChild( _button );
		}		
		
		private function _onTouch(e:TouchEvent):void 
		{
			e.stopImmediatePropagation();
			var touch:Touch = e.getTouch(this);
			
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN) {
					isDown = true;
				}
				
				if (touch.phase == TouchPhase.ENDED) {
					isDown = false;
				}				
			}
		}
	}

}