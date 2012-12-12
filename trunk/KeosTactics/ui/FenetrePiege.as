package KeosTactics.ui
{
	/**
	 * ...
	 * @author YopSolo
	 */
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.Screen;
	import feathers.controls.TabBar;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.data.ListCollection;
	import feathers.themes.MetalWorksMobileTheme;
	import flash.text.TextFormat;
	
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class FenetrePiege extends Screen
	{
		protected var theme:MetalWorksMobileTheme;
		
		private var _header:Header;
		private var _tabBar:TabBar;
		private var _label:Label;
		private var _desc:TextFieldTextRenderer;
		
		// un bouton valider 
		// une image du piege
		// de la mise en page
		
		public function FenetrePiege()
		{
			trace("#1");			
		}
		
		override protected function initialize():void
		{
			trace("#2");
			// -- theme
			theme = new MetalWorksMobileTheme(stage);			
			setSize(640, 480);
			
			// -- tabs
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection(
			[
				{ label: "Trou" },
				{ label: "Mur" },
				{ label: "Mine" }
			]);			
			addChild(_tabBar);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			
			// -- label
			_label = new Label();
			_label.setSize(100,20);
			_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			addChild( DisplayObject(_label) );			
			
			// --
			var fmt:TextFormat = new TextFormat;
			fmt.color = 0xFFFFFF;
			fmt.size = 18;
			_desc = new TextFieldTextRenderer();
			_desc.textFormat = fmt;
			_desc.wordWrap = true;
			_desc.setSize( 300, 200 ); 
			_desc.text  = "* * *";
			addChild(_desc);
			
			// -- header
			_header = new Header();
			_header.title = "Tab Bar";
			addChild(this._header);			
		}
		
		override protected function draw():void
		{
			trace("#3", this.actualWidth);
			this._header.width = this.actualWidth;
			this._header.validate();

			this._tabBar.width = this.actualWidth;
			this._tabBar.validate();
			this._tabBar.y = this.actualHeight - this._tabBar.height;

			this._label.x = (this.actualWidth - this._label.width) / 2;
			this._label.y = 100; // this._header.height + (this.actualHeight - this._header.height - this._tabBar.height - this._label.height) / 2;
			
			this._desc.x = (actualWidth - _label.width) / 2;
			this._desc.y = _label.y + _label.height + 50; 
			
		}		
		
		private function tabBar_changeHandler(event:Event):void
		{
			trace("#4");
			_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			
			if (_tabBar.selectedIndex == 0) {
				_desc.text = "Le trou est le piege qui a la plus grande priorité (il bat tous les autres pieges), il bloque le passage mais laisse passer les tirs";
			}else if (_tabBar.selectedIndex == 1) {
				_desc.text = "Le mur bloque le passage et le champ de vision des snipers";
			}else {
				_desc.text = "La mine est invisible aux yeux de votre adversaire.";
			}
			
			
		}

	}

}