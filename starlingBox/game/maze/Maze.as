package starlingBox.game.maze
{
	import starling.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.getTimer;	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starlingBox.game.utils.Ran;
	
	// donner la possibilité d'overrider les points d'entree/sortie
	
	public class Maze
	{
		public static const GRAND:int = 35; //75;
		public static const MOYEN:int = 25; //50;
		public static const PETIT:int = 15; //25;
		
		private const BLANC:int = 0xFFFFFF;
		private const NOIR:int = 0x000000;		
		
		private var _WIDTH:int;
		private var _HEIGHT:int;
		
		private var _url:String;
		private var _cleanURL:String;
		private var _startPoint:Point;
		private var _heartPoint:Point;
		private var _orientation:int;
		private var _seed:int;		
		
		// -- affichage
		private var _labyrinthe_dat:BitmapData;
		private var _path_dat:BitmapData;
		private var _obj_dat:BitmapData;
		private var _dat:BitmapData;
		private var _bmp:Bitmap;
	
		// -- path
		private var startNode:Node;
		private var goalNode:Node;
		private var openList:Array;
		private var closeList:Array;
		private var dir4:Array = [[0, -1], [ -1, 0], [0, 1], [1, 0]];		
		private var nodeMap:Array;
		
		public var monsters_location:Vector.<Point>;
		public var objets_location:Vector.<Point>;
		public var hero_location:Point;
		
		private var _autoEntryAndExit:Boolean
		
		public function Maze( url:String = "", casesW:int = 10, casesH:int = 10, pEntry:Point = null, pExit:Point = null ) 
		{
			if ( (pEntry == null || pExit == null ) )
			{
				_autoEntryAndExit = true;
			}else {
				_startPoint = pEntry;
				_heartPoint = pExit;
				_orientation = 0;
			}
			
			if (url == "") {
				_WIDTH = casesW;
				_HEIGHT = casesH;
				
				_labyrinthe_dat = new BitmapData(_WIDTH, _HEIGHT);
				_path_dat = new BitmapData(_WIDTH, _HEIGHT, true, NOIR);
				_obj_dat = new BitmapData(_WIDTH, _HEIGHT, true, NOIR);
				generate();				
			}else {
				// URL
				_url = url;			
				_cleanURL = cleanURL( url );
				
				// creation des objets d'affichage			
				_labyrinthe_dat = new BitmapData(GRAND, GRAND);
				_path_dat = new BitmapData(GRAND, GRAND, true, NOIR);
				_obj_dat = new BitmapData(GRAND, GRAND, true, NOIR);
				
				// génération du labyrinthe
				generateFromURL( _cleanURL );
			}
			
			// emplacement (tableau de points);
			monsters_location = new Vector.<Point>();
			objets_location = new Vector.<Point>();
			hero_location = startPoint.clone();
			
			_dat = new BitmapData( _WIDTH, _HEIGHT, false, BLANC );
			_bmp = new Bitmap( _dat );
			
			update();	
		}
		
		public function destroy():void
		{
			trace("TODO");
		}
		
		public function update():void
		{
			var p:Point = new Point;
			_dat.fillRect( _dat.rect, NOIR );
			_dat.copyPixels( _labyrinthe_dat, _dat.rect, p );
			_dat.copyPixels( _path_dat, _dat.rect, p );
			_dat.copyPixels( _obj_dat, _dat.rect, p );			
		}
		
		private function generate():void
		{
			Ran.seed = _WIDTH * _HEIGHT;
			Ran.reset();
			
			_labyrinthe_dat.copyPixels( build(_WIDTH,_HEIGHT),new Rectangle(0,0,_WIDTH,_HEIGHT), new Point );
			
			if(_autoEntryAndExit) autoEntryExit();
		}
		
		private function generateFromURL( cleanURL:String ):void
		{
			Ran.seed = calcSeed( cleanURL );
			Ran.reset();
			
			if (Ran.seed % 2 == 0) {
				_labyrinthe_dat.copyPixels( build(MOYEN,MOYEN),new Rectangle(0,0,MOYEN,MOYEN), new Point );
			} else {
				if (_cleanURL.length % 2 == 0) {					
					_labyrinthe_dat.copyPixels( build(PETIT,GRAND),new Rectangle(0,0,PETIT,GRAND), new Point );
				} else {
					_labyrinthe_dat.copyPixels( build(GRAND,PETIT),new Rectangle(0,0,GRAND,PETIT), new Point );
				}
			}
			
			if(_autoEntryAndExit) autoEntryExit();
		}
		
		private function autoEntryExit():void
		{
			var rx:int = Ran.integer(_WIDTH);			
			var ry:int = Ran.integer(_HEIGHT);			
			while ( _labyrinthe_dat.getPixel(rx, ry) == NOIR )			
			{
				rx = Ran.integer(_WIDTH);
				ry = Ran.integer(_HEIGHT);
			}
			_startPoint = new Point(rx, ry);		
			
			_orientation = 0;
			
			var dist:int = -1;			
			var d:int = Math.min(_WIDTH, _HEIGHT);
			while (dist < d )
			{				
				var coeurx:int = Ran.integer(_WIDTH);				
				var coeury:int = Ran.integer(_HEIGHT);				
				while ( _labyrinthe_dat.getPixel(coeurx, coeury) == NOIR )
				{
					coeurx = Ran.integer(_WIDTH);					
					coeury = Ran.integer(_HEIGHT);					
				}
				dist = searchMap( _startPoint, new Point(coeurx, coeury) );				
			}
			_heartPoint = new Point( coeurx, coeury );				
		}		
		
		public function get WIDTH():int { return _WIDTH; }		
		public function get HEIGHT():int { return _HEIGHT; }		
		public function get url():String { return _url; }		
		public function get startPoint():Point { return _startPoint; }		
		public function get heartPoint():Point { return _heartPoint; }		
		public function get labyrinthe_dat():BitmapData { return _labyrinthe_dat; }		
		public function get path_dat():BitmapData { return _path_dat; }
		public function get obj_dat():BitmapData { return _obj_dat; }
		public function get bitmap():Bitmap { return _bmp; }
		public function get orientation():int { return _orientation; }
		
		public function get autoEntryAndExit():Boolean { return _autoEntryAndExit; }
		
		public function set startPoint(value:Point):void 
		{
			_startPoint = value;
		}
		
		public function set heartPoint(value:Point):void 
		{
			_heartPoint = value;
		}
		
		private function build(w:int, h:int):BitmapData
		{
			_WIDTH = w;
			_HEIGHT = h;
			
			var bd:BitmapData = new BitmapData(w, h, false, 0xFFFFFFFF);			
			
			for (var y:int = 0; y < bd.height; y++) {				
				for (var x:int = 0; x < bd.width; x++) {					
					if (y == 0 || x == 0 || y == bd.height - 1 || x == bd.width - 1 || y % 2 == 0 && x % 2 == 0) 
					{						
						bd.setPixel(x, y, 0xCC000000);						
					}
				}
			}

			for (y = 2; y < bd.height - 1; y += 2) {				
				var dx:int = 2;				
				var dy:int = y;				
				
				switch ( Ran.integer(4) ) 
				{
					case 0 :
						dx++;
						break;
					case 1 :
						dx--;
						break;
					case 2 :
						dy++;
						break;
					case 3 :
						dy--;
						break;
				}
				
				if (bd.getPixel(dx, dy) != 0xFF000000) 
				{				
					bd.setPixel(dx, dy, 0xFF000000);					
				} else {
					y -= 2;
				}
			}
			
			for (x = 4; x < bd.width - 1; x += 2) 
			{
				for (y = 2; y < bd.height - 1; y += 2) 
				{
					dx = x;					
					dy = y;
					
					switch ( Ran.integer(3) ) 
					{
						case 0 :						
							dy++;
							break;
						case 1 :
							dy--;
							break;
						case 2 :
							dx++;
							break;
					}
					
					if (bd.getPixel(dx, dy) != 0xFF000000) 
					{
						bd.setPixel(dx, dy, 0xFF000000);						
					} else {						
						y -= 2;						
					}					
				}				
			}
			
			return bd;			
		}
		
		// -- pathfinding
		private function makeNodeMap():void
		{
			nodeMap = [];			
			for (var y:int = 0; y < _HEIGHT; y++) {				
				nodeMap[y] = [];
				for (var x:int = 0; x < _WIDTH; x++) {					
					nodeMap[y][x] = new Node(x, y, 0);					
				}				
			}			
		}
		
		public function searchMap(startPoint:Point, goalPoint:Point, drawpath:Boolean = false):int		
		{
			makeNodeMap();
			
			startNode = new Node(startPoint.x, startPoint.y, 0);			
			goalNode = new Node(goalPoint.x, goalPoint.y, 0);			
			
			openList = [startNode];			
			closeList = [];
			
			var totalCost:int = 0;			
			if (drawpath) {
				_path_dat.fillRect( _dat.rect, NOIR );
			}
			while (openList.length > 0)			
			{
				openList.sortOn(["cost"], Array.NUMERIC );				
				var cnode:Node = openList.shift();				
				closeList.push(cnode);				
				// if goal
				if (cnode.x == goalNode.x && cnode.y == goalNode.y) 
				{
					prevNodeSearch(drawpath);					
					return cnode.totalCost / 16777215;					
				}
				
				var diffX:int;				
				var diffY:int;				
				var posX:int;				
				var posY:int;				
				var targetNode:Node;
				
				for (var i:int = 0; i < 4; i++) 
				{
					diffX = dir4[i][0];					
					diffY = dir4[i][1];					
					posX = cnode.x + diffX;					
					posY = cnode.y + diffY;					
					
					if (posX >= 0 && posX < _WIDTH && posY >= 0 && posY < _HEIGHT) 
					{
						targetNode = nodeMap[posY][posX];
						
						if (targetNode.cost == 0 && _labyrinthe_dat.getPixel(posX, posY) > 0) 
						{
							targetNode.totalCost = cnode.totalCost + _labyrinthe_dat.getPixel(posX, posY);							
							targetNode.cost = Math.sqrt( Math.pow((goalNode.x - targetNode.x), 2) + Math.pow((goalNode.y - targetNode.y), 2)) + targetNode.totalCost;							
							targetNode.parent = cnode;							
							nodeMap[posY][posX] = targetNode;							
							openList.push(targetNode);							
						}
					}
				}
			}
			
			return -1;
		}
		
		private function prevNodeSearch(drawpath:Boolean = false):void
		{
			var node:Node = closeList.pop();			
			var i:int = 1;			
			do {				
				if (drawpath)_path_dat.setPixel32(node.x, node.y, 0xffff0000);				
				if (node.parent == null) {					
					break;					
				}				
			} while (node = node.parent);			
		}
		
		// -- Calcul de la seed
		private function calcSeed(site:String):uint
		{
			var rs:uint = 1;			
			var nb:int = site.length;			
			// seed de base
			for (var i:int = 0; i < nb; i++) {				
				rs += site.charCodeAt(i) * i;				
			}
			return rs;			
		}
		
		private function cleanURL( url:String ):String
		{
			var sp:Array = url.split("//");			
			var site:Array = sp[1].split("/");			
			return site[0];			
		}		
		
	}

}

class Node
{
	private var _x:int;
	public function get x():int
	{
		return _x;
	}

	private var _y:int;
	public function get y():int
	{
		return _y;
	}

	public var totalCost:int;

	private var _cost:Number;
	public function get cost():Number
	{
		return _cost;
	}
	public function set cost(value:Number):void
	{
		_cost = value;		
	}

	public var parent:Node;

	public function Node(x:int, y:int, cost:Number = 0):void
	{
		_x = x;		
		_y = y;		
		_cost = cost;		
	}
}