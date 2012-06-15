package flashjack 
{
	/**
	 * ...
	 * @author YopSolo
	 * 
	 */
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.core.Starling;
	
	public class Tracker extends Personnage 
	{
		[Embed(source="../../media/ennemi/sprite32.xml",mimeType="application/octet-stream")]
		private const SpriteSheetXML:Class;
		[Embed(source="../../media/ennemi/sprite32.png")]
		private const SpriteSheet:Class;		
		
		private var _targetX:int;
		private var _targetY:int;
		
		private var gameover:Boolean = false;
		
		public function Tracker(posX:int, posY:int) 
		{
			WIDTH = 32;
			HEIGHT = 32;
			HALF_WIDTH = 16;
			HALF_HEIGHT = 16;
			
			_posx = posX;
			_posy = posY;
			
			_targetX = 16 + int(Math.random() * 624);
			_targetY = 16 + int(Math.random() * 624);	
			
			_aabb = new Rectangle(4, 4, 28, 28);
			
			var texture:Texture = Texture.fromBitmap(new SpriteSheet() as Bitmap, true, true);
			var xml:XML = XML(new SpriteSheetXML);
			var tAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			_stand = new MovieClip(tAtlas.getTextures("tracker"), 24);
			_stand.pivotX = 16;
			_stand.pivotY = 16;
			
			_anim = _stand;
			state = STAND;
			
			init();			
		}
		
		override protected function init():void
		{
			state = STAND;
			
			_dx = Constants.TRACKER_FLYING_SPEED;
			_dy = Constants.TRACKER_FLYING_SPEED;
			_onGround = false;
			// --
			Starling.juggler.add(_anim);
		}
		
		override protected function changeVelocity():void
		{
			var dist:Number = Point.distance( new Point(_posx, _posy), new Point(_targetX, _targetY) );
			//trace( _posx, _posy, _targetX, _targetY, dist );
			
			//trace( dist );
			if ( dist < 128 ) {
				_targetX = 16 + int(Math.random() * 624);
				_targetY = 16 + int(Math.random() * 624);				
			}
			
			/*
			else {
				
				if ( Math.abs(_targetY - _posy) < 1 )  {
					_dy = 0;
				}else if(_targetY < _posy) {
					_dy = -Constants.TRACKER_FLYING_SPEED;
				}else {
					_dy = Constants.TRACKER_FLYING_SPEED;					
				}
				
				if ( Math.abs(_targetX - _posx) < 1 ) {
					_dx = 0;
				}else if (_targetX < _posx) {
					_dx = -Constants.TRACKER_FLYING_SPEED;
				}else {
					_dx = Constants.TRACKER_FLYING_SPEED;
				}				
			}
			*/
		}
		
		override protected function detectCollision():void
		{
			if (gameover) return;
			
			var nextY:int = ( _targetY - _posy ) * .03;
			_posy += nextY/2;
			
			var nextX:Number = ( _targetX - _posx ) * .03;
			_posx += nextX/2;
			
			_aabb.right = _posx + HALF_WIDTH;
			_aabb.left = _posx - HALF_WIDTH;
			_aabb.top = _posy - HEIGHT;
			_aabb.bottom = posy - 1;			
			
		}
		
		override protected function set state(value:int):void
		{
			// --
		}		
		
		override public function gameOver():void
		{
			gameover = true;
			_dx = 0;
			_dy = 0;
		}		
		
	}

}