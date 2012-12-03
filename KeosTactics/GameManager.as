package KeosTactics
{
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class GameManager
	{
		private static var _instance:GameManager;
		private var _phase:int = -1;
		
		public function GameManager(singletonLock:SingletonLock) { }
		
		public static function get instance():GameManager
		{
			if (_instance == null)
			{
				_instance = new GameManager(new SingletonLock);
			}
			
			return _instance;
		}
		
		public function get phase():int
		{
			return _phase;
		}
		
		public function nextPhase():int
		{
			if (_phase++ >= Config.PHASE_RESOLUTION)
			{
				_phase = Config.PHASE_ACTION;
			}
			
			return _phase;
		}
	}

}

internal class SingletonLock
{
}