package starlingBox.malbolge
{ 
	public class Cipher 
	{
		public static var shiftValue:Number = 6;
	
		public static function calculate(src:String):String 
		{
			var result:String = new String("");
			var charCode:Number;
			for (var i:Number = 0; i<src.length; i++) {
				charCode = src.substr(i, 1).charCodeAt(0);
				result += String.fromCharCode(charCode^shiftValue);
			}
			return result;
		}
	}
}