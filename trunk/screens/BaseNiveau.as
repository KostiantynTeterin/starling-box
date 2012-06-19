package screens
{
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flashjack.Blast;
	import flashjack.BonusMC;
	import flashjack.Fumee;
	import flashjack.Hero;
	import flashjack.HUD;
	import flashjack.Personnage;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.BaseTileMap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starlingBox.game.common.Input;
	import starlingBox.malbolge.Safe;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starlingBox.SupaBox;
	import starlingBox.utils.LinkedList;
	import starlingBox.utils.LinkedListNode;
	
	
	/**
	 * 
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
	 * ATTENTION
	 * dans l'update addChild a repetition
	 * animation de saut
	 * 
	 * bomb jack twins
	 * http://planetemu.net/index.php?section=articles&id=273&numPage=3
	 */	 
	
	public class BaseNiveau extends Screen
	{
		[Embed(source="../../media/bonus-spritesheet.png")]
		private const bonusTextureClass:Class;		
		
		[Embed(source = "../../media/fj-pause.png")]
		private const pauseTextureClass:Class;
		private var pauseBMP:Image;
		
		// supabox
		protected var _supaBox:SupaBox;		
		protected var _safe:Safe;
		
		protected var tilemap:BaseTileMap;
		protected var hero:Hero;
		protected var bonusLayer:Sprite;		
		protected var bonusList:LinkedList;
		protected var blast:Blast;
		protected var ennemisLayer:Sprite;
		protected var ennemis:Vector.<Personnage>;
		
		public function BaseNiveau()
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN ==");
			
			// datas
			_safe = new Safe(1000, 60);
			_safe.addEventListener(TimerEvent.TIMER, _onTimer);
			_safe.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			_supaBox = new SupaBox;			
			_supaBox.safe = _safe;
			_supaBox.addEventListener(SupaBox.COMPLETE, _onSupaBoxSendComplete);			
			
			// layer 1, hero
			hero = new Hero;
			// layer 2, bonus
			bonusLayer = new Sprite;
			bonusList = new LinkedList();
			
			// layer 3, ennemis
			ennemisLayer = new Sprite;
			ennemis = new Vector.<Personnage>();
			
			pauseBMP = new Image( Texture.fromBitmap( new pauseTextureClass as Bitmap ) );
			pauseBMP.x = int( (640 - pauseBMP.width) / 2 );
			pauseBMP.y = 215;
			
			//
			this.touchable = false;
			
			
		}
		
		// ========================================================================================		
		// BASE
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN :: BEGIN ==");
			
			if (tilemap) addChild( tilemap.image );
			
			if (hero) { 
				hero.levelDat = tilemap.datMiniature;
				//addChild( fumee );
				addChild( hero.animation );
			}
			
			if (tilemap) 
			{
				var bonusXML:XML = <TextureAtlas imagePath="spritesheet.png">
						<SubTexture name="bonus0001" x="0" y="0" width="32" height="32"/>
						<SubTexture name="bonus0002" x="32" y="0" width="32" height="32"/>
						<SubTexture name="bonus0003" x="64" y="0" width="32" height="32"/>
						<SubTexture name="bonus0004" x="96" y="0" width="32" height="32"/>
					</TextureAtlas>;
				
				var bonusTextureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new bonusTextureClass as Bitmap, true, false), bonusXML);
				var bonusXMLList:XMLList = tilemap.xml.bloc.(@type == "bonus");
				
				bonusXMLList = sortXMLList(bonusXMLList);
				
				var bonus:BonusMC;
				var sp:Array;
				for each (var pBonus:XML in bonusXMLList)
				{
					bonus = new BonusMC(bonusTextureAtlas.getTextures());
					bonus.x = pBonus.@x;
					bonus.y = pBonus.@y;
					sp = (pBonus.@name).split("_");
					bonus.name = sp[1];
					bonus.stop();
					bonusList.push(bonus);
					bonusLayer.addChild(bonus);
				}
				
				blast = new Blast(new Rectangle(0, 0, 64, 64));	
				bonusLayer.addChild(blast);
				addChild(bonusLayer);
				//bonusLayer.addEventListener(TouchEvent.TOUCH, _onTouchlayerBonus);
				
				var nb:int = ennemis.length;
				for (var i:int = 0 ; i < nb ; i++ ) {
					ennemisLayer.addChild( ennemis[i].animation );					
				}				
				addChild( ennemisLayer );
				
			}
			
			tilemap.miniature.x = 640 - tilemap.miniature.width - 5;
			tilemap.miniature.y = 64;
			
			//if (tilemap) addChild( tilemap.miniature );
			addChild( HUD.instance );
			HUD.instance.temps = _safe.repeatCount;
			// --
			_safe.start();			
			Input.init( SB.nativeStage );			
			startOEF();
		}
		
		// base 
		override public function update(e:Event):void
		{
			Input.update();						
			hero.update(); // collide avec le décor
			//fumee.init( hero.animation.x, hero.animation.y );
			if (!SB.engine.paused) addChild( hero.animation ); // hack temporaire pour eviter qu'il ne passe devant l'image de pause
			if (!_safe.gameOver) addChild( hero.animation ); // la même ...
			//addChild( ennemisLayer );
			collideBonus(); // collide avec les bonus
			collideMonsters(); // collide avec les ennemies
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
			SB.soundBox.stopAllSound();
			super.end();
		}		
		
		override public function pause():void
		{
			//super.pause();
			SB.console.addMessage(this, "== NIVEAU SCREEN :: PAUSE ==");
			if (!_safe.gameOver) {			
				_safe.stop();			
				SB.soundBox.pauseBGM();			
				hero.pause();
			}
			if (!_safe.gameOver) {
				addChild( pauseBMP );
			}
			
		}
		
		override public function resume():void
		{
			//super.resume();
			SB.console.addMessage(this, "== NIVEAU SCREEN :: RESUME ==");
			if (!_safe.gameOver) {
				_safe.start();
				SB.soundBox.resumeBGM();
				hero.resume();				
			}			
			if (!_safe.gameOver) {
				removeChild( pauseBMP );
			}
		}
		
		override public function destroy():void
		{
			SB.console.addMessage(this, "== NIVEAU SCREEN :: DESTROY ==");
			_safe.removeEventListener(TimerEvent.TIMER, _onTimer);
			_safe.removeEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			// == TODO ==
			// destroy le safe
			// destroy le hero
			// destroy le niveau
			// destroy l'image de fond
			// destroy la tilemap
			// l'ecouteur clavier
			// la SupaBox
			
			super.destroy();
		}
		
		// ========================================================================================		
		// TIMER + SUPABOX
		
		protected function _onTimerComplete(e:TimerEvent = null):void
		{
			if ( e ) _safe.motif = SupaBox.TIME_UP;
			addChild( HUD.instance );
			_safe.gameOver = true;
			HUD.instance.gameOver( _safe.getValue(Safe.SCORE) );
			HUD.instance.temps = 0;
			hero.gameOver();
			var nb:int = ennemis.length;
			for (var i:int = 0 ; i < nb ; i++ ) {
				ennemis[i].gameOver();
			}
			SB.soundBox.fadeOut();
			
			// envoi du score
			//_supaBox.send();
			
		}
		
		protected function _onSupaBoxSendComplete(e:flash.events.Event):void 
		{
			SB.console.addMessage("#Motif:", _supaBox.motif, " #Erreur(s):", _supaBox.error);
		}
		
		protected function _onTimer(e:TimerEvent):void
		{
			HUD.instance.temps = (_safe.repeatCount - _safe.currentCount);
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
		
		protected function collideBonus():void 
		{
			var cur:LinkedListNode = bonusList.head;
			var tail:LinkedListNode = bonusList.tail;
			if (!tail) return
			
			// --
			var bns:BonusMC = tail.value as BonusMC;
			var hit:Boolean = hero.aabb.intersects( bns.aabb );
			
			if(!hit){
				while (cur != tail)
				{
					bns = (cur.value as BonusMC);
					if ( hero.aabb.intersects( bns.aabb ) )
					{
						hit = true;
						break;
					}
					cur = cur.next;
				}	
			}
			
			if (hit) {
				blast.x = bns.x + 16;
				blast.y = bns.y + 16;
				blast.init();
				blast.start();
				
				if (bonusList.length == 35)
				{
					_safe.incValue( Safe.SCORE, 100 );
					HUD.instance.score = _safe.getValue( Safe.SCORE );
				}
				else
				{
					if (bns.isPlaying)
					{
						_safe.incValue( Safe.SCORE, 100 );
						HUD.instance.score = _safe.getValue( Safe.SCORE );
					}
					else
					{
						_safe.incValue( Safe.SCORE, 10 );
						HUD.instance.score = _safe.getValue( Safe.SCORE );
					}
				}
				
				highlightNext( bns );
				
			}
			
			if (bonusList.length == 0)
			{
				_safe.stop();
				_safe.motif = SupaBox.GAGNE;
				_onTimerComplete();
			}			
		}	
		
		/*
		private function _onTouchlayerBonus(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(this.stage);
			var pos:Point = touch.getLocation(this.stage);
			// --
			if (touch.phase == TouchPhase.BEGAN)
			{
				if (e.target is BonusMC)
				{
					var cur:BonusMC = e.target as BonusMC;
					blast.x = cur.x;
					blast.y = cur.y;
					blast.init();
					blast.start();
					
					// 100 points si le bonus en cours est actif
					// 10 points sinon
					if (bonusList.length == 35)
					{
						HUD.instance.incScore(100);
					}
					else
					{
						if (cur.isPlaying)
						{
							HUD.instance.incScore(100);
						}
						else
						{
							HUD.instance.incScore(10);
						}
					}
					
					// puis on passe au bonus suivant dans la liste chainée.
					highlightNext(cur);
				}
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				if (bonusList.length == 0)
				{
					safe.stop();
				}
			}
		}		
		*/
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
		
		// ========================================================================================		
		// COLLIDE MONSTERS
		protected function collideMonsters():void 
		{
			var nb:int = ennemis.length;
			
			// déplacement
			for (var i:int = 0 ; i < nb ; i++ ) {
				ennemis[i].update( hero.aabb );				
			}
			
			// collision
			var hit:Boolean = false;
			for (i = 0 ; i < nb ; i++ ) 
			{
				//trace( hero.aabb, ennemis[i].aabb );
				if ( hero.aabb.intersects( ennemis[i].aabb ) ) 
				{
					hit = true;
					break;
				}
			}
			
			if (hit) {
				_safe.stop();
				_safe.motif = SupaBox.PERDU;
				_onTimerComplete();				
			}
		}		
	
	}

}