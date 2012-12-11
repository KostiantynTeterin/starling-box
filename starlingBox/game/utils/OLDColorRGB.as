package starlingBox.game.utils 
{
	
	public class OLDColorRGB implements IColor
	{	
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		private var _a:Number;
		
		/**
		 * ColorRGB
		 * 
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 * @param	a_	Alpha [0,1]
		 */
		public function OLDColorRGB( r:uint=0, g:uint=0, b:uint=0, a:Number=1.0 )
		{
			rgb( r, g, b );
			_a = a;
		}
		
		/**
		 * 
		 */
		public function clone():ColorRGB
		{
			return new ColorRGB( _r, _b, _b, _a );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Value
		
		/**
		 * 24bit Color (0xRRGGBB)
		 */
		public function get value():uint { return _r << 16 | _g << 8 | _b; }
		public function set value( value_:uint ):void
		{
			_r = value_ >> 16 & 0xff;
			_g = value_ >> 8 & 0xff;
			_b = value_ & 0xff;
		}
		
		/**
		 * 32bit Color (0xAARRGGBB)
		 */
		public function get value32():uint { return a8 << 24 | _r << 16 | _g << 8 | _b ; }
		public function set value32( value_:uint ):void
		{
			_r = value_ >> 16 & 0xff;
			_g = value_ >> 8 & 0xff;
			_b = value_ & 0xff;
			_a = ( value_ >>> 24 ) / 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- Alpha
		
		/**
		 * 
		 * 
		 */
		public function get a():Number { return _a; }
		public function set a(value_:Number):void
		{
			_a = value_;
		}
		
		private function get a8():uint
		{
			return Math.round( _a * 0xff ) & 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- RGB
		
		/**
		 * (Red) 0 .. 255
		 */
		public function get r():uint { return _r; }
		public function set r( value_:uint ):void
		{
			_r = value_ & 0xff;
		}
		
		/**
		 * (Green) 0 .. 255
		 */
		public function get g():uint { return _g; }
		public function set g( value_:uint ):void
		{
			_g = value_ & 0xff;
		}
		
		/**
		 * (Blue) 0 .. 255
		 */
		public function get b():uint { return _b; }
		public function set b( value_:uint ):void
		{
			_b = value_ & 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * RGB
		 * @param	r_	Red [0,255]
		 * @param	g_	Green [0,255]
		 * @param	b_	Blue [0,255]
		 */
		public function rgb( r_:uint, g_:uint, b_:uint ):void
		{
			_r = r_ & 0xff;
			_g = g_ & 0xff;
			_b = b_ & 0xff;
		}
		
		/**
		 * @param	gray_	Gray [0,255]
		 */
		public function gray( gray_:uint ):void
		{
			_r = _g = _b = gray_ & 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- CONVERT
		
		/**
		 * RGB 2 HSV return ColorHSV
		 */
		public function toHSV():ColorHSV
		{
			var c:ColorHSV = new ColorHSV();
			c.rgb( _r, _g, _b );
			c.a = _a;
			return c;
		}
		
		//------------------------------------------------------------------------------------------------------------------- STRING, VALUE
		
		public function toString():String 
		{
			return "[RGB(" + _r + "," + _g + "," + _b + ")A("+ _a.toFixed(2)+")]";
		}
		
		/**
		 * @return 0xRRBBGG
		 */
		public function valueOf():uint 
		{
			return value;
		}
	}
	
}