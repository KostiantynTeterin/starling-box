package starlingBox.game.utils
{
	
	public class Ran
	{
		protected static var _instance:Ran;
		
		public static function get instance():Ran
		{
			if (_instance == null)
			{
				_instance = new Ran();
			}
			return _instance;
		}
		
		public static function get seed():uint
		{
			return instance.seed;
		}
		
		public static function set seed(value:uint):void
		{
			instance.seed = value;
		}
		
		public static function get currentSeed():uint
		{
			return instance.currentSeed;
		}
		
		public static function random():Number
		{
			return instance.random();
		}
		
		public static function float(min:Number, max:Number = NaN):Number
		{
			return instance.float(min, max);
		}
		
		public static function boolean(chance:Number = 0.5):Boolean
		{
			return instance.boolean(chance);
		}
		
		public static function sign(chance:Number = 0.5):int
		{
			return instance.sign(chance);
		}
		
		public static function bit(chance:Number = 0.5):int
		{
			return instance.bit(chance);
		}
		
		public static function integer(min:Number, max:Number = NaN):int
		{
			return instance.integer(min, max);
		}
		
		public static function reset():void
		{
			instance.reset();
		}
		
		// constants:
		// private properties:
		protected var _seed:uint = 0;
		protected var _currentSeed:uint = 0;
		
		// public properties:
		
		// constructor:
		public function Ran(seed:uint = 1)
		{
			_seed = _currentSeed = seed;
		}
		
		// public getter/setters:
		
		// seed = Math.random()*0xFFFFFF; // sets a random seed
		// seed = 50; // sets a static seed
		public function get seed():uint
		{
			return _seed;
		}
		
		public function set seed(value:uint):void
		{
			_seed = _currentSeed = value;
		}
		
		// gets the current seed
		public function get currentSeed():uint
		{
			return _currentSeed;
		}
		
		// public methods:
		// random(); // returns a number between 0-1 exclusive.
		public function random():Number
		{
			return (_currentSeed = (_currentSeed * 16807) % 2147483647) / 0x7FFFFFFF + 0.000000000233;
		}
		
		// float(50); // returns a number between 0-50 exclusive
		// float(20,50); // returns a number between 20-50 exclusive
		public function float(min:Number, max:Number = NaN):Number
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			return random() * (max - min) + min;
		}
		
		// boolean(); // returns true or false (50% chance of true)
		// boolean(0.8); // returns true or false (80% chance of true)
		public function boolean(chance:Number = 0.5):Boolean
		{
			return (random() < chance);
		}
		
		// sign(); // returns 1 or -1 (50% chance of 1)
		// sign(0.8); // returns 1 or -1 (80% chance of 1)
		public function sign(chance:Number = 0.5):int
		{
			return (random() < chance) ? 1 : -1;
		}
		
		// bit(); // returns 1 or 0 (50% chance of 1)
		// bit(0.8); // returns 1 or 0 (80% chance of 1)
		public function bit(chance:Number = 0.5):int
		{
			return (random() < chance) ? 1 : 0;
		}
		
		// integer(50); // returns an integer between 0-49 inclusive
		// integer(20,50); // returns an integer between 20-49 inclusive
		public function integer(min:Number, max:Number = NaN):int
		{
			if (isNaN(max))
			{
				max = min;
				min = 0;
			}
			// Need to use floor instead of bit shift to work properly with negative values:
			return int(float(min, max));
		}
		
		// reset(); // resets the number series, retaining the same seed
		public function reset():void
		{
			_seed = _currentSeed;
		}
		
	}
}