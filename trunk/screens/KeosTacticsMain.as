package screens
{
	import com.furusystems.dconsole2.DConsole;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;
	import feathers.themes.MetalWorksMobileTheme;
	import KeosTactics.Background;
	import KeosTactics.board.Arena;
	import KeosTactics.Config;
	import KeosTactics.factory.StangFactory;
	import KeosTactics.GameManager;
	import KeosTactics.players.Player;
	import KeosTactics.players.Players;
	import KeosTactics.ui.FenetrePiege;
	import KeosTactics.ui.FenetreDeploiement;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	/**
	 * ...
	 * @author YopSolo
	 *
	 * Faire les ecrans
	 * loading
	 * avant-jeu
	 * jeu
	 * fin jeu
	 *
	 * resolution : 960 * 640
	 * 
	 * 
	 */
	public class KeosTacticsMain extends starlingBox.Screen
	{
		private var _theme:MetalWorksMobileTheme;
		private var _navigator:ScreenNavigator;
		private var _transitionManager:ScreenSlidingStackTransitionManager;
		
		// [ECRAN DE JEU]
		public function KeosTacticsMain()
		{
			// creation des joueurs
			Players.instance.add(new Player(Players.PLAYER_1, new StangFactory()));
			Players.instance.add(new Player(Players.PLAYER_2, new StangFactory()));
			
			//addEventListener(TouchEvent.TOUCH, onTouch);
			// DEBUG
			SB.nativeStage.addChild(DConsole.view);
			DConsole.createCommand("nextPhase", nextPhase);
			SB.addMessage("GameManager.instance.phase ", GameManager.instance.phase);
			
			// creation du fond
			addChild(new Background);
			
			// creation de l'arene			
			var arena:Arena = Arena.instance;
			arena.type = Config.ARENA_4_6;
			arena.x = 120;
			arena.y = 150;
			//SB.nativeStage.addChild(arena.debug);
			
			_theme = new MetalWorksMobileTheme(this);
			
			this._navigator = new ScreenNavigator();
			this.addChild(this._navigator);
			
			this._navigator.addScreen( GameManager.PHASE_PIEGE, new ScreenNavigatorItem(FenetrePiege ,{ complete: GameManager.PHASE_DEPLOIEMENT} ) );
			this._navigator.addScreen( GameManager.PHASE_DEPLOIEMENT, new ScreenNavigatorItem(FenetreDeploiement ,{ complete: GameManager.PHASE_PIEGE} ) );
			
			this._navigator.showScreen(GameManager.PHASE_PIEGE);
			this._transitionManager = new ScreenSlidingStackTransitionManager(this._navigator);
			this._transitionManager.duration = 0.8;
			
			
			/*
			// creation des pieges du joueur 1
			arena.setValeur(3, 0, Players.instance.getMe().pieges[0]);
			arena.setValeur(2, 1, Players.instance.getMe().pieges[1]);
			arena.setValeur(3, 3, Players.instance.getMe().pieges[2]);			
			
			// creation des pieces j1
			arena.setValeur(0, 0, Players.instance.getMe().units[0]);
			arena.setValeur(0, 1, Players.instance.getMe().units[1]);
			arena.setValeur(0, 3, Players.instance.getMe().units[2]);
			
			// creation des pieces j2
			arena.setValeur(arena.colones - 1, 0, Players.instance.getPlayer(Players.PLAYER_2).units[0]);
			arena.setValeur(arena.colones - 1, 2, Players.instance.getPlayer(Players.PLAYER_2).units[1]);
			arena.setValeur(arena.colones - 1, 3, Players.instance.getPlayer(Players.PLAYER_2).units[2]);
			// creation des pieges du j2
			arena.setValeur(2, 0, Players.instance.getPlayer(Players.PLAYER_2).pieges[0]);
			arena.setValeur(3, 1, Players.instance.getPlayer(Players.PLAYER_2).pieges[1]);
			arena.setValeur(2, 2, Players.instance.getPlayer(Players.PLAYER_2).pieges[2]);	
			
			
			// affiche les unites
			for each (var sp:Sprite in arena.cases)
			{
				if (sp is IUnit)
				{
					sp.x = (sp as IUnit).col * arena.SIZE + arena.x + int(arena.SIZE/2);
					sp.y = (sp as IUnit).lig * arena.SIZE + arena.y + int(arena.SIZE/2);
					addChild(sp);
				}
				
				if (sp is IPiege)
				{
					sp.x = (sp as IPiege).col * arena.SIZE + arena.x + int(arena.SIZE/2);
					sp.y = (sp as IPiege).lig * arena.SIZE + arena.y + int(arena.SIZE/2);
					addChild(sp);
				}				
			}
			*/
			
			
		}
		
		private function nextPhase():void
		{
			GameManager.instance.nextPhase();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch.phase == TouchPhase.ENDED)
			{
				nextPhase();
			}
		}
	}

}