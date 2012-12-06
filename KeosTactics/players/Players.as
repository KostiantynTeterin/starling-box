package KeosTactics.players 
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Players 
	{
		public static const PLAYER_1:int = 0;
		public static const PLAYER_2:int = 1;
		
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
		
		public function getPlayer(idx:int = 0):Player
		{
			if (idx <= _datas.length) {
				return _datas[idx];
			}
			
			return null;
		}
		
		public function add( player:Player ):void
		{
			player.color = colors.splice( int(Math.random() * colors.length) , 1 );
			_datas.push( player );
		}
		
		
	}

}

class SingletonLock{}