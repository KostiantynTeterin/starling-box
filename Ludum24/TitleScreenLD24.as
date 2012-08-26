package Ludum24 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import screens.TitleScreenFlashJack;
	import starling.core.RenderSupport;
	import starling.events.Event;
	import starlingBox.Screen;
	import starlingBox.SB;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import starling.display.BlendMode;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.display.Sprite;	 
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;	 
	import starlingBox.SB;
	
	/**
	 * @author YopSolo
	 * Typewritter
	 * Transition
	 * 
	 */
	public class TitleScreenLD24 extends Screen 
	{
		
		public function TitleScreenLD24() { }
		
		override public function begin():void
		{
			const definition:String = "Evolution is the change in the inherited characteristics of biological populations across successive generations. Evolutionary processes give rise to diversity at every level of biological organisation, including species, individual organisms and molecules such as DNA and proteins.";
			
			// wait, while building assets
			var wait:TextField = new TextField(400, 35, "Building assets, please wait !", EmbedFonts.instance.geo , 21, 0xFFFFFF);
			wait.border = true;
			wait.x = (stage.stageWidth - wait.width) >> 1;
			wait.y = int(stage.stageHeight * 1 / 4 );			
			addChild( wait );
			
			var bg:Background = new Background( -1 ); // 0xda1930, 3fbbfc
			trace( bg.coul.toString(16) );
			
			var bg2:Background2 = new Background2( bg.coul );			
			
			var sl:Scanline = new Scanline;
			
			var title:TextField = new TextField(550, 105, "= ÉVOLUTION =", EmbedFonts.instance.metalmania , 90, 0xFFFFFF);
			//title.underline = true;
			title.nativeFilters = [new DropShadowFilter(6)];
			//title.border = true;
			title.x = (stage.stageWidth - title.width) >> 1;
			title.y = int(stage.stageHeight * 2 / 15 );	
			title.touchable = false;
			
			var defTxt:TextField = new TextField(450, 120, definition, EmbedFonts.instance.geo, 19, 0xFFFFFF );			
			defTxt.x = (stage.stageWidth - defTxt.width) >> 1;
			defTxt.y = title.y + title.height;
			defTxt.touchable = false;
			
			var press2Play:TextField = new TextField(270, 50, "click to start", EmbedFonts.instance.geo, 45, 0xFFFFFF );
			press2Play.border = true;
			press2Play.nativeFilters = [new DropShadowFilter(6)];
			press2Play.x = (stage.stageWidth - press2Play.width) >> 1;
			press2Play.y = int(stage.stageHeight * 4 / 5 );	
			//press2Play.touchable = false;
			
			// --
			removeChild( wait );
			
			addChild( bg );			
			addChild( bg2 );
			addChild( sl );
			addChild(title);
			addChild(defTxt);
			addChild(press2Play);
			
			this.addEventListener(TouchEvent.TOUCH, _onTouchedSprite);
		}		
		
		private function _onTouchedSprite(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(stage);
			if ( touch ) {
				var clicked:DisplayObject = e.currentTarget as DisplayObject;
				
				if ( touch.phase == TouchPhase.ENDED )
				{
					var support:RenderSupport = new RenderSupport();
					RenderSupport.clear( stage.color, 1.0 );
					support.setOrthographicProjection(SB.width, SB.height);
					stage.render(support, 1.0);
					support.finishQuadBatch();
					
					var result:BitmapData = new BitmapData(SB.width, SB.height, false,0x0);
					Starling.context.drawToBitmapData(result);
					
					SB.screen = new Evo( result );
				}				
			}
		}		
		
	}

}