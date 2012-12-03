package KeosTactics.players 
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Players 
	{
		private var _datas:Vector.<Player>;
		private static var _instance:Players;		
		public static var colors:Array = [ 0xCC0000, 0x00CC00, 0x0000CC, 0xCCCC00, 0x00CCCC, 0xCC00CC ];		
		
		public function Players( singletonlock:SingletonLock ) 
		{
			_datas = new Vector.<Player>;
		}
		
		public static function get instance():Players 
		{
			if ( _instance == null  ) {
				_instance = new Players( new SingletonLock );
			}
			
			return _instance;
		}
		
		public function get datas():Vector.<Player> 
		{
			return _datas;
		}
		
		public function add( player:Player ):void
		{
			player.color = colors.splice( int(Math.random() * colors.length) , 1 );
			_datas.push( player );
		}
		
		
	}

}

class SingletonLock{}