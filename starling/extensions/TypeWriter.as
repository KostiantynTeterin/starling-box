package starling.extensions
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import flash.text.TextFieldAutoSize;
	import starlingBox.SB;
	
	/*
	 * memory leak :/
	 * optim quad batch 1 per char
	 * sound (embed en bytearray, en base64 ?) 
	 * */
	
	public class TypeWriter extends Sprite
	{
		
		private const DEFAULT_DURATION:Number = 5.0;
		
		public static const RENDER_MODE_LETTER:int = 0;
		public static const RENDER_MODE_WORD:int = 1;
		public static const RENDER_MODE_LINE:int = 2;
		
		public static const EFFECT_NONE:int = 0;
		public static const EFFECT_ALPHA:int = 1;
		public static const EFFECT_SCALE:int = 2;
		public static const EFFECT_BOING:int = 3;
		//etc...
		
		private var _currentRenderMode:int = RENDER_MODE_LETTER;
		private var _currentEffect:int = EFFECT_ALPHA;
		
		private var _text:String
		private var _time:Point;
		private var _curr:int;
		private var _tween:Tween;
		
		private var _temp:Array;
		private var _flashTextField:flash.text.TextField;
		
		public function TypeWriter()
		{
			_time = new Point;
			_temp = new Array;
			_time.x = 0;
			_curr = 0;			
		}
		
		// -- INITIALIZE
		public function init(text:String, duration:Number = DEFAULT_DURATION):void
		{
			_text = text;
			
			_tween = new Tween(_time, duration, Transitions.EASE_IN);
			_tween.onUpdate = _onUpdate;
			_tween.onComplete = _onFinish;
			
			var size:int = 16;
			var color:int = 0x0;
			
			var fmt:TextFormat = new TextFormat;
			fmt.font = 'Arial';
			fmt.color = color;
			fmt.size = size;
			fmt.align = TextFormatAlign.CENTER;
			
			_flashTextField = new flash.text.TextField;
			_flashTextField.type = TextFieldType.INPUT;
			_flashTextField.maxChars = 800;
			_flashTextField.wordWrap = true;
			_flashTextField.width = 275;
			_flashTextField.multiline = true;
			_flashTextField.autoSize = TextFieldAutoSize.LEFT;
			_flashTextField.defaultTextFormat = fmt;
			_flashTextField.text = _text;
			//_flashTextField.border = true;
			_flashTextField.borderColor = 0xFF0000;
			//_flashTextField.selectable = false;
			_flashTextField.x = 340;
			_flashTextField.border = true;
			_flashTextField.borderColor = 0x0;
			SB.nativeStage.addChild(_flashTextField);
			
			//updateText();
		}
		
		public function initFromFlashTextfield(tf:flash.text.TextField, duration:Number = DEFAULT_DURATION):void
		{
			// TODO !
		}
		
		public function updateText():void
		{
			clear();

			// -- new value
			_text = _flashTextField.text;									
			// RENDER_MODE_LETTER
			var boundaries:Rectangle = new Rectangle;
			var fmt:TextFormat = _flashTextField.getTextFormat();
			var size:Number = (fmt.size) ? Number(fmt.size) : 12 ;
			var color:Number = (fmt.color) ? Number(fmt.color) : 0x0 ;
			var nb:int = _text.length;
			for (var i:int = 0; i < nb; i++)
			{
				boundaries = _flashTextField.getCharBoundaries(i); // magic function :D
				if (boundaries)
				{
					_temp[i] = new Letter(boundaries.width + 4, boundaries.height + 4, _text.charAt(i), fmt.font, size, color);
					_temp[i].x = boundaries.x - 2; //  default padding in regular flash textfield or magic number ?
					_temp[i].y = boundaries.y - 2; //  default padding in regular flash textfield or magic number ?
				}
			}
		}
		
		// ok
		public function resetTween(pDuration:Number, pTransition:String):void
		{
			_tween.reset(_time, pDuration, pTransition);
			_tween.onUpdate = _onUpdate;
			_tween.onComplete = _onFinish;
		}
		
		// -- DESTROYER
		// a checker !
		override public function dispose():void
		{
			_tween.onUpdate = null;
			_tween.onComplete = null;
			super.dispose();
		}
		
		// -- EVENTS
		private function _onUpdate():void
		{
			var time:int = _time.x >> 0;
			//trace( _time.x );
			if (time >= 0 && time <= _text.length)
			{
				var i:int;
				if (time > _curr)
				{
					
					var nb:int = time - _curr;
					var ref:Letter;
					for (i = time - nb; i < time; i++)
					{
						ref = _temp[i];
						if (ref)
						{
							ref.animate( _currentEffect );
							addChild(ref);
						}
					}
				}
				else
				{
					while (numChildren > time)
					{
						removeChildAt(numChildren - 1);
					}
				}
				_curr = time;
			}
		}
		
		private function _onFinish():void
		{
			Starling.juggler.remove(_tween);
			_time.x = 0;
			_curr = 0;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// -- PUBLIC METHODS
		public function start():void
		{
			Starling.juggler.add(_tween);
			_tween.moveTo(_text.length, 0);
		}
		
		public function set effect(type:int):void
		{
			_currentEffect = type;
		}
		
		public function set renderMode(type:int):void
		{
			_currentRenderMode = type;
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			_text = value;
		}
		
		public function skip():void
		{
			// TODO
		}
		
		public function pause():void
		{
			// TODO
		}
		
		public function resume():void
		{
			// TODO
		}
		
		public function clear():void
		{
			Starling.juggler.removeTweens(_tween);
			removeChildren();
			//
			var i:int = _temp.length;				
			while (i--) {
				if ( _temp[i] ) {
					(_temp[i] as Letter).destroy();					
					_temp[i] = null;	
				}
			}
			_temp.length = 0;
			
		}
	
	}

}

// LETTER CLASS

import flash.events.Event;
import starling.core.Starling;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.extensions.TypeWriter

class Letter extends TextField
{
	private var _tween:Tween;
	
	public function Letter(width:Number, height:Number, char:String, font:String, size:int, color:int)
	{
		super(width, height, char, font, size, color);
	}
	
	private function movePivotToCenter():void
	{
		if (this.pivotX == 0)
		{
			this.pivotX = width / 2;
			this.pivotY = height / 2;
			this.x += this.pivotX;
			this.y += this.pivotY;
		}
	}
	
	private function undoMovePivotToCenter():void
	{
		if (this.pivotX != 0)
		{
			this.x -= this.pivotX;
			this.y -= this.pivotY;
			this.pivotX = 0;
			this.pivotY = 0;
		}
	}
	
	private function animAplha(from:Number, to:Number):void
	{
		alpha = from;
		_tween = new Tween(this, .4, Transitions.EASE_IN);
		_tween.onComplete = _onComplete;
		_tween.fadeTo(to);
		Starling.juggler.add(_tween);
	}
	
	private function animScale(from:Number, to:Number):void
	{
		movePivotToCenter();
		scaleY = scaleX = from;
		_tween = new Tween(this, 2, Transitions.EASE_OUT_ELASTIC);
		_tween.onComplete = _onComplete;
		_tween.scaleTo(to);
		Starling.juggler.add(_tween);
	}
	
	private function animBoing(fromY:Number, toY:Number):void
	{
		this.y = fromY;
		_tween = new Tween(this, .5, Transitions.EASE_OUT_BOUNCE);
		_tween.onComplete = _onComplete;
		_tween.moveTo(this.x, toY);
		Starling.juggler.add(_tween);
	}
	
	public function destroy():void
	{
		_tween = null;		
		this.dispose();
	}	
	
	public function animate(anim:int = 1, from:Number=.0, to:Number=1.):void
	{
		switch (anim)
		{
			case TypeWriter.EFFECT_ALPHA:
				animAplha(.0, 1.0);
				break;
			
			case TypeWriter.EFFECT_SCALE:
				animScale(.5, 1.0);
				break;
			
			case TypeWriter.EFFECT_BOING:
				animBoing(this.y-8, this.y);
				break;
			
			default: 
			//
		}
	
	}
	
	public function _onComplete():void
	{
		Starling.juggler.removeTweens(this);
	}
}
