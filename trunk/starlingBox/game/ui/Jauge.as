package starlingBox.game.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starlingBox.game.common.SpriteExt;
	
	/*
	 * valeur, max
	 * sprite avec 2 textures
	 * couleur unie
	 * dégradé
	 * remplisage/vidage
	 * skin
	 * */
	
	// === TODO ===
	// tween vers la nouvelle valeur
	// orientation verticale ?
	
	public class Jauge
	{
		private var _max:int = 100;
		private var _min:int = 0;
		private var _value:int = 0;
		
		private var _width:int;
		private var _height:int;
		
		private var _x:int = 0;
		private var _y:int = 0;
		
		private var _sprite:SpriteExt;
		private var _rect:Rectangle;
		private var _barColors:Array = [0xFFFF00, 0xFF0000];
		private var _texture:Image;
		private var _skin:Bitmap;
		
		private var _fill:Boolean = false;
		
		public function Jauge(width:int = 100, height:int = 20, max:int = 100)
		{
			_width = width;
			_height = height;
			
			_max = max;
			
			_sprite = new SpriteExt;
			_rect = new Rectangle(0, 0, 0, height);
			
			draw();
		}
		
		// changement de valeur
		public function get value():int
		{
			return _value;
		}
		
		public function set value(val:int):void
		{
			if (val < 0)
			{
				val = 0;
			}
			if (val > _max)
			{
				val = _max;
			}
			
			_value = val;
			
			draw();
		}
		
		public function incValue(inc:int):void
		{
			value = _value + inc;
		}
		
		// propriétés
		public function get x():int
		{
			return _x;
		}
		
		public function set x(value:int):void
		{
			_x = value;
			sprite.x = _x;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function set y(value:int):void
		{
			_y = value;
			sprite.y = _y;
		}
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get sprite():Sprite
		{
			return _sprite;
		}
		
		public function get barColors():Array
		{
			return _barColors;
		}
		
		public function set barColors(value:Array):void
		{
			_barColors = value;
			_texture = null;
			
			draw();
		}
		
		public function get fill():Boolean
		{
			return _fill;
		}
		
		public function set fill(value:Boolean):void
		{
			_fill = value;
			_texture = null;
			
			draw();
		}
		
		public function get skin():Bitmap
		{
			return _skin;
		}
		
		public function set skin(value:Bitmap):void
		{
			_skin = value;
			_texture = null;
			
			draw();
		}
		
		// methodes graphiques		
		private function draw():void
		{
			// update
			if (_texture)
			{
				// Scrollrect sur le conteneur
				var r:Number = value / _max;
				if (_fill)
				{
					_rect.width = int(r * _width);
					_sprite.visible = (value > 0);
				}
				else
				{
					_rect.width = int((1 - r) * _width);
					_sprite.visible = (value < _max);
				}				
				_sprite.scrollRect = _rect;
			}
			else
			{
				// create				
				// clean la displaylist et la mémoire
				while (_sprite.numChildren)
				{
					(_sprite.getChildAt(0) as Image).texture.dispose();
					_sprite.removeChildAt(0);
				}
				
				// Barre -----------------------------
				var sh:Shape = new Shape;
				if (skin)
				{
					with (sh.graphics)
					{
						beginBitmapFill(skin.bitmapData);
						drawRect(0, 0, _width, _height);
						endFill();
					}
				}
				else
				{
					// dégradé
					if (_barColors.length == 2)
					{
						var fType:String = GradientType.LINEAR;
						var alphas:Array = [1, 1];
						var ratios:Array = [0, 255];
						var mtx:Matrix = new Matrix();
						mtx.createGradientBox(width, height, 0, 0, 0);
						var sprMethod:String = SpreadMethod.PAD;
						
						with (sh.graphics)
						{
							beginGradientFill(fType, _barColors, alphas, ratios, mtx, sprMethod);
							drawRect(0, 0, _width, _height);
							endFill();
						}
					}
					else
					{
						// flat color
						with (sh.graphics)
						{
							beginFill(_barColors[0]);
							drawRect(0, 0, _width, _height);
							endFill();
						}
					}
				}
				
				var skinBarreDat:BitmapData = new BitmapData(sh.width, sh.height, false, 0xFFFFFF);
				skinBarreDat.draw(sh);
				_texture = new Image(Texture.fromBitmapData(skinBarreDat, false, true));
				
				// --
				if (_fill)
				{
					_sprite.scrollRect = new Rectangle();
					_sprite.visible = false;
				}
				_sprite.addChild(_texture);
			}
		
		}
	
	}

}