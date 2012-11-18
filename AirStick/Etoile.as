package AirStick 
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.TextureAtlas;
	import starlingBox.debug.Console;
	import starlingBox.game.pooling.Pool;
	import starlingBox.SB;
	import starlingBox.SoundBox;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Etoile extends MovieClip 
	{
		private var ttl:Number = 125;
		public function Etoile( ta:TextureAtlas ) 
		{
			super(ta.getTextures(), 6);
			this.touchable = false;
			
			this.pivotX = this.width >> 1;
			this.pivotY = this.height >> 1;
			this.scaleX = .3;
			this.scaleY = .3;			
			
		}
		
		public function init(x:int, y:int):void
		{
			ttl = 125;
			this.x = x;
			this.y = y;		
			this.addEventListener(Event.ENTER_FRAME, _oef );
		}
		
		private function _oef(e:EnterFrameEvent):void
		{
			this.rotation += .1;
			if ( --ttl < 0) {
				destroy();
			}
		}	
		
		public function destroy():void
		{
			removeEventListener(EnterFrameEvent.ENTER_FRAME, _oef);
			removeFromParent();
			Pool.instance.pool("etoiles").push(this);
		}		
		
	}

}