package Ludum24 
{
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	 
	public class Background2 extends Sprite
	{
		private var _perlin_dat:BitmapData;
		private var _offsets:Array = new Array(new Point(), new Point());
		private var _colorT:ColorTransform;
		private var _sh:Shape = new Shape();
		private var _p:Vector.<Image>;
		private var _circle_dat:BitmapData;
		private var _texure:Texture;
		
		public function Background2( coul:Number ) 
		{
			this.touchable = false;
			_perlin_dat = new BitmapData(16, 21, false);
			_p = new Vector.<Image>(16 * 21, true);
			_colorT = new ColorTransform(3, 3, 3, 1, -256, -256, -256, 0);
			_sh = new Shape;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_perlin_dat.width, _perlin_dat.height, Math.PI/2);
			_sh.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [1, 1], [0, 255], matrix);
			_sh.graphics.drawRect(0, 0, _perlin_dat.width, _perlin_dat.height);
			// --		
			var sh:Shape = new Shape();
			sh.graphics.beginFill( 0xFFFFFF, 1 );
			sh.graphics.drawCircle(20, 20, 15);
			sh.graphics.endFill();
			_circle_dat = new BitmapData(40, 40, true, 0x0 );
			_circle_dat.draw( sh, null, null, null, null, true);
			_texure = Texture.fromBitmapData( _circle_dat, true, true );
			
			// --
			var nb:int = _p.length;
			for (var i:int = 0; i < nb; i++) 
			{
				var c:Image = new Image( _texure );
				c.pivotX = c.pivotY = 20;
				c.x = (i % 16) * 40;
				c.y = int(i / 16) * 40;				
				c.color = coul; //  0xffffff;// int( Math.random() * 0xFFFFFF)
				_p[i] = c;
				addChild( c );				
			}			
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, _oef );
		}
		
		private function _oef(e:EnterFrameEvent):void 
		{
			_perlin_dat.perlinNoise(10, 8, 3, 0, false, true, 0, true, _offsets);
			_perlin_dat.draw(_sh, null, null, BlendMode.OVERLAY);
			_perlin_dat.colorTransform(_perlin_dat.rect, _colorT );
			
			var nb:int = _p.length;
			var circle:Image;
			for (var i:int = 0; i < nb ; i++) {
				circle = _p[i];
				circle.scaleX = circle.scaleY = (_perlin_dat.getPixel(i % _perlin_dat.width, int(i / _perlin_dat.width)) & 0xFF) / 128;
			}
			_offsets[0].offset(0.2, -0.1);
			_offsets[1].offset(-0.1, 0.05);			
		}
		
		public function destroy():void
		{
			this.removeEventListener(EnterFrameEvent.ENTER_FRAME, _oef); 			
			_p = null;
			_circle_dat.dispose();
			_perlin_dat.dispose();
			_texure.dispose();
			while (numChildren) removeChildAt(0);			
		}
		
	}

}
