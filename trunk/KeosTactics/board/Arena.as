package KeosTactics.board
{
	import flash.display.Sprite;
	import flash.display.Shape;
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
		private var _pions:Vector.<IUnit>;
		private var _pieges:Vector.<IPiege>;
		private var _colones:int;
		private var _lignes:int;
		private var _mtx:Array;
		private const SIZE:int = 150;
		
		private static var _instance:Arena;
		
		public function Arena( singletonLock:SingletonLock ) { }
		
		public function set type( pType:Point ):void
		{
			_colones = pType.x;
			_lignes = pType.y;
			
			_mtx = [];
			
			var size2:int = SIZE >> 1;
			var sp:Sprite = new Sprite;
			for (var c:int = 0 ; c < _colones ; c++ ) {
				_mtx[c] = [];
				for (var l:int = 0 ; l < _lignes ; l++ ) {
					var sh:Shape = new Shape();
					sh.name = "s_" + c + "_" + l;
					sh.graphics.beginFill( 0x0, .5);
					sh.graphics.drawCircle( 0, 0, size2 );
					sh.graphics.endFill();
					sh.x = size2 + c * SIZE;
					sh.y = size2 + l * SIZE;
					sp.addChild( sh );
				}
			}
			
			sp.graphics.beginFill( 0xCC0000, .5 );
			sp.graphics.drawRect( 0, 0, sp.width, sp.height );
			sp.graphics.endFill();
			
			sp.x = (SB.width - sp.width ) >> 1  ;			
			sp.y = (SB.height - sp.height) >> 1;
			sp.z = 0;
			
			sp.rotationX = -8;
			
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.projectionCenter = new Point(SB.width>>1, SB.height>>1);			
			sp.transform.perspectiveProjection = pp;			
			
			
			for (c = 0 ; c < _colones ; c++ ) {
				_mtx[c] = [];
				for (l = 0 ; l < _lignes ; l++ ) {
					sh = sp.getChildByName("s_" + c + "_" + l) as Shape;
					/*
					_mtx[c][l] = sp.localToGlobal(new Point(sh.x, sh.y));
					//_mtx[c][l] = sh.transform.concatenatedMatrix;
					var pinPoint:Shape = new Shape;
					pinPoint.graphics.beginFill(0xCC0000);
					pinPoint.graphics.drawCircle( 0, 0, 5);
					pinPoint.graphics.endFill();
					//pinPoint.x = sp.x + (_mtx[c][l] as Point).x;
					//pinPoint.y = sp.y +(_mtx[c][l] as Point).y;					
					pinPoint.transform.matrix = new Matrix(1,0,0,1,_mtx[c][l].x, _mtx[c][l].y);
					pinPoint.x += sp.x;
					pinPoint.y += sp.y;					
					SB.nativeStage.addChild( pinPoint );
					*/
				}
			}			
			
			SB.nativeStage.addChild( sp );		
			
			
			sp.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown );
			sp.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp );			
			
			/*
			sh = sp.getChildAt(9) as Shape;
			trace( sh.transform.concatenatedMatrix );
			trace( sh.localToGlobal(new Point) );
			*/
			
			//(a = 1, b = 0, c = 0, d = 1, tx = 100, ty = 50)
			//(x = 635, y = 222)			
			
			
			/*
			import flash.external.ExternalInterface;
			var url:String=ExternalInterface.call("eval","document.location.href");
			*/
			
			/*
			function logSpiral(r:Number,
							   a:Number,b:Number,
							   dir:int,
							   cx:Number=0,cy:Number=0):Point{

			   if(dir<0){dir=-1;} // just to make sure dir is -1 or 1
			   else{dir=1;}
			   var pt:Point=new Point();
			   pt.x=dir*a*Math.pow(Math.E,b*r)*Math.cos(r)+cx;
			   pt.y=a*Math.pow(Math.E,b*r)*Math.sin(r)+cy;
			   return pt;
			}
			Parameters:
			   r - angle in radians
			   a - determines how far away from the center the spiral starts from
			   b - determines density of each round of the spiral
			   dir - direction of spiral (1 for clockwise, -1 for counter-clockwise)
			   cx,cy - center point of spiral
			*/
			
			
		}
		
		private function _onMouseUp(e:MouseEvent):void 
		{
			(e.target as Sprite).stopDrag();
			(e.target as Sprite).z = 0;			
		}
		
		private function _onMouseDown(e:MouseEvent):void 
		{
			(e.target as Sprite).startDrag();
		}
		
		public function get colones():int 
		{
			return _colones;
		}
		
		public function get lignes():int 
		{
			return _lignes;
		}
		
		static public function get instance():Arena 
		{
			if (_instance == null) {				
				_instance = new Arena( new SingletonLock );
				_instance.type = Config.ARENA_4_6;
			}
			
			return _instance;
		}
		
	}

}

class SingletonLock{}