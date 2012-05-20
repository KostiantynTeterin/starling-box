package flashjack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
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
	 * ...
	 * @author YopSolo
	 *
	 * todo, une methode de bounding box
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
		
		private var _collisionMap:BitmapData;
		
		public function Hero()
		{
			state = STAND;
			
			var texture:Texture = Texture.fromBitmap(new SpriteSheet() as Bitmap, true, true);
			var xml:XML = XML(new SpriteSheetXML);

			var tAtlas:TextureAtlas = new TextureAtlas(texture, xml);

			_stand = new MovieClip(tAtlas.getTextures("stand"), 15);
			_stand.pivotX = 35;
			_stand.pivotY = 188 - 32;
			_walk = new MovieClip(tAtlas.getTextures("walk"), 15);
			_walk.pivotX = 35;
			_walk.pivotY = 187 - 32;
			
			
			
			
			/*
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new AnimContainer, 1, 0, true, true);
			
			_stand = new MovieClip(atlas.getTextures("Stand"), 15);
			_stand.pivotX = 16;
			_stand.pivotY = 32;
			
			_walk = new MovieClip(atlas.getTextures("Walk"), 15);
			_walk.pivotX = 16;
			_walk.pivotY = 32;
			*/
			
			init();
		}
		
		public function init():void
		{
			_posx = Constants.HERO_DEF_X;
			_posy = Constants.HERO_DEF_Y;
			_dx = 0;
			_dy = 0;
			_onGround = false;
		}
		
		public function set collisionMap(value:BitmapData):void
		{
			_collisionMap = value;
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
			
			_state = value;
			
			switch (_state)
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
			}
			else if (Input.isDown(Input.KEY_LEFT))
			{
				_dx = -(Constants.HERO_WALKING_SPEED);
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
		
		private function detectCollision():void
		{
			var directionX:int = ((_dx < 0) ? -1 : 1);
			var directionY:int = ((_dy < 0) ? -1 : 1);
			
			var nextX:int = int(_posx + _dx);
			var nextY:int = int(_posy + _dy);
			
			var edgeNextXGrid:Number = _collisionMap.getPixel((nextX + (directionX * 16)) >> 5, nextY >> 5);
			var edgeNextYGrid:Number = _collisionMap.getPixel(nextX >> 5, (nextY + (directionY * 31)) >> 5);
			var edgeNextXYGrid:Number = _collisionMap.getPixel((nextX + (directionX * 16)) >> 5, (nextY + (directionY * 31)) >> 5);
			
			if (edgeNextXGrid > 0)
			{
				_posx = int(_posx / 32) * 32 + ((directionX == 1) ? (32 - 16) : 16);
				_dx = 0;
			}
			
			if (edgeNextYGrid > 0)
			{
				// _posY = 
				_dy = 0;
				
				if (directionY == 1)
				{
					_onGround = true;
				}
			}
			
			if ((_dx != 0 && _dy != 0) && edgeNextXYGrid > 0)
			{
				_posx = int(_posx / 32) * 32 + ((directionX == 1) ? (32 - 16) : 16);
				_dx = 0;
			}
			
			if (_dx != 0)
			{
				_posx = nextX;
			}
			
			if (_dy != 0)
			{
				_posy = nextY;
			}
		}
	
	}

}

/*
package flashjack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
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
		
		private var jumping:Boolean;
		private var falling:Boolean;
		private var walking:Boolean;
		
		private const tile_size:int = 32;
		private var _collisionMap:BitmapData;
		
		private var left:int;
		private var right:int;
		private var top:int;
		private var bottom:int;
		private var top_right:int;
		private var top_left:int
		private var bottom_left:int;
		private var bottom_right:int;
		
		public function Hero()
		{
			state = STAND;
			
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new AnimContainer, 1, 0, true, true);
			_stand = new MovieClip(atlas.getTextures("Stand"), 15);
			_stand.pivotX = 16;
			_stand.pivotY = 32;
			
			_walk = new MovieClip(atlas.getTextures("Walk"), 15);
			_walk.pivotX = 16;
			_walk.pivotY = 32;
			
			init();
		}
		
		public function init():void
		{
			_posx = Constants.HERO_DEF_X;
			_posy = Constants.HERO_DEF_Y;
			_dx = 0;
			_dy = 0;
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
			
			_state = value;
			
			switch (_state)
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
		
		public function set collisionMap(value:BitmapData):void
		{
			_collisionMap = value;
		}
		
		public function update():void
		{
			ground_under_feet();
			walking = false;
			changeVelocity();
			detectCollision();
			
			_anim.x = _posx;
			_anim.y = _posy;
		}
		
		public function ground_under_feet():void
		{
			// [OPTIM] en faire un rect			
			var left_foot_x:int = int((_posx - 16) / tile_size); // ok taille du hero dans la tile, cool
			var right_foot_x:int = int((_posx + 15) / tile_size);
			var foot_y:int = int((_posy + 31) / tile_size);
			
			var current_tile:int;
			var left_foot:int = _collisionMap.getPixel(left_foot_x, foot_y);
			var right_foot:int = _collisionMap.getPixel(right_foot_x, foot_y);
			if (left_foot > 0)
			{
				current_tile = left_foot;
			}
			else
			{
				current_tile = right_foot;
			}
			
			if (current_tile == 0)
			{
				falling = true;
			}
		
		}
		
		private function changeVelocity():void
		{
			
			if (Input.isDown(Input.KEY_RIGHT))
			{
				_dx = Constants.HERO_WALKING_SPEED;
				walking = true;
			}
			else if (Input.isDown(Input.KEY_LEFT))
			{
				_dx = -(Constants.HERO_WALKING_SPEED);
				walking = true;
			}
			else
			{
				_dx = 0;
			}
			
			if (Input.isDown(Input.KEY_A))
			{
				get_edges();
				if (!falling && !jumping)
				{
					jumping = true;
					_dy = -(Constants.HERO_JUMPING_ABILITY);
				}
			}
			
			if (falling || jumping)
			{
				_dy += Constants.GRAVITY;
			}
		}
		
		private function detectCollision():void
		{
			_posy += _dy;
			get_edges();			
			
			// tombe
			if (_dy > 0)
			{
				if (bottom_right > 0 || bottom_left > 0)
				{
					_dy = 0;
					falling = false;
					jumping = false;					
					_posy = bottom * tile_size - 31;					
				}
			}
			
			// monte
			if (_dy < 0)
			{
				if ( top_right > 0 || top_left > 0 )
				{
					_posy = bottom * tile_size + 1 + 32;
					_dy = 0;
					falling = false;
					jumping = false;
				}
			}
			
			
			_posx += _dx;
			get_edges();
			
			if (_dx < 0)
			{
				if ( top_left > 0 ||  bottom_left > 0 )
				{
					_posx = (left + 1) * tile_size + 15;
					_dx = 0;
				}
			}
			
			if (_dx > 0)
			{
				if ( top_right > 0 || bottom_right > 0)
				{
					_posx = right * tile_size - 16;
					_dx = 0;
				}
			}
		}
		
		public function get_edges():void
		{
			right = int((_posx + 15) / tile_size);
			left = int((_posx - 16) / tile_size);
			bottom = int((_posy + 31) / tile_size);
			top = int((_posy - 32) / tile_size);
			
			top_right = _collisionMap.getPixel(right, top);
			top_left = _collisionMap.getPixel(left, top);
			bottom_left = _collisionMap.getPixel(left, bottom);
			bottom_right = _collisionMap.getPixel(right, bottom);
		}
	
	}

}
*/