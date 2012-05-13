package starlingBox.debug
{
	import com.greensock.core.TweenCore;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starlingBox.SB;
	
	public class Console
	{
		private const VERSION:String = "v 0.0";
		private const WIDTH:int = 250;
		private const HEIGHT:int = 200;
		private const BGCOLOR:uint = 0x0000CC; // FF STYLE ^^
		private const TXCOLOR:uint = 0xFFFFFF;
		
		static private var _instance:Console;
		
		// Starling Sprite
		private var _gfx:Sprite = new Sprite;
		// Flash Native TextField
		private var _tf:TextField = new TextField();
		private var _stage:Stage;
		
		public function Console(singletonLock:SingletonLock)
		{
			_tf.width = WIDTH - 10;
			_tf.height = HEIGHT - 10;
			_tf.wordWrap = true;
			
			_tf.border = true;
			_tf.borderColor = TXCOLOR;
			_tf.background = true;
			_tf.backgroundColor = BGCOLOR;
			
			_tf.filters = [new DropShadowFilter()];
			
			var fmt:TextFormat = new TextFormat();
			fmt.font = "_sans";
			fmt.color = TXCOLOR;
			fmt.size = 12;
			_tf.defaultTextFormat = fmt;
		}
		
		public function addMessage(... data):void
		{
			var s:String = "";
			if (data)
			{
				//trace(data);
				if (data.length > 1)
				{
					var i:int = 0;
					while (i < data.length)
					{
						if (i > 0)
							s += " ";
						s += data[i++].toString();
					}
				}
				else
				{
					s = data.toString();
				}
			}
			
			_tf.appendText(s + "\n");
			_tf.scrollV = _tf.maxScrollV;
			
			if(Starling.context){
				var _txtDat:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0x000000);
				_txtDat.draw(_tf);
				_gfx.removeChildren();
				var txt:Image = new Image(Texture.fromBitmapData(_txtDat, false));
				_gfx.addChild(txt);
			}
			trace(data);
		}
		
		public function message(... data):void
		{
			_tf.text = "";
			addMessage(data);
		}
		
		public function set visible(value:Boolean):void
		{
			_gfx.visible = value;
		}
		
		static public function get instance():Console
		{
			if (!_instance)
				_instance = new Console(new SingletonLock);
			return _instance;
		}
		
		public function get gfx():Sprite
		{			
			return _gfx;
		}
		
		public function set x(pX:int):void
		{
			gfx.x = pX;
		}
		
		public function set y(pY:int):void
		{
			gfx.y = pY;
		}
		
		public function get width():int
		{
			return WIDTH;
		}
		
		public function get height():int
		{
			return HEIGHT;
		}
	}
}

internal class SingletonLock
{
	// --
}