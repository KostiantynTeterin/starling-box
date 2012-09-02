package starlingBox.game.effects
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.text.TextField;
	import flash.text.TextFieldAutoSize;
	import starlingBox.SB;
	
	/*
	 * set transition
	 * gerer les retour arriere
	 * optmiser
	 * son (embed en bytearray, en base64 ?)
	 * */
	
	public class TypeWriter extends Sprite
	{
		
		private const DEFAULT_DURATION:Number = 1.0;
		
		public static const RENDER_MODE_LETTER:int = 0;
		public static const RENDER_MODE_WORD:int = 1;
		public static const RENDER_MODE_LINE:int = 2;
		
		public static const EFFECT_NONE:int = 0;
		public static const EFFECT_ALPHA:int = 1;
		//etc...
		
		private var _currentRenderMode:int = RENDER_MODE_LETTER;
		private var _currentEffect:int = EFFECT_NONE;
		
		private var _text:String
		private var _time:Point;
		private var _curr:int;
		private var _tween:Tween;
		
		private var _temp:Vector.<Letter>;
		private var _flashTextField:flash.text.TextField;
		
		public function TypeWriter()
		{
			_time = new Point;
			_time.x = 0;
			_curr = 0;
			_flashTextField = new flash.text.TextField;
		}
		
		// -- INITIALIZE
		public function init(text:String, duration:Number = DEFAULT_DURATION):void
		{
			_text = text;
			_tween = new Tween(_time, duration, Transitions.EASE_OUT);
			_tween.onUpdate = _onUpdate;
			_tween.onComplete = _onFinish;
			
			var size:int = 16;
			var color:int = 0x0;
			
			var fmt:TextFormat = new TextFormat;
			fmt.font = 'Arial';
			fmt.color = color;
			fmt.size = size;
			fmt.align = TextFormatAlign.CENTER;
			
			_flashTextField.wordWrap = true;
			_flashTextField.width = 275;
			_flashTextField.autoSize = TextFieldAutoSize.LEFT;
			_flashTextField.defaultTextFormat = fmt;
			_flashTextField.text = _text;
			//_flashTextField.border = true;
			_flashTextField.borderColor = 0xFF0000;
			_flashTextField.selectable = false;
			_flashTextField.x = 340;
			SB.nativeStage.addChild( _flashTextField );
			
			// RENDER_MODE_LETTER						
			_temp = new Vector.<Letter>(text.length, true);
			var boundaries:Rectangle = new Rectangle;
			var nb:int = text.length;
			for (var i:int = 0; i < nb; i++)
			{
				boundaries = _flashTextField.getCharBoundaries(i); // magic function :D
				if (boundaries)
				{
					_temp[i] = new Letter( boundaries.width + 4, boundaries.height + 4, _text.charAt(i), fmt.font, size, color );
					_temp[i].x = boundaries.x - 2; //  default padding in regular flash textfield or magic number ?
					_temp[i].y = boundaries.y - 2; //  default padding in regular flash textfield or magic number ?
				}
			}
		
		}
		
		public function initFromFlashTextfield(tf:flash.text.TextField, duration:Number = DEFAULT_DURATION):void
		{
		
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
				if ( time > _curr)
				{
					
					var nb:int = time - _curr;
					var ref:Letter;
					for (i = time-nb; i < time ; i++ ) {
						ref = _temp[i];
						if (ref) {						
							//ref.animAplha(0, 1);
							//ref.animScale(.5,1);
							//ref.animFall(ref.y - 8, ref.y);
							addChild( ref );
						};
					}	
				}else {
					while (numChildren > time) {
						removeChildAt( numChildren-1 ) ; 
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
			trace(this, "FINISHED!");
			//this.dispatchEvent();
		}
		
		// -- PUBLIC METHODS
		public function start():void
		{
			Starling.juggler.add(_tween);
			_tween.moveTo(_text.length, 0);
		}
		
		public function skip():void
		{
			// stop la tween et affiche tout le texte
		}
		
		public function pause():void
		{
			// pause la tween
		}
		
		public function resume():void
		{
			// resume la tween
		}
		
		public function reset():void
		{
			// efface le contenu et reset les variables
		}
	
	}

}


// LETTER CLASS

import starling.core.Starling;
import starling.text.TextField;
import starling.animation.Transitions;
import starling.animation.Tween;

class Letter extends TextField
{
	private var _tween:Tween;
	
	public function Letter( width:Number, height:Number, char:String, font:String, size:int, color:int ) {
		super(width, height, char, font, size, color);
	}
	
	private function movePivotToCenter():void
	{
		if(this.pivotX == 0){
			this.pivotX = width / 2;
			this.pivotY = height / 2;
			this.x += this.pivotX;
			this.y += this.pivotY;		
		}
	}
	
	private function undoMovePivotToCenter():void
	{
		if(this.pivotX != 0){
			this.x -= this.pivotX;
			this.y -= this.pivotY;		
			this.pivotX = 0;
			this.pivotY = 0;			
		}
	}	
	
	public function animAplha(from:Number, to:Number):void
	{
		alpha = from;
		_tween = new Tween(this, .4, Transitions.EASE_IN);
		_tween.onComplete = _onComplete;
		_tween.fadeTo( to );
		Starling.juggler.add( _tween );
	}
	
	public function animScale(from:Number, to:Number):void
	{
		movePivotToCenter();
		scaleY = scaleX = from;
		_tween = new Tween(this, 2, Transitions.EASE_OUT_ELASTIC);
		_tween.onComplete = _onComplete;
		_tween.scaleTo(to);
		Starling.juggler.add( _tween );
	}	
	
	public function animFall( fromY:Number, toY:Number ):void
	{
		this.y = fromY;
		_tween = new Tween(this, .5, Transitions.EASE_OUT_BOUNCE);
		_tween.onComplete = _onComplete;
		_tween.moveTo( this.x, toY );
		Starling.juggler.add( _tween );
	}	
	
	public function _onComplete():void
	{
		Starling.juggler.removeTweens( this );
	}
	
}
