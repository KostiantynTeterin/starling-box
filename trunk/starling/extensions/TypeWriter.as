package starling.extensions
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starlingBox.SB;
	
	/* 
	 * V 0.0
	 * 
	 * [TODO]
	 * 
	 * RENDER_MODE_WORD
	 * RENDER_MODE_LINE
	 * new effects
	 * destroy
	 * sound
	 * optim drawcall
	 * 
	 * */
	
	public class TypeWriter extends Sprite
	{
		// CONFIG AND EVENTS
		private const DEFAULT_DURATION:Number = 5.0;
		private const DEBUG:Boolean = true;
		
		public static const RENDER_MODE_LETTER:int = 0;
		public static const RENDER_MODE_WORD:int = 1;
		public static const RENDER_MODE_LINE:int = 2;
		
		public static const EFFECT_NONE:int = 0;
		public static const EFFECT_ALPHA:int = 1;
		public static const EFFECT_SCALE:int = 2;
		public static const EFFECT_BOING:int = 3;
		// ...more
		
		private var _currentRenderMode:int = RENDER_MODE_LETTER;
		private var _currentEffect:int = EFFECT_ALPHA;
		
		// display
		private var _text:String;
		private var _time:Point;
		private var _curr:int;
		private var _tween:Tween;
		private var _boundaries:Rectangle;
		
		// letter pooling
		private var _LetterPool:Array;
		private var _LetterCounter:int;
		private var _currentLetter:Letter;
		
		private const POOL_GROW:int = 100;
		
		// regular Flash textfield
		private var _flashTextField:flash.text.TextField;
		
		public function TypeWriter()
		{
			// --
		}
		
		// ------------------------------------------------------------
		// -- INITIALIZE
		public function init(text:String, textfield:flash.text.TextField = null, textformat:TextFormat = null, duration:Number = DEFAULT_DURATION):void
		{
			// time
			_time = new Point;
			_time.x = 0;
			_curr = 0;
			
			// text
			_text = text;
			
			// display
			_tween = new Tween(_time, duration, Transitions.EASE_IN);
			_tween.onUpdate = _onUpdate;
			_tween.onComplete = _onFinish;
			
			// pooling
			_LetterPool = new Array;
			var i:int = _text.length;
			while (--i > -1)
				_LetterPool[i] = new Letter();
			_LetterCounter = _text.length;
			
			// textfield
			var size:int = 16;
			var color:int = 0x0;
			
			var fmt:TextFormat
			if (!textformat)
			{
				fmt = new TextFormat;
				fmt.font = 'Arial';
				fmt.color = color;
				fmt.size = size;
				fmt.align = TextFormatAlign.CENTER;
			}
			else
			{
				fmt = textformat;
			}
			
			if (textfield)
			{
				_flashTextField = textfield;
			}
			else
			{
				// my default textfield
				_flashTextField = new flash.text.TextField;
				_flashTextField.type = TextFieldType.INPUT;
				_flashTextField.maxChars = _text.length;
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
				
				_flashTextField.setTextFormat( new TextFormat( "Arial", 20, 0xCC0000), 0, 8 );
				
			}
			
			if (DEBUG)
				SB.nativeStage.addChild(_flashTextField);
		}
		
		// [TODO] améliorer si je change de textfield
		public function updateText():void
		{
			// clearing the displaylist
			clear();			
			// -- new text value
			_text = _flashTextField.text;		
		}
		
		// ------------------------------------------------------------
		// -- DESTROYER
		override public function dispose():void
		{
			_tween.onUpdate = null;
			_tween.onComplete = null;
			// [TODO] detruire la pool
			super.dispose();
		}
		
		// ------------------------------------------------------------
		// -- EVENTS
		private function _onUpdate():void
		{
			var time:int = _time.x >> 0;
			var color:int;
			var size:int;
			var fmt:TextFormat;
			
			// LETTER_MODE
			if (time >= 0 && time <= _text.length)
			{
				var i:int;
				if (time > _curr)
				{
					var nb:int = time - _curr;
					var ref:Letter;
					for (i = time - nb; i < time; i++)
					{
						_boundaries = _flashTextField.getCharBoundaries(i); // awesome function :D
						if (_boundaries)
						{
							fmt = _flashTextField.getTextFormat(i, i + 1);
							size = (fmt.size) ? Number(fmt.size) : 12;
							color = (fmt.color) ? Number(fmt.color) : 0x0;							
							ref = getLetter();							
							ref.init(_boundaries.width + 4, _boundaries.height + 4, _text.charAt(i), fmt.font, size, color);
							ref.x = _boundaries.x + 2; // + 2 and +4 are magic numbers
							ref.y = _boundaries.y + 2; // magic again !
							
							ref.animate(_currentEffect);
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
				
				// [TODO] play sound :D
			}
		}
		
		// -- OK
		private function _onFinish():void
		{
			Starling.juggler.remove(_tween);
			_time.x = 0;
			_curr = 0;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		// ------------------------------------------------------------
		// -- ACTION
		public function start():void
		{
			if (_text && text.length > 0)
			{
				_LetterCounter = _LetterPool.length;
				_currentLetter = _LetterPool[_LetterCounter];
				_tween.moveTo(_text.length, 0);
				Starling.juggler.add(_tween);
			}
		}
		
		// -- OK
		public function clear():void
		{
			Starling.juggler.removeTweens(_time);
			while (numChildren)
				disposeLetter(removeChildAt(0) as Letter);
		}
		
		// -- OK
		public function resetTween(pDuration:Number, pTransition:String):void
		{
			_tween.reset(_time, pDuration, pTransition);
			_tween.onUpdate = _onUpdate;
			_tween.onComplete = _onFinish;
		}
		
		// ------------------------------------------------------------
		// GETTER/SETTER
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
		
		// ------------------------------------------------------------
		// OTHER STUFF :p		
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
		
		// ------------------------------------------------------------
		// POOL
		private function getLetter():Letter
		{
			if (_LetterCounter > 0)
				return _currentLetter = _LetterPool[--_LetterCounter] as Letter;
			var i:uint = POOL_GROW;
			while (--i > -1)
				_LetterPool.unshift(new Letter());
			
			_LetterCounter = POOL_GROW;
			
			trace("#+++"+POOL_GROW, _LetterPool.length);
			
			return getLetter();
			
			return null;
		}
		
		private function disposeLetter(l:Letter):void
		{
			_LetterPool[_LetterCounter++] = l;
		}
	
	}

}

// LETTER CLASS

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.extensions.TypeWriter;
import starling.text.TextField;

class Letter extends TextField
{
	private var _tween:Tween;	
	
	public function Letter()
	{
		super(1, 1, "");
	}
	
	public function init(width:Number, height:Number, char:String, font:String, size:int, color:int):void
	{
		this.width = width;
		this.height = height;
		this.text = char;
		this.fontName = font;
		this.fontSize = size;
		this.color = color;
		// undo
		if (this.pivotX != 0) {
			this.x -= this.pivotX;
			this.y -= this.pivotY;
			this.pivotX = 0;
			this.pivotY = 0;			
		}
	}
	
	private function movePivotToCenter():void
	{
		this.pivotX = width / 2;
		this.pivotY = height / 2;
		this.x += this.pivotX;
		this.y += this.pivotY;
		
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
	
	public function animate(anim:int = 1, from:Number = .0, to:Number = 1.):void
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
				animBoing(this.y - 8, this.y);
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
