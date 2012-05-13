package starling.extensions
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.extensions.TileMap;
	import starling.textures.Texture;
	import starlingBox.SB;
	
	/**
	 * ...
	 * @author YopSolo
	 *
	 */
	public class TileMap
	{
		protected var _bg:Bitmap;
		protected var _image:Image;
		protected var _miniature:Image;
		protected var _arr:Array;
		protected var _xml:XML;
		protected var _blocs:Array;
		
		public function TileMap()
		{
			_blocs = [];
		}
		
		public function destroy():void
		{
			// --
		}
		
		// --		
		// Création des textures BG et miniature
		protected function buildImage():void
		{
			SB.console.addMessage(this, "== buildImage ==");
			
			var _datImage:BitmapData = new BitmapData(640, 640, false, 0x0);
			
			// creation de l'image de fond
			_datImage.copyPixels(_bg.bitmapData, _bg.bitmapData.rect, _bg.bitmapData.rect.topLeft);
			_bg.bitmapData.dispose();
			_bg = null;
			
			var nb:int = _xml.bloc.length();
			var bmp:Bitmap;
			var p:Point = new Point;
			var classe:String;
			for (var i:int = 0; i < nb; i++)
			{
				classe = _xml.bloc[i].@type;
				// TODO, à améliorer
				if (classe == "bloc" || classe == "blocBordGauche" || classe == "blocBordDroite")
				{
					bmp = _blocs[classe];
					p.x = _xml.bloc[i].@x;
					p.y = _xml.bloc[i].@y;
					_datImage.copyPixels(bmp.bitmapData, bmp.bitmapData.rect, p);
				}
			}
			_image = new Image(Texture.fromBitmapData(_datImage, true, false));
			(_blocs["bloc"] as Bitmap).bitmapData.dispose();
			(_blocs["blocBordGauche"] as Bitmap).bitmapData.dispose();
			(_blocs["blocBordDroite"] as Bitmap).bitmapData.dispose();
			
			// Creation de la miniature
			var _datMiniature:BitmapData = new BitmapData(20, 20, false, 0x0);
			for (i = 0; i < nb; i++)
			{
				classe = _xml.bloc[i].@type;
				// TODO, à améliorer
				if (classe == "bloc" || classe == "blocBordGauche" || classe == "blocBordDroite")
				{
					_datMiniature.setPixel(_xml.bloc[i].@x / 32, _xml.bloc[i].@y / 32, 0xFFFFFF);
				}
			}
			_miniature = new Image(Texture.fromBitmapData(_datMiniature, true, false));
			var w:int = _datMiniature.width;
			var h:int = _datMiniature.height;
			var k:int = 0;
			_arr = new Array;
			for (var y:int = 0; y < h; y++)
			{
				_arr[y] = [];
				
				for (var x:int = 0; x < w; x++, k++)
				{
					_arr[y][x] = (_datMiniature.getPixel(x, y) == 0) ? 0 : 1;
				}
			}
			
			_datMiniature.dispose();
		}
		
		// --
		public function get miniature():Image
		{
			return _miniature;
		}
		
		public function get image():Image
		{
			return _image;
		}
		
		// --
		public function get arr():Array
		{
			return _arr;
		}
	
	}

}