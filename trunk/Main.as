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
	import screens.TitleScreenFlashJack;
	
	
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
	 * 
	 * 
	 * * * TODO FLASH JACK * * *
	 * 
	 * tester un delayed stage.framerate = 0, ca va eviter d'avoir a implémenter des methodes pause/resume à chaque objet
	 * du coup attention a n'activer les ecouteurs activate/deactivate qu'une fois que tout est chargé
	 * a etudier/tester.
	 * 
	 * animation win et écran de fin score / 3500
	 * ecran de fin
	 * monstres 
	 * deplacement des monstres
	 * plate forme disparaissent
	 * plate forme mobiles ?
	 * 
	 * effets de poussieres, impacts, explosions
	 * 
	 * * * OPTIMS * * *
	 * http://wiki.starling-framework.org/manual/performance_optimization
	 * vérifier les histoires 
	 * 		->minimiser les states change
	 * 		-> de texte bitmap
	 * 		-> de flatten
	 * 
	 * faire 1 seul texture atlas -pour toutes les animations- taille max 2048 * 2048 (dans la mesure du possible)
	 * background.blendmode = BlendMode.none (mis sur baseTileMap)
	 * précalculer les with/height , a priori ok
	 * container.touchable = false, tous les niveaux sont en touchable = false :)
	 * object.dispatchEventWith("lol", bubbles);, pour l'instant c'est pas utilisé
	 */	
	 
	public class Main extends Sprite
	{
		public function Main() 
		{
			SB.root		= this;			
			//SB.screen	= new Niveau1;
			SB.screen	= new TitleScreenFlashJack;			
		}
	}

}