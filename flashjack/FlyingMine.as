package flashjack 
{
	/**
	 * ...
	 * @author YopSolo
	 * 
	 */
	
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.core.Starling;
	
	public class FlyingMine extends Personnage 
	{
		[Embed(source="../../../media/ennemi/sprite32.xml",mimeType="application/octet-stream")]
		private const SpriteSheetXML:Class;
		[Embed(source="../../../media/ennemi/sprite32.png")]
		private const SpriteSheet:Class;		
		
		public function FlyingMine(posX:int, posY:int) 
		{
			WIDTH = 32;
			HEIGHT = 32;
			HALF_WIDTH = 16;
			HALF_HEIGHT = 16;
			
			_posx = posX;
			_posy = posY;
			
			_aabb = new Rectangle(4, 4, 28, 28);
			
			var texture:Texture = Texture.fromBitmap(new SpriteSheet() as Bitmap, true, true);
			var xml:XML = XML(new SpriteSheetXML);
			var tAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			_stand = new MovieClip(tAtlas.getTextures("ennemi"), 24);
			_stand.pivotX = 16;
			_stand.pivotY = 16;
			
			_anim = _stand;
			state = STAND;
			
			init();			
		}
		
		override protected function init():void
		{
			state = STAND;
			
			_dx = Constants.MINE_FLYING_SPEED;
			_dy = .0;
			_onGround = false;
			// --
			Starling.juggler.add(_anim);
		}
		
		override protected function changeVelocity():void
		{
			// --
		}
		
		override protected function detectCollision():void
		{
			var nextY:int = _posy;
			_posy = nextY;			
			
			//var directionX:int = ((_dx < 0) ? -1 : 1);
			var nextX:Number = int(_posx + _dx);
			if ( nextX < 0 || nextX > 640 ) {
				_dx = -_dx;				
				nextX = int(_posx + _dx);
			}
			
			_posx = nextX;
			
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
			_dx = 0;
			_dy = 0;
		}		
		
	}

}