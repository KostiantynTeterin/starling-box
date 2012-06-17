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
		private var _dist:Number = -999;
		
		private var gameover:Boolean = false;
		
		public function Tracker(posX:int, posY:int) 
		{
			WIDTH = 32;
			HEIGHT = 32;
			HALF_WIDTH = 16;
			HALF_HEIGHT = 16;
			
			_posx = posX;
			_posy = 32*15;
			
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
			
			if (gameover) return;

			var dy:Number = _targetY - _posy;			
			var dx:Number = _targetX - _posx;			
			animation.scaleX = (dx > 0) ? -1: 1 ;
			var nextY:Number = int(dy * .05);
			_posy += nextY;
			var nextX:Number = int(dx * .01);			
			_posx += nextX;				
			/*
			if(dx<0){ dx *=-1; }
			if(dy<0){ dy *=-1; }
			_dist = dx + dy;			
			*/
		}
		
		override public function update( rect:Rectangle = null ):void
		{
			_targetX = rect.x + 16;
			_targetY = rect.y + 32;			
			changeVelocity();
			detectCollision();
			_anim.x = _posx;
			_anim.y = _posy;
		}		
		
		override protected function detectCollision():void
		{
			if (gameover) return;
			
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