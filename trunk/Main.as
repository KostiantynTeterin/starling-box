package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import flash.net.URLRequest;
	import Ludum24.EndScreenLD24;
	import Ludum24.Evo;
	import Ludum24.TitleScreenLD24;
	import rectpacking.Rectpacking;
	import screens.FlashJack;
	import screens.Intro;
	import screens.Jeu;
	import screens.BaseNiveau;
	//import screens.Keos_GuildScreen;
	//import screens.KeoS_TitleScreen;
	import screens.SimulationFluides;
	import typewriter.TypeWriterTest
	import starling.display.Sprite;
	import starlingBox.ConfigXML;
	import starlingBox.SB;
	import screens.Niveau1;
	import screens.TitleScreenFlashJack;
	//import KeoS.Config;
	
	
	/**
	 * * * TODO STARLING BOX * * *
	 * deplacer les assets du jeu dans une classe assets
	 * tester le system.pause et le system.resume
	 * starling.start(); ou starling.stop(); 
	 * gerer le added dans les screen
	 * verifier que la displaylist ne monte pas
	 * faire un flash de transition entre 2 screen
	 * une phase d'initialisation avec un loader le temps que les objets soient crées
	 * pb de pause/reprise d'un son avec le SM
	 * integration de nape avec le juggler de starling
	 * passer du monocle
	 * 
	 * * * TODO ALIEN FLEET >> QUANTIC HATE * * *
	 * un ecran titre pour mettre ce todo ^^
	 * 
	 * * * CONTROLE TACTILE * * *
	 * creer un joy tactile (en cours)
	 * 
	 */	
	 
	public class Main extends Sprite
	{
		public function Main() 
		{
			SB.root		= this;
			
			SB.screen	= new Rectpacking;
			
			//SB.screen	= new Keos_GuildScreen;
			//SB.screen	= new Niveau1;
			//SB.screen	= new TitleScreenFlashJack;			
			//SB.screen = new Jeu;
			
			//SB.screen = new TitleScreenLD24;
			//SB.screen = new TypeWriterTest;			
			// output
			// ..\..\WebLocal\Lockpickers\assets\swf\Lockpickers.swf
			// 995 * 665
			// external command
			// iexplore.exe http://127.0.0.1/lockpickers/index.php?local
			
			/*
			Config.LANG = SB.flashvar("lang", "FR");
			ConfigXML.instance.loadDatas( '/lockpickers/assets/lang/'+Config.LANG+'.xml' );
			ConfigXML.instance.addEventListener(Event.COMPLETE, _onDataComplete, false, 0, true);
			ConfigXML.instance.addEventListener(Event.CLOSE, _onDataError, false, 0, true);			
			*/
		}
		
		private function _onDataComplete(e:Event):void 
		{
			e.stopImmediatePropagation();
			//SB.screen	= new KeoS_TitleScreen;
		}
		
		private function _onDataError(e:Event):void 
		{
			e.stopImmediatePropagation();			
		}
	}

}