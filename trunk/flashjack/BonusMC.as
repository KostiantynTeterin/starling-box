package flashjack 
{
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
		
		public function BonusMC( frames:Vector.<Texture> ) 
		{
			super(frames, FPS);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
			Starling.juggler.add(this);
		}
		
	}

}