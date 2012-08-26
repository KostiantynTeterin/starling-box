package Ludum24 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.textures.Texture;
	import starlingBox.game.utils.BitmapPatternBuilder;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Scanline extends Image 
	{
		
		public function Scanline() 
		{
			/*
			var sh:Shape = new Shape();
			sh.graphics.lineStyle( 1, 0x0, 1 );			
			for (var i:int = 1 ; i < 400 ; i+=2 ) {
				sh.graphics.moveTo( 0, i );
				sh.graphics.lineTo( 550, i );
			}
			var dat:BitmapData = new BitmapData(550, 400, true, 0x0);			
			dat.draw( sh )
			*/
			var patternList:Array = [BitmapPatternBuilder.VERTICAL, BitmapPatternBuilder.HORIZONTAL, BitmapPatternBuilder.DIAGONAL_4x4, BitmapPatternBuilder.WAVE_5x5, BitmapPatternBuilder.STAR_5x5];
			var pattern:BitmapData = BitmapPatternBuilder.build( patternList[int( Math.random() * patternList.length )], [0x00000000, 0xFF333333] );
			var sh:Shape = new Shape();
			sh.graphics.beginBitmapFill( pattern );
			sh.graphics.drawRect(0, 0, 551, 401);
			sh.graphics.endFill();
			var dat:BitmapData = new BitmapData( 551, 401, true, 0x0 );
			dat.draw( sh );
			super( Texture.fromBitmapData( dat, false, true ) );
			// --
			this.blendMode = BlendMode.ADD;
		}
		
	}

}