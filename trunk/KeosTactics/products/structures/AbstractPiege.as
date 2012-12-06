package KeosTactics.products.structures
{
	import KeosTactics.players.Player;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class AbstractPiege extends Sprite implements IPiege
	{
		protected var _lig:int;
		protected var _col:int;
		protected var _owner:Player;
		
		public function AbstractPiege()
		{
		
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
		
		public function speech():void
		{
			trace(this);
		}
	
	}

}