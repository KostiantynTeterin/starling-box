package screens
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flashjack.TileMapNiveau1;
	import starling.display.Image;
	import starling.extensions.BaseTileMap;
	import starling.textures.Texture;
	import starlingBox.SB;
	
	public class Niveau1 extends BaseNiveau	
	{
		
		override public function Niveau1()
		{
			SB.console.addMessage(this, "== NIVEAU1 SCREEN ==");
			
			tilemap = new TileMapNiveau1;
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU-1 SCREEN :: BEGIN ==");			
			
			super.begin();			
		}		

	}

}