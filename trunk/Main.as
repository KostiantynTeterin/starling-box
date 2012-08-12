package
{
	import alienfleet.StarField;
	import flash.events.Event;
	import flash.net.URLRequest;
	import screens.FlashJack;
	import screens.Intro;
	import screens.Jeu;
	import screens.BaseNiveau;
	import screens.Keos_GuildScreen;
	import screens.KeoS_TitleScreen;
	import screens.SimulationFluides;
	import starling.display.Sprite;
	import starlingBox.ConfigXML;
	import starlingBox.SB;
	import screens.Niveau1;
	import screens.TitleScreenFlashJack;
	import KeoS.Config;
	
	
	/**
	 * console debug
	 * ui : jauge
	 * 
	 * mise a jour de starling en 1.1
	 * mise a jour de fox hole
	 * mise a jour du dynamic atlas
	 * 
	 * * * TODO STARLING BOX * * *
	 * deplacer les assets du jeu dans une classe assets
	 * hook sur l'initialisation des assets
	 * tester le system.pause et le system.resume
	 * starling.start(); ou starling.stop(); 
	 * gerer le added dans les screen
	 * verifier que la displaylist ne monte pas
	 * faire un flash de transition
	 * une phase d'initialisation avec un loader 
	 * pb de pause/reprise d'un son avec le SM
	 * integration de nape avec le juggler de starling
	 * 
	 * * * TODO ALIEN FLEET * * *
	 * QUANTIC HATE
	 * 
	 * * * TODO FLASH JACK * * *
	 * 
	 * animation win
	 * anim de hit + mort
	 * explosion de l'ennemi au contact, electricité ou autre
	 * monstres (rebond ok, tracker volant, marche aller-retour + chute );
	 * plate forme disparaissent
	 * plate forme mobiles
	 * 
	 * effets de poussiere au moment du saut (ok)
	 * 
	 * amélio de ce WE
	 * # controles tactiles
	 * # nouvelle mécanique de saut
	 * # explosion au contact d'un monstre (plus le monste qui disparait) ?
	 * 
	 * * * OPTIMS * * *
	 * http://wiki.starling-framework.org/manual/performance_optimization
	 * vérifier les histoires 
	 * 		-> minimiser les states change
	 * 		-> de texte bitmap
	 * 		-> de flatten
	 * 
	 * faire 1 seul texture atlas -pour toutes les animations- taille max 2048 * 2048 (dans la mesure du possible)
	 * background.blendmode = BlendMode.none (mis sur baseTileMap)
	 * précalculer les width/height , a priori ok
	 * container.touchable = false, tous les niveaux sont en touchable = false :)
	 * object.dispatchEventWith("lol", bubbles);, pour l'instant c'est pas utilisé
	 */	
	 
	public class Main extends Sprite
	{
		public function Main() 
		{
			SB.root		= this;
			
			//SB.screen	= new Keos_GuildScreen;
			//SB.screen	= new Niveau1;
			//SB.screen	= new TitleScreenFlashJack;			
			
			Config.LANG = SB.flashvar("lang", "FR");
			ConfigXML.instance.loadDatas( '/lockpickers/assets/lang/'+Config.LANG+'.xml' );
			ConfigXML.instance.addEventListener(Event.COMPLETE, _onDataComplete, false, 0, true);
			ConfigXML.instance.addEventListener(Event.CLOSE, _onDataError, false, 0, true);
			/*
			SB.addConsole( this );
			SB.console.addMessage( 'oOo Please wait oOo' );
			SB.console.addMessage( 'Loading language : ', Config.LANG );
			*/
		}
		
		private function _onDataComplete(e:Event):void 
		{
			e.stopImmediatePropagation();
			//removeChildren();
			SB.screen	= new KeoS_TitleScreen;
		}
		
		private function _onDataError(e:Event):void 
		{
			e.stopImmediatePropagation();			
		}
	}

}