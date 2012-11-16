package starlingBox.game.controller
{
	import flash.geom.Point;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	import starlingBox.SB;
	import starling.events.TouchEvent;
	
	/**
	 * touch enabled ?
	 * keyboard support ?
	 * mouseEnabled ?
	 *
	 * Ajouter le tap
	 *
	 **/
	
	public class VirtualJoystickController
	{
		private const DISTANCE_MIN:int = 35;
		private const DISTANCE_MAX:int = 85;
		private const LIMIT:int = 500;
		
		private var _knobId:int = -1;
		private var _knobX:int = 0;
		private var _knobY:int = 0;
		private var _ref:VirtualJoystick;
		
		public function VirtualJoystickController(vjoy:VirtualJoystick)
		{
			_ref = vjoy;
			_ref.stage.addEventListener( TouchEvent.TOUCH, _onTouch );			
		}
		
		private function _onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(_ref.stage, TouchPhase.BEGAN);
			if (touch) {
				_onTouchBegin(touch);
			}
		}
		
		// ===================================================
		public function get knobY():int
		{
			return _knobY;
		}
		
		public function get knobX():int
		{
			return _knobX;
		}
		
		public function destroy():void
		{
			SB.console.addMessage(this, "DESTROY");
			_ref.stage.removeEventListener( TouchEvent.TOUCH, _onTouch );	
			
			_ref = null;
		}
		
		// ===================================================		
		private function _onTouchEnd(event:TouchEvent):void
		{
			/*
			if (event.touchPointID == _knobId)
			{
				_knobX = 0;
				_knobY = 0;
				_knobId = -1;
				_ref.LF = false;
				_ref.RG = false;
				_ref.UP = false;
				_ref.DW = false;
				//trace(_ref.LF, _ref.RG)
				_ref.update();
			}
			else
			{
				_ref.BTN = false;
			}
			*/
		}
		
		private function _onTouchMove(event:TouchEvent):void
		{
			SB.console.addMessage(this, "_onTouchMove");
			/*
			if (event.touchPointID == _knobId)
			{
				var angle:Number;
				var dx:int = (event.stageX - _ref.x) / _ref.scaleX;
				var dy:int = (event.stageY - _ref.y) / _ref.scaleY;
				var dist:int = Math.sqrt(dx * dx + dy * dy);
				if (dist < DISTANCE_MAX)
				{
					_knobX = dx;
					_knobY = dy;
				}
				else
				{
					angle = Math.atan2(dy, dx);
					_knobX = (Math.cos(angle) * DISTANCE_MAX);
					_knobY = (Math.sin(angle) * DISTANCE_MAX);
					dist = DISTANCE_MAX;
				}
				// ========================================
				//trace( dx );
				if (dx < -DISTANCE_MIN)
				{
					_ref.LF = true;
				}
				else
				{
					_ref.LF = false;
				}
				
				if (dx > DISTANCE_MIN)
				{
					_ref.RG = true;
				}
				else
				{
					_ref.RG = false;
				}
				
				if (dy < -DISTANCE_MIN)
				{
					_ref.UP = true;
				}
				else
				{
					_ref.UP = false;
				}
				
				if (dy > DISTANCE_MIN)
				{
					_ref.DW = true;
				}
				else
				{
					_ref.DW = false;
				}
				
				// ========================================
				_ref.V = dist / DISTANCE_MAX; // etalonner sur 0..1 en commencant à .35 ?
				_ref.angle = angle;
				_ref.update();
			}
			*/
		}
		
		private function _onTouchBegin( touch:Touch ):void
		{
			SB.console.addMessage(this, "_onTouchBegin");
			var pos:Point = touch.getLocation( _ref.stage );
			if (pos.x < LIMIT)
			{
				if ( _knobId == -1 )
				{
					//_knobId = event.touchPointID;
					//_onTouchMove(event);
					_ref.update();
				}
			}
			
			/*
			if (event.touchPointID != _knobId)
			{
				_ref.BTN = true;
			}
			*/
		}
	}
}