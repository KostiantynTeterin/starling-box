package screens
{
	import feathers.display.Image;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import pageFlip.Page;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class StarlingPageFlipTest extends Screen
	{
		[Embed(source="../pageFlip/628_stone_greenstone.jpg")]
		private var page1Class:Class;
		private var _page1:Page;
		
		[Embed(source="../pageFlip/629_stone_crackedwall.jpg")]
		private var page2Class:Class;
		private var _page2:Page;
		
		private var _pages:Vector.<Page>;		
		
		private var _debugShape:Shape;
		private var _midPoint:Point;
		
		public function StarlingPageFlipTest()
		{
			_debugShape = new Shape;
			_midPoint = new Point;
			//
			_pages = new Vector.<Page>;
			_page1 = new Page( new Image(Texture.fromBitmap(new page1Class as Bitmap, false, true, 1)) );
			_pages.push(_page1);			
			
			_page2 = new Page( new Image(Texture.fromBitmap(new page2Class as Bitmap, false, true, 1)) ); 
			_pages.push(_page2);
			
			_midPoint = _page2.corner3.clone();
			
			// --
			addChild(_page1.img);
			addChild(_page2.img);
			// --
			_page2.img.addEventListener(TouchEvent.TOUCH, _onTouch);
			// --
			SB.nativeStage.addChild( _debugShape );
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN){
					trace("BEGIN");
					_midPoint = Point.interpolate( new Point( SB.nativeStage.mouseX, SB.nativeStage.mouseY) , _page2.corner3 , .5);
				}else if (touch.phase == TouchPhase.ENDED){
					trace("STOP");
					_midPoint = new Point(512, 512);
				}else if (touch.phase == TouchPhase.MOVED){
					trace("MOVE");
					_midPoint = Point.interpolate( new Point( SB.nativeStage.mouseX, SB.nativeStage.mouseY) , _page2.corner3 , .5);
				}
			}
			
			
			
			_drawDebug();
		}
		
		private function _drawDebug():void 
		{
			// ligne entre la souris/le doigt et le coin bas gauche
			_debugShape.graphics.clear();
			_debugShape.graphics.lineStyle(2, 0xCCCC00 );
			_debugShape.graphics.moveTo( _debugShape.stage.mouseX, _debugShape.mouseY );
			_debugShape.graphics.lineTo( _page2.corner3.x, _page2.corner3.y );
			
			_debugShape.graphics.moveTo( _midPoint.x, _midPoint.y );
			_debugShape.graphics.beginFill( 0xCC0000 );
			_debugShape.graphics.drawCircle( _midPoint.x, _midPoint.y, 3 );
			_debugShape.graphics.endFill();
			
		}
	
	}

}