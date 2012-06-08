package flashjack
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starlingBox.game.common.Input;
	import starling.extensions.DynamicAtlas;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Personnage
	{
		static public const STAND:int = 0;
		static public const WALK:int = 1;
		static public const JUMP:int = 2;
		static public const FALL:int = 3;
		
		protected var _stand:MovieClip;
		protected var _walk:MovieClip;
		protected var _jump:MovieClip;
		protected var _fall:MovieClip;
		
		protected var _state:int;
		protected var _anim:MovieClip;
		
		protected var _posx:int;
		protected var _posy:int;
		protected var _dx:Number;
		protected var _dy:Number;
		protected var _onGround:Boolean;
		
		protected var _aabb:Rectangle;
		protected var _levelDat:BitmapData;
		
		protected var WIDTH:int;
		protected var HEIGHT:int;
		protected var HALF_WIDTH:int;
		protected var HALF_HEIGHT:int;
		
		public function Personnage()
		{
			
			WIDTH = 32;
			HEIGHT = 64;
			HALF_WIDTH = 16;
			HALF_HEIGHT = 32;
			
			_aabb = new Rectangle(0, 0, 32, 64);
			
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new AnimContainer, 1, 0, true, true);
			
			_stand = new MovieClip(atlas.getTextures("Stand"), 1);
			_stand.pivotX = 16;
			_stand.pivotY = 64;
			
			_walk = new MovieClip(atlas.getTextures("Walk"), 1);
			_walk.pivotX = 16;
			_walk.pivotY = 64;
			
			_jump = new MovieClip(atlas.getTextures("Stand"), 1);
			_jump.pivotX = 16;
			_jump.pivotY = 64;
			
			_fall = new MovieClip(atlas.getTextures("Stand"), 1);
			_fall.pivotX = 16;
			_fall.pivotY = 64;
			
			_anim = _stand;
			state = STAND;
			
			init();
		}
		
		protected function init():void
		{
			state = STAND;
			_posx = Constants.HERO_DEF_X;
			_posy = Constants.HERO_DEF_Y;
			_dx = .0;
			_dy = 5.0;
			_onGround = true;
		}
		
		// == PUBLIC =======================		
		
		public function set levelDat(value:BitmapData):void
		{
			_levelDat = value;
		}		
		
		public function get animation():MovieClip
		{
			return _anim;
		}
		
		public function update():void
		{
			changeVelocity();
			detectCollision();
			_anim.x = _posx;
			_anim.y = _posy;
		}
		
		public function get aabb():Rectangle
		{
			return _aabb;
		}		
		
		public function gameOver( /*motif:int = -1*/ ):void
		{
			// --
		}
		
		// == PAUSE/RESUME ================
		public function pause():void
		{
			Starling.juggler.remove(_anim);
		}
		
		public function resume():void
		{
			Starling.juggler.add(_anim);
		}		
		
		// == PRIVEE ======================		
		
		protected function get posx():int
		{
			return _posx;
		}
		
		protected function get posy():int
		{
			return _posy;
		}
		
		protected function get state():int
		{
			return _state;
		}
		
		protected function set state(value:int):void
		{
			if (value != _state)
			{
				_state = value;
				_anim.visible = false;
				Starling.juggler.remove(_anim);
				/* ************************ */
				switch (value)
				{
					case STAND: 
						_stand.x = _anim.x;
						_stand.y = _anim.y;
						_stand.scaleX = _anim.scaleX;
						_anim = _stand;
						break;
					
					case WALK: 
						_walk.x = _anim.x;
						_walk.y = _anim.y;
						_walk.scaleX = _anim.scaleX;
						_anim = _walk;
						break;
					
					case JUMP: 
						_jump.x = _anim.x;
						_jump.y = _anim.y;
						_jump.scaleX = _anim.scaleX;
						_anim = _jump;
						_anim.currentFrame = 1;
						_anim.play();
						break;
					
					case FALL: 
						_fall.x = _anim.x;
						_fall.y = _anim.y;
						_fall.scaleX = _anim.scaleX;
						_anim = _fall;
						break;
						
					default: 
						trace("State non défini");
				}
				/* ************************ */
				_anim.visible = true;
				Starling.juggler.add(_anim);
			}		
		}
		
		protected function changeVelocity():void
		{
			// setting du state			
			if (_dy < 0)
			{
				state = JUMP;
			}
			else
			{
				if (_onGround)
				{
					if (_dx == 0)
					{
						state = STAND;
					}
					else
					{
						state = WALK;
					}
				}
				else
				{
					state = FALL;
				}
			}
			
			// orientation
			if (_dx > 0)
			{
				_anim.scaleX = -1;
			}
			if (_dx < 0)
			{
				_anim.scaleX = 1;
			}
		
		}
		
		// detecter les collisions avec les tiles statiques
		protected function detectCollision():void
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
			
			if (directionY == 1)
			{
				nCY = 640;
				for (i = _aabb.bottom >> 5; i < 21; i++)
				{
					if (_levelDat.getPixel(c1, i) > 0 || _levelDat.getPixel(c2, i) > 0)
					{
						nCY = (i << 5);
						break;
					}
				}
				
				if (nCY < nextY)
				{
					nextY = nCY;
					_onGround = true;
					_dy = 5;
				}
				else
				{
					_onGround = false;
				}
			}
			else
			{
				nCY = -64;
				
				for (i = _aabb.top >> 5; i > -1; i--)
				{
					if (_levelDat.getPixel(c1, i) > 0 || _levelDat.getPixel(c2, i) > 0)
					{
						nCY = ((i + 1) << 5) + HEIGHT;
						break;
					}
				}
				
				if (nCY > nextY)
				{
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
			_aabb.bottom = _posy - 1;
			
			var nCX:Number;
			var l1:int = (_aabb.top >> 5);
			var l2:int = l1 + 1;
			var l3:int = (_aabb.bottom >> 5);
			
			//var i:int;
			
			if (directionX == 1)
			{
				nCX = 640;
				for (i = _aabb.right >> 5; i < 20; i++)
				{
					if (_levelDat.getPixel(i, l1) > 0 || _levelDat.getPixel(i, l2) > 0 || _levelDat.getPixel(i, l3) > 0)
					{
						nCX = (i << 5) - (HALF_WIDTH + 1);
						break;
					}
				}
				if (nCX < nextX)
				{
					nextX = nCX;
				}
			}
			else
			{
				nCX = 0;
				for (i = _aabb.left >> 5; i > -1; i--)
				{
					if (_levelDat.getPixel(i, l1) > 0 || _levelDat.getPixel(i, l2) > 0 || _levelDat.getPixel(i, l3) > 0)
					{
						nCX = ((i + 1) << 5) + HALF_WIDTH; // le +1 me gene mais bon
						break;
					}
				}
				if (nCX > nextX)
				{
					nextX = nCX;
				}
			}
			
			_posx = nextX;
		}
	
	}

}