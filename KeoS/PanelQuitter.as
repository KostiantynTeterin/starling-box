package KeoS 
{
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import screens.KeoS_TitleScreen;
	import starlingBox.SB;
	import starlingBox.utils.EventBroker;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PanelQuitter extends PushButton 
	{
		public function PanelQuitter() 
		{
			super(SB.nativeStage, SB.nativeStage.stageWidth - 108, 8, "Quitter", _onClickQuitter);
		}
		
		public function destroy():void
		{
			SB.console.addMessage(this, "#destroy");
		}			
		
		private function _updateCommPanel(msg:String):void 
		{
			var dataE:DataEvent = new DataEvent( Config.E_UPDATE_COMM );
			dataE.data = msg;			
			EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
		}		
		
		private function _onClickQuitter(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			_updateCommPanel("--- Coupure de la session ---");			
			var variables:URLVariables = new URLVariables;
			var m:Message = new Message(Config.A_DECO, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseQuitter, false, 0, true);
			m.sendAndLoad();
			
		}		
		private function _onResponseQuitter(e:Event):void 
		{
			e.stopImmediatePropagation();		
			_updateCommPanel("oOo Bye :) oOo");
			
			SB.screen = new KeoS_TitleScreen;
		}			
		
	}

}