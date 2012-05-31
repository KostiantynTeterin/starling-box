package
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.getDefinitionByName;
	import starlingBox.SB;
	
	
	[SWF(width="640",height="640",frameRate="60",backgroundColor="#000000")]
	
	public class Preloader extends Sprite
	{
		public var preloader:DonutLoader;
		public var i:int = 0;
		
		public function Preloader():void
		{
			preloader = new DonutLoader(0, 0, 100);
			
			preloader.color = 0x808000;
			preloader.textColor = 0x808000;
			
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);		
			/*
			 * -frame start Main
			 * */
		}
		
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
			
			var newContextMenu:ContextMenu = new ContextMenu;
			newContextMenu.hideBuiltInItems();
			
			var cmi:ContextMenuItem = new ContextMenuItem("Version: " + SB.VERSION);
			newContextMenu.customItems.push(cmi);			
			this.contextMenu = newContextMenu;			 
			 
			preloader.x = 640 >> 1; // attention c'est important de se baser sur la taille du swf
			preloader.y = 640 >> 1; // car il peut être embed en w/h 100%
			
			addChild(preloader);
			
			addEventListener(Event.ENTER_FRAME, updateLoop);
		}
		
		public function updateLoop(e:Event):void
		{
			//trace( "preload updateLoop: ",preloader.value );
			
			if (preloader.value >= preloader.maximum)
			{
				removeEventListener(Event.ENTER_FRAME, updateLoop);
				
				addChild(preloader);
				TweenMax.to(preloader, 0.75, {alpha: 0, onComplete: onLoadComplete});
			}
			else
			{
				preloader.value = (stage.loaderInfo.bytesLoaded / stage.loaderInfo.bytesTotal) * 100;
			}
		}
		
		private function onLoadComplete():void
		{
			removeChild(preloader);
			
			var mainClass:Class = getDefinitionByName("Startup") as Class;
			addChild(new mainClass);			
		}
	}

}

import flash.display.IGraphicsData;
import flash.display.Shader;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;

class DonutLoader extends Sprite
{
	private var graphics2:GraphicsPlus;
	private var label:TextField;
	private var _radius:int = 0;
	private var _value:Number = 0.0;
	
	public function DonutLoader(x:int = 0, y:int = 0, radius:int = 80):void
	{
		graphics2 = new GraphicsPlus();
		label = new TextField();
		label.mouseEnabled = false;
		
		this.x = x;
		this.y = y;
		this.radius = radius;
		
		addChild(graphics2);
		addChild(label);
	}
	
	private function draw():void
	{
		this.graphics2.clear();
		this.graphics2.beginFill(color);
		this.graphics2.drawFan(0, 0, radius, radius * 0.7, -90, value / maximum * 360 - 90);
		this.graphics2.endFill();
		
		label.textColor = textColor;
		label.text = String(Math.round(value / maximum * 100) + "%");
	}
	
	public var color:uint = 0xCC0000;
	public var textColor:uint = 0xAAAAAA;
	public var maximum:Number = 100;
	public var minimum:Number = 0;
	
	public function get radius():Number
	{
		return _radius;
	}
	
	public function set radius(val:Number):void
	{
		_radius = val;
		label.defaultTextFormat = new TextFormat("Trebuchet MS", val * 2 / 5, textColor, true, null, null, null, null, "center");
		draw();
		
		label.x = -val / 2;
		label.y = -label.textHeight / 2;
		label.width = val;
	}
	
	public function get value():Number
	{
		return _value;
	}
	
	public function set value(val:Number):void
	{
		_value = Math.min(100, val);
		draw();
	}

}


class GraphicsPlus extends Shape
{
	public function GraphicsPlus()
	{
		beginFill = this.graphics.beginFill;
		beginGradientFill = this.graphics.beginGradientFill;
		beginShaderFill = this.graphics.beginShaderFill;
		clear = this.graphics.clear;
		curveTo = this.graphics.curveTo;
		drawCircle = this.graphics.drawCircle;
		drawEllipse = this.graphics.drawEllipse;
		drawGraphicsData = this.graphics.drawGraphicsData;
		drawPath = this.graphics.drawPath;
		drawRect = this.graphics.drawRect;
		drawRoundRect = this.graphics.drawRoundRect;
		drawRoundRectComplex = this.graphics.drawRoundRectComplex;
		drawTriangles = this.graphics.drawTriangles;
		endFill = this.graphics.endFill;
		lineGradientStyle = this.graphics.lineGradientStyle;
		lineShaderStyle = this.graphics.lineShaderStyle;
		lineStyle = this.graphics.lineStyle;
		lineTo = this.graphics.lineTo;
		moveTo = this.graphics.moveTo;
	}
	
	public function drawFan(x:Number, y:Number, r1:Number, r2:Number, a1:Number, a2:Number):void
	{
		
		var radian1:Number = a1 * Math.PI / 180;
		var radian2:Number = a2 * Math.PI / 180;
		
		draw(x, y, r1, radian1, radian2, false);
		draw(x, y, r2, radian2, radian1, true);
	}
	
	private function draw(x:Number, y:Number, r:Number, t1:Number, t2:Number, lineTo:Boolean):void
	{
		var div:Number = Math.max(1, Math.floor(Math.abs(t1 - t2) / 0.4));
		var lx:Number;
		var ly:Number;
		var lt:Number;
		
		for (var i:int = 0; i <= div; i++)
		{
			var ct:Number = t1 + (t2 - t1) * i / div;
			var cx:Number = Math.cos(ct) * r + x;
			var cy:Number = Math.sin(ct) * r + y;
			
			if (i == 0)
			{
				if (lineTo)
					this.graphics.lineTo(cx, cy);
				else
					this.graphics.moveTo(cx, cy);
			}
			else
			{
				var cp:Point = getControlPoint(new Point(lx, ly), lt + Math.PI / 2, new Point(cx, cy), ct + Math.PI / 2);
				this.graphics.curveTo(cp.x, cp.y, cx, cy);
			}
			lx = cx;
			ly = cy;
			lt = ct;
		}
	}
	
	private function getControlPoint(p1:Point, t1:Number, p2:Point, t2:Number):Point
	{
		var dif:Point = p2.subtract(p1);
		var l12:Number = Math.sqrt(dif.x * dif.x + dif.y * dif.y);
		var t12:Number = Math.atan2(dif.y, dif.x);
		var l13:Number = l12 * Math.sin(t2 - t12) / Math.sin(t2 - t1);
		
		return new Point(p1.x + l13 * Math.cos(t1), p1.y + l13 * Math.sin(t1));
	}
	
	public var beginFill:Function;
	public var beginGradientFill:Function;
	public var beginShaderFill:Function;
	public var clear:Function;
	public var curveTo:Function;
	public var drawCircle:Function;
	public var drawEllipse:Function;
	public var drawGraphicsData:Function;
	public var drawPath:Function;
	public var drawRect:Function;
	public var drawRoundRect:Function;
	public var drawRoundRectComplex:Function;
	public var drawTriangles:Function;
	public var endFill:Function;
	public var lineGradientStyle:Function;
	public var lineShaderStyle:Function;
	public var lineStyle:Function;
	public var lineTo:Function;
	public var moveTo:Function;
}