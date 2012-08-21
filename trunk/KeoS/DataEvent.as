package KeoS 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class DataEvent extends Event 
	{
		public var data:*;
		
		public function DataEvent(type:String) 
		{
			super( type, true, true );
		}
		
	}

}