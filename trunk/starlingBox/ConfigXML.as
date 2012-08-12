package starlingBox
{
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
    public class ConfigXML extends EventDispatcher 
	{ 
        private static var _instance:ConfigXML; 
		
        private var _datas:XML;
		private var _url:String		= "";		
		private var _loader:URLLoader;		
		
		public var err:String		= "";
		
        public function ConfigXML( lock:SingletonLock ) { }
		
        public static function get instance():ConfigXML {
            if (_instance == null){
                _instance = new ConfigXML(new SingletonLock());
            };
            return (_instance);
        }
		
		public function loadDatas( url:String ):void {
			_url = url;			
            _loader	= new URLLoader();
            _loader.addEventListener(IOErrorEvent.IO_ERROR, this._onError);
            _loader.addEventListener(Event.COMPLETE, this._onLoadComplete);
            _loader.load( new URLRequest( _url ) );			
		}
		
        public function reloadDatas():void {
			var req:URLRequest = new URLRequest( _url );
			// mode bourrin :D
			// attention les header peuvent être refuser
			req.requestHeaders.push(new URLRequestHeader("pragma", "no-cache"));
			req.requestHeaders.push(new URLRequestHeader("Expires", "Thu, 01 Jan 1970 00:00:00 GMT, -1"));
			req.requestHeaders.push(new URLRequestHeader("Cache-Control", "no-cache, no-store, must-revalidate"));
			
			_loader.load( req );
		}		
		
        private function _onLoadComplete( e:Event ):void {
			e.stopImmediatePropagation();
            _datas = XML( (e.target as URLLoader).data );
			dispatchEvent(new Event(Event.COMPLETE));
        }
		
        private function _onError(e:IOErrorEvent):void {
			err = e.text;
			dispatchEvent( new Event(Event.CLOSE) );
        }
		
		// --
        public function get datas():XML{
			if( !_datas ){
				throw (new Error("Exécuter la methode loadDatas() et ecouter Event.COMPLETE avant d'essayer d'acceder aux datas.") );
			}
            return _datas;
        }
 
    }
}

internal class SingletonLock { }