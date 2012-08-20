package screens 
{
	import flash.events.MouseEvent;
	import KeoS.PanelA;
	import KeoS.PanelB;
	import starlingBox.Screen;
	import starlingBox.SB;	
	import starlingBox.utils.BrowserLocation;
	import starlingBox.utils.EventBroker;
	import KeoS.DataEvent;
	
	/**
	 * ...
	 * @author YopSolo
	 * test de browserlocation, OK
	 * test de eventbroker
	 * 
	 * 
	 */
	public class Test extends Screen 
	{
		private var pa:PanelA;
		private var pb:PanelB;
		
		override public function Test() 
		{
			SB.console.addMessage(this, "== TEST :: CONSTRUCT ==");
		}
		
		override public function begin():void
		{
			super.begin();
			
			SB.console.addMessage(this, "== TEST :: BEGIN ==");
			
			var url:String = "http://blogs.adobe.com/connectsupport/adobe-connect-meetings-wont-load-with-firefox-with-flash-11-3-update/";
			BrowserLocation.url = url;
			SB.console.addMessage( 'BrowserLocation.fragment', BrowserLocation.fragment );
			SB.console.addMessage( 'BrowserLocation.parameters', BrowserLocation.parameters );
			SB.console.addMessage( 'BrowserLocation.path', BrowserLocation.path );
			SB.console.addMessage( 'BrowserLocation.port', BrowserLocation.port );
			SB.console.addMessage( 'BrowserLocation.protocal', BrowserLocation.protocal );
			SB.console.addMessage( 'BrowserLocation.query', BrowserLocation.query );
			SB.console.addMessage( 'BrowserLocation.serverName', BrowserLocation.serverName );
			SB.console.addMessage( 'BrowserLocation.url', BrowserLocation.url );
			
			SB.addConsole( this );
			
			pa = new PanelA;			
			pb = new PanelB;
			
			EventBroker.subscribe( DataEvent.KEOS_EVENT, _onKeosDataEvent, "ROOT" );
			SB.nativeStage.addEventListener( MouseEvent.CLICK, _onMouseClick );
		}
		
		private function _onMouseClick(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			pa.sendMessage();
		}
		
		private function _onKeosDataEvent(e:DataEvent):void 
		{
			SB.console.addMessage(this, '_onKeosDataEvent', e.data);
			EventBroker.clearAllSubscriptions();
		}
		
	}

}