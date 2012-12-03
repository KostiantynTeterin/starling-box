package screens 
{
	import flash.display.Shape;
	import KeosTactics.Background;
	import KeosTactics.factory.StangFactory;
	import KeosTactics.GameManager;
	import KeosTactics.players.Player;
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
			Players.instance.add( new Player( new StangFactory() ) );
			Players.instance.add( new Player( new StangFactory() ) );					
			
			trace( GameManager.instance.phase );
			
			//addEventListener(TouchEvent.TOUCH, onTouch);
			
			addChild( new Background );
			
			SB.nativeStage.addChild(DConsole.view);
			
			DConsole.console.print( "LOL" );
			DConsole.addErrorMessage("error message");
			DConsole.addFatalMessage("fatal message");
			DConsole.addHoorayMessage("horray message");
			DConsole.addSystemMessage("system message");
			DConsole.addWarningMessage("warning message");
			
			DConsole.createCommand("drawRect", drawRect);
			
			//var arena:Arena = Arena.instance;
			
			/*
			var posy:int = 1;
			var player:Player = Players.instance.datas[0];			
			for each (var unit:AbstractUnit in player.units) 
			{
				unit.x = 64;
				unit.y = posy * 128;
				addChild( unit );
				posy++;
			}		
			
			player = Players.instance.datas[1];
			posy = 1;
			for each (unit in player.units) 
			{
				unit.x = 730;
				unit.y = posy * 128;
				addChild( unit );
				posy++;
			}
			*/
			
			
		}		
		
		private function onTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(this);
			if (touch.phase == TouchPhase.ENDED)
			{
				trace( GameManager.instance.nextPhase() );
			}
			
		}
		
		private function drawRect(x:Number, y:Number, width:Number, height:Number, color:uint):void {
			var sh:Shape = new Shape
			sh.graphics.clear();
			sh.graphics.beginFill(color);
			sh.graphics.drawRect(0, 0, width, height);
			sh.x = x;
			sh.y = y;
			SB.nativeStage.addChild( sh );
		}		
		
	}

}