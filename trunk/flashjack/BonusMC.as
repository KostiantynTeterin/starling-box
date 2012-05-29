package flashjack 
{
	import flash.geom.Rectangle;
	import starling.display.MovieClip;
	import starling.core.Starling;
	import starling.textures.Texture;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class BonusMC extends MovieClip 
	{
		
		private const FPS:int = 12;
		private var _aabb:Rectangle;
		
		public function BonusMC( frames:Vector.<Texture> ) 
		{
			super(frames, FPS);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			_aabb = getBounds( this.stage );
			_aabb.x += 8;
			_aabb.y += 8;
			_aabb.width = 16;
			_aabb.height = 16;
			Starling.juggler.add(this);
		}
		
		public function get aabb():Rectangle
		{
			return _aabb;
		}
		
	}

}