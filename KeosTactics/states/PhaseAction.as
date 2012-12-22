package KeosTactics.states 
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import starlingBox.game.fsm.IState;
	import starlingBox.SB;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PhaseAction implements IState 
	{
		private var _textfield:TextField;		
		
		public function PhaseAction() 
		{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 32;
			fmt.font = "Arial";
			fmt.color = 0xFFFFFF;
			
			_textfield = new TextField;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.defaultTextFormat = fmt;
			
			_textfield.text = "-- PHASE ACTION --";
		}
		
		public function enter():void
		{
			SB.addMessage("Enter-PhaseAction");		
			SB.nativeStage.addChild( _textfield );
		}
		
		public function exit():void
		{
			SB.addMessage("Sortie-PhaseAction");
			SB.nativeStage.removeChild( _textfield );
		}		
		
	}

}