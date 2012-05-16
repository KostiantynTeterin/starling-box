package flashjack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
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
		
		public function Hero()
		{
			/*
			   var texture:Texture = Texture.fromBitmap(new SpriteSheet() as Bitmap, true, true);
			   var xml:XML = XML(new SpriteSheetXML);
			
			   var tAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			   _stand = new MovieClip(tAtlas.getTextures("stand"), 15);
			   _stand.pivotX = 35;
			   _stand.pivotY = 188;
			   _walk = new MovieClip(tAtlas.getTextures("walk"), 15);
			   _walk.pivotX = 35;
			   _walk.pivotY = 187;
			 */
			
			state = STAND;
			
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new AnimContainer, 1, 0, true, true);
			
			_stand = new MovieClip(atlas.getTextures("Stand"), 15);
			_stand.pivotX = 16;
			_stand.pivotY = 32;
			
			_walk = new MovieClip(atlas.getTextures("Walk"), 15);
			_walk.pivotX = 32;
			_walk.pivotY = 64;
			
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
		
		public function update( map:BaseTileMap ):void
		{
			changeVelocity();
			detectCollision( map );
			//adjustDisplayPosition();
		
			//_anim.x = _posx;
			//_anim.y = _posy;
			/*
			   if (_posy > WonderflWorld.MAP_HEIGHT + Plumber.HALF_HEIGHT) {
			   initialize();
			   }
			*/
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
		
		private function detectCollision(map:BaseTileMap):void
		{
			var directionX:int = ((_dx < 0) ? -1 : 1);
			var directionY:int = ((_dy < 0) ? -1 : 1);
			
			var nextX:int = int(_posx + _dx);
			var nextY:int = int(_posy + _dy);
			
			// [HERE]
			/*
			var edgeNextXGrid:Point = map.getGridFromPosition(nextX + (directionX * Plumber.HALF_WIDTH), nextY);
			var edgeNextYGrid:Point = map.getGridFromPosition(nextX, nextY + (directionY * Plumber.HALF_HEIGHT));
			var edgeNextXYGrid:Point = map.getGridFromPosition(nextX + (directionX * Plumber.HALF_WIDTH), nextY + (directionY * Plumber.HALF_HEIGHT));
			
			if (map.model[edgeNextXGrid.y][edgeNextXGrid.x].isSolid())
			{
				_posx = Math.floor(_posx / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE + ((directionX == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_WIDTH) : Plumber.HALF_WIDTH);
				_dx = 0;
			}
			
			if (map.model[edgeNextYGrid.y][edgeNextYGrid.x].isSolid())
			{
				_posy = Math.floor(_posy / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE + ((directionY == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_HEIGHT) : Plumber.HALF_HEIGHT);
				_dy = 0;
				
				if (directionY == 1)
				{
					_onGround = true;
				}
			}
			
			if ((_dx != 0 && _dy != 0) && map.model[edgeNextXYGrid.y][edgeNextXYGrid.x].isSolid())
			{
				_posx = Math.floor(_posx / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE + ((directionX == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_WIDTH) : Plumber.HALF_WIDTH);
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
			*/
		}
	
	}

}