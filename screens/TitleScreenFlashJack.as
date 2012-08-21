package screens 
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import starlingBox.game.controller.VirtualJoystick;
	import starlingBox.SB;
	import starlingBox.Screen;
	import screens.Niveau1;
	
	/**
	 * animation win
	 * anim de hit + mort
	 * explosion de l'ennemi au contact, electricité ou autre
	 * monstres (rebond ok, tracker volant, marche aller-retour + chute );
	 * plate forme disparaissent
	 * plate forme mobiles
 	 * effets de poussiere au moment du saut (ok)
	 * explosion au contact d'un monstre (plus le monste qui disparait) ?
	 * 
	 * http://wiki.starling-framework.org/manual/performance_optimization
	 * vérifier les histoires 
	 * 		-> minimiser les states change
	 * 		-> de texte bitmap
	 * 		-> de flatten
	 * painter algo pour minimiser le nombre de drawcall ! -> tactique pour mettre plusieurs classe sur la même sprite sheet
	 * 
	 * faire 1 seul texture atlas -pour toutes les animations- taille max 2048 * 2048 (dans la mesure du possible)
	 * background.blendmode = BlendMode.none (mis sur baseTileMap)
	 * précalculer les width/height , a priori ok
	 * container.touchable = false, tous les niveaux sont en touchable = false :)
	 * object.dispatchEventWith("lol", bubbles);, pour l'instant c'est pas utilisé
	 * 
	 */
	
	 public class TitleScreenFlashJack extends Screen 
	{
		[Embed(source = "../../media/title-screen.png")]
		private const TitleScreenClass:Class;
		private var bmp:Bitmap;
		
		public function TitleScreenFlashJack() 
		{
			bmp = new TitleScreenClass() as Bitmap;
			//bmp.y  = 5;
			SB.engine.starling.nativeOverlay.addChild( bmp );
			SB.engine.starling.nativeOverlay.addEventListener(MouseEvent.CLICK, _onClickTitleScreen );
		}
		
		private function _onClickTitleScreen(e:MouseEvent):void 
		{
			SB.engine.starling.nativeOverlay.removeEventListener(MouseEvent.CLICK, _onClickTitleScreen );
			TweenMax.to( bmp, 1, { autoAlpha:0 } );
			//
			SB.screen	= new Niveau1;
		}
		
	}

}