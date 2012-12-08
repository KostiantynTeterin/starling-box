package KeosTactics
{
	import KeosTactics.states.PhaseAction;
	import KeosTactics.states.PhaseDeploiement;
	import KeosTactics.states.PhaseFinPartie;
	import KeosTactics.states.PhasePiege;
	import KeosTactics.states.PhaseResolution;
	import starlingBox.game.fsm.StateMachine;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class GameManager
	{
		public static const PHASE_PIEGE:String = "PHASE_PIEGE";
		public static const PHASE_DEPLOIEMENT:String = "PHASE_DEPLOIEMENT";
		public static const PHASE_ACTION:String = "PHASE_ACTION";
		public static const PHASE_RESOLUTION:String = "PHASE_RESOLUTION";
		public static const PHASE_FINPARTIE:String = "PHASE_FIN_PARTIE";
		
		private static var _instance:GameManager;
		private var _fsm:StateMachine;
		
		public function GameManager(singletonLock:SingletonLock)
		{
			_fsm = new StateMachine;
			_fsm.addState(PHASE_PIEGE, new PhasePiege, [PHASE_DEPLOIEMENT]);
			_fsm.addState(PHASE_DEPLOIEMENT, new PhaseDeploiement, [PHASE_ACTION]);
			_fsm.addState(PHASE_ACTION, new PhaseAction, [PHASE_RESOLUTION]);
			_fsm.addState(PHASE_RESOLUTION, new PhaseResolution, [PHASE_ACTION, PHASE_FINPARTIE]);
			_fsm.addState(PHASE_FINPARTIE, new PhaseFinPartie, []);
			_fsm.state = PHASE_PIEGE;
		}
		
		public static function get instance():GameManager
		{
			if (_instance == null)
			{
				_instance = new GameManager(new SingletonLock);
			}
			
			return _instance;
		}
		
		public function get phase():String
		{
			return _fsm.state;
		}
		
		public function nextPhase():String
		{
			switch (_fsm.state)
			{
				case PHASE_PIEGE: 
					_fsm.state = PHASE_DEPLOIEMENT;
					break;
				
				case PHASE_DEPLOIEMENT: 
					_fsm.state = PHASE_ACTION;
					break;
				
				case PHASE_ACTION: 
					_fsm.state = PHASE_RESOLUTION;
					break;
				
				case PHASE_RESOLUTION: 
					_fsm.state = PHASE_ACTION
					break;
				default: 
					throw new Error("Ahem... il y a une erreur imprévue dans GameManager->nextPhase().");
			}
			
			return _fsm.state;
		}
	}

}

internal class SingletonLock
{
}