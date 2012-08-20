package starlingBox.game.controller
{
	import flash.display.Bitmap;	
	import flash.display.Stage;
	import starling.events.Event
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class VirtualJoystick extends Sprite
	{
		public var UP:Boolean 	= false;
		public var DW:Boolean 	= false;
		public var LF:Boolean 	= false;
		public var RG:Boolean 	= false;
		public var BTN:Boolean	= false;
		public var V:Number		= 0;
		public var angle:Number	= 0;		
		
		private var _knob:Image;
		private var _joystick:Image;		
		private var _knobId:int = -1;
		private var _controller:VirtualJoystickController;
		[Embed(source = "../../../../media/joystick.png")]
		private const joyClass:Class;
		[Embed(source = "../../../../media/joystick.png")]
		private const knobClass:Class;
		
		public function VirtualJoystick(x:int, y:int, scale:Number = 1.5){
			scaleX = scaleY = scale;			
			this.x = x;
			this.y = y;		

			//mouseChildren = false;
			//mouseEnabled = false;
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage );			
		}
		
		protected function _onAddedToStage(event:Event):void
		{
			Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
			_controller = new VirtualJoystickController(this);
			
			/*
			var joy:Shape = new Shape();
			joy.graphics.beginFill(0x333333);
			joy.graphics.drawRect(0, 0, 60, 60);
			joy.graphics.endFill();
			var dat:BitmapData = new BitmapData(60, 60, true, 0x0);
			dat.draw( joy );
			
			var knob:Shape = new Shape();
			knob.graphics.beginFill(0xCC0000);
			knob.graphics.drawCircle(0,0,30)
			knob.graphics.endFill();		
			var dat2:BitmapData = new BitmapData(30, 30, true, 0x0);
			dat2.draw(knob);	
			*/
			
			_joystick = new Image( Texture.fromBitmap( new joyClass as Bitmap ) );
			_joystick.pivotX = int(_joystick.width/2);
			_joystick.pivotY = int(_joystick.height / 2);
			
			_knob = new Image( Texture.fromBitmap( new knobClass as Bitmap ) );
			_knob.pivotX = int(_knob.width / 2);			
			_knob.pivotY = int(_knob.height / 2);			
			
			draw();
		}
		
		// ================================================================
		
		public function destroy():void
		{
			// [TODO]
			_controller.destroy();
		}
		
		public function draw():void
		{
			addChild( _joystick );		
			addChild( _knob );
		}
		
		public function update():void
		{
			if(this.stage != null){
				_knob.x = _controller.knobX;
				_knob.y = _controller.knobY;
			}
		}			

	}
}