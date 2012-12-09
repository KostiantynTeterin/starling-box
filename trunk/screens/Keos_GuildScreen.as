package screens 
{
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLVariables;
	import KeoS.Config;
	import KeoS.DataEvent;
	import KeoS.Datas;
	import KeoS.Message;
	import KeoS.PanelEntree;
	import KeoS.PanelExploration;
	import KeoS.PanelFichePerso;
	import KeoS.PanelQuitter;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starlingBox.utils.EventBroker;
	
	/**
	 * @author YopSolo
	 * dans app/explore.php, test si il s'agit de mon domaine
	 * dans app/explore.php, test si il s'agit du domaine d'un autre joueur
	 * 
	 * un truc sympa >> enyoyer un message à xxxx pour leur demander d'ouvrir leur donjon sur lockpickers
	 */
	 
	public class Keos_GuildScreen extends Screen 
	{
		private var _commTxt:TextArea;
		private var _panelExplo:PanelExploration; // le pannel exploration (choix de destination et exploration)
		private var _panelFichePerso:PanelFichePerso; // 
		private var _panelQuitter:PanelQuitter; // retourne à l'a page de loggin
		private var _panelEntree:PanelEntree;
		
		public function Keos_GuildScreen() { 
			// --
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "DEFAULT SCREEN BEGIN");
			
			var comm:Window = new Window(SB.nativeStage, 680, 50, "Comm");
			_commTxt = new TextArea(comm, 0, 0, "oOo bienvenue oOo");
			_commTxt.editable = false;
			comm.setSize(300, 200);
			_commTxt.setSize(300, 175);
			_commTxt.text = "oOo Choisissez une destination à explorer oOo";
			
			/**/
			EventBroker.subscribe( Config.E_GETINFOS, _getInfos, Config.C_GUILD_SCREEN );
			EventBroker.subscribe( Config.E_UPDATE_COMM, _updateCommPanel, Config.C_GUILD_SCREEN );
			EventBroker.subscribe( Config.E_DESTINATION, _onDestination, Config.C_GUILD_SCREEN );
			EventBroker.subscribe( Config.E_RESET, _onResetPanelExploration, Config.C_GUILD_SCREEN );			
			
			/**/
			_panelExplo = new PanelExploration();			
			_panelQuitter = new PanelQuitter();
			_panelFichePerso = new PanelFichePerso();
			_panelEntree = new PanelEntree();
			_panelEntree.visible = false;			
			
			SB.addConsole(this);						
		}		
		
		override public function destroy():void
		{
			SB.console.addMessage(this, "#destroy");
			_panelExplo.destroy();
			_panelFichePerso.destroy();
			_panelQuitter.destroy();
			_panelEntree.destroy();
			EventBroker.clearAllSubscriptions();
			while ( SB.nativeStage.numChildren ) SB.nativeStage.removeChildAt(0);
		}			
		
		private function _updateCommPanel(e:DataEvent):void 
		{
			_commTxt.text = e.data;
		}		
		
		public function _getInfos(e:DataEvent=null):void
		{
			//e.stopImmediatePropagation();
			SB.console.addMessage(this, "#appel de _getInfos");
			var variables:URLVariables = new URLVariables;
			var m:Message = new Message(Config.A_GETINFOS, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseGetInfos, false, 0, true);
			m.sendAndLoad();			
		}
		
		private function _onResponseGetInfos(e:Event):void 
		{	
			SB.console.addMessage(this, "#appel de _onResponseGetInfos");
			e.stopImmediatePropagation();
			var resp:XML = (e.target as Message).response;
			//SB.console.addMessage(this, mess);
			var sp:Array = resp.message.datas.split(':');
			Datas.instance.FOR = sp[0];
			Datas.instance.DEX = sp[1];
			Datas.instance.END = sp[2];
			Datas.instance.POU = sp[3];
			Datas.instance.XP = sp[4];				
			// --
			Datas.instance.domaines =  resp.message.noyaux.split(',');
			Datas.instance.domaines.length = Datas.instance.domaines.length - 1;
			//SB.console.addMessage(this, Datas.instance.domaines.length);
			
			// mise à jour des infos
			//_panelFichePerso.update();
			var dataE:DataEvent = new DataEvent( Config.E_UPDATE );
			EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
		}
		
		/*
		private function updateMaze(e:Event):void 
		{
			// SB.console.addMessage(this, "#updateMaze");			
			e.stopImmediatePropagation();
			_panelEntree.update( "http://"+_panelExplo.destination );
		}
		*/
		
		private function _onDestination(e:DataEvent):void
		{
			e.stopImmediatePropagation();
			_panelEntree.initMe();
			_panelEntree.title = _panelExplo.destination;
		}
		
		private function _onResetPanelExploration(e:DataEvent):void 
		{
			e.stopImmediatePropagation();
			_panelEntree.lock();
		}		
		
	}

}