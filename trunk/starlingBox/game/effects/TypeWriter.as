package starlingBox.game.effects 
{
	import flash.text.TextField;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author YopSolo
	 * 
	 * idee 
	 * recycler 1 pool de N textfield
	 * 
	 */
	public class TypeWriter extends Sprite 
	{
		public static const RENDER_MODE_LETTER:String	= "TypeWriter_letter";
		public static const RENDER_MODE_WORD:String 	= "TypeWriter_word";
		public static const RENDER_MODE_LINE:String 	= "TypeWriter_line";
		
		public static const EFFECT_NONE:String 			= "TypeWriter_effect_none";
		public static const EFFECT_ALPHA:String 		= "TypeWriter_effect_alpha";
		// ...
		
		private var _duration:Number;
		private var _text:String
		private var _dummy:Object;
		
		public function TypeWriter() { 
			_dummy = {};			
		}
		
		
		public function init( d:Number, text:String ):void
		{
			_dummy.x = 0;
			_dummy.y = 0;
			
			_text = text;
			
			_duration = d;			
		}
		
		public function initFromFlashIdeTextField( tf:flash.text.TextField ):void {
			
		}
		
		public function start():void
		{
			var ref:Tween = new Tween( _dummy, _duration, Transitions.EASE_IN );
			ref.moveTo(100, 0);
			ref.onUpdate = updateMe;
			Starling.juggler.add( ref );
		}
		
		private function updateMe():void 
		{
			
		}
		
		public function skip():void
		{
			
		}
		
		public function pause():void
		{
			
		}
		
		public function clear():void
		{
			
		}
		
		private function _onFinish():void
		{
			//this.dispatchEvent();
		}
		
		override public function dispose():void
		{
			trace(this, "DESTROYED !");
			super.dispose();
		}
		
	}

}

