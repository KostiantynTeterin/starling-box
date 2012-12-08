package KeosTactics.products.units 
{
	import KeosTactics.players.Players;
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
			if ( _owner.id == Players.PLAYER_1) {
				scaleX *= -1;
			}
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