package KeoS 
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.events.Event;
	import flash.net.URLVariables;
	import starlingBox.SB;
	import starlingBox.utils.EventBroker;
	
	/**
	 * @author YopSolo
	 * 
	 */
	 
	public class PanelFichePerso extends Window 
	{
		private var niv_xpVal:Label;
		private var forceVal:Label;
		private var dextVal:Label;
		private var endVal:Label;
		private var pouVal:Label;
		private var descLbL:Label;
		
		public function PanelFichePerso()
		{
			super( SB.nativeStage, 680, 270, "Fiche de personnage" );
			
			var _vbox:VBox = new VBox(this);
			var pseudoLbl:Label = new Label(_vbox, 0, 0, Datas.instance.pseudo  );
			
			var xpHB:HBox = new HBox( _vbox );
			var niv_xplbl:Label = new Label(xpHB,0,0, 'Niveau (XP) ' );
			niv_xpVal = new Label(xpHB, 0, 0, '-' );
			//niv_xplbl.setSize( 250, 20 );
			
			var forceHB:HBox = new HBox( _vbox );
			forceVal = new Label(forceHB, 0, 0, '-' );				
			var forcelbl:Label = new Label(forceHB,0,0, ' : FORce' );
			//forcelbl.setSize( 250, 20 );
			
			var dextHB:HBox = new HBox( _vbox );
			dextVal = new Label(dextHB, 0, 0, '-' );			
			var dextlbl:Label = new Label(dextHB,0,0, ' : DEXtérité' );
			//dextlbl.setSize( 250, 20 );
			
			var endHB:HBox = new HBox( _vbox );
			endVal = new Label(endHB, 0, 0, '-' );			
			var endlbl:Label = new Label(endHB,0,0, ' : ENDurance' );
			//endlbl.setSize( 250, 20 );
			
			var pouHB:HBox = new HBox( _vbox );
			pouVal = new Label(pouHB, 0, 0, '-' );
			var poulbl:Label = new Label(pouHB,0,0, ' : POUvoir : ' );		
			//poulbl.setSize( 250, 20 );
			
			var descHB:HBox = new HBox( _vbox );
			descLbL = new Label(descHB,0,0, '-' );
			
			update();
			
			//this.setSize( 300, 350);
			this.setSize( 300, 200);
			EventBroker.subscribe(Config.E_UPDATE, update, Config.C_GUILD_SCREEN );
		}		
		
		public function destroy():void
		{
			SB.console.addMessage(this, "#destroy");
		}			
		
		public function update(e:DataEvent = null):void
		{
			SB.console.addMessage(this, "#appel de update");
			var datas:Datas = Datas.instance;
			niv_xpVal.text = datas.NIV +' (' + datas.XP + ')';
			forceVal.text = datas.FOR.toString() + ' (' + datas.mFOR +')';
			dextVal.text = datas.DEX.toString() + ' (' + datas.mDEX +')';
			endVal.text = datas.END.toString() + ' (' + datas.mEND +')';;
			pouVal.text = datas.POU.toString() + ' (' + datas.mPOU +')';;
			
			if ( datas.domaines.length == 0) {
				descLbL.text = "Vous n'avez aucun noyau. Lancez vous dans l'exploration ^^";
			}else if ( datas.domaines.length == 1) {
				descLbL.text = 'Au total vous avez 1 noyau ('+datas.domaines+')';
			}else {
				descLbL.text = 'Vous avez ' + datas.domaines.length + ' noyaux ('+datas.domaines+')';
			}
		}
		
		private function _updateCommPanel(msg:String):void 
		{
			var dataE:DataEvent = new DataEvent( Config.E_UPDATE_COMM );
			dataE.data = msg;			
			EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
		}		
		
	}

}