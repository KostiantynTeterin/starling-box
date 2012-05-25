package screens
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjack.TileMapNiveau1;
	import starling.display.Image;
	import starling.extensions.BaseTileMap;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	public class SimulationFluides extends Screen
	{
		
		private const NB_PARTICULES:int = 500;		
		private const GRID_SIZE:int = 32;
		
		override public function SimulationFluides()
		{
			SB.console.addMessage(this, "== NIVEAU1 SCREEN ==");
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU-1 SCREEN :: BEGIN ==");			
			
			super.begin();
		}		

	}
}

class Particule
{
	
}