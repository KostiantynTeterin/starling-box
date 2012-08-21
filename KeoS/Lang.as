package KeoS 
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Lang 
	{
		static private var _instance:Lang;
		
		public function Lang( lock:SingletonLock ) { /* */ }
		
        public static function get instance():Lang {
            if (_instance == null){
                _instance = new Datas(new SingletonLock());
            };
            return (_instance);
        }
		
		public function TEXT(str:String):String
		{
			
		}
		
	}

}

internal class SingletonLock { }