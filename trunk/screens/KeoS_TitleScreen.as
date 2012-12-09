package screens
{
	/**
	 * @author YopSolo
	 *
	 * jouer la musique du keos :)
	 * iexplore.exe http://127.0.0.1/lockpickers/index.php?local
	 * F:\WebLocal\Lockpickers\assets\swf
	 *
	 * login, OK
	 * login avec openID, TODO
	 * inscription, OK
	 * recup de MDP, OK
	 * generation de l'image de capcha, OK
	 * une window avec un panel de message, OK
	 * changement de page, OK
	 * déco, OK
	 * checker les destroyers, TODO (monocle)
	 * 
	 * _commTxt >> singleton
	 * Salle de détente, TODO
	 * Salle noire, TODO
	 * Quartier Perso, TODO
	 * Exploration, OK
	 * Atelier, TODO
	 * Salle d'entrainement, TODO
	 * 
	 * Panel profil
	 * Quitter, OK
	 * 
	 * table tricher
	 * - logger les tentatives d'accès à un donjon non autorisé, OK
	 * mdp, envoyer en md5 tester en md5, TODO
	 * 
	 * Traduction, OK
	 * faire le jeu en anglais/francais
	 * 
	 * pb sur l'insertion triche dans le script search.php
	 * améliorer le debug
	 * utiliser un eventBroker, OK
	 * tester si on peut outrepasser avec un form web, idée tout laisser en enabled true et tout apsser en verbose maximale !
	 * mise a jour de la fiche de perso (nombre de noyaux)
	 * sites spéciaux
	 * site tres spécial => google
	 * verif si urlUtils peut m'aider ou non dans le test de l'url et la recup du domaine
	 * 
	 * exemple de messages envoyés par delain
	 * methode=magie&sort_cod=3&cible=12072&type_lance=1
	 * methode=deplacement&position=52518&dist=1
	 * type_lance=1&sort=3
	 * methode=deplacement&position=52518&dist=1
	 * 
	 */
	
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import KeoS.Config;
	import KeoS.Datas;
	import KeoS.Message;
	import starlingBox.ConfigXML;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	public class KeoS_TitleScreen extends Screen
	{
		private var _PI:Window;
		private var _panel:Window;
		private var _logTxt:InputText;
		private var _mdpTxt:InputText;
		private var _logTxtPI:InputText;
		private var _mdpTxtPI:InputText;
		private var _mdpTxt2PI:InputText;
		private var _mailTxtPI:InputText;
		private var _capchaTxtPI:InputText;
		private var _comm:Window;
		private var _commTxt:TextArea;
		private var _recover:Window;
		private var _logTxtRE:InputText;
		private var _mailTxtRE:InputText;
		private var _captchaTxRE:InputText;
		private var _captchaLoader:Loader;
		
		public function KeoS_TitleScreen(){	}		
		
		//  * * *		
		override public function begin():void
		{
			var dico:XML = ConfigXML.instance.datas;
			
			_panel = new Window(SB.nativeStage);
			_panel.title = dico.title.BIENVENUE;
			
			var _vbox:VBox = new VBox(_panel);
			var _logBox:HBox = new HBox(_vbox, 5);
			_logTxt = new InputText(_logBox);
			_logTxt.text = "Ryoga";
			var _logLbl:Label = new Label(_logBox, 0, 0, dico.title.PSEUDO);
			var _mdpBox:HBox = new HBox(_vbox, 5);
			_mdpTxt = new InputText(_mdpBox);
			_mdpTxt.text = "lolpoulet";
			var _logMdp:Label = new Label(_mdpBox, 0, 0, dico.title.PASS);
			_mdpTxt.password = true;
			var _okBtn:PushButton = new PushButton(_vbox, 5, 0, "OK", _onClickOkButton);
			var _recupMdp:PushButton = new PushButton(_vbox, 5, 0, dico.title.RECUP, _onClickRecupMDP);
			var _inscription:PushButton = new PushButton(_vbox, 5, 0, dico.title.INSCRIPTION, _onClickInscription);
			var nb_joueurs:String = SB.flashvar("nb_joueurs", "X");
			var lbl:Label = new Label(_vbox, 5, 0, dico.title.ILYA +' '+ nb_joueurs +' '+ dico.title.ILYA2);
			
			
			
			_panel.setSize(210, 190);
			_panel.x = 25;
			_panel.y = 25;
			_okBtn.setSize(190, 40);
			_recupMdp.setSize(190, 20);
			_logTxt.setSize(155, 20);
			_mdpTxt.setSize(156, 20);
			_inscription.setSize(190, 20);
			
			// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
			
			_PI = new Window(SB.nativeStage, 250, 50, "Inscription");
			_PI.hasMinimizeButton = true;
			_PI.hasCloseButton = true;
			_PI.minimized = true;
			
			var _vboxPI:VBox = new VBox(_PI);
			
			var _logBoxPI:HBox = new HBox(_vboxPI, 5);
			_logTxtPI = new InputText(_logBoxPI);
			var _logLblPI:Label = new Label(_logBoxPI, 0, 0, "PSEUDO");
			
			var _mdpBoxPI:HBox = new HBox(_vboxPI, 5);
			_mdpTxtPI = new InputText(_mdpBoxPI);
			_mdpTxtPI.password = true;
			var _logMdpPI:Label = new Label(_mdpBoxPI, 0, 0, "PASS");
			
			var _mdpBox2PI:HBox = new HBox(_vboxPI, 5);
			_mdpTxt2PI = new InputText(_mdpBox2PI);
			_mdpTxt2PI.password = true;
			var _logMdp2PI:Label = new Label(_mdpBox2PI, 0, 0, "PASS (vérif)");
			
			var _mailPI:HBox = new HBox(_vboxPI, 5);
			_mailTxtPI = new InputText(_mailPI);
			var _mailLblPI:Label = new Label(_mailPI, 0, 0, "MAIL");
			
			var _capchaPI:HBox = new HBox(_vboxPI, 5);
			_capchaTxtPI = new InputText(_capchaPI, 0, 0, "Code de sécurité ->");
			_capchaTxtPI.addEventListener(MouseEvent.CLICK, _onFocusIn);
			var _capchaLblPI:Label = new Label(_capchaPI, 0, 0, "CAPTCHA");
			
			_captchaLoader = new Loader();
			_captchaLoader.x = _capchaLblPI.x + 5;
			_captchaLoader.y = _capchaPI.y - 4;
			_captchaLoader.load(new URLRequest(SB.flashvar("capcha", "0000")));
			_captchaLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _onLoadCaptchaComplete);
			_PI.addChild(_captchaLoader);
			
			var _okBtnPI:PushButton = new PushButton(_vboxPI, 5, 0, "OK", _onClickOkInscription);
			
			_PI.setSize(200, 190);
			_okBtnPI.setSize(190, 40);
			
			_PI.addEventListener(MouseEvent.CLICK, _onClickInscription);
			
			//SB.addConsole(this);
			
			// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
			
			_comm = new Window(SB.nativeStage, 680, 50, "Comm");
			_commTxt = new TextArea(_comm, 0, 0, "oOo bienvenue oOo");
			_commTxt.editable = false;
			_comm.setSize(300, 300);
			_commTxt.setSize(300, 275);
			
			// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
			
			_recover = new Window(SB.nativeStage, 465, 25, "Récupération mot de passe");
			_recover.setSize(200, 140);
			_recover.hasMinimizeButton = true;
			_recover.hasCloseButton = true;
			_recover.minimized = true;
			
			_recover.addEventListener( MouseEvent.CLICK, _onClickRecover );
			
			var _recoverVbox:VBox = new VBox(_recover);
			
			var _logBoxRE:HBox = new HBox(_recoverVbox, 5);
			_logTxtRE = new InputText(_logBoxRE);
			var _logLblRE:Label = new Label(_logBoxRE, 0, 0, "PSEUDO");
			
			var _mailRE:HBox = new HBox(_recoverVbox, 5);
			_mailTxtRE = new InputText(_mailRE);
			var _mailLblRE:Label = new Label(_mailRE, 0, 0, "ou MAIL");
			
			var _capchaRE:HBox = new HBox(_recoverVbox, 5);
			_captchaTxRE = new InputText(_capchaRE, 0, 0, "Code de sécurité ->");
			_captchaTxRE.addEventListener(MouseEvent.CLICK, _onFocusIn);
			var _capchaLblRE:Label = new Label(_capchaRE, 0, 0, "CAPTCHA");
			
			var _okBtnRE:PushButton = new PushButton(_recoverVbox, 5, 0, "OK", _onClickOkRecover);
			_okBtnRE.setSize(190, 40);			
		}
		
		override public function destroy():void
		{
			_PI.removeEventListener(MouseEvent.CLICK, _onClickInscription);
			_capchaTxtPI.removeEventListener(MouseEvent.CLICK, _onFocusIn);
			_captchaTxRE.removeEventListener(MouseEvent.CLICK, _onFocusIn);
			_captchaLoader.unloadAndStop();
			
			while ( SB.nativeStage.numChildren ) SB.nativeStage.removeChildAt(0);
		}
		
		
		private function _onLoadCaptchaComplete(e:Event):void
		{
			var dat:BitmapData = new BitmapData(75, 25, false, 0x0);
			dat.draw(_captchaLoader);
			var clone:Bitmap = new Bitmap(dat);
			clone.x = 111;
			clone.y = 42;
			_recover.addChild(clone);
		}
		
		private function _onClickOkRecover(e:MouseEvent):void
		{
			_commTxt.text = "--- Recupération du mot de passe ---";
			_recover.enabled = false;
			var variables:URLVariables = new URLVariables;
			variables.pseudo = _logTxtRE.text;
			variables.email = _mailTxtRE.text;
			variables.capcha = _captchaTxRE.text;
			var m:Message = new Message(Config.A_PASSRECOVER, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseRecover, false, 0, true);
			m.sendAndLoad();
		}
		
		private function _onResponseRecover(e:Event):void
		{
			e.stopImmediatePropagation();
			_recover.enabled = true;
			var resp:XML = (e.target as Message).response;
			SB.console.addMessage(resp.message);
			if (resp.message == "Envoi OK")
			{
				_commTxt.text = "oOo Le mail a bien été envoyé oOo";
			}
			else
			{
				_commTxt.text = "oOo "+resp.message+" oOo";
			}
		}
		
		private function _onFocusIn(e:MouseEvent):void
		{
			e.target.text = "";
		}
		
		private function _onClickRecupMDP(e:MouseEvent):void
		{
			_recover.minimized = false;
		}
		
		private function _onClickOkButton(e:MouseEvent):void
		{
			_commTxt.text = "--- Identification en cours ---";
			_panel.enabled = false;
			var variables:URLVariables = new URLVariables;
			variables.pseudo = _logTxt.text;
			variables.pass = _mdpTxt.text;
			var m:Message = new Message(Config.A_LOGMEIN, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponse, false, 0, true);
			m.sendAndLoad();
		}
		
		private function _onResponse(e:Event):void
		{
			e.stopImmediatePropagation();
			var resp:XML = (e.target as Message).response;
			SB.console.addMessage(resp.message);
			if (resp.message == "access granted")
			{
				_commTxt.text = "oOo :) oOo";
				// --
				Datas.instance.pseudo = _logTxt.text;
				SB.console.addMessage( resp.datas );
				var sp:Array = resp.datas.split(':');				
				Datas.instance.FOR = sp[0];
				Datas.instance.DEX = sp[1];
				Datas.instance.END = sp[2];
				Datas.instance.POU = sp[3];
				Datas.instance.XP = sp[4];				
				// --
				Datas.instance.domaines =  resp.noyaux.split(',');
				Datas.instance.domaines.length = Datas.instance.domaines.length - 1;
				// --
				SB.screen = new Keos_GuildScreen;
			}
			else
			{
				_panel.enabled = true;
				_commTxt.text = "oOo Erreur :/ oOo";
			}
		}
		
		private function _onResponseInscription(e:Event):void
		{
			e.stopImmediatePropagation();
			_PI.enabled = true;
			var resp:XML = (e.target as Message).response;
			SB.console.addMessage('#IResponse', resp.message);
			if (resp.message == "Bienvenue")
			{
				_commTxt.text = "oOo Inscription reussie oOo";
				_logTxt.text = _logTxtPI.text;
				_mdpTxt.text = _mdpTxtPI.text;
			}
			else
			{
				_PI.enabled = true;
				_commTxt.text = "oOo " + resp.message + " oOo";
			}
		
		}
		
		private function _onClickInscription(e:MouseEvent = null):void
		{
			_PI.minimized = false;
			_commTxt.text = "oOo Informations oOo";
			_commTxt.text += "\n- Le pseudo ne peut conteniur que des lettres de l'alphabet";
			_commTxt.text += "\n- Le mail est necessaire pour vous renvoyer votre mot de passe en cas d'oubli";
			_commTxt.text += "\n- Le mot de passe doit compter au moins au moins 6 caractères mais attention les mots de passe du type 123456, azerty etc. seront refusés";
			_commTxt.text += "\n- Le capcha sert à verifier que vous n'êtes pas un 'robot spammeur'";
		}
		
		private function _onClickRecover(e:MouseEvent = null):void
		{
			_recover.minimized = false;
			_commTxt.text = "oOo Informations oOo";
			_commTxt.text += "\n- Au choix vous pouvez renseigner votre email d'inscription ou bien votre pseudo.";
		}
		
		
		
		private function _onClickOkInscription(e:MouseEvent):void
		{
			SB.console.addMessage("#onClickInscription");
			_commTxt.text = "--- Inscription en cours ---";
			_PI.enabled = false;
			var variables:URLVariables = new URLVariables;
			variables.email = _mailTxtPI.text;
			variables.pseudo = _logTxtPI.text;
			variables.pass = _mdpTxtPI.text;
			variables.passCheck = _mdpTxt2PI.text;
			variables.capcha = _capchaTxtPI.text;
			var m:Message = new Message(Config.A_INSCRIPTION, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseInscription, false, 0, true);
			m.sendAndLoad();
		}		
	
	}

}