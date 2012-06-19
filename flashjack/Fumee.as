package flashjack 
{
	import flash.display.Bitmap;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	 
	public class Fumee extends MovieClip 
	{
		[Embed(source="../../media/fumee96.png")]
		private const ImageClass:Class;
		[Embed(source = "../../media/fumee96.xml", mimeType = "application/octet-stream")]
		private const DescriptionXML:Class;
		
		public function Fumee() 
		{
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new ImageClass() as Bitmap), XML(new DescriptionXML))
			super(atlas.getTextures(), 24);
			pivotX = 48;
			pivotY = 96;
			loop	= false;
			touchable = false;
			Starling.juggler.add(this);
			visible = false;			
			stop();
			this.addEventListener(Event.COMPLETE, _onMovieComplete );			
		}
		
		private function _onMovieComplete(e:Event):void
		{
			visible = false;
		}
		
		
		public function init(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		override public function play():void
		{
			currentFrame = 0;
			visible = true;
			super.play();
		}
		
	}

}