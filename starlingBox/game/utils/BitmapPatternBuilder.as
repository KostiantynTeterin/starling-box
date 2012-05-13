package starlingBox.game.utils
{
	import flash.display.BitmapData;
	    
	public class BitmapPatternBuilder
	{
	    /**
	     *
	     * @parameter pattern:array, pixels position and color index.
	     * @parameter colors:arrray, colors.
	     * @returns BitmapData		
		 * 
		 * var colors:Array = [0xFF000000, 0xFFFFFFFF];
		 * var pattern:BitmapData = build(BitmapPatternBuilder.HORIZONTAL, colors);
		 * 
		 * */
	    public static function build(pattern:Array, colors:Array):BitmapData
		{
			var bitmapW:int = pattern[0].length;			
			var bitmapH:int = pattern.length;
			var bmd:BitmapData = new BitmapData(bitmapW, bitmapH, true, 0x00000000);			
			for (var yy:int = 0; yy < bitmapH; yy++) {				
				for (var xx:int = 0; xx < bitmapW; xx++) {
					var color:int = colors[pattern[yy][xx]];
					bmd.setPixel32(xx, yy, color);
				}
			}
			
			return bmd;		
	    }
		
		
		// -- pattern		
		public static const HORIZONTAL:Array = [
		[1],
		[0]
		];
		
		public static const VERTICAL:Array = [
		[1, 0]
		];
		
		public static const DIAGONAL_3x3:Array = [
		[1, 0, 0],
		[0, 0, 1],
		[0, 1, 0]
		];		
		
		public static const DIAGONAL_4x4:Array = [
		[0, 1, 0, 0],		
		[1, 0, 0, 0],		
		[0, 0, 0, 1],
		[0, 0, 1, 0],		
		];
		
		public static const STAR_5x5:Array = [
		[0, 0, 0, 0, 0],				
		[0, 0, 1, 0, 0],				
		[0, 1, 0, 1, 0],		
		[0, 0, 1, 0, 0],		
		[0, 0, 0, 0, 0]		
		];		
		
		public static const SQUARE_5x5:Array = [
		[0, 1, 0, 1, 0],				
		[1, 1, 0, 1, 1],				
		[0, 0, 0, 0, 0],		
		[1, 1, 0, 1, 1],		
		[0, 1, 0, 1, 0]		
		];	
		
		public static const CIRCLE_5x5:Array = [
		[0, 0, 1, 0, 0],				
		[0, 1, 0, 1, 0],				
		[1, 0, 0, 0, 1],		
		[0, 1, 0, 1, 0],		
		[0, 0, 1, 0, 0]		
		];			
		
		public static const WAVE_5x5:Array = [
		[0, 0, 0, 0, 0],				
		[0, 1, 0, 0, 0],				
		[0, 0, 0, 0, 0],		
		[0, 0, 0, 1, 0],		
		[1, 0, 0, 0, 0]		
		];			
		
		public static const GRID_5x5:Array = [
		[1, 0, 0, 0, 1],				
		[0, 1, 0, 1, 0],				
		[0, 0, 1, 0, 0],		
		[0, 1, 0, 1, 0],		
		[1, 0, 0, 0, 1]		
		];		
		
		//... create your custom patterns here...
	}
}