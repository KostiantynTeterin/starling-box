package alienfleet
{
	import flash.display.Bitmap;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Explosion extends MovieClip
	{
		// TIR
		[Embed(source="../../media/explosion2.png")]
		private const ExplosionClass:Class;
		[Embed(source = "../../media/explosion.xml",mimeType="application/octet-stream")]
		private const ExplosionXML:Class;
		
		private var _centerX:int = 64;
		private var _centerY:int = 64;
		
		public var flag:Boolean = false;
		
		public function Explosion()
		{
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ExplosionClass() as Bitmap), XML(new ExplosionXML))
			super(atlas.getTextures(), 24);
			this.pivotX = _centerX;
			this.pivotY = _centerY;
			this.loop	= false;
			this.touchable = false;
			Starling.juggler.add(this);			
			
			this.addEventListener(Event.COMPLETE, _onMovieComplete );
		}
		
		private function _onMovieComplete(e:Event):void
		{
			this.flag = true;
		}
		
		public function init(x:int, y:int):void
		{
			this.x = x;
			this.y = y;			
			this.currentFrame = 0;			
			this.flag = false;
			
			this.scaleY = this.scaleX = .5 + Math.random() ;			
			this.alpha = .5 + Math.random();
			this.rotation = Math.random() * (Math.PI * 2);
			this.color = int(Math.random() * 0xFFFFFF);
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