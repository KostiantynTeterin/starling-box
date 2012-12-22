package KeosTactics.states 
{
	import starlingBox.game.fsm.IState;
	import starlingBox.SB;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;	
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PhaseDeploiement implements IState 
	{
		private var _textfield:TextField;
		
		public function PhaseDeploiement() 
		{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 32;
			fmt.font = "Arial";
			fmt.color = 0xFFFFFF;
			
			_textfield = new TextField;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.defaultTextFormat = fmt;
			
			_textfield.text = "-- PHASE DEPLOIEMENT --";			
		}
		
		public function enter():void
		{
			SB.addMessage("Enter-PhaseDeploiement");		
			SB.nativeStage.addChild( _textfield );
		}
		
		public function exit():void
		{
			SB.addMessage("Sortie-PhaseDeploiement");
			SB.nativeStage.removeChild( _textfield );
		}			
		
	}

}