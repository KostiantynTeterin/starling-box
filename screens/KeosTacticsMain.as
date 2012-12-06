package screens
{
	import starling.display.Sprite;
	import flash.display.Shape;
	import KeosTactics.Background;
	import KeosTactics.factory.StangFactory;
	import KeosTactics.GameManager;
	import KeosTactics.players.Player;
	import KeosTactics.products.units.IUnit;
	import KeosTactics.products.units.Sniper;
	import KeosTactics.products.units.Tank;
	import KeosTactics.products.units.Scout;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingBox.SB;
	import starlingBox.Screen;
	import KeosTactics.players.Players;
	import KeosTactics.products.units.AbstractUnit;
	import KeosTactics.board.Arena;
	import com.furusystems.dconsole2.DConsole;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class KeosTacticsMain extends Screen
	{
		
		public function KeosTacticsMain()
		{
			Players.instance.add(new Player(Players.PLAYER_1, new StangFactory()));
			Players.instance.add(new Player(Players.PLAYER_2, new StangFactory()));
			
			//addEventListener(TouchEvent.TOUCH, onTouch);
			
			addChild(new Background);
			
			SB.nativeStage.addChild(DConsole.view);
			
			/*
			DConsole.console.print("LOL");
			DConsole.addErrorMessage("error message");
			DConsole.addFatalMessage("fatal message");
			DConsole.addHoorayMessage("horray message");
			DConsole.addSystemMessage("system message");
			DConsole.addWarningMessage("warning message");
			DConsole.createCommand("drawRect", drawRect);
			*/
			
			DConsole.console.print("GameManager.instance.phase " + GameManager.instance.phase );
			
			
			
			var arena:Arena = Arena.instance;
			
			arena.setValeur(0, 0, Players.instance.getPlayer(Players.PLAYER_1).units[0]);
			arena.setValeur(0, 1, Players.instance.getPlayer(Players.PLAYER_1).units[1]);
			arena.setValeur(0, 3, Players.instance.getPlayer(Players.PLAYER_1).units[2]);
			
			arena.setValeur(arena.colones - 1, 0, Players.instance.getPlayer(Players.PLAYER_2).units[0]);
			arena.setValeur(arena.colones - 1, 2, Players.instance.getPlayer(Players.PLAYER_2).units[1]);
			arena.setValeur(arena.colones - 1, 3, Players.instance.getPlayer(Players.PLAYER_2).units[2]);
			
			// affiche les unites
			for each(var sp:Sprite in arena.cases) {
				if (sp is IUnit) {
					sp.x = (sp as IUnit).col * Arena.CASE_SIZE;
					sp.y = (sp as IUnit).lig * Arena.CASE_SIZE;
					addChild( sp );
				}
			}
			
			
			
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this);
			if (touch.phase == TouchPhase.ENDED)
			{
				trace(GameManager.instance.nextPhase());
			}
		
		}
		
		private function drawRect(x:Number, y:Number, width:Number, height:Number, color:uint):void
		{
			var sh:Shape = new Shape
			sh.graphics.clear();
			sh.graphics.beginFill(color);
			sh.graphics.drawRect(0, 0, width, height);
			sh.x = x;
			sh.y = y;
			SB.nativeStage.addChild(sh);
		}
	
	}

}