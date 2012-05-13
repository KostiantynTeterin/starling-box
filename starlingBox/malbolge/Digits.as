package starlingBox.malbolge
{
	public class Digits
	{
		private var Fragment:Number;
		private var Sibling:Digits;
		private var Encoder:Number;
		
		public function Digits( digit:Number, index:Number=0 )
		{
			Encoder = 0;
			setValue( digit, index );
		}

		public function get value():Number
		{
			return Number(this.toString());
		}

		public function set value(v:Number):void
		{
			setValue( v );
		}

		/**
		 * Method: add
		 * Increments the stored value by a specified amount
		 * @param   inc: Value to add to the stored variable
		 */
		public function addValue(v:Number):void
		{
			this.value += v;
		}

		/**
		 * Method: setValue
		 * Resets the stored value
		 * @param   digit: initialization value
		 * @param   index: internal use only
		 */
		public function setValue( digit:Number, index:Number=0 ):void
		{
			var s:String = digit.toString();

			if( isNaN(index) )
				index = 0;

			Fragment = s.charCodeAt(index++) ^ Encoder;

			if( index < s.length )
				Sibling = new Digits(digit,index);
			else
				Sibling = null;

			reencode();
		}

		/**
		 * Method: reencode
		 * Reencodes the stored number without changing its value
		 */
		public function reencode():void
		{
			var newEncode:Number = int(0x7FFFFFFF * Math.random());

			Fragment ^= newEncode ^ Encoder;
			Encoder = newEncode;
		}

		/**
		 * Method: toString
		 * Returns the stored number as a formatted string
		 */
		public function toString():String
		{
			var s:String = String.fromCharCode(Fragment ^ Encoder);

			return ( Sibling != null ) ? s.concat(Sibling.toString()) : s;
		}
	}
}