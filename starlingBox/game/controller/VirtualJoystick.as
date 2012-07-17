package starlingBox.game.controller
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class VirtualJoystick extends Sprite
	{
		public var UP:Boolean 	= false;
		public var DW:Boolean 	= false;
		public var LF:Boolean 	= false;
		public var RG:Boolean 	= false;
		public var BTN:Boolean	= false;
		public var V:Number		= 0;
		public var angle:Number	= 0;		
		
		private var _knob:Bitmap;
		private var _joystick:Bitmap;		
		private var _knobId:int = -1;
		private var _controller:VirtualJoystickController;
		
		public function VirtualJoystick(x:int, y:int, scale:Number = 1.5){
			scaleX = scaleY = scale;			
			this.x = x;
			this.y = y;		
			
			mouseChildren = false;
			mouseEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );			
		}
		
		protected function _onAddedToStage(event:Event):void
		{
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			_controller = new VirtualJoystickController(this);
			
			draw();
		}
		
		// ================================================================
		
		public function destroy():void
		{
			// [TODO]
			_controller.destroy();
		}				
		
		public function get joystick():Bitmap
		{
			return _joystick;
		}

		public function set joystick(value:Bitmap):void
		{
			_joystick = value;
			_joystick.x = -int(_joystick.width/2);
			_joystick.y = -int(_joystick.height/2);
		}

		public function get knob():Bitmap
		{
			return _knob;
		}

		public function set knob(value:Bitmap):void
		{
			_knob = value;
			_knob.x = -int(_knob.width/2);
			_knob.y = -int(_knob.height/2);			
		}
		
		public function draw():void
		{
			addChild( _joystick );		
			addChild( _knob );
		}
		
		public function update():void
		{
			if(this.stage != null){
				_knob.x = _controller.knobX -int(_knob.width/2);
				_knob.y = _controller.knobY -int(_knob.height/2);					
			}
		}			

	}
}