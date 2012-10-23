package starlingBox
{
	import flash.display.Stage;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starlingBox.debug.Console;
	import flash.utils.describeType;
	
	public class SB
	{
		public static const VERSION:String = "StarlingBox 0.00";
		public static var bgColor:uint = 0x222222;
		private static var _screen:Screen;
		
		// -- GETTER/SETTER
		static public function get screen():Screen
		{
			return _screen;
		}
		
		static public function set screen(value:Screen):void
		{
			SB.engine.screen = value;
		}
		
		// -- STANDARD
		// --
		public static function formatTime(sec:int):String
		{
			var minutes:Number = int(sec / 60);
			var secondes:Number = int(sec % 60);
			var minutes_str:String = (minutes <= 9) ? "0" + minutes : String(minutes);
			var secondes_str:String = (secondes <= 9) ? "0" + secondes : String(secondes);
			
			return minutes_str + ":" + secondes_str;
		}
		
		public static function flashvar(nom:String, valeurParDefautSiInconnu:*):*
		{
			
			if (!SB.engine.starling)
			{
				return 0;
			}
			
			var result:* = valeurParDefautSiInconnu;
			
			if (SB.nativeStage.loaderInfo.parameters[nom] != undefined)
			{
				if (valeurParDefautSiInconnu is Number)
				{
					result = Number(SB.nativeStage.loaderInfo.parameters[nom]);
				}
				else
				{
					result = SB.nativeStage.loaderInfo.parameters[nom];
				}
			}
			
			return result;
		}
		
		// addChild( setProps( new Sprite(), {x:200, y:200, alpha:0.5, name:"bob"}) );
		public static function setProps(o:Object, props:Object):*
		{
			for (var n:String in props)
			{
				o[n] = props[n];
			}
			
			return o;
		}
		
		public static function vectorToArray(v:*):Array
		{
			var n:int = v.length;
			var a:Array = new Array();
			for (var i:int = 0; i < n; i++)
				a[i] = v[i];
			
			return a;
		}
		
		public static function shuffle(a:Array):void
		{
			for (var i:int = a.length - 1; i > 0; --i)
			{
				var p:int = int(Math.random() * (i + 1));
				if (p == i)
					continue;
				var tmp:Object = a[i];
				a[i] = a[p];
				a[p] = tmp;
			}
		}
		
		// -- DEBUG CONSOLE
		public static function addConsole(dpo:DisplayObjectContainer, px:int = 200, py:int = 10):void
		{
			Console.instance.x = px;
			Console.instance.y = py;
			dpo.addChild(Console.instance.gfx);
		}
		
		public static function get console():Console
		{
			return Console.instance;
		}
		
		public static function describe(value:*):String
		{
			return describeType(value).@name
		}
		
		// -- SOUND HELPER
		// --				
		public static function get soundBox():SoundBox
		{
			return SoundBox.instance;
		}		
		
		// -- GFX HELPER
		// --
		
		// -- UI HELPER
		// --
		
		// -- MATH HELPER
		// utiliser une approx de PI ?
		public static function degreesToRadians(degrees:Number):Number
		{
			return (degrees * Math.PI / 180);
		}
		
		public static function radiansToDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		
		//angle en rad
		public static function getAngleBetweenPoints(p1:Point, p2:Point):Number
		{
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var radians:Number = Math.atan2(dy, dx);
			
			return radians;
		}
		
		public static function distanceBetweenPoints(p1:Point, p2:Point):Number
		{
			return Point.distance(p1, p2);
		}
		
		//http://lab.polygonal.de/2007/05/10/bitwise-gems-fast-integer-math/		
		public static function abs(value:Number):Number
		{
			return (value ^ (value >> 31)) - (value >> 31);
		}
		
		public static function clamp(value:Number, min:Number, max:Number):Number
		{
			if (max > min)
			{
				value = value < max ? value : max;
				return value > min ? value : min;
			}
			value = value < min ? value : min;
			return value > max ? value : max;
		}		
		
		
		public static function clone(source:*):Object {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(source as Object);
			copier.position = 0;
			
			return copier.readObject();
		}		
		
		// -- GLOBAL
		public static var width:int;
		public static var height:int;
		public static var centerX:int;
		public static var centerY:int;
		public static var engine:Engine;
		public static var root:Sprite;
		public static var antiAliasLevel:int = 0;
		public static var debug:Boolean = false;
		public static var nativeStage:Stage;
		
		public static var point:Point = new Point;
		public static var rect:Rectangle = new Rectangle;
		public static var mtx:Matrix = new Matrix;
		public static var original_framerate:int = 60;
	}
}