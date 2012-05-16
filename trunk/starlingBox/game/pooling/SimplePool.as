package starlingBox.game.pooling
{
	public class SimplePool
	{
		private var pool:Array;
		private var counter:int;
		
		public function SimplePool(type:Class, size:int):void
		{
			pool = new Array;
			counter = size;
			
			var i:int = size;
			while(--i> -1)
				pool[i] = new Type;
			
		}
		
		public function getO():*
		{
			if ( counter > 0 ){
				return pool[--counter];
			}
			
			return null;
		}
		
		
		public function putO(obj:*):void
		{
			pool[counter++] = obj;
		}		
	}
}