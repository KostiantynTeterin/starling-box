package KeoS 
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Datas 
	{
		static private var _instance:Datas;
		
		public var pseudo:String;
		public var FOR:int;
		public var DEX:int;
		public var END:int;
		public var POU:int;
		public var XP:int;
		public var blessures:int = 0;
		public var domaines:Array;
		
		public function Datas( lock:SingletonLock ) { }
		
        public static function get instance():Datas {
            if (_instance == null){
                _instance = new Datas(new SingletonLock());
            };
            return (_instance);
        }

		// * * *
		public function get NIV():int
		{
			var lvl:Number = 1;
			var accumulateur:Number = 0;
			while (accumulateur + (lvl*1000) <= XP ) {
				accumulateur += ( lvl++ * 1000 );
			}
			
			return lvl;
		}
		
		public function get INI():int
		{
			return ( DEX * 2) + NIV;
		}
		
		public function get mFOR():int
		{
			return calc_modificateur( FOR )
		}
		
		public function get mDEX():int
		{
			return calc_modificateur( DEX )
		}
		
		public function get mEND():int
		{
			return calc_modificateur( END )
		}
		
		public function get mPOU():int
		{
			return calc_modificateur( POU )
		}		
		
		// * * *
		private function calc_modificateur( val:int ):int 
		{
			return int( (val - 10) / 2);
		}		
		
	}

}

internal class SingletonLock { }