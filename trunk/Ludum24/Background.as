package Ludum24 
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Background extends Image 
	{
		private var _coul:uint;
		// build my background
		public function Background( pColor:Number ) 
		{
			this.touchable = false;
			
            var back:BitmapData = new BitmapData(275, 200, false, 0xffffff);
            back.perlinNoise(275, 200, 9, new Date().getTime(), false, true, 7, true);
            back.colorTransform(back.rect, new ColorTransform(1, 1, 1, 1, 100, 100, 100, 0));
            var grad:Shape = new Shape();
			if ( pColor > 0 ) {
				_coul = pColor;
			}else {
				_coul = int(Math.random() * 0xFFFFFF);
			}
			
            grad.graphics.beginGradientFill(GradientType.RADIAL, [ _coul , 0x000000], [1, 1], [0, 255], new Matrix(0.6, 0, 0, 0.6, 232.5, 232.5));
            grad.graphics.drawRect(0, 0, 275, 200);
            back.draw(grad, null, null, BlendMode.MULTIPLY);
			super( Texture.fromBitmapData( back, true, true, 1 ) );
			this.scaleX = this.scaleY = 2;
		}
		
		public function get coul():uint 
		{
			return _coul;
		}
		
	}

}