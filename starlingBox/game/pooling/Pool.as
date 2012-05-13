package starlingBox.game.pooling
{
	
	/*
	 * alkemiTools is a class Package by Alkemi (Mickael Mouillé & Alain Puget)
	 * Find out more about us at www.alkemi-games.com
	 *
	 * You may freely use or modify these files for personal or commercial use.
	 * Crediting us in any way, if you do so would be nice.
	 */
	
	public class Pool
	{
		protected var _count:int;
		
		public function get length():int
		{
			return _count;
		}
		
		public var head:LinkedListNode;
		public var tail:LinkedListNode;
		
		protected var _poolType:Class;
		protected var _poolSize:int = 0;
		protected var _poolGrowthRate:int = 0;
		
		// Start of the list of free objects
		protected var _freeListHead:LinkedListNode = null;
		
		/**
		 * An implementation of an object Pool to limit instantiation for better performances.
		 * Though you pass the Class as a parameter at the pool creation, there's no way for it to send you back your object correctly typed
		 * If you want that, reimplement the Pool class and the LinkedListNode for each of your pool or port these files to Haxe with Generics !
		 * WARNING : Be sure to design your pooled objects with NO constructor parameters and an 'init' method of some kind that will reinitialized
		 * all necessary properties each time your objects are 'recycled'.
		 * WARNING : Remember to cast your objects in the correct type before using them each time you get on from a LinkedListNode.data !!!
		 *
		 * @param $pooledType the Class Object of the type you want to store in this pool
		 * @param $poolSize the initial size of your pool. Ideally you should never have to use more than this number.
		 * @param $poolGrowthRate the number of object to instantiate each time a new one is needed and the free list is empty
		 */
		public function Pool($pooledType:Class, $poolSize:int, $poolGrowthRate:int):void
		{
			head = tail = null;
			_count = 0;
			
			_poolType = $pooledType;
			_poolSize = $poolSize;
			_poolGrowthRate = $poolGrowthRate;
			
			increasePoolSize(_poolSize);
		
		}
		
		/**
		 * Create new objects of the _poolType type and store them in the free list for future needs.
		 * Called once at the pool creation with _poolSize as a parameter, and once with _poolGrowthRate
		 * each time a new Object is needed and the free list is empty.
		 *
		 * @param	$sizeIncrease the number of objects to instantiate and store in the free list
		 */
		protected function increasePoolSize($sizeIncrease:int):void
		{
			
			for (var i:int = 0; i < $sizeIncrease; ++i)
			{
				var node:LinkedListNode = new LinkedListNode();
				node.data = new _poolType();
				if (_freeListHead)
				{
					_freeListHead.prev = node;
					node.next = _freeListHead;
					_freeListHead = node;
				}
				else
				{
					_freeListHead = node;
				}
				
			}
		}
		
		/** Get an object from the free list and returns the node holding it in its data property
		 * Don't forget to cast and reinitialize it !!!
		 * @return a node holding the newly 'recycled' object
		 */
		public function create():LinkedListNode
		{
			var node:LinkedListNode;
			
			// if no object is available in the freelist, make some more !
			if (!_freeListHead)
				increasePoolSize(_poolGrowthRate);
			
			// get the first free object
			node = _freeListHead;
			
			// extract it from the free list
			if (node.next)
			{
				_freeListHead = node.next;
				_freeListHead.prev = null;
				node.next = null;
			}
			else
				_freeListHead = null
			
			// append it to the list of the pool
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
		 * Discard a now useless object to be stored in the free list.
		 * @param	$node the node holding the object to discard
		 */
		public function dispose($node:LinkedListNode):void
		{
			// Extract the node from the list
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
			
			// Store the discarded object in the free list
			if (_freeListHead)
			{
				_freeListHead.prev = $node;
				$node.next = _freeListHead;
				_freeListHead = $node;
			}
			else
			{
				_freeListHead = $node;
				$node.next = null;
			}
			
			--_count;
		
		}
		
		/**
		 * Discard all currently used objects and send them all back to the free list
		 */
		public function disposeAll():void
		{
			while (head)
			{
				dispose(head);
			}
		}
		
		/**
		 * Completely destroy all the content of the pool
		 */
		public function clear():void
		{
			disposeAll()
			
			var node:LinkedListNode;
			
			while (_freeListHead)
			{
				node = _freeListHead;
				node.data = null;
				_freeListHead = node.next;
				if (_freeListHead)
					_freeListHead.prev = null;
				node.next = null;
			}
		
		}
	
	}

}