package flashjack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.extensions.BaseTileMap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.core.Starling;
	import starlingBox.SB;
	import starling.extensions.DynamicAtlas;
	import starlingBox.game.common.Input;
	
	/**
	 * @author YopSolo
	 * 
	 */
	
	public class Hero
	{
		[Embed(source="../../media/kliff_complete_v2/kliff.xml",mimeType="application/octet-stream")]
		private const SpriteSheetXML:Class;
		[Embed(source="../../media/kliff_complete_v2/kliff.png")]
		private const SpriteSheet:Class;
		
		private var _stand:MovieClip;
		static public const STAND:int = 0;
		private var _walk:MovieClip;
		static public const WALK:int = 1;
		
		private var _state:int = STAND;
		private var _anim:MovieClip;
		
		private var _posx:int;
		private var _posy:int;
		private var _dx:Number;
		private var _dy:Number;
		private var _onGround:Boolean;
		
		private var _collisionMap:Array;
		private var _levelDat:BitmapData;
		private var _aabb:Rectangle;
		
		private const WIDTH:int = 32;
		private const HEIGHT:int = 64;
		private const HALF_WIDTH:int = 16;
		private const HALF_HEIGHT:int = 32;
		
		public function Hero()
		{
			var texture:Texture = Texture.fromBitmap(new SpriteSheet() as Bitmap, true, true);
			var xml:XML = XML(new SpriteSheetXML);
			
			var tAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			_stand = new MovieClip(tAtlas.getTextures("stand"), 15);
			_stand.pivotX = 35;
			_stand.pivotY = 188;
			_walk = new MovieClip(tAtlas.getTextures("walk"), 15);
			_walk.pivotX = 35;
			_walk.pivotY = 187;
			
			_aabb = new Rectangle(0, 0, 32, 64);
			
			state = STAND;
			//state = WALK;
			/*
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new AnimContainer, 1, 0, true, true);
			
			_stand = new MovieClip(atlas.getTextures("Stand"), 15);
			_stand.pivotX = 16;
			_stand.pivotY = 64;
			
			_walk = new MovieClip(atlas.getTextures("Walk"), 15);
			_walk.pivotX = 16;
			_walk.pivotY = 64;
			*/
			
			init();
		}
		
		public function init():void
		{
			_posx = Constants.HERO_DEF_X;
			_posy = Constants.HERO_DEF_Y;
			_dx = .0;
			_dy = .0;
			_onGround = false;
		}		
		
		public function set collisionMap(value:Array):void
		{
			_collisionMap = value;
		}
		
		public function set levelDat(value:BitmapData):void
		{
			_levelDat = value;
		}		
		
		public function get posx():int
		{
			return _posx;
		}
		
		public function get posy():int
		{
			return _posy;
		}
		
		public function get animation():MovieClip
		{
			return _anim;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(value:int):void
		{
			if (_anim)
			{
				_anim.visible = false;
				Starling.juggler.remove(_anim);
			}
			
			switch (value)
			{
				case STAND: 
					if (_anim)
					{
						_stand.x = _anim.x;
						_stand.y = _anim.y;
						_stand.scaleX = _anim.scaleX;
					}
					_anim = _stand;
					break;
				
				case WALK: 
					if (_anim)
					{
						_walk.x = _anim.x;
						_walk.y = _anim.y;
					}
					_anim = _walk;
					break;
				
				default: 
					trace("Error !");
			}
			
			Starling.juggler.add(_anim);
			//_anim.visible = true;
		}
		
		public function get aabb():Rectangle 
		{
			return _aabb;
		}
		
		public function update():void
		{
			changeVelocity();
			detectCollision();
			_anim.x = _posx;
			_anim.y = _posy;			
		}
		
		private function changeVelocity():void
		{
			
			if (Input.isDown(Input.KEY_RIGHT))
			{
				_dx = Constants.HERO_WALKING_SPEED;
				_anim.scaleX = -1;
			}
			else if (Input.isDown(Input.KEY_LEFT))
			{
				_dx = -(Constants.HERO_WALKING_SPEED);
				_anim.scaleX = 1;
			}
			else
			{
				_dx = 0;
			}
			
			if (_onGround && Input.isDown(Input.KEY_A))
			{
				_dy = -(Constants.HERO_JUMPING_ABILITY);
			}
			
			_dy += Constants.GRAVITY;
			_onGround = false;
		}
		
		// detecter les collisions avec les tiles statiques
		private function detectCollision():void
		{
			// =======================================================================
			// NEXT STEP_Y
			// =======================================================================
			var directionY:int = ((_dy < 0) ? -1 : 1);
			var nextY:Number = int(_posy + _dy);
			var i:int;
			
			_aabb.right = _posx + HALF_WIDTH;
			_aabb.left = _posx - HALF_WIDTH;
			_aabb.top = _posy - HEIGHT;
			_aabb.bottom = posy - 1;
			
			var nCY:Number;
			var c1:int = (_aabb.left >> 5);
			var c2:int = (_aabb.right >> 5);			

			if (directionY == 1) {
				nCY = 640;
				for ( i = _aabb.bottom >> 5 ; i < 21; i++)
				{					
					if ( _levelDat.getPixel(c1, i) > 0 || _levelDat.getPixel(c2, i) > 0 ) {
						nCY = (i << 5);
						break;
					}
				}
				
				if (nCY < nextY ) {
					nextY = nCY;
					_onGround = true;
					_dy = 5;
				}				
			}else {
				 nCY = -64;
				 
				 for ( i = _aabb.top >> 5 ; i > -1; i--)
				 {
					if ( _levelDat.getPixel(c1, i) > 0 || _levelDat.getPixel(c2, i) > 0 ) {
						nCY = ( (i + 1) << 5) + HEIGHT;
						break;
					}
				}
				
				if (nCY > nextY) {
					nextY = nCY;
					_dy = 1;
				}
			}
			
			_posy = nextY;			
			
			// =======================================================================
			// NEXT STEP_X
			// =======================================================================
			var directionX:int = ((_dx < 0) ? -1 : 1);
			var nextX:Number = int(_posx + _dx);
			
			// BB on the next posX ? ou _posX ?
			_aabb.right = nextX + HALF_WIDTH;
			_aabb.left = nextX - HALF_WIDTH;
			_aabb.top = _posy - HEIGHT;
			_aabb.bottom = _posy -1;
			
			var nCX:Number;
			var l1:int = (_aabb.top >> 5);
			var l2:int = l1 + 1;
			var l3:int = (_aabb.bottom >> 5);
			
			//var i:int;
			
			if (directionX == 1) {
				nCX = 640;
				for ( i = _aabb.right >> 5 ; i < 20; i++)
				{
					if (_levelDat.getPixel(i, l1) > 0 || _levelDat.getPixel(i, l2) > 0 || _levelDat.getPixel(i, l3) > 0) {
						nCX = (i << 5) - (HALF_WIDTH + 1);
						break;
					}
				}
				if (nCX < nextX) {
					nextX = nCX;
				}
			}else {
				nCX = 0;
				for ( i = _aabb.left >> 5 ; i > -1; i--)
				{
					if (_levelDat.getPixel(i, l1) > 0 || _levelDat.getPixel(i, l2) > 0 || _levelDat.getPixel(i, l3) > 0) {
						nCX = ( (i+1) << 5) + HALF_WIDTH; // le +1 me gene mais bon
						break;
					}
				}				
				if (nCX > nextX) {
					nextX = nCX;
				}				
			}
			
			_posx = nextX;
		}
	
	}

}