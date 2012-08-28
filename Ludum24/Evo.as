package Ludum24
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import Ludum24.Explosion;
	import Ludum24.StarField;
	import Ludum24.Tir;
	import Ludum24.Vaisseau;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingBox.debug.Console;
	import starlingBox.game.pooling.LinkedListNode;
	import starlingBox.game.pooling.Pool;
	import starlingBox.game.ui.Jauge;
	import starlingBox.malbolge.Safe;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starlingBox.SoundBox;
	import starlingBox.SupaBox;
	
	/*
	 * WARNING really bugged ZONE ! 
	 * my pooling system is corrupted
	 * 
	 * 
	 * 
	 * */
	
	public class Evo extends Screen
	{
		private var _myPool:Pool;
		private var _myPoolExplo:Pool;
		private var _myPoolParticles:Pool;
		
		private var _wave:Wave;
		private var _waveContainer:Sprite;
		
		private var _vaisseau:Vaisseau;
		private var _point:Point = new Point;
		private var _console:Console;
		
		[Embed(source="../../media/sounds/83560_1272599-lq.mp3")]
		private const LaserClass:Class;
		
		private var _jauge:Jauge;
		[Embed(source="../../media/rail.png")]
		private const railClass:Class;
		private var _safe:Safe;
		private var _supaBox:SupaBox;
		private var _sf:StarField;
		private var _scanline:Scanline;
		
		public function Evo( bmp:Bitmap )
		{
			super(false);
			SB.nativeStage.addChild(bmp);
			TweenMax.to(bmp, 1, {delay:0.3, autoAlpha:0});	
			SB.console.addMessage(this, "== JEU SCREEN ==");
			//Mouse.hide();
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== BEGIN INTRO ==");
			
			_scanline = new Scanline(1);
			_waveContainer = new Sprite;
			// param le timer
			_safe = new Safe(1000, 240);
			_safe.addEventListener(TimerEvent.TIMER, _onTimer);
			_safe.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			_supaBox = new SupaBox();
			_supaBox.safe = _safe;
			_supaBox.addEventListener(flash.events.Event.COMPLETE, _onSupaBoxSendComplete);			
			
			
			_wave = new Wave(Wave.AMOEBAS);			
			
			init();
		}
		
		private function init():void
		{
			this.visible = false;
			SB.console.addMessage(this, "== INIT ==");
			_sf = new StarField(SB.width, SB.height);
			addChild(_sf);
			// vaisseau
			_vaisseau = new Vaisseau;
			_point.x = SB.centerX;
			_point.y = SB.centerY;
			_vaisseau.position = _point;
			
			addChild(_vaisseau);
			
			// POOLS tir, explo et particles
			_myPool = new Pool(Tir, 10, 5);
			_myPoolExplo = new Pool(Explosion, 15, 5);
			//_myPoolEnnemis = new Pool( Amoeba, 50, 10 );
			
			SoundBox.instance.addRessource( new LaserClass(), SoundBox.ACTION1 );
			SoundBox.instance.setSFXVolume( .4 );
			
			// jauge
			_jauge = new Jauge(100, 20);
			_jauge.x = stage.stageWidth - (_jauge.width + 10);
			_jauge.y = 15;
			//_jauge.barColors = [0x0000FF];
			//_jauge.barColors = [0x0, 0xFFFFFF];
			//_jauge.skin = new railClass() as Bitmap;
			_jauge.fill = true;
			
			addChild(_jauge.sprite);
			
			var nb:int = _wave.positions.length;
			
			for (var i:int = 0 ; i < nb ; i++ ) {
				_waveContainer.addChild( _wave.positions[i] );
			}
			
			addChild( _waveContainer );
			this.visible = true;
			_safe.start();
			startOEF();
			
			stage.addEventListener(TouchEvent.TOUCH, _onTouchThis);
		}
		
		private function _onTouchThis(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			//
			if (stage)
			{
				var touch:Touch = e.getTouch(stage);
				if (touch.phase == TouchPhase.BEGAN)
				{
					openFire();
				}
			}
		}
		
		private function openFire():void
		{
			//trace( "_tir", _tir );
			_jauge.incValue(5);
			
			// == TIR ==
			var _newNodeTir:LinkedListNode = _myPool.create();
			var _tir:Tir = Tir(_newNodeTir.data);
			_tir.init(_vaisseau.position.x, _vaisseau.position.y);
			
			var aNode:LinkedListNode = _myPool.head;
			var nextNodeTir:LinkedListNode;
			var myObj:Tir;
			
			while (aNode)
			{
				nextNodeTir = aNode.next;
				myObj = Tir(aNode.data);
				
				if (myObj.flag)
				{
					_myPool.dispose(aNode);
				}
				
				aNode = nextNodeTir;
			}
			
			// --
			
			var bNode:LinkedListNode = _myPoolExplo.head;
			var nextNodeExplo:LinkedListNode;
			var myObjExplo:Explosion;
			
			while (bNode)
			{
				nextNodeExplo = bNode.next;
				myObjExplo = Explosion(bNode.data);
				
				if (myObjExplo.flag)
				{
					_myPoolExplo.dispose(bNode);
				}
				
				bNode = nextNodeExplo;
			}
			
			//_jauge.incValue(1);
			addChild(_tir);
		}
		
		override public function update(e:Event):void
		{
			//trace(this, "== UPDATE INTRO ==");
			_point.x = SB.engine.mouseX;
			_point.y = Math.max( 550, SB.engine.mouseY );
			_vaisseau.position = _point;
			
			var nb:int = _wave.positions.length;
			for (var i:int = 0 ; i < nb ; i++ ) {
				_waveContainer.addChild( _wave.positions[i] );
			}
			
			var aNode:LinkedListNode = _myPool.head;
			var nextNodeTir:LinkedListNode;
			var myObj:Tir;			
			
			while (aNode)
			{
				nextNodeTir = aNode.next;
				myObj = Tir(aNode.data);				
				
				if (!myObj.flag) {
					for ( i = 0 ; i < nb ; i++ ) {				
						var tg:Amoeba = _wave.positions[i];
						if(!tg.flag){
							if ( myObj.getBounds(stage).intersects(tg.getBounds(stage) ) ) {
								myObj.flagMe();
								var _newNodeExplo:LinkedListNode = _myPoolExplo.create();
								var _explo:Explosion = Explosion(_newNodeExplo.data);
								_explo.init(_wave.positions[i].x, _wave.positions[i].y);
								addChild(_explo);
								tg.alpha = .1;								
								_wave.positions[i].flagMe();
								_wave.incSize();
								break;
							}
						}
					}
				}				
				aNode = nextNodeTir;
			}	
			
			addChild( _scanline );
		}
		
		private function _onSupaBoxSendComplete(e:flash.events.Event):void
		{
			SB.console.addMessage("#Motif:", _supaBox.motif, " #Erreur(s):", _supaBox.error);
			_safe.stop();
		}		
		
		private function _onTimer(e:TimerEvent):void
		{
			SB.console.addMessage("onTimer");
		}		
		
		private function _onTimerComplete(e:TimerEvent):void
		{
			// stoppe les différents trucs en cours
			_sf.stop(); // starField			
			Starling.juggler.purge(); // juggler
			stopOEF(); // boucle d'affichage
			//stage.removeEventListener(TouchEvent.TOUCH, _onTouchThis); // souris
			
			//Mouse.show();
			
			SB.console.addMessage(this, "EVENT-SUPABOX-COMPLETE");
			
			//_supaBox.motif = SupaBox.TIME_UP;
			_supaBox.send();
		}		
		
		override public function destroy():void
		{
			super.destroy();
			
		}		
		
		override public function end():void
		{
			super.end();
		}
		
		
		override public function pause():void
		{
			// --
		}
		
		override public function resume():void
		{
			// --
		}		
	
	}

}