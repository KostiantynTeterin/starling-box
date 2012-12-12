package starlingBox.game.utils
{
	import flash.display.BitmapData;
	import starlingBox.color.ColorRGB;
	
	public class XORTexture extends BitmapData	{
		
		public function XORTexture(width:int, height:int, coul:uint) 
		{
			super(width, height, false, 0x0);
			
			for ( var w:int = 0 ; w < width; w++ ) 
			{
				for ( var h:int = 0 ; h < height ; h++ ) 
				{
					var coul256:uint = w ^ h;					
					var red:int = Math.max( (coul >> 16 & 0xff) - coul256, 0);					
					var green:int = Math.max( (coul >> 8 & 0xff) - coul256, 0 );					
					var blue:int = Math.max( (coul & 0xff) - coul256, 0 );
					
					this.setPixel( w, h, new ColorRGB( red, green, blue).value );
				}
			}
			
		}
		
	}
	
}