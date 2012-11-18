package AirStick
{
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starlingBox.game.pooling.Pool;
	import starlingBox.SB;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Tir extends MovieClip
	{
		private var speed:int = 15;
		private var angleVaisseau:Number;
		private var screenRect:Rectangle;
		
		public function Tir( ta:TextureAtlas )
		{
			super(ta.getTextures(), 6);
			this.touchable = false;
			this.pivotX = this.width / 2;
			this.pivotY = this.height;			
			screenRect = new Rectangle(-64, -64, SB.width+64, SB.height+64);			
		}
		
		public function init(x:int, y:int, angle:Number):void
		{
			this.x = x;
			this.y = y;
			this.angleVaisseau = angle;
			this.rotation = angle + (Math.PI * 1 / 2);	
			Starling.juggler.add(this);			
			this.addEventListener(Event.ENTER_FRAME, _oef );			
		}
		
		private function _oef(e:EnterFrameEvent):void
		{
			if (screenRect.containsRect( this.getBounds(this.parent) ) ) {
				x += Math.cos(angleVaisseau) * speed;
				y += Math.sin(angleVaisseau) * speed;				
			}else{			
				destroy();				
			}
			
		}
		
		public function destroy():void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, _oef);
			Starling.juggler.remove( this);
			removeFromParent();
			Pool.instance.pool("tirs").push(this);
		}
		
	}

}