package screens
{
	import feathers.controls.PageIndicator;
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
	 * http://forum.starling-framework.org/topic/page-flip-in-starling
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
		private var _mouse:Point;
		private var _interceptBottom:Point;
		private var _interceptRight:Point;
		private var _interceptTop:Point;
		
		private var _ori:Point;
		private var _oriX:int = 120;
		private var _oriY:int = 120;
		
		private var WIDTH:int;
		private var HEIGHT:int;
		
		private var _backPage:Page;
		
		public function StarlingPageFlipTest()
		{
			_debugShape = new Shape;
			
			_midPoint = new Point;
			_interceptBottom = new Point;
			_interceptRight = new Point;
			_interceptTop = new Point;
			
			_ori = new Point( _oriX, _oriY );			
			
			_pages = new Vector.<Page>;
			_page1 = new Page( new Image(Texture.fromBitmap(new page1Class as Bitmap, false, true, 1)) );
			_page1.translate(_ori);
			_pages.push(_page1);
			
			_page2 = new Page( new Image(Texture.fromBitmap(new page2Class as Bitmap, false, true, 1)) );
			_page2.translate(_ori);
			_pages.push(_page2);
			
			_backPage = new Page( new Image( Texture.fromBitmapData(new BitmapData( 512, 512, false, 0xFFFFFF))) );			
			_backPage.translate(_ori);
			
			_midPoint = _page2.corner3.clone();
			_mouse = _page2.corner3.clone();
			
			WIDTH = _page1.img.width;
			HEIGHT = _page1.img.height;			
			
			// --
			addChild(_page1.img);
			addChild( _backPage.img );
			addChild(_page2.img);
			
			_page2.img.addEventListener(TouchEvent.TOUCH, _onTouch);
			
			// --
			SB.nativeStage.addChild( _debugShape );
		}
		
		private function _onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if (touch)
			{
				if (touch.phase == TouchPhase.BEGAN) {
					// --					
				}else if (touch.phase == TouchPhase.ENDED) {
					// --
				}else if (touch.phase == TouchPhase.MOVED) {
					_mouse = new Point( SB.nativeStage.mouseX, SB.nativeStage.mouseY);					
					if (_mouse.x >= _oriX + WIDTH) {
						_mouse.x = _oriX + WIDTH - 1;
					}
					if (_mouse.y >= _oriY + HEIGHT) {
						_mouse.y = _oriY + HEIGHT - 1;
					}
					
					_midPoint = Point.interpolate( _mouse , _page2.corner3 , .5);
					
					var px:Number = (WIDTH + _oriX - _midPoint.x);
					var py:Number = (HEIGHT + _oriY - _midPoint.y);	
					var m:Number = py / px;
					var inv:Number = -1 / m;
					var b:Number = _midPoint.y - (_midPoint.x * inv);
					
					// intercept en Y=BOTTOM
					_interceptBottom.x = ((_oriX + WIDTH - b) / inv);
					_interceptBottom.y = _oriY + HEIGHT;
					
					// ajout d'une contrainte physique
					if (_interceptBottom.x <= _oriX) {
						_interceptBottom.x = _oriX;
					}
					// intercept droite
					_interceptRight.x = _oriX + WIDTH;
					_interceptRight.y = ((inv * _interceptRight.x) + b);
					
					_interceptTop = _interceptRight.clone();
					if (_interceptRight.y <= _oriY) {
						_interceptTop.y = _oriY - 1;
						//_interceptTop.x = 
					}
					
					
					_draw();
					_drawDebug();
				}				
				
			}
		}
		
		private function _draw():void 
		{
			//_page2.img.setTexCoords( 3, new Point(.3, 0) );
			/*
			_page2.img.setTexCoords( 0, _page2.corner1 );
			_page2.img.setTexCoords( 1, _interceptRight );
			_page2.img.setTexCoords( 2, _interceptBottom );
			_page2.img.setTexCoords( 3, _page2.corner1 );
			*/
		}
		
		private function _drawDebug():void 
		{
			// dessine le contour
			_debugShape.graphics.clear();
			
			_debugShape.graphics.lineStyle(3, 0x00CC00 );
			_debugShape.graphics.moveTo(_oriX, _oriY);
			_debugShape.graphics.lineTo( _interceptRight.x, _oriY );
			_debugShape.graphics.lineTo( _interceptRight.x, _interceptRight.y );						
			
			_debugShape.graphics.lineStyle(3, 0xCCCC00, .3 );
			_debugShape.graphics.lineTo( _interceptBottom.x, _interceptBottom.y );
			_debugShape.graphics.lineStyle(3, 0x00CC00 );			
			_debugShape.graphics.lineTo( _oriX, _oriY + HEIGHT );
			_debugShape.graphics.lineTo( _oriX, _oriY );			
			_debugShape.graphics.moveTo(_interceptBottom.x, _interceptBottom.y);
			_debugShape.graphics.lineTo( _mouse.x, _mouse.y );
			_debugShape.graphics.lineTo( _interceptRight.x, _interceptRight.y );			
			
			_debugShape.graphics.lineStyle(2, 0xCCCC00, .3 );
			_debugShape.graphics.moveTo( _debugShape.stage.mouseX, _debugShape.mouseY );
			_debugShape.graphics.lineTo( _oriX + WIDTH, _oriY + HEIGHT );	
			_debugShape.graphics.endFill();
			
			
			// dessine les points			
			_debugShape.graphics.lineStyle(2, 0xCCCC00, 1 );
			_debugShape.graphics.beginFill( 0x00CC00 );
			_debugShape.graphics.drawCircle( _interceptBottom.x, _interceptBottom.y, 5 );
			_debugShape.graphics.endFill();
						
			_debugShape.graphics.beginFill( 0x00CC00 );
			_debugShape.graphics.drawCircle( _interceptRight.x, _interceptRight.y, 5 );
			_debugShape.graphics.endFill();	
			
			_debugShape.graphics.beginFill( 0x00CC00 );
			_debugShape.graphics.drawCircle( _interceptTop.x, _interceptTop.y, 5 );
			_debugShape.graphics.endFill();				
			
			_debugShape.graphics.beginFill( 0x00CC00 );
			_debugShape.graphics.drawCircle( _midPoint.x, _midPoint.y, 5 );
			_debugShape.graphics.endFill();
			
		}
	
	}

}