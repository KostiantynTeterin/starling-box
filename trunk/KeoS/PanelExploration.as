package KeoS 
{
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import screens.Keos_GuildScreen;
	import starlingBox.SB;
	import starlingBox.utils.EventBroker;
	
	/**
	 * ...
	 * @author YopSolo
	 * 
	 * ne pas mettre de tiles pour les murs, pkoi pas
	 * faire le clear sur le quit du labyrinthe
	 * bug bizarre du echamp de destination qui est coupé
	 * le coup du htt:// pour la clean url, aller recup le domaine plutot que le champ texte
	 * placer l'entrée et le noyau
	 * faire mon singleton pour le panel comm
	 * utiliser une classe pour faire la mediation entre toutes les fenetres ( ce que j'avais trouvé pour dekio ! )
	 */
	 
	public class PanelExploration extends Window 
	{
		private var _destTxt:InputText;		
		
		public function PanelExploration() 
		{
			super( SB.nativeStage, 25, 25, "Exploration" );
			
			var _vbox:VBox = new VBox(this);
			var _logBox:HBox = new HBox(_vbox, 5);
			_destTxt = new InputText(_logBox);
			_destTxt.text = "google.com";
			var _logLbl:Label = new Label(_logBox, 0, 0, "DESTINATION");
			var _okBtn:PushButton = new PushButton(_vbox, 5, 0, "OK", _onClickOkButton);
			
			_destTxt.setSize( 212, 20 );
			_okBtn.setSize(280, 40);
			
			this.setSize( 290, 100);
			
			this.hasCloseButton = true;			
		}
		
		public function destroy():void
		{
			SB.console.addMessage(this, "#destroy");
		}		
		
		// ===========================================================================================
		
		override protected function onClose(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			var commText:String = "oOo Je suis le pannel d'exploration oOo";
			commText += "\nDestination : Vous pouvez entrer ici l'adresse ( l'url ) d'un site web";
			commText += "\nExplorer : Si le site est accessible vous pourrez explorer et tenter de récupérer son Noyau";
			
			_updateCommPanel("--- Expédition en cours ---");			
		}
		
		private function _updateCommPanel(msg:String):void 
		{
			var dataE:DataEvent = new DataEvent( Config.E_UPDATE_COMM );
			dataE.data = msg;			
			EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
		}		
		
		// ===========================================================================================
		private function _onClickOkButton(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			_updateCommPanel("--- Expédition en cours ---");
			
			//[]this.enabled = false;
			var variables:URLVariables = new URLVariables;
			variables.destination = _destTxt.text;
			var m:Message = new Message(Config.A_DESTINATION, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseDestination, false, 0, true);
			m.sendAndLoad();
		}
		
		private function _onResponseDestination(e:Event):void
		{
			e.stopImmediatePropagation();
			
			var _commTxt:String = "oOo Aucun Evenement spécial oOo"
			_updateCommPanel( _commTxt );
			
			var resp:XML = (e.target as Message).response;
			var mess:String  = resp.message;
			SB.console.addMessage(mess);			
			this.enabled = true;
			
			var dataE:DataEvent;
			if ( mess.indexOf("OK::") > -1 )
			{
				var sp:Array = mess.split('.');
				_commTxt += '\n';
				_commTxt += 'Vous êtes devant le donjon de : ' + mess.substring(4, mess.length);
				if( sp[1] == "google" ){
					_commTxt += '\nSi cet univers a un centre, c\'est ici vous en êtes le + proche';
				}
				_commTxt += '\n';
				_commTxt += '\n';
				_commTxt += 'oOo Choisissez une action oOo';
				_updateCommPanel( _commTxt );
				
				dataE = new DataEvent(Config.E_DESTINATION);
				EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN ); 
			}else if ( mess.indexOf("KO::") > -1 ) {		
				_commTxt += '\n';
				_commTxt += 'Vous êtes devant le donjon de : ' + mess.substring(4, mess.length);
				_commTxt += '\n';
				_commTxt += '\n';
				_commTxt += 'oOo La porte est fermée et vous semble complètement impossible à ouvrir pour le moment oOo';
				
				dataE = new DataEvent(Config.E_RESET);
				EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );				
				_updateCommPanel( _commTxt );				
			}else {
				_commTxt = 'oOo ' + mess + ' oOo';
				_updateCommPanel( _commTxt );
			}
		}
		
		// ===========================================================================================		
		
		public function get destination():String 
		{
			return _destTxt.text;
		}
		
	}

}