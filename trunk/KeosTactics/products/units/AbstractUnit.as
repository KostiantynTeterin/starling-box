package KeosTactics.products.units 
{
	import starling.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import KeosTactics.players.NullPlayer;
	import KeosTactics.players.Player;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class AbstractUnit extends Sprite implements IUnit 
	{
		protected var _lig:int;
		protected var _col:int;
		protected var _owner:Player;
		
		public function AbstractUnit(owner:Player) 
		{
			_lig = -1;
			_col = -1;
			_owner = owner;
			
			drawMe();		
			
			addEventListener( TouchEvent.TOUCH, _onTouch );
		}
		
		private function _onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch) {				
				if (touch.phase == TouchPhase.BEGAN) {
					this.speech();
				}				
			}
		}
		
		protected function drawMe():void
		{
			/*
			this.graphics.beginFill( 0x0 );
			this.graphics.drawCircle(0, 0, 48 );
			this.graphics.endFill();			
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = "Arial";
			fmt.size = 14;
			fmt.color = 0xFFFFFF;
			
			var _tf:TextField = new TextField();
			_tf.x = -48;
			_tf.y = -10;
			_tf.defaultTextFormat = fmt;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.text = this.toString();
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			
			addChild( _tf );			
			*/
		}		
		
		public function speech():void
		{
			//if ( isOwner ) {
				trace(this, "panel action");
			//}else {
				//trace("panel info");
			//}
			
		}
		
		public function get owner():Player 
		{
			return _owner;
		}
		
		public function set owner(value:Player):void 
		{
			_owner = value;
		}
		
		public function get lig():int 
		{
			return _lig;
		}
		
		public function set lig(value:int):void 
		{
			_lig = value;
		}
		
		public function get col():int 
		{
			return _col;
		}
		
		public function set col(value:int):void 
		{
			_col = value;
		}
		
	}

}