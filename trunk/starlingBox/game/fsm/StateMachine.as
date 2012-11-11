package starlingBox.game.fsm
{
	import flash.utils.Dictionary;
	
	/*
	_fsm = new StateMachine;			
	_fsm.addState( NORMAL, new StateNormal(this), [SHIELD, POWER_UP, BLINKING] );
	_fsm.addState( POWER_UP, new StatePowerUp(this), [NORMAL] );
	_fsm.addState( SHIELD, new StateShield(this), [NORMAL] );
	_fsm.addState( BLINKING, new StateBlink(this), [NORMAL, SHIELD, POWER_UP] );
	_fsm.state = NORMAL;
	*/

	public class StateMachine
	{
		private var states:Dictionary;
		
		private var _state:String;		
		public var current:String;
		
		public function StateMachine()
		{
			states = new Dictionary;
		}
		
		public function addState(name:String, stateObj:IState, toStates:Array):void
		{
			states[name] = { state: stateObj, toState: toStates }
		}
		
		public function set state(value:String):void
		{
			// 1ere fois	
			if (current == null)
			{
				current = value;
				(states[current].state as IState).enter();
				//(states[current].state as IState).update();
				return;
			}	
			// deja dans l'etat désiré ou n'est pas dans le toState
			if ( current == value || states[current].toState.indexOf(value) == -1 ) {
				//E.console.addMessage( 'NOPE !', '| current ', current , '| allowed ' , states[current].toState, ' | requested ', value );
				return;
			}
			
			(states[current].state as IState).exit();
			
			current = value;
			
			(states[current].state as IState).enter();
			//(states[current].state as IState).update();
		}
		
		public function get state():String 
		{
			return current;
		}
	
	}

}