package screens
{
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flashjack.FlyingMine;
	import flashjack.TileMapNiveau1;
	import flashjack.Tracker;
	import starlingBox.SB;
	import starlingBox.SoundBox;
	
	public class Niveau1 extends BaseNiveau	
	{
		override public function Niveau1()
		{
			SB.console.addMessage(this, "== NIVEAU1 SCREEN ==");
			
			tilemap = new TileMapNiveau1;
			ennemis[0] = new FlyingMine(int(32 * 9.5), int(32 * 2.5));
			ennemis[1] = new FlyingMine(int(32 * 3.5), int(32 * 9.5));
			ennemis[2] = new Tracker(int(32 * 15), int(32 * 5));
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU-1 SCREEN :: BEGIN ==");			
			
			super.begin();
			
			SB.soundBox.addRessource( new Sound( new URLRequest("http://yopsolo.fr/ressources/gees_tacatac_44100.mp3"), new SoundLoaderContext() ), SoundBox.BGM1 );
			SB.soundBox.setBGMVolume( .5 );
			SB.soundBox.playBGM();
		}
	}
}