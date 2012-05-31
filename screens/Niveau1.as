package screens
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flashjack.TileMapNiveau1;
	import starling.display.Image;
	import starling.extensions.BaseTileMap;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starlingBox.SoundBox;
	
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
			
			var snd:Sound = new Sound( new URLRequest("http://yopsolo.fr/ressources/gees_tacatac_44100.mp3"), new SoundLoaderContext() );
			var sc:SoundChannel = snd.play();
			sc.soundTransform = new SoundTransform(.05);			
		}		

	}

}