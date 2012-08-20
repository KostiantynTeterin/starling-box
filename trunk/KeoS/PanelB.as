package KeoS 
{
	import starlingBox.SB;
	import starlingBox.utils.EventBroker;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PanelB 
	{
		
		public function PanelB() 
		{
			EventBroker.subscribe( DataEvent.KEOS_EVENT, _onKeosDataEvent );
		}
		
		private function _onKeosDataEvent(e:DataEvent):void 
		{
			e.stopImmediatePropagation();
			SB.console.addMessage( this, "_onKeosDataEvent", e.data );
			_sendMessage();
		}
		
		private function _sendMessage():void
		{
			var dataE:DataEvent = new DataEvent();
			dataE.data = 84;			
			
			EventBroker.broadcast( dataE, "ROOT" );
		}		
		
	}

}