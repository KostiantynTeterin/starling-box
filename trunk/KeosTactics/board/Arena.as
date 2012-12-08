package KeosTactics.board
{
	import flash.display.Shape;
	import starling.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.CompressionAlgorithm;
	import KeosTactics.Config;
	import KeosTactics.products.units.IUnit;
	import KeosTactics.products.structures.IPiege;
	import starlingBox.SB;
	
	/**
	 * ...
	 * @author YopSolo
	 *
	 */
	public class Arena
	{
		private var CASE_SIZE:int = 150;
		
		private var _cases:Vector.<Sprite>
		private var _pions:Vector.<IUnit>;
		private var _pieges:Vector.<IPiege>;
		private var _colonnes:int;
		private var _lignes:int;
		private var _type:Point;
		
		private var _debug:Shape;
		
		private var _x:int = 0;
		private var _y:int = 0;
		
		private static var _instance:Arena;
		
		public function Arena(singletonLock:SingletonLock)
		{
			_debug = new Shape();
		}
		
		public function set type(pType:Point):void
		{
			_type = pType;
			_colonnes = pType.x;
			_lignes = pType.y;
			_cases = new Vector.<Sprite>(_colonnes * lignes, true);
			_pions = new Vector.<IUnit>;
			_pieges = new Vector.<IPiege>;
			// 
			_debug.graphics.clear();
			_debug.graphics.lineStyle(3, 0x000000);
			for (var col:Number = 0; col < _colonnes + 1; col++)
			{
				for (var row:Number = 0; row < _lignes + 1; row++)
				{
					_debug.graphics.moveTo(col * SIZE, 0);
					_debug.graphics.lineTo(col * SIZE, SIZE * _lignes);
					_debug.graphics.moveTo(0, row * SIZE);
					_debug.graphics.lineTo(SIZE * _colonnes, row * SIZE);
				}
			}
			_debug.graphics.beginFill(0xCC9966, .3 );
			_debug.graphics.drawRect(0, 0, SIZE * _colonnes, _lignes  * SIZE );
			_debug.graphics.endFill();
		}
		
		public function getValeur(colonne:uint, ligne:uint):Sprite
		{
			return _cases[(ligne * _colonnes) + colonne];
		}
		
		public function setValeur(colonne:uint, ligne:uint, valeur:Sprite):void
		{
			if (valeur is IUnit) {
				(valeur as IUnit).col = colonne;
				(valeur as IUnit).lig = ligne;
				_pions.push(valeur);
			}
			
			if (valeur is IPiege ) {
				(valeur as IPiege).col = colonne;
				(valeur as IPiege).lig = ligne;				
				_pieges.push(valeur);
			}
			
			_cases[(ligne * _colonnes) + colonne] = valeur;
		}
		
		public function get colones():int
		{
			return _colonnes;
		}
		
		public function get lignes():int
		{
			return _lignes;
		}
		
		static public function get instance():Arena
		{
			if (_instance == null)
			{
				_instance = new Arena(new SingletonLock);
				_instance.type = Config.ARENA_4_6;
			}
			
			return _instance;
		}
		
		public function get pions():Vector.<IUnit> 
		{
			return _pions;
		}
		
		public function get pieges():Vector.<IPiege> 
		{
			return _pieges;
		}
		
		public function get cases():Vector.<Sprite> 
		{
			return _cases;
		}
		
		public function get SIZE():int 
		{
			if (_type == Config.ARENA_4_7) {
				CASE_SIZE = 128;
			}
			
			if (_type == Config.ARENA_5_7) {
				CASE_SIZE = 110;
			}
			
			return CASE_SIZE;
		}
		
		public function get debug():Shape 
		{
			return _debug;
		}
		
		public function get x():int 
		{
			return _x;
		}
		
		public function set x(value:int):void 
		{
			debug.x = value;
			_x = value;
		}
		
		public function get y():int 
		{
			return _y;
		}
		
		public function set y(value:int):void 
		{
			debug.y = value;
			_y = value;
		}
	
	}

}

class SingletonLock
{
}