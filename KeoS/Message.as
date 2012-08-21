package KeoS 
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.System;
	import starlingBox.SB;
	
	public class Message extends URLLoader 
	{
		public static const ON_RESPONSE:String = "message_on_response";
		
		private var _action:String;
		private var _variables:URLVariables;
		public var response:XML;		
		
		public function Message(action:String, variables:URLVariables) 
		{
			init(action, variables);
		}
		
		public function init(action:String, variables:URLVariables):void
		{
			_action = action;
			_variables = variables;
			response = null;
			//System.disposeXML(response);
		}
		
		public function sendAndLoad():void
		{
			this.addEventListener(Event.COMPLETE, _onComplete );
			this.addEventListener(IOErrorEvent.IO_ERROR, _onIOError );			
			
			var req:URLRequest = new URLRequest( Config.ROOT_URL + _action );
			req.method = URLRequestMethod.POST;
			req.data = _variables;			
			load( req );
			
			SB.console.addMessage("#ACTION: "+_action);
		}
		
		
		private function _onComplete(e:Event):void 
		{
			e.stopImmediatePropagation();
			SB.console.addMessage("#COMPLETE: " + _action);
			response = XML( (e.target as URLLoader).data );
			dispatchEvent( new Event(ON_RESPONSE) );
		}
		
		private function _onIOError(e:IOErrorEvent):void 
		{
			e.stopImmediatePropagation();
			SB.console.addMessage("#COMPLETE: "+_action);
			response = XML('<root><message>'+e.text+'</message></root>');
			dispatchEvent( new Event(ON_RESPONSE) );
		}		
		
	}

}