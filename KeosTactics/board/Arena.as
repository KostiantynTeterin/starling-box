package KeosTactics.board
{
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
		private var _cases:Vector.<Sprite>
		private var _pions:Vector.<IUnit>;
		private var _pieges:Vector.<IPiege>;
		private var _colonnes:int;
		private var _lignes:int;
		public static const CASE_SIZE:int = 150;
		
		private static var _instance:Arena;
		
		public function Arena(singletonLock:SingletonLock)
		{
			// --
		}
		
		public function set type(pType:Point):void
		{
			_colonnes = pType.x;
			_lignes = pType.y;
			_cases = new Vector.<Sprite>(_colonnes * lignes, true);
			_pions = new Vector.<IUnit>;
			_pieges = new Vector.<IPiege>;
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
	
	}

}

class SingletonLock
{
}