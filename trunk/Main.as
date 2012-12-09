package
{
	import flash.events.Event;
	import starling.display.Sprite;
	import starlingBox.SB;
	import screens.*;	
	
	/*
	 * revoir la gestion du viewport
	 * 
	 * 
	 * */
	
	 
	public class Main extends Sprite
	{
		public function Main() 
		{
			SB.root	= this;
			
			SB.screen = new KeosTacticsMain;
			
			//SB.screen = new StarlingPageFlipTest;
			
			//SB.screen	= new AirStick;			
			
			// don't build :/
			//SB.screen	= new NapeHillsMain;			
			
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