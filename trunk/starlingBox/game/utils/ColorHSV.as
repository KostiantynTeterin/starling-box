package starlingBox.game.utils 
{
	
	public class ColorHSV implements IColor
	{
		
		private var _h:Number;	//Hue
		private var _s:Number;	//Saturation
		private var _v:Number;	//Value | Brightness
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
		private var _a:Number;
		private var update_flg:Boolean;
		
		/**
		 * ColorHSV
		 * 
		 * @param	h_	Hue (degree 360)
		 * @param	s_	Saturation [0.0,1.0]
		 * @param	v_	Brightness [0.0,1.0]
		 * @param	a	Alpha [0.0,1.0]
		 */
		public function ColorHSV( h_:Number=0.0, s_:Number = 1.0, v_:Number = 1.0, a:Number = 1.0  ) 
		{
			hsv( h_, s_, v_ );
			_a = a;
		}
		
		/**
		 * 
		 */
		public function clone():ColorHSV
		{
			return new ColorHSV( _h, _s, _v, _a );
		}
		
		//------------------------------------------------------------------------------------------------------------------- Value
		
		/**
		 * 24bit Color (0xRRGGBB)
		 */
		public function get value():uint
		{
			if ( update_flg ) update();
			return _r << 16 | _g << 8 | _b;
		}
		public function set value( value_:uint ):void
		{
			_r = value_ >> 16 & 0xff;
			_g = value_ >> 8 & 0xff;
			_b = value_ & 0xff;
			update_hsv();
		}
		
		/**
		 * 32bit Color (0xAARRGGBB) を示します.
		 */
		public function get value32():uint
		{
			if ( update_flg ) update();
			return a8<<24 | _r << 16 | _g << 8 | _b ;
		}
		public function set value32( value_:uint ):void
		{
			_r = value_ >> 16 & 0xff;
			_g = value_ >> 8 & 0xff;
			_b = value_ & 0xff;
			_a = ( value_ >>> 24 ) / 0xff;
			update_hsv();
		}
		
		//------------------------------------------------------------------------------------------------------------------- Alpha
		
		/**
		 * (Alpha) 0.0 .. 1.0
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
		public function get r():uint
		{
			if ( update_flg ) update();
			return _r;
		}
		public function set r( value_:uint ):void
		{
			_r = value_ & 0xff;
			update_hsv();
		}
		
		/**
		 * (Green) 0 .. 255
		 */
		public function get g():uint
		{
			if ( update_flg ) update();
			return _g;
		}
		public function set g( value_:uint ):void
		{
			_g = value_ & 0xff;
			update_hsv();
		}
		
		/**
		 * (Blue) 0 .. 255
		 */
		public function get b():uint
		{
			if ( update_flg ) update();
			return _b;
		}
		public function set b( value_:uint ):void
		{
			_b = value_ & 0xff;
			update_hsv();
		}
		
		//------------------------------------------------------------------------------------------------------------------- HSV
		
		/**
		 * (Hue) 0 .. 360
		 */
		public function get h():Number { return _h; }
		public function set h( value_:Number ):void
		{
			_h = value_;
			update_flg = true;
		}
		/**
		 * (Hue) 0..2PI
		 */
		public function get hr():Number { return Math.PI*_h / 180; }
		public function set hr( value_:Number ):void
		{
			_h = 180*value_/Math.PI;
			update_flg = true;
		}
		
		/**
		 * (Saturation) 0.0 .. 1.0
		 */
		public function get s():Number { return _s; }
		public function set s( value_:Number ):void
		{
			_s = Math.max( 0.0, Math.min( 1.0, value_ ) );
			update_flg = true;
		}
		
		/**
		 * Brightness 0.0 .. 1.0
		 */
		public function get v():Number { return _v; }
		public function set v( value_:Number ):void
		{
			_v = Math.max( 0.0, Math.min( 1.0, value_ ) );
			update_flg = true;
		}
		
		//------------------------------------------------------------------------------------------------------------------- SET
		
		/**
		 * HSV
		 * @param	h_	Hue (degree 360)
		 * @param	s_	Saturation [0.0,1.0]
		 * @param	v_	Brightness [0.0,1.0]
		 */
		public function hsv( h_:Number, s_:Number = 1.0, v_:Number = 1.0 ):void
		{
			_h = h_;
			_s = Math.max( 0.0, Math.min( 1.0, s_ ) );
			_v = Math.max( 0.0, Math.min( 1.0, v_ ) );
			update_flg = true;
		}
		
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
			update_hsv();
		}
		
		/**
		 * @param	gray_	Gray [0,255]
		 */
		public function gray( gray_:uint ):void
		{
			_h = 0.0;
			_s = 0.0;
			_v = _r = _g = _b = gray_ / 0xff;
		}
		
		//------------------------------------------------------------------------------------------------------------------- CONVERT
		
		/**
		 * HSV 2 RGB, return ColorRGB
		 */
		public function toRGB():ColorRGB
		{
			if ( update_flg ) update();
			return new ColorRGB( _r, _g, _b, _a );
		}
		
		//------------------------------------------------------------------------------------------------------------------- update
		
		/**
		 * @private
		 */
		private function update():void
		{
			if ( _s == 0 )
			{
				_r = _g = _b = Math.round( _v * 0xff );
			}
			else
			{
				var ht:Number = _h;
				ht = (((ht %= 360) < 0) ? ht + 360 : ht )/60;
				var vt:Number = Math.max( 0, Math.min( 0xff, _v*0xff ) );
				var hi:int = Math.floor( ht );
				
				switch( hi )
				{
					case 0:
						_r = vt;
						_g = Math.round( vt * ( 1 - (1 - ht + hi) * _s ) );
						_b = Math.round( vt * ( 1 - _s ) );
						break;
					case 1:
						_r = Math.round( vt * ( 1 - _s * ht + _s * hi ) );
						_g = vt;
						_b = Math.round( vt * ( 1 - _s ) );
						break;
					case 2:
						_r = Math.round( vt * ( 1 - _s ) );
						_g = vt;
						_b = Math.round( vt * ( 1 - (1 - ht + hi) * _s ) );
						break;
					case 3:
						_r = Math.round( vt * ( 1 - _s ) );
						_g = Math.round( vt * ( 1 - _s * ht + _s * hi ) );
						_b = vt;
						break;
					case 4:
						_r = Math.round( vt * ( 1 - (1 - ht + hi) * _s ) );
						_g = Math.round( vt * ( 1 - _s ) );
						_b = vt;
						break;
					case 5:
						_r = vt;
						_g = Math.round( vt * ( 1 - _s ) );
						_b = Math.round( vt * ( 1 - _s * ht + _s * hi ) );
						break;
				}
			}
			update_flg = false;
		}
		
		/**
		 * @private
		 */
		private function update_hsv():void
		{
			var max:Number = Math.max( _r , Math.max( _g, _b ) );
			var min:Number = Math.min( _r , Math.min( _g, _b ) );
			var mm:Number  = max - min;
			
			if ( mm == 0 )
			{
				_h = 0;
				_s = 0;
				_v = max / 0xff;
			}
			else
			{
				_s = mm / max;
				_v = max / 0xff;
				if ( _r == max )
					_h = 60 * ( _g - _b ) / mm;
				else if ( _g == max )
					_h = 60 * ( _b - _r ) / mm + 120;
				else
					_h = 60 * ( _r - _g ) / mm + 240;
			}
			update_flg = false;
		}
		
		//---------------------------------------------------------------------------------------------------STRING, VALUE
		
		public function toString():String 
		{
			return "[HSV(" + _h.toFixed(2) + "," + _s.toFixed(2) + "," + _v.toFixed(2) + ")A("+ _a.toFixed(2)+")]";
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