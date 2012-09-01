package flashjack 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Blast extends Sprite
	{
		private var _max_particles:int = 6;
		
		private var _count:int = 0;
		private var _particles:Vector.<Particle>;
		private var _gfx:Image;
		
		private var _bounds:Rectangle;
		
		public var isAvailable:Boolean = true;
		
		public function Blast(pRect:Rectangle) {
			_bounds = pRect;
			_particles = new Vector.<Particle>(_max_particles, true);			
			this.touchable = false;
			// --
			init();
		}
		
		// -- on cree la 1ere fois ensuite on reutilise
		public function init():void
		{
			var i:int;
			if ( numChildren < _max_particles ) 
			{
				for ( i = 0 ; i < _max_particles ; i++ ) {
					_particles[i] = new Particle(_bounds.width, _bounds.height );
					addChild( _particles[i] );
				}
			}else {
				for (i = 0 ; i < _max_particles ; i++ ) {
					_particles[i].init();
				}								
			}
		}		
		
		// --
		public function get max_particles():int { return _max_particles; }
		
		public function set max_particles(value:int):void
		{
			// -- todo
		}
		
		// --
		public function start():void
		{
			if( !this.hasEventListener(Event.ENTER_FRAME) ) {
				isAvailable = false;
				this.addEventListener(Event.ENTER_FRAME, _update );
			}
			
		}
		
		public function stop():void
		{
			this.removeEventListener(Event.ENTER_FRAME, _update );
			isAvailable = true;
			init();
		}
		
		// --
		public function _update(e:Event):void
		{
			for each (var p:Particle in _particles) {
				p.update();
				if (p.destroy) {
					if (++_count >= _max_particles) {
						stop();
					}
				}
			}
			_count = 0;
		}
		
		public function reset():void
		{
			for ( var i:int = 0 ; i < _max_particles ; i++ ) {
				// remove
				// destroy
			}			
		}
		
	}

}


import flash.display.Bitmap;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

class Particle extends Image
{
	[Embed(source = "../../../media/star32.png")]
	private const imageClass:Class;
	
    public var vx:Number;
    public var vy:Number;
    public var life:Number;
    public var size:Number;
	
	private var _count:uint;
    private var _destroy:Boolean;
	
	private var _maxX:int;
	private var _maxY:int;

    public function Particle(pMaxX:int = 320, pMaxY:int = 240)
    {
		super( Texture.fromBitmap( new imageClass as Bitmap ) );
		this.touchable = false;
		this.pivotX = 16;
		this.pivotY = 16;
		
		_maxX = pMaxX;
		_maxY = pMaxY;
		
		life = 300;
		
		init();
    }
	
	public function setGfx():void
	{
		//addChild( starlingImage );
		//this.flatten();
		
		//init();
	}

    public function init():void
    {
		scaleY = scaleX = .2 + ( Math.random() * .2 ); 
		x = 0;
		y = 0;
		rotation = Math.random() * Math.PI;
        vx = int(Math.random() * 6) - 3;
        vy = -int(Math.random() * 12); // Math.random() * 20 - 10;
        _count = 0;		
        _destroy = false;
		visible = false;
    }
	
    public function update():void
    {
		if ( !_destroy )
		{
			x += vx;
			vy += 1.5;
			y += vy;
			_count++;
			//rotation += -vx * 3;
			if(vx>0){
				rotation += .2;
			}else{
				rotation -= .2;
			}			
			
			if (life < _count || (x < -_maxX) || (x > _maxX) || (y > _maxY ) ) {				
				_destroy = true;
				visible = false;
			}
		}
		visible = !destroy;
    }

    public function get destroy():Boolean
    {
        return _destroy;
    }
}