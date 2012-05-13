package screens
{
	import alienfleet.Explosion;
	import alienfleet.PhysParticle;
	import alienfleet.StarField;
	import alienfleet.Tir;
	import alienfleet.Vaisseau;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import starling.core.Starling;
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
	import fr.kouma.starling.utils.Stats;
	import starlingBox.SupaBox;
	
	public class Jeu extends Screen
	{
		private var _myPool:Pool;
		private var _myPoolExplo:Pool;
		private var _myPoolParticles:Pool;
		
		private var _vaisseau:Vaisseau;
		private var _point:Point = new Point;
		private var _console:Console;
		
		[Embed(source="../../media/sounds/83560_1272599-lq.mp3")]
		private const laserClass:Class;
		
		private var _jauge:Jauge;
		[Embed(source="../../media/rail.png")]
		private const railClass:Class;
		private var space:Space;
		private var _safe:Safe;
		private var _supaBox:SupaBox;
		private var _sf:StarField;
		
		public function Jeu()
		{
			super(false);
			SB.console.addMessage(this, "== JEU SCREEN ==");
			Mouse.hide();
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== BEGIN INTRO ==");
			
			// param le timer
			_safe = new Safe(1000, 10);
			_safe.addEventListener(TimerEvent.TIMER, _onTimer);
			_safe.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			_supaBox = new SupaBox();
			_supaBox.safe = _safe;
			_supaBox.addEventListener(flash.events.Event.COMPLETE, _onSupaBoxSendComplete);
			
			if (SB.debug)
			{
				addChild(new Stats());
				SB.addConsole(this, SB.width - (SB.console.width + 5), 10);
				SB.console.addMessage(stage.stageWidth, "px * ", stage.stageHeight, "px");
			}
			
			init();
		}
		
		private function init():void
		{
			SB.console.addMessage(this, "== INIT ==");
			_sf = new StarField(SB.width, SB.height, int(stage.stageWidth / 2));
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
			_myPoolParticles = new Pool(PhysParticle, 15, 5);
			
			SoundBox.instance.add("laser", laserClass);
			//SoundBox.instance.add(SoundBox.BG_MUSIC).load("http://video.premiere.fr/premiere/publicite/yop/Portal2-01-Science_is_Fun.mp3").play();
			
			// jauge
			_jauge = new Jauge(100, 20);
			_jauge.x = stage.stageWidth - (_jauge.width + 10);
			_jauge.y = 15;
			//_jauge.barColors = [0x0000FF];
			//_jauge.barColors = [0x0, 0xFFFFFF];
			//_jauge.skin = new railClass() as Bitmap;
			_jauge.fill = true;
			
			addChild(_jauge.sprite);
			
			// gravite Y 3000 et rien en X
			space = new Space(new Vec2(0, 3000));
			var floor:Body = new Body(BodyType.STATIC);
			floor.shapes.add(new Polygon(Polygon.rect(0, SB.height, SB.width, 100)));
			floor.space = space;
			
			stage.addEventListener(TouchEvent.TOUCH, _onTouchThis);
			
			// démarre le compteur
			_safe.start();
			startOEF();
		}
		
		private function _onTouchThis(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			//
			var touch:Touch = e.getTouch(stage);
			if (touch.phase == TouchPhase.ENDED)
			{
				openFire();
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
			
			//_jauge.incValue(1);
			addChild(_tir);
			// ===============
			
			// == EXPLOSION ==
			var _newNodeExplo:LinkedListNode = _myPoolExplo.create();
			var _explo:Explosion = Explosion(_newNodeExplo.data);
			_explo.init(int(Math.random() * stage.stageWidth), int(Math.random() * stage.stageHeight));
			
			var bNode:LinkedListNode = _myPoolExplo.head;
			var nextNodeExplo:LinkedListNode;
			var myObjExplo:Explosion;
			
			while (bNode)
			{
				nextNodeExplo = bNode.next;
				myObjExplo = Explosion(bNode.data);
				//myObj.update () ;
				
				if (myObjExplo.flag)
				{
					_myPoolExplo.dispose(bNode);
				}
				
				bNode = nextNodeExplo;
			}
			
			addChild(_explo);
			
			// == PhysParticle			
			
			var _newNodeParticle:LinkedListNode = _myPoolParticles.create();
			var _particle:PhysParticle = PhysParticle(_newNodeParticle.data);
			_particle.init(int(Math.random() * SB.width), 0, space);
			
			var cNode:LinkedListNode = _myPoolParticles.head;
			var nextNodeParticle:LinkedListNode;
			var myObjParticle:PhysParticle;
			
			while (cNode)
			{
				nextNodeParticle = cNode.next;
				myObjParticle = PhysParticle(cNode.data);
				
				if (myObjParticle.flag)
				{
					_myPoolParticles.dispose(cNode);
				}
				
				cNode = nextNodeParticle;
			}
			
			//SB.console.addMessage("Laser Pool size: ", _myPool.length);
			//SB.console.addMessage("Explo Pool size: ", _myPoolExplo.length);
			SB.console.addMessage("PhysParticle Pool size: ", _myPoolParticles.length);
			
			addChild(_particle);
		
			// ===============
		
			//SoundBox.instance.item("laser").play();			
		
		}
		
		override public function update(e:Event):void
		{
			//trace(this, "== UPDATE INTRO ==");
			_point.x = SB.engine.mouseX;
			_point.y = SB.engine.mouseY;
			_vaisseau.position = _point;
			
			space.step(1 / 100);
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
			stage.removeEventListener(TouchEvent.TOUCH, _onTouchThis); // souris
			
			Mouse.show();
			
			SB.console.addMessage(this, "EVENT-SUPABOX-COMPLETE");
			
			_supaBox.motif = SupaBox.TIME_UP;
			_supaBox.send();
		}		
		
		override public function end():void
		{
			stage.removeEventListener(TouchEvent.TOUCH, _onTouchThis);
			super.end();
		}
	
	}

}