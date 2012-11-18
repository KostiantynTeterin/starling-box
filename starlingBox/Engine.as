package starlingBox
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	import starling.core.Starling;
	import starlingBox.debug.Console;
	
	public class Engine extends Sprite
	{
		protected var _screen:Screen;
		protected var _paused:Boolean = false;
		
		private var _fullScreen:Boolean = false;
		
		private var _starlingRootClass:Class;
		private var _starling:Starling;
		
		public function Engine(width:int, height:int, rootClass:Class, mobile:Boolean = true ,antiAliasLevel:int = 0 ,debug:Boolean = true)
		{
			_starlingRootClass = rootClass;			
			
			SB.width = width;
			SB.height = height;
			SB.centerX = width >> 1;
			SB.centerY = height >> 1;
			SB.antiAliasLevel = antiAliasLevel;
			SB.debug = debug;
			SB.mobile = mobile;
			
			SB.engine = this;
			
			this.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);		
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;			
			
			stage.stageFocusRect = false;
			stage.tabChildren = false;
			stage.showDefaultContextMenu = false;			
			
			Starling.handleLostContext = true;
			SB.console.addMessage( "Starling.handleLostContext", Starling.handleLostContext );
			Starling.multitouchEnabled = true;
			SB.console.addMessage( "Starling.multitouchEnabled", Starling.multitouchEnabled );
			
			if ( SB.mobile ) {
				SB.ratioX = stage.fullScreenWidth / SB.width;
				SB.ratioY = stage.fullScreenHeight / SB.height;
			}
			
			//SB.console.addMessage( "#", SB.ratioX, SB.ratioY );
			
			_starling = new Starling( _starlingRootClass, this.stage );
			_starling.simulateMultitouch = SB.debug;
			_starling.antiAliasing = SB.antiAliasLevel;
			_starling.enableErrorChecking = SB.debug;
			_starling.showStats = SB.debug;
			_starling.start();
			
			SB.nativeStage = this.stage;
			
			stage.addEventListener(Event.ACTIVATE, _onActivate);
			stage.addEventListener(Event.DEACTIVATE, _onDeactivate);			
			
			SB.original_framerate = stage.frameRate;
			
			SB.console.addMessage(this, "== INITSTAGE-3D == Starling v" + Starling.VERSION);
		}
		
		// =============================================================
		public function _onDeactivate(e:Event):void
		{
			// TODO
			// sans ce flag, il y a un double appel, à creuser.
			if (!_paused) {
				if (screen)
					screen.pause();
				_paused = true;
				
				var t:Timer = new Timer(SB.original_framerate,1);
				t.addEventListener(TimerEvent.TIMER_COMPLETE, _onDeactivateTimerComplete );
				t.start();
			}
		}
		
		private function _onDeactivateTimerComplete(e:TimerEvent):void 
		{
			if (SB.nativeStage)
				SB.nativeStage.stage.frameRate = 0;
		}
		
		public function _onActivate(e:Event):void
		{
			// TODO
			// sans ce flag, il y a un double appel, à creuser.
			if (_paused) {
				if (SB.nativeStage)
					SB.nativeStage.stage.frameRate = SB.original_framerate;				
					
				if (screen)
					screen.resume();
					
				_paused = false;
			}
		}
		
		// =============================================================
		public function get screen():Screen
		{
			return _screen;
		}
		
		public function set screen(value:Screen):void
		{
			if (_screen) {
				SB.root.removeChild(_screen);
				_screen.end();
				_screen.dispose();
			}
				
			_screen = value;
			SB.root.addChild(_screen);
		}
		
		// =============================================================
		public function get debug():Boolean
		{
			return SB.debug;
		}
		
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		
		public function set fullScreen(value:Boolean):void
		{
			_fullScreen = value;
			if (_fullScreen)
			{
				try{
					SB.nativeStage.displayState = StageDisplayState.FULL_SCREEN;
				}catch (e:SecurityError) {
					SB.console.addMessage( "#", e.message, e.errorID );
				}
			}
			else
			{
				SB.nativeStage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		public function get starling():Starling
		{
			return _starling;
		}
	}

}