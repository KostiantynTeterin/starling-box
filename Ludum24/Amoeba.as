package Ludum24
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
	public class Amoeba extends MovieClip
	{
		private var _centerX:int = 8;
		private var _centerY:int = 8;
		
		public var flag:Boolean = false;
		
		public var vx:Number;
		public var vy:Number;	
		public var s:Number;		
		
		public function Amoeba(atlas:TextureAtlas)
		{
			super(atlas.getTextures(), 8);
			this.pivotX = _centerX;
			this.pivotY = _centerY;
			this.loop	= true;
			this.touchable = false;
			Starling.juggler.add(this);			
		}
		
		public function init(px:Number, py:Number, sp:Number):void
		{
			this.x = px;
			this.y = py;
			this.s = sp;
			this.vx = 0;
			this.vy = 0;
			this.currentFrame = 0;
			this.flag = false;
			
			this.scaleY = this.scaleX = .8 + Math.random() ;
		}
		
		public function get centerX():int
		{
			return _centerX;
		}
		
		public function get centerY():int
		{
			return _centerY;
		}
		
		public function flagMe():void 
		{
			flag = true;
			vy = 0;
			Starling.juggler.remove(this);
		}
		
		public function destroy():void
		{
			this.dispose();
		}
	
	}

}