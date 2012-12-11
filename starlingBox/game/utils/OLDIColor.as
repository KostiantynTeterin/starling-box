package starlingBox.game.utils 
{
	
	public interface OLDIColor 
	{
		/**
		 * 24bit Color (0xRRGGBB)
		 */
		function get value():uint;
		function set value( value_:uint ):void;
		
		/**
		 * 32bit Color (0xAARRGGBB)
		 */
		function get value32():uint;
		function set value32( value_:uint ):void;
		
		/**
		 * (Red)
		 */
		function get r():uint;
		function set r( value_:uint ):void;
		
		/**
		 * (Green)
		 */
		function get g():uint;
		function set g( value_:uint ):void;
		
		/**
		 * (Blue)
		 */
		function get b():uint;
		function set b( value_:uint ):void;
		
		/**
		 * (Alpha)
		 */
		function get a():Number;
		function set a( value_:Number ):void;
	}
	
}