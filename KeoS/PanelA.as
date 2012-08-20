package KeoS 
{
	import starlingBox.SB;
	import starlingBox.utils.EventBroker;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PanelA 
	{
		
		public function PanelA() {
			
		}
		
		public function sendMessage():void
		{
			SB.console.addMessage( "click click click" );
			var dataE:DataEvent = new DataEvent();
			dataE.data = 42;
			
			EventBroker.broadcast( dataE );
		}
		
	}

}