package KeosTactics.players
{
	import KeosTactics.factory.IRaceFactory;
	import KeosTactics.products.units.AbstractUnit;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Player
	{
		private var _raceFactory:IRaceFactory;
		private var _units:Vector.<AbstractUnit>;
		private var _blason:Blason;
		private var _color:int = 0x0;
		
		public function Player(raceFactory:IRaceFactory)
		{
			_raceFactory = raceFactory;
			_units = _raceFactory.createStartingUnits(this);
		}
		
		public function get blason():Blason
		{
			return _blason;
		}
		
		public function get units():Vector.<AbstractUnit>
		{
			return _units;
		}
		
		public function get race():int
		{
			return _raceFactory.race;
		}
		
		public function get nomRace():String
		{
			return _raceFactory.nomRace;
		}		
		
		public function get color():int 
		{
			return _color;
		}
		
		public function set color(value:int):void 
		{
			_color = value;
		}
	
	}
}