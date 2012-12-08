package KeosTactics.players
{
	import KeosTactics.factory.IRaceFactory;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.products.structures.AbstractPiege;
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
		private var _pieges:Vector.<AbstractPiege>;
		private var _blason:Blason;
		private var _color:int = 0x0;
		private var _id:int = -1;
		
		public function Player(id:int, raceFactory:IRaceFactory)
		{
			_id = id;
			_raceFactory = raceFactory;
			_units = _raceFactory.createStartingUnits(this);
			_pieges = _raceFactory.createStartingPieges(this);
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
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get pieges():Vector.<AbstractPiege> 
		{
			return _pieges;
		}
	
	}
}