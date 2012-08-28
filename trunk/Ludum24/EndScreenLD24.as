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
	import com.greensock.TweenMax;
	/**
	 * @author YopSolo
	 * 
	 */
	public class EndScreenLD24 extends Screen 
	{
		private var bg:Background;
		private var bg2:Background2;
		private var sl:Scanline;
		private var title:TextField;
		private var defTxt:TextField;		
		
		public function EndScreenLD24( bmp:Bitmap ) { 
			SB.nativeStage.addChild(bmp);
			TweenMax.to(bmp, 1, {delay:0.3, autoAlpha:0});			
		}
		
		override public function begin():void
		{
			this.name = 'TitleScreenLD24';
			const definition:String = 'You saved the universe -again-\nAnd more important by finishing this game\nyou stopped a huge memory leak ;)\n\nThis game was coded for luddumdare#25\nby Christophe Bessis an optimist Flash Game developper :)';
			
			bg = new Background( -1 ); // 0xda1930, 3fbbfc
			trace( bg.coul.toString(16) );
			
			bg2 = new Background2( bg.coul );			
			
			sl = new Scanline;
			
			title = new TextField(550, 105, "Well Done !", EmbedFonts.instance.metalmania , 90, 0xFFFFFF);
			//title.underline = true;
			title.nativeFilters = [new DropShadowFilter(6)];
			//title.border = true;
			title.x = (stage.stageWidth - title.width) >> 1;
			title.y = int(stage.stageHeight * 2 / 15 );	
			title.touchable = false;
			
			defTxt = new TextField(450, 150, definition, EmbedFonts.instance.geo, 19, 0xFFFFFF );			
			defTxt.x = (stage.stageWidth - defTxt.width) >> 1;
			defTxt.y = title.y + title.height;
			defTxt.touchable = false;
			
			addChild( bg );
			addChild( bg2 );
			addChild( sl );
			
			addChild(title);
			addChild(defTxt);
		}	
		
		override public function destroy():void
		{
			super.destroy();
		}
		
		
	}

}