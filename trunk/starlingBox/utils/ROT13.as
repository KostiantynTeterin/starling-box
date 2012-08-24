package starlingBox.utils
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class ROT13 
	{
		private static const ROT13_CHARS : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMabcdefghijklmnopqrstuvwxyzabcdefghijklm";
		public function ROT13() { }
		
		public static function calculate(src : String) : String {
				var calculated : String = new String( "" );
				var nb:int = src.length;
				for (var i : Number = 0; i < nb ; i++) {
						var character : String = src.charAt( i );
						var pos : Number = ROT13_CHARS.indexOf( character );
						if (pos > -1) character = ROT13_CHARS.charAt( pos + 13 );
						calculated += character;
				}
				return calculated;
		}		
		
	}

}