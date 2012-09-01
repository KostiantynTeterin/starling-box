package KeoS 
{
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.TextArea;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLVariables;
	import starlingBox.game.maze.Maze;
	import starlingBox.game.utils.XORTexture;
	import starlingBox.SB;	
	import starlingBox.utils.EventBroker;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PanelEntree extends Window 
	{
		private var _maze:Maze;
		private var _floor:Shape;
		private var _walls:Sprite;
		
		private var _explorerBtn:PushButton;
		private var _ouvrirBtn:PushButton;
		
		[Embed(source = "../../../media/KeoS/closedDoor3.jpg")]
		private var closeDoorImgClass:Class;		
		
		public function PanelEntree() 
		{
			super( SB.nativeStage, 25, 165, "---" );			
			this.setSize(590, 470);	
			
			var _vbox:VBox = new VBox( this );
			
			var sp:Component = new Component( _vbox );
			sp.addChild( new closeDoorImgClass() as Bitmap );
			sp.setSize( 480, 270 );
			
			var _hbox:HBox = new HBox(_vbox, 5);
			_ouvrirBtn = new PushButton(_hbox, 5, 0, "Ouvrir", _onClickOuvrirButton);
			_explorerBtn = new PushButton(_hbox, 5, 0, "Explorer", _onClickExplorerButton);
			
			_floor = new Shape;
			_walls = new Sprite;
			_walls.filters = [new DropShadowFilter(4, 45, 0, 1, 6, 6, 1, 1)];			
			_walls.mouseChildren = false;
			//update( 'http://www.google.com' );
		}
		
		public function destroy():void
		{
			SB.console.addMessage(this, "#destroy");
		}			
		
		public function initMe():void
		{
			this.visible = true;
			_ouvrirBtn.enabled = true;
			//[]_explorerBtn.enabled = false;			
		}
		
		private function _updateCommPanel(msg:String):void 
		{
			var dataE:DataEvent = new DataEvent( Config.E_UPDATE_COMM );
			dataE.data = msg;			
			EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
		}		
		
		public function lock():void
		{
			this.visible = true;
			//[]_ouvrirBtn.enabled = false;
			//[]_explorerBtn.enabled = false;				
		}
		
		// ===========================================================================================
		
		public function _onClickOuvrirButton(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			//[]this.enabled = false;
			
			_updateCommPanel( "--- Ouverture en cours ---" );
			
			var variables:URLVariables = new URLVariables;
			var m:Message = new Message(Config.A_OPEN, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseOuvrir, false, 0, true);
			m.sendAndLoad();
		}
		
		private function _onResponseOuvrir(e:Event):void 
		{
			this.enabled = true;			
			//[]_ouvrirBtn.enabled = false;
			// --
			var resp:XML = (e.target as Message).response;			
			var message:String = resp.message.toString();			
			switch ( message )
			{
				// protection ?
				case 'nope' :
						_updateCommPanel( "oOo La porte d'entrée est ouverte oOo" );
						_explorerBtn.enabled = true;
					break;
				case 'yep' :
						_updateCommPanel( "oOo La porte est fermée et vous semble complètement impossible à ouvrir pour le moment oOo" );
						_explorerBtn.enabled = true;
					break;					
				default :
					break;
			}			
			
			SB.console.addMessage( resp.message );
		}	
		
		// ===========================================================================================
		public function _onClickExplorerButton(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			//SB.console.addMessage("#TODO, _onClickExplorerButton");
			
			_updateCommPanel( "--- L'exploration commence---" );
			//[]this.enabled = false;
			var variables:URLVariables = new URLVariables;
			var m:Message = new Message(Config.A_SEARCH, variables);
			m.addEventListener(Message.ON_RESPONSE, _onResponseExplorer, false, 0, true);
			m.sendAndLoad();
			
		}		
		
		private function _onResponseExplorer(e:Event):void 
		{
			e.stopImmediatePropagation();
			
			//[]_explorerBtn.enabled = false;
			var commText:String;
			var resp:XML = (e.target as Message).response;
			var mess:String  = resp.message;
			SB.console.addMessage(mess);
			
			this.enabled = true;
			var nope:Boolean = false;
			if ( mess.indexOf("A") > -1 )
			{
				commText = 'Vous arrivez dans la salle du trésor.\nYouhooo vous avez récupéré un noyau supplémentaire :)';				
				var dataE:DataEvent = new DataEvent( Config.E_GETINFOS );
				EventBroker.broadcast( dataE, Config.C_GUILD_SCREEN );
			}else if ( mess.indexOf("B") > -1 ) {
				commText = 'Vous arrivez dans la salle du trésor, mais elle a déjà été pillée :/';
			}else if (mess.indexOf("G") > -1) {
				nope = true;
				commText = "oOo vous êtes devant l'oracle oOo";
				commText += "\n";
				commText += "TODO:: mettre les FAQs ici";
				_updateCommPanel( commText );				
			}else{
				nope = true;
				commText = "oOo La porte est fermée et vous semble complètement impossible à ouvrir pour le moment oOo";
			}
			
			if (!nope) {
				var nbNoyaux:Array = mess.split("::");
				if (nbNoyaux[1] == '0') {				
					commText += '\n';
					commText += 'Essayez de chercher une destination moins commune.';
				}
				SB.console.addMessage(this, "#_onResponseExplorer>!nope");
			}
			
			_updateCommPanel( commText );			
		}		
		
		public function update(url:String):void
		{
			if (_maze) clear();
			_maze = new Maze(url);
			build();
		}
		
		public function clear():void
		{
			//removeChild( _floor );
			//removeChild( _walls );
			_floor.graphics.clear();
			while ( _walls.numChildren ) _walls.removeChildAt(0);
			if(_maze) _maze.destroy();			
		}
		
		public function build():void
		{
			var T:int = 16;
			_floor.graphics.beginBitmapFill( new XORTexture( 32, 32, 0xCCCCCC ) );
			_floor.graphics.drawRect(0, 0, _maze.WIDTH * T, _maze.HEIGHT * T );
			_floor.graphics.endFill();
			
			for (var x:int = 0; x < _maze.WIDTH ; x++ ) {
				for (var y:int = 0; y < _maze.HEIGHT; y++ ) {
					var tile:Bitmap;			
					if ( _maze.labyrinthe_dat.getPixel( x, y ) == 0x0 ) {
						tile = getTile1( T );
						tile.x = T * x;
						tile.y = T * y;
						_walls.addChild( tile )
					}						
				}
			}
			
			addChild( _floor );
			addChild( _walls );			
		}
		
		private function getTile1(taille:int):Bitmap {
			return new Bitmap( new BitmapData(taille, taille, false, 0x0) );
		}		
		
	}

}