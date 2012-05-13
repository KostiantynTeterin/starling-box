package starlingBox
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import starlingBox.malbolge.Safe;
	import starlingBox.SB;
	
	public class SupaBox extends EventDispatcher
	{
		private var _flag:Boolean = false;
		
		public static const GAGNE:String = "motif_gagne";
		public static const PERDU:String = "motif_perdu";
		public static const TIME_UP:String = "motif_temps_ecoule";
		
		public var motif:String = "motif_aucun";		
		public var error:String = "";
		
		private var _safe:Safe;
		
		public function SupaBox(){}
		
		public function send():void
		{
			if (!_flag)
			{
				_flag = true;
				if (!_safe) {
					_safe = new Safe(30, 1);
					SB.console.addMessage("Création d'un objet Safe par défaut");
				}
				
				var couples:Object = new Object();
				couples.NJ = "JEU_TEST";
				couples.ID = SB.flashvar("ID_JOUEUR", "0");
				couples.UR = SB.nativeStage.loaderInfo.url;
				couples.DJ = _safe.currentCount;
				couples.ND = _safe.mouseMove;
				couples.NC = _safe.mouseClick;
				couples.NK = 0;
				couples.CP = 0;
				couples.V1 = int(Math.random() * 16);
				couples.V2 = int(Math.random() * 16);
				couples.V3 = int(Math.random() * 16);
				couples.V4 = int(Math.random() * 16);
				couples.V5 = int(Math.random() * 16);
				
				var nfoComplet:String = _safe.encryptMe(couples, "0123456789ABCDEF");
				
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, completeHandler);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				
				var variables:URLVariables = new URLVariables();
				variables.ID_JOUEUR = SB.flashvar("ID_JOUEUR", "0");
				variables.SCORE_JOUEUR = _safe.getValue(Safe.SCORE);
				variables.NFO = nfoComplet;
				
				var req:URLRequest = new URLRequest(SB.flashvar("URL_INSERT", "http://www.yopsolo.fr/ressources/post.php"));
				req.method = URLRequestMethod.POST;
				req.data = variables;
				
				SB.console.addMessage(nfoComplet);
				
				try
				{
					urlLoader.load(req);
				}
				catch (error:Error)
				{
					// --
				}				
			}
		}
		
		private function completeHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			error += event.text + ";";
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			error += event.text + ";";
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function set safe(value:Safe):void
		{
			_safe = value;
		}
	
	}

}