package KeoS 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class DataEvent extends Event 
	{
		public static const KEOS_EVENT:String = 'keos_event';
		public var data:int = 0;
		
		public function DataEvent() 
		{
			super( KEOS_EVENT, true, true );
		}
		
	}

}