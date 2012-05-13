package starlingBox.game.pooling
{
	
	/*
	 * alkemiTools is a class Package by Alkemi (Mickael Mouillé & Alain Puget)
	 * Find out more about us at www.alkemi-games.com
	 *
	 * You may freely use or modify these files for personal or commercial use.
	 * Crediting us in any way, if you do so would be nice.
	 */
	
	public class LinkedListNode
	{
		
		public var data:*;
		public var next:LinkedListNode;
		public var prev:LinkedListNode;
		
		/**
		 * A simple data node used for LinkedList and Pool
		 * @param $obj untyped data stored in the node
		 */
		public function LinkedListNode($obj:* = null):void
		{
			next = prev = null;
			data = $obj;
		}
	
	}

}