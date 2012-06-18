package flashjack 
{
	import starling.display.Sprite;
	import starling.text.TextField;
	import starlingBox.SB;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class HUD extends Sprite 
	{
		static private var _instance:HUD;
		private var _scoreTxt:TextField;
		
		private var _tempsTxt:TextField;
		
		private var _popFin:PopFin;
		
		public function HUD( lock:SingletonLock ) {
			addChild( new TextField(80, 30, "Score : ", "Verdana", 12, 0xFFFFFF) );
			
			_scoreTxt = new TextField(120, 30, "0000" , "Verdana", 12, 0xFFFFFF );
			_scoreTxt.x = 20;
			addChild( _scoreTxt );
			
			_tempsTxt = new TextField( 80, 30, "xx:xx", "Verdana", 12, 0xFFFFFF );
			_tempsTxt.x = SB.width - 80;
			temps = 90;
			addChild( _tempsTxt );
			
			_popFin = new PopFin;			
		}
		
        public static function get instance():HUD {
            if (_instance == null){
                _instance = new HUD(new SingletonLock());
            };
            return (_instance);
        }
		
		public function set score(value:int):void 
		{
			_scoreTxt.text = value.toString();
		}
		
		public function set temps(value:int):void 
		{
			_tempsTxt.text = SB.formatTime( value );
		}
		
		public function gameOver( score:int ):void
		{
			_popFin.setFinalScore( score );
			addChild( _popFin );			
		}
		
	}

}

internal class SingletonLock { }