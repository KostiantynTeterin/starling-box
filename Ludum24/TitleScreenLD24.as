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
	import starlingBox.SoundBox;
	
	/**
	 * @author YopSolo
	 * 
	 */
	public class TitleScreenLD24 extends Screen 
	{
		private var bg:Background;
		private var bg2:Background2;
		private var sl:Scanline;
		private var title:TextField;
		private var defTxt:TextField;
		private var press2Play:TextField;
		
		public function TitleScreenLD24() { }
		
		override public function begin():void
		{
			this.name = 'TitleScreenLD24';
			//const definition:String = '"Evolution is the change in the inherited characteristics of biological populations across successive generations. Evolutionary processes give rise to diversity at every level of biological organisation, including species, individual organisms and molecules such as DNA and proteins."';
			const definition:String = 'Evolution looks cool but things can go wrong.\nYou have to stop the evolution of a new life form.\n\nWhy ? Because one day they will steal\nour ideas and violate our patents.\n\nSo burn that sh*t as quick as you can !\n\n--end transmission '; 
			
			/*
			SoundBox.instance.setBGMVolume(.4);
			SoundBox.instance.streamBGMusic( "http://www.yopsolo.fr/ressources/evolution.mp3" );
			*/
			
			// wait, while building assets
			var wait:TextField = new TextField(400, 35, "Building assets, please wait !", EmbedFonts.instance.geo , 21, 0xFFFFFF);
			wait.border = true;
			wait.x = (stage.stageWidth - wait.width) >> 1;
			wait.y = int(stage.stageHeight * 1 / 4 );			
			addChild( wait );
			
			bg = new Background( -1 ); // 0xDD4466 0xda1930, 3fbbfc
			trace( bg.coul.toString(16) );
			
			bg2 = new Background2( bg.coul );			
			
			sl = new Scanline;
			
			title = new TextField(550, 105, "= ÉVOLUTION =", EmbedFonts.instance.metalmania , 90, 0xFFFFFF);
			//title.underline = true;
			title.nativeFilters = [new DropShadowFilter(6)];
			//title.border = true;
			title.x = (stage.stageWidth - title.width) >> 1;
			title.y = int(stage.stageHeight * 2 / 15 );	
			title.touchable = false;
			
			defTxt = new TextField(450, 200, definition, EmbedFonts.instance.geo, 19, 0xFFFFFF );			
			defTxt.x = (stage.stageWidth - defTxt.width) >> 1;
			defTxt.y = title.y + title.height;
			defTxt.touchable = false;
			
			press2Play = new TextField(270, 50, "click to start", EmbedFonts.instance.geo, 45, 0xFFFFFF );
			press2Play.border = true;
			press2Play.nativeFilters = [new DropShadowFilter(6)];
			press2Play.x = (stage.stageWidth - press2Play.width) >> 1;
			press2Play.y = int(stage.stageHeight * 4 / 5 );	
			
			//press2Play.touchable = false;
			
			// --
			removeChild( wait );
			wait.dispose();
			
			addChild( bg );			
			addChild( bg2 );
			addChild( sl );
			
			addChild(title);
			addChild(defTxt);
			addChild(press2Play);
			
			this.useHandCursor = true;
			
			this.stage.addEventListener(TouchEvent.TOUCH, _onTouchSprite);
		}	
		
		override public function destroy():void
		{
			super.destroy();
			
			bg.destroy();
			bg2.destroy();
			sl.destroy();
			
			title.dispose();
			defTxt.dispose();
			press2Play.dispose();
		}
		
		private function _onTouchSprite(e:TouchEvent):void 
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
					
					SB.screen = new Evo( new Bitmap(result) );
				}				
			}
		}
		
	}

}