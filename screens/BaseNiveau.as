package screens
{
	import alienfleet.Explosion;
	import alienfleet.Vaisseau;
	import flash.events.TimerEvent;
	import flashjack.Hero;
	import flashjack.HUD;
	import starling.extensions.BaseTileMap;
	import starling.extensions.BaseTileMap;	
	import flashjack.TileMapNiveau1;
	import starling.events.Event;
	import starlingBox.game.common.Input;
	import starlingBox.malbolge.Safe;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	
	/**
	 * ...
	 * @author YopSolo
	 * 
	 * un timer
	 * un hero
	 * un niveau
	 * un controller clavier
	 * collision
	 * mon HUD
	 * temps/points
	 * 
	 * 1ere couche build du background + tile ( une texture unique avec le background et les tiles dessus );
	 * 2eme couche build des bonus
	 * 	-> son
	 * 	-> le score qui monte
	 * controles
	 * 	-> clavier
	 * 		-> saut,
	 * 		-> float,
	 * 		-> vérifier la joubilité pendant le float, il me semble que le joueur ne peut pas se stopper en l'air
	 * 	-> virtual gamepad
	 * 	-> remote gamepad (usb/wifi)
	 * 
	 * 	-> collide avec la grid
	 * 	-> update des positions
	 * 	-> recup des bonus
	 * 
	 * bomb jack twins
	 * http://planetemu.net/index.php?section=articles&id=273&numPage=3
	 */	 
	
	public class BaseNiveau extends Screen
	{
		// supabox
		protected var safe:Safe;
		protected var tilemap:BaseTileMap;
		protected var hero:Hero;
		
		public function BaseNiveau()
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN ==");
			
			// datas
			safe = new Safe(1000, 90);
			safe.addEventListener(TimerEvent.TIMER, _onTimer);
			safe.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			// layer 1, hero
			hero = new Hero();
			hero.state = Hero.STAND;
		}
		
		// ========================================================================================		
		// BASE
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN :: BEGIN ==");
			if (tilemap) addChild( tilemap.image );
			if (hero) { 
				//hero.collisionMap = tilemap.arr;
				hero.levelDat = tilemap.datMiniature;
				addChild( hero.animation );			
			}			
			
			//tilemap.miniature.scaleX = tilemap.miniature.scaleY = 2;
			tilemap.miniature.x = 640 - tilemap.miniature.width - 5;
			tilemap.miniature.y = 64;
			
			if (tilemap) addChild( tilemap.miniature );
			addChild( HUD.instance );
			
			/*
			var test:Explosion = new Explosion;
			test.x = 200;
			test.y = 200;
			addChild( test );
			*/
			
			safe.start();
			Input.init( SB.nativeStage );
			startOEF();
		}
		
		// base 
		override public function update(e:Event):void
		{
			Input.update();
			hero.update();
			/*
			trace( 
			Input.mouseX, 
			Input.mouseY, 
			Input.mouseDown, 
			Input.mouseUp, 
			Input.mouseDelta, 
			Input.isDown( Input.KEY_SPACE )
			);
			*/
		}		
		
		override public function end():void
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN :: END ==");
			super.end();
		}		
		
		override public function pause():void
		{
			//super.pause();
			SB.console.addMessage(this, "== NIVEAU SCREEN :: PAUSE ==");
		}
		
		override public function resume():void
		{
			//super.resume();
			SB.console.addMessage(this, "== NIVEAU SCREEN :: RESUME ==");
		}
		
		override public function destroy():void
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN :: DESTROY ==");
			safe.removeEventListener(TimerEvent.TIMER, _onTimer);
			safe.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			// == TODO ==
			// destroy le safe
			// destroy le hero
			// destroy le niveau
			// destroy l'image de fond
			// destroy la tilemap
			// l'ecouteur clavier
			
			super.destroy();
		}
		
		// ========================================================================================		
		// TIMER
		
		protected function _onTimerComplete(e:TimerEvent):void
		{
			HUD.instance.temps = 0;
		}
		
		protected function _onTimer(e:TimerEvent):void
		{
			HUD.instance.temps = (safe.repeatCount - safe.currentCount);
		}
		
		// ========================================================================================
		// XML
		
		protected function sortXMLList(list:XMLList):XMLList
		{
			var liste:Array = [];
			var sp:Array;
			
			// -- explode
			for each (var elem:XML in list)
			{
				var obj:Object = {};
				obj.x = elem.@x;
				obj.y = elem.@y;
				obj.type = elem.@type;
				sp = elem.@name.split("_");
				obj.name = sp[1];
				obj.value = elem.toString();
				liste.push(obj);
			}
			
			// -- tri
			liste.sortOn("name", Array.NUMERIC);
			
			// -- nouvelle XMLList
			var result:XMLList = new XMLList();
			
			var nb:int = liste.length;
			for (var i:int = 0; i < nb; i++)
			{
				result +=   <bloc x={liste[i].x} y={liste[i].y} type={liste[i].type} name={"bonus_" + liste[i].name}>{liste[i].value}</bloc>;
			}
			
			return result;
		}
		
		// ========================================================================================		
		// BONUS
		
		/*
		protected function highlightNext(bonus:BonusMC):void
		{
			// stoppe tous les bonus
			var cur:LinkedListNode = bonusList.head;
			var tail:LinkedListNode = bonusList.tail;
			while (cur != tail)
			{
				(cur.value as BonusMC).stop();
				cur = cur.next;
			}
			(cur.value as BonusMC).stop();
			
			// lance le prochain
			cur = bonusList.find(bonus);
			
			var next:BonusMC;
			if (cur.next.value)
			{
				next = cur.next.value;
			}
			else
			{
				next = bonusList.head.value;
			}
			
			if (next)
			{
				next.play();
			}
			
			// et degage le bonus en cours
			bonusList.remove(bonus);
			bonus.visible = false;
		}		
		*/
		
		// ========================================================================================		
		// COLLISIONS
	
	}

}