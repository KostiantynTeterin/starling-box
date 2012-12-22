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
	import flash.display.Bitmap;
	import flash.text.TextFormat;
	import starling.display.Image;
	import starling.textures.Texture;
	
	import starling.display.Sprite;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class FenetrePiege2 extends Screen
	{
		[Embed(source="../assets/trou.png")]
		private const TrouGFXClass:Class;
		[Embed(source="../assets/mur.png")]
		private const MurGfxClass:Class;
		[Embed(source="../assets/bomb.png")]
		private const MineGfxClass:Class;
		
		protected var theme:MetalWorksMobileTheme;
		
		private var _header:Header;
		private var _tabBar:TabBar;
		private var _label:Label;
		private var _desc:TextFieldTextRenderer;
		private var _img:Image;
		
		private var _valider:Button;
		
		// un bouton valider 
		
		public function FenetrePiege2()
		{
		
		}
		
		override protected function initialize():void
		{
			// -- theme
			theme = new MetalWorksMobileTheme(stage);
			setSize(1080, 1047);
			
			// -- tabs
			_tabBar = new TabBar();
			_tabBar.dataProvider = new ListCollection([{label: "Trou"}, {label: "Mur"}, {label: "Mine"}]);
			addChild(_tabBar);
			_tabBar.addEventListener(Event.CHANGE, tabBar_changeHandler);
			
			// -- label
			_label = new Label();
			_label.setSize(100, 20);
			_label.text = "Selectionnez votre piege";
			addChild(DisplayObject(_label));
			
			// -- picto
			_img = new starling.display.Image(Texture.fromBitmap(new TrouGFXClass as Bitmap));
			_img.x = 100;
			_img.y = 100;
			addChild(_img);
			// --
			var fmt:TextFormat = new TextFormat;
			fmt.color = 0xFFFFFF;
			fmt.size = 18;
			_desc = new TextFieldTextRenderer();
			_desc.textFormat = fmt;
			_desc.wordWrap = true;
			_desc.setSize(300, 200);
			_desc.text = "* * *";
			addChild(_desc);
			
			// -- valider
			_valider = new Button();
			_valider.x = 0;
			_valider.y = 500;
			_valider.width = 640;
			_valider.label = "Valider";
			_valider.addEventListener(Event.TRIGGERED, _onClickValidate);
			addChild( _valider );
			
			// -- header
			_header = new Header();
			_header.title = "PHASE PIEGE";
			addChild(this._header);
		}
		
		private function _onClickValidate(e:Event):void 
		{
			trace("Selection", "#"+_tabBar.selectedIndex, _tabBar.selectedItem.label);
		}
		
		override protected function draw():void
		{
			this._header.width = this.actualWidth;
			this._header.validate();
			
			this._tabBar.width = this.actualWidth;
			this._tabBar.validate();
			this._tabBar.y = this.actualHeight - this._tabBar.height;
			
			this._label.x = (this.actualWidth - this._label.width) * .5;
			this._label.y = 100; // this._header.height + (this.actualHeight - this._header.height - this._tabBar.height - this._label.height) * .5;
			
			this._desc.x = (actualWidth - _label.width) * .5;
			this._desc.y = _label.y + _label.height + 50;
		
		}
		
		private function tabBar_changeHandler(event:Event):void
		{
			//_label.text = "selectedIndex: " + _tabBar.selectedIndex.toString();
			_img.dispose();
			removeChild(_img);
			if (_tabBar.selectedIndex == 0)
			{
				_img = new starling.display.Image(Texture.fromBitmap(new TrouGFXClass as Bitmap));
				_img.x = 150;
				_img.y = 180;
				_desc.text = "Le trou est le piege qui a la plus grande priorité (il bat tous les autres pieges), il bloque le passage mais laisse passer les tirs";
			}
			else if (_tabBar.selectedIndex == 1)
			{
				_img = new starling.display.Image(Texture.fromBitmap(new MurGfxClass as Bitmap));
				_img.x = 150;
				_img.y = 180;
				_desc.text = "Le mur bloque le passage et le champ de vision des snipers";
			}
			else
			{
				_img = new starling.display.Image(Texture.fromBitmap(new MineGfxClass as Bitmap));
				_img.x = 150;
				_img.y = 180;
				_desc.text = "La mine est invisible aux yeux de votre adversaire";
			}
			
			addChild(_img);
		
		}
	
	}

}