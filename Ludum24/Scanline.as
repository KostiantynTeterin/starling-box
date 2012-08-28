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
		private var dat:BitmapData;
		
		public function Scanline( type:int = -1 ) 
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
			var ran:int;
			if (type < 0) {
				ran = int( Math.random() * patternList.length )
			}else {
				ran = type;
			}
			var pattern:BitmapData = BitmapPatternBuilder.build( patternList[ran], [0x00000000, 0xFF222222] );
			var sh:Shape = new Shape();
			sh.graphics.beginBitmapFill( pattern );
			sh.graphics.drawRect(0, 0, 601, 801);
			sh.graphics.endFill();
			dat = new BitmapData( 601, 801, true, 0x0 );
			dat.draw( sh );
			super( Texture.fromBitmapData( dat, false, true ) );
			dat.dispose();	
			// --
			this.blendMode = BlendMode.ADD;
		}
		
		public function destroy():void
		{
			this.texture.dispose();
		}
		
	}

}