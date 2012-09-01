package Ludum24 
{
	import flash.display.Bitmap;
	import flash.system.Capabilities;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class StarField extends Sprite 
	{
		[Embed(source = "../../../media/stars.png")]	
		private const starTexture:Class;
		
		[Embed(source = "../../../media/stars.xml", mimeType = "application/octet-stream")]
		private const starAtlas:Class;
	
		private var WIDTH:int 			= 480;
		private var HEIGHT:int 			= 640;
		private var MAX_STARS:int 		= 300;
		
		private var starList:Vector.<MovieClip>;
		
		public function StarField(width:int = 480, height:int = 640, num_stars:int = 300 ) 
		{
			WIDTH 		= width;
			HEIGHT		= height;
			MAX_STARS	= Math.max(num_stars, 300);			
			starList 	= new Vector.<MovieClip>(MAX_STARS, true);
			
			var atlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new starTexture() as Bitmap), XML(new starAtlas));
			
			var star:MovieClip;
			for (var i:int = 0; i < MAX_STARS; i++) 
			{
				star = new MovieClip(atlas.getTextures(), 1);
				star.y = -10 + Math.random() * (HEIGHT + 20);
				star.scaleX = star.scaleY = 0.05 + Math.random() * 0.15;
				star.rotation = Math.random() * Math.PI * 2;
				star.pivotX = 16;
				star.pivotY = 16;
				starList[i] = star;
				addChild( star );
			}			
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			for (var i:int = 0; i < MAX_STARS; i++) 
			{
				starList[i].x = Math.random() * stage.stageWidth;			
			}
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			start();
		}
		
		
		private function enterFrame(e:EnterFrameEvent):void 
		{
			var sh:int = stage.stageHeight + 10;			
			
			var star:MovieClip;
			for (var i:int = 0; i < MAX_STARS; i++) 
			{
				star = starList[i];				
				star.y += star.scaleX * 10;
				star.rotation += star.scaleX / 5;
				star.alpha = Math.abs(star.rotation / Math.PI);
				if (star.y > sh) star.y = -10;
			}
			//trace( star.rotation );			
		}
		public function start():void 
		{
			if (!hasEventListener(EnterFrameEvent.ENTER_FRAME)) {
				addEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);			
			}			
		}
		
		public function stop():void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, enterFrame);
		}
		
	}

}