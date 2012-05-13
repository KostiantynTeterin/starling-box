package starlingBox.game.pooling
{
	
	/*
	 * alkemiTools is a class Package by Alkemi (Mickael Mouillé & Alain Puget)
	 * Find out more about us at www.alkemi-games.com
	 *
	 * You may freely use or modify these files for personal or commercial use.
	 * Crediting us in any way, if you do so would be nice.
	 */
	
	public class LinkedList
	{
		protected static var _freeNodesHead:LinkedListNode = null;
		
		/**
		 * Destroy all free nodes available in the free nodes list
		 */
		public static function CLEAR_FREE_NODES():void
		{
			var node:LinkedListNode;
			
			while (_freeNodesHead)
			{
				node = _freeNodesHead;
				_freeNodesHead = node.next;
				if (_freeNodesHead)
					_freeNodesHead.prev = null;
				node.next = null;
			}
		}
		
		protected var _count:int;
		
		public function get length():int
		{
			return _count;
		}
		
		public var head:LinkedListNode;
		public var tail:LinkedListNode;
		
		/**
		 * Very simple implemention of a doubly linked list
		 * using some kind of pool of list nodes for better performances
		 *
		 * @param $nodesReserve the number of nodes instantiated at the creation of the list.
		 */
		public function LinkedList($nodesReserve:int = 0):void
		{
			head = tail = null;
			_count = 0;
			
			// Instantiation of LinkedListNodes stored in a static 'free nodes list'
			// These nodes will be used by all LinkedList when needed
			for (var i:int = 0; i < $nodesReserve; ++i)
			{
				var node:LinkedListNode = new LinkedListNode();
				
				if (_freeNodesHead)
				{
					_freeNodesHead.prev = node;
					node.next = _freeNodesHead;
					_freeNodesHead = node;
				}
				else
				{
					_freeNodesHead = node;
				}
				
			}
		
		}
		
		/**
		 * Append an object to the list.
		 * @param	$data an object of any type added at the end of the list.
		 */
		public function append($data:*):LinkedListNode
		{
			var node:LinkedListNode;
			
			//  If no node is available in the free nodes list one is instantiated
			if (_freeNodesHead)
			{
				node = _freeNodesHead;
				node.data = $data;
				
				if (node.next)
				{
					_freeNodesHead = node.next;
					_freeNodesHead.prev = null;
					node.next = null;
				}
				else
					_freeNodesHead = null
			}
			else
				node = new LinkedListNode($data);
			
			// Node insertion
			if (head != null)
			{
				tail.next = node;
				node.prev = tail;
				tail = node;
			}
			else
				head = tail = node;
			
			++_count;
			
			return node;
		}
		
		/**
		 * Prepend an object to the list.
		 * @param	$data an object of any type added at the beginning of the list.
		 */
		public function prepend($data:*):LinkedListNode
		{
			var node:LinkedListNode;
			
			//  If no node is available in the free list one is instantiated
			if (_freeNodesHead)
			{
				node = _freeNodesHead;
				node.data = $data;
				
				if (node.next)
				{
					_freeNodesHead = node.next;
					_freeNodesHead.prev = null;
					node.next = null;
				}
				else
					_freeNodesHead = null
			}
			else
				node = new LinkedListNode($data);
			
			// Node insertion
			if (head != null)
			{
				head.prev = node;
				node.next = head;
				head = node;
			}
			
			else
				head = tail = node;
			
			++_count;
			
			return node;
		}
		
		/**
		 * Remove a Node from the list and return its data
		 * @param	$node the node to remove from the list
		 * @return	returns the data held by the removed node
		 */
		public function removeNode($node:LinkedListNode):*
		{
			var data:* = $node.data;
			
			// Extraction of the node from the list
			if ($node == head)
			{
				head = $node.next;
				if (head != null)
					head.prev = null;
			}
			else
			{
				$node.prev.next = $node.next;
			}
			
			if ($node == tail)
			{
				tail = $node.prev;
				if (tail != null)
					tail.next = null;
			}
			else
			{
				$node.next.prev = $node.prev;
			}
			
			$node.prev = null;
			
			// Reinsertion of the removed node in the free nodes list
			if (_freeNodesHead)
			{
				_freeNodesHead.prev = $node;
				$node.next = _freeNodesHead;
				_freeNodesHead = $node;
			}
			else
			{
				_freeNodesHead = $node;
				$node.next = null;
			}
			_freeNodesHead.data = null;
			
			--_count;
			
			return data;
		}
		
		/**
		 * Remove the first node of the list and return its data
		 * @return	returns the data held by the removed node
		 */
		public function removeHead():*
		{
			var node:LinkedListNode = head;
			
			if (head != null)
			{
				// Extraction of the node from the list
				var data:* = node.data;
				
				head = node.next;
				if (head != null)
					head.prev = null;
				
				--_count;
				
				// Reinsertion of the removed node in the free nodes list
				if (_freeNodesHead)
				{
					_freeNodesHead.prev = node;
					node.next = _freeNodesHead;
					_freeNodesHead = node;
					
				}
				else
				{
					_freeNodesHead = node;
					node.next = null;
				}
				_freeNodesHead.data = null;
				
				return data;
			}
		
		}
		
		/**
		 * Remove the last node of the list and return its data
		 * @return	returns the data held by the removed node
		 */
		public function removeTail():*
		{
			var node:LinkedListNode = tail;
			
			if (tail != null)
			{
				// Extraction of the node from the list
				var data:* = node.data;
				
				tail = tail.prev;
				if (tail != null)
					tail.next = null;
				--_count;
				
				node.prev = null;
				
				// Reinsertion of the removed node in the free nodes list
				if (_freeNodesHead)
				{
					_freeNodesHead.prev = node;
					node.next = _freeNodesHead;
					_freeNodesHead = node;
				}
				else
				{
					_freeNodesHead = node;
					node.next = null;
				}
				_freeNodesHead.data = null;
				
				return data;
				
			}
		
		}
		
		/**
		 * Clear the list and send back all nodes in the free nodes list
		 */
		public function clear():void
		{
			var node:LinkedListNode;
			
			while (head != null)
			{
				node = head;
				if (node.next)
				{
					head = node.next;
					head.prev = null;
				}
				else
					head = null;
				
				// Reinsertion of the removed node in the free nodes list
				if (_freeNodesHead)
				{
					_freeNodesHead.prev = node;
					node.next = _freeNodesHead;
					_freeNodesHead = node;
				}
				else
				{
					_freeNodesHead = node;
					node.next = null;
				}
				_freeNodesHead.data = null;
				
				--_count;
			}
			
			head = null;
			tail = null;
		}
	
	}

}