package Ludum24 
{
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	 
	public class Background2 extends Sprite
	{
		private var _dat:BitmapData
		private var _offsets:Array = new Array(new Point(), new Point());
		private var _colorT:ColorTransform;
		private var _sh:Shape = new Shape();
		private var _p:Vector.<Circle>;
		
		public function Background2( coul:Number ) 
		{
			this.touchable = false;
			_dat = new BitmapData(12, 8, false);		
			
			_p = new Vector.<Circle>(12 * 8, true);
			_colorT = new ColorTransform(3, 3, 3, 1, -256, -256, -256, 0);
			
			_sh = new Shape;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_dat.width, _dat.height, Math.PI/2);
			_sh.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [1, 1], [0, 255], matrix);
			_sh.graphics.drawRect(0, 0, _dat.width, _dat.height);
			// 
			for (var i:int = 0; i < 12*8; i++) 
			{
				var c:Circle = new Circle;
				c.x = (i % 12) * 50;
				c.y = int( i / 8) * 50;				
				c.color = coul; //  0xffffff;// int( Math.random() * 0xFFFFFF)
				_p[i] = c;
				addChild( c );				
			}			
			
			this.addEventListener(EnterFrameEvent.ENTER_FRAME, _oef );
		}
		
		private function _oef(e:EnterFrameEvent):void 
		{
			
			_dat.perlinNoise(10, 8, 3, 0, false, true, 0, true, _offsets);
			_dat.draw(_sh, null, null, BlendMode.OVERLAY);
			_dat.colorTransform(_dat.rect, _colorT );
			
			var nb:int = _p.length;
			var circle:Circle;
			for (var i:int = 0; i < nb ; i++) {
				circle = _p[i];
				circle.scaleX = circle.scaleY = (_dat.getPixel(i % _dat.width, int(i / _dat.width)) & 0xFF) / 128;
			}
			
			_offsets[0].offset(0.2, -0.1);
			_offsets[1].offset(-0.1, 0.05);			
		}
		
	}

}


import flash.display.BitmapData;
import flash.display.Shape;
import starling.display.Image;
import starling.textures.Texture;

class Circle extends Image
{
	public function Circle()
	{
		var sh:Shape = new Shape();
		sh.graphics.beginFill( 0xFFFFFF, 1 );
		sh.graphics.drawCircle(25, 25, 12.5);
		sh.graphics.endFill();
		var dat:BitmapData = new BitmapData(50, 50, true, 0x0 );
		dat.draw( sh, null, null, null, null, true);		
		super( Texture.fromBitmapData( dat, true, true ) );		
		this.pivotX = 25;
		this.pivotY = 25;
	}
}

