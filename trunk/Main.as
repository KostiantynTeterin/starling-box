package
{
	import alienfleet.StarField;
	import screens.FlashJack;
	import screens.Intro;
	import screens.Jeu;
	import screens.BaseNiveau;
	import screens.SimulationFluides;
	import starling.display.Sprite;
	import starlingBox.SB;
	import screens.Niveau1;
	
	
	/**
	 * console debug
	 * ui : jauge
	 * 
	 * mise a jour de starling en 1.1
	 * mise a jour de fox hole
	 * mise a jour du dynamic atlas
	 * 
	 * TODO :
	 * deplacer les assets du jeu dans une classe assets
	 * hook sur l'initialisation des assets
	 * tester le system.pause et le system.resume
	 * starling.start(); ou starling.stop(); 
	 * mettre les assets dans une classe statique Assets
	 * gerer le added dans les screen
	 * utiliser un swc de starling pour accel la compil
	 * verifier que la displaylist ne monte pas
	 * faire un flash de transition
	 * une phase d'initialisation avec un loader 
	 * pb de pause/reprise d'un son avec le SM
	 * integration de nape avec le juggler de starling
	 */	
	public class Main extends Sprite
	{
		public function Main() 
		{
			SB.root		= this;			
			SB.screen	= new Niveau1;
		}
	}

}