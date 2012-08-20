// http://code.google.com/p/developmentarc-core/wiki/EventBroker

 package starlingBox.utils
{
	import flash.events.Event;
	
	/**
	 * The EventBroker is a remote Observer pattern that allows objects to subscribe to events that may be broadcasted by any item in the system.
	 * This utility is useful for situations where the broadcaster may not be a direct child or could change as the application is run.  The EventBroker
	 * allows for any object to subscribe to any event that is broadcasted through the broker.  The subscriber must provide a callback that accepts one
	 * argument of type Event.
	 * 
	 * <p>The EventBroker subscription, broadcasting and un-subscription system supports contextual definitions.  A context groups a set of subscriptions to
	 * a specific contextual space meaning that an application may have multiple subscribers to the same event type and callback, but are in different groups.
	 * Because the EventBroker is a singleton, context enables calls to be compartmentalized.</p>
	 * 
	 * <p>For example, an application requires the EventBroker to send application and system level commands.  If the EventBroker is used in a multiple document based application, 
	 * having a single contextual space becomes problematic, such as dispatching a Save command.  What should be saved? All the documents? A specific document?
	 * Using context, the application can be configured so that each document has its own context and all messages dispatched have a specific context allowing the 
	 * application finer control of the overall behavior.</p>
	 * 
	 * <p>The EventBroker is a Static object which means that all access must be made through the static methods.  The class is a facade Singleton which means
	 * that even though you are calling a static method a singleton object is defined so that only one instance of the EventBroker exists.</p>
	 *  
	 * @author jpolanco
	 * 
	 */
	public class EventBroker
	{
		/**
		 * Defines the default context used when subscribing and broadcasting events through the
		 * broker. 
		 */		
		static public const EVENT_BROKER_DEFAULT_CONTEXT:String = "eventBrokerDefaultContext";
		
		/* stores the singleton instance */
		static private var _inst:EventBroker;
		
		/* stores the listener/callback pairs */
		private var _eventContextList:Object;
		
		private var _lockQueue:Boolean = false;
		private var _itemsDuringLock:Array;
		
		/**
		 * CONSTRUCTOR.
		 * 
		 * @private 
		 * @param lock
		 * 
		 */
		public function EventBroker(lock:SingletonLock)
		{
			_eventContextList = {};
			_itemsDuringLock = [];
		}
		
		/**
		 * Enables any object to subscribe to any event type by providing the Event type and the callback method the EventBroker should call
		 * when an Event of the requested type is broadcasted.  The callback must be a single argument method that accepts type Event. A context
		 * can be used to define how to group this subscription.  By default, the default context is used and the argument is optional.
		 *  
		 * @param eventType The Event type to subscribe to.
		 * @param callback The method to call when the event type is broadcasted.
		 * @param context Defines the subscribers context, the default context is used unless defined.
		 * 
		 */
		static public function subscribe(eventType:String, callback:Function, context:String = EVENT_BROKER_DEFAULT_CONTEXT):void
		{
			instance.addSubscriber(eventType, callback, context);
		}
		
		/**
		 * Called by an object that wishes to broadcast an event.  An optional context can be provided to allow the broadcast method to determine which
		 * context to use when looking up subscribers. All subscribers of the event type within the context will be called and passed the provided Event.
		 *  
		 * @param event The Event to broadcast to the subscriber set.
		 * @param context Defines the context to use when broadcasting the message.
		 * 
		 */
		static public function broadcast(event:Event, context:String = EVENT_BROKER_DEFAULT_CONTEXT):void
		{
			instance.broadcastMessage(event, context);	
		}
		
		/**
		 * Removes subscription of the specified event and callback based on the requested context.
		 *  
		 * @param eventType The event type to unsubscribe.
		 * @param callback The callback reference to unsubscribe.
		 * @param context The context of the existing subscription.
		 * 
		 */
		static public function unsubscribe(eventType:String, callback:Function, context:String = EVENT_BROKER_DEFAULT_CONTEXT):void
		{
			instance.removeSubscriber(eventType, callback, context);
		}
		
		/**
		 * Removes all subscribed methods and objects from the EventBroker. 
		 * 
		 */
		static public function clearAllSubscriptions():void
		{
			instance.clean();
		}
		
		/**
		 * Hidden singleton instance that is called from the facade static API.
		 *  
		 * @return 
		 * 
		 */
		static private function get instance():EventBroker
		{
			if(!_inst) _inst = new EventBroker(new SingletonLock());
			return _inst;			
		}
		
		/*
		 * subscribes the event.
		 * 
		 */
		private function addSubscriber(eventType:String, callback:Function, context:String):void
		{
			// prevent items from being added while broadcasting
			if(_lockQueue)
			{
				_itemsDuringLock.push(new QueueParam(QueueParam.ADD, eventType, callback, context));
				return;
			}
			
			if(_eventContextList.hasOwnProperty(context) && _eventContextList[context][eventType])
			{
				// see if we already have the context, determin if we have the type
				var callbackList:Array = _eventContextList[context][eventType] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++) if(callbackList[i] == callback) return;
				
				// we must not, add it
				callbackList.push(callback);

			} else {
				// create a new one
				var contextList:Object;
				
				// see if we have a context predefined
				if(_eventContextList.hasOwnProperty(context)) {
					// use the existing context object
					contextList = _eventContextList[context];
				} else {
					// create a new one
					contextList = {};
					_eventContextList[context] = contextList;
				}
				
				// store the references
				contextList[eventType] = [callback];
			}
		}
		
		/*
		 * removes the subscription.
		 * 
		 */
		private function removeSubscriber(eventType:String, callback:Function, context:String):void
		{
			// prevent items from being deleted while broadcasting
			if(_lockQueue)
			{
				_itemsDuringLock.push(new QueueParam(QueueParam.REMOVE, eventType, callback, context));
				return;
			}
			
			// delete the request subscriber by context
			if(_eventContextList.hasOwnProperty(context) && _eventContextList[context].hasOwnProperty(eventType)) {
				// find the event list
				var callbackList:Array = _eventContextList[context][eventType] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++) {
					if(callbackList[i] == callback) {
						// remove the callback
						callbackList.splice(i, 1);
						
						if(callbackList.length == 0) {
							// remove the list
							delete _eventContextList[context][eventType];
						}
					}
				}
			}
		}
		
		/*
		 * broadcasts the message
		 * 
		 */
		private function broadcastMessage(event:Event, context:String):void
		{
			_lockQueue = true;
			if(_eventContextList.hasOwnProperty(context) && _eventContextList[context].hasOwnProperty(event.type)) {
				var callbackList:Array = _eventContextList[context][event.type] as Array;
				var len:int = callbackList.length;
				for(var i:uint = 0; i < len; i++)
				{
					var callback:Function = callbackList[i] as Function;
					if(callback != null) callback.call(this, event);
				}
			}
			
			_lockQueue = false;
			if(_itemsDuringLock.length > 0) clearQueue();
		}
		
		/*
		* Used to execute all the queued messages that occured while a lock was active.
		* 
		*/	
		private function clearQueue():void
		{
			var len:int = _itemsDuringLock.length;
			for(var i:uint = i; i < len; i++)
			{
				var item:QueueParam = QueueParam(_itemsDuringLock[i]);
				switch(item.type)
				{
					case QueueParam.ADD:
						addSubscriber(item.eventType, item.callback, item.context);
					break;
					
					case QueueParam.REMOVE:
						removeSubscriber(item.eventType, item.callback, item.context);
					break;
				}
			}
			
			_itemsDuringLock = new Array();
		}
		
		/*
		* removes all references and subscriptions.
		* 
		*/		
		private function clean():void
		{
			_eventContextList = {};
			_itemsDuringLock = [];
			_lockQueue = false;
		}

	}
}

class QueueParam
{
	static public const ADD:String = "ADD";
	static public const REMOVE:String = "REMOVE";
	
	public var type:String;
	public var eventType:String;
	public var callback:Function;
	public var context:String;
	
	public function QueueParam(t:String, e:String, c:Function, context:String)
	{
		type = t;
		eventType = e;
		callback = c;
		this.context = context;
	}
}

class SingletonLock
{
	public function SingletonLock()
	{
		// constructor
	}
}