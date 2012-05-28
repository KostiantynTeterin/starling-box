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
	 * TODO STARLING BOX :
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
	 * TODO ALIEN FLEET :
	 * 
	 * TODO FLASH JACK :
	 * refactor du systeme de bonus => générique dans baseNiveau et Specialisation dans Niveau1,2,3 etc.
	 * collision avec les bonus
	 * 
	 * monstres
	 * IA des monstres
	 * 
	 * Animation des 
	 * 
	 * plate forme mobiles ?
	 * 
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