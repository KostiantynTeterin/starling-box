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
	public class PhaseFinPartie implements IState 
	{
		private var _textfield:TextField;
		
		public function PhaseFinPartie() 
		{
			var fmt:TextFormat = new TextFormat();
			fmt.size = 32;
			fmt.font = "Arial";
			fmt.color = 0xFFFFFF;
			
			_textfield = new TextField;
			_textfield.selectable = false;
			_textfield.autoSize = TextFieldAutoSize.LEFT;
			_textfield.defaultTextFormat = fmt;
			
			_textfield.text = "-- FIN DE PARTIE --";				
		}
		
		public function enter():void
		{
			SB.addMessage("Enter-PhaseFinPartie");
			SB.nativeStage.addChild( _textfield );
		}
		
		public function exit():void
		{
			SB.addMessage("Sortie-PhaseFinPartie");
			SB.nativeStage.removeChild( _textfield );
		}	
		
	}

}