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
		private var _score:int;
		private var _scoreTxt:TextField;
		
		private var _tempsTxt:TextField;
		private var _temps:int;
		
		public function HUD( lock:SingletonLock ) {
			_score = 0;
			addChild( new TextField(80, 30, "Score : ", "Verdana", 12, 0xFFFFFF) );
			
			_scoreTxt = new TextField(120, 30, _score.toString() , "Verdana", 12, 0xFFFFFF );
			_scoreTxt.x = 20;
			addChild( _scoreTxt );
			
			_tempsTxt = new TextField( 80, 30, "xx:xx", "Verdana", 12, 0xFFFFFF );
			_tempsTxt.x = SB.width - 80;
			temps = 90;
			addChild( _tempsTxt );
		}
		
        public static function get instance():HUD {
            if (_instance == null){
                _instance = new HUD(new SingletonLock());
            };
            return (_instance);
        }
		
		public function incScore(value:int):void 
		{
			score += value;
		}
		
		public function set score(value:int):void 
		{
			_score = value;
			_scoreTxt.text = _score.toString();
		}
		
		public function get score():int 
		{
			return _score;
		}
		
		public function get temps():int 
		{
			return _temps;
		}
		
		public function set temps(value:int):void 
		{
			_temps = value;
			_tempsTxt.text = SB.formatTime( _temps );
		}
		
		public function incTemps(value:int = 1):void 
		{
			temps += value;
		}
		
	}

}

internal class SingletonLock { }