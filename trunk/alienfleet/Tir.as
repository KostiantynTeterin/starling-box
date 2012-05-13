package alienfleet
{
	import flash.display.Bitmap;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Tir extends MovieClip
	{
		// TIR
		[Embed(source="../../media/tir.png")]
		private const TirClass:Class;
		[Embed(source="../../media/tir.xml",mimeType="application/octet-stream")]
		private const TirXML:Class;
		
		private var _centerX:int = 0;
		private var _centerY:int = 0;
		private var speed:int = 18;
		
		public var flag:Boolean = false;
		
		public function Tir()
		{
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new TirClass() as Bitmap), XML(new TirXML))
			super(atlas.getTextures(), 12);
			this.scaleX = .5;
			this.scaleY = .5;
			this.alpha = .8;
			this.touchable = false;
			Starling.juggler.add(this);
		}
		
		public function init(x:int, y:int):void
		{
			this.x = x -11;
			this.y = y - 80;
			this.flag = false;
			if ( !hasEventListener(EnterFrameEvent.ENTER_FRAME) ) {
				addEventListener(EnterFrameEvent.ENTER_FRAME, _oef);
			}			
		}
		
		private function _oef(e:EnterFrameEvent):void
		{
			if (y > -64)
			{
				y -= speed;
			}
			else
			{
				removeEventListener(EnterFrameEvent.ENTER_FRAME, _oef);
				flag = true;
			}
		}
		
		public function get centerX():int
		{
			return _centerX;
		}
		
		public function get centerY():int
		{
			return _centerY;
		}
	
	}

}