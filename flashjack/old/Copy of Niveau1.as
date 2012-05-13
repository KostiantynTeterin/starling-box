package screens
{
	import flash.display.Bitmap;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flashjack.Blast;
	import flashjack.BonusMC;
	import flashjack.Hero;
	import flashjack.HUD;
	import flashjack.Niveau1data;
	import flashjack.TileMapNiveau1;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.TileMap;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starlingBox.malbolge.Safe;
	import utils.LinkedList;
	import utils.LinkedListNode;
	import starlingBox.SB;
	import starlingBox.Screen;
	import fr.kouma.starling.utils.Stats;
	import flash.ui.Keyboard;
	
	public class Niveau1 extends BaseNiveau
	{
		// bonus
		[Embed(source="../../media/bonus-spritesheet.png")]
		private const bonusTextureClass:Class;
		private var bonusList:LinkedList;
		private var blast:Blast;
		// hero
		private var hero:Hero;
		
		// controls
		private var isRight:Boolean = false;
		private var isLeft:Boolean = false;
		private var isUp:Boolean = false;
		private var isDown:Boolean = false;		
		private var upIsEnabled:Boolean = true;
		
        private const GRAVITY:Number = .8;
		private const LOW_GRAVITY:Number = 0;
		private var gravity:Number;		
		
		// supabox
		private var safe:Safe;
		
		// niveau en cours
		private var tilemap:TileMapNiveau1;
		
		override public function Niveau1()
		{
			SB.console.addMessage(this, "== NIVEAU 1 SCREEN ==");
			
			// datas
			safe = new Safe(1000, 90);
			safe.addEventListener(TimerEvent.TIMER, _onTimer);
			safe.addEventListener(TimerEvent.TIMER_COMPLETE, _onTimerComplete);
			
			var xml:XML = Niveau1data.instance.datas;
			
			// layer 0, background
			tilemap = new TileMapNiveau1(xml);
			addChild(tilemap.image);
			//addChild( layer0.miniature );			
			
			// layer 1, hero
			hero = new Hero();
			hero.state = Hero.STAND;
			hero.animation.x = 0;
			hero.animation.y = tilemap.image.height;
			addChild(hero.animation);
			//addChild(hero.bb);
			
			// layer N-1, bonus
			var bonusLayer:Sprite = new Sprite;
			bonusList = new LinkedList();
			bonusLayer.addEventListener(TouchEvent.TOUCH, _onTouchlayerBonus);
			
			var bonusXML:XML =      <TextureAtlas imagePath="spritesheet.png">
					<SubTexture name="bonus0001" x="0" y="0" width="32" height="32"/>
					<SubTexture name="bonus0002" x="32" y="0" width="32" height="32"/>
					<SubTexture name="bonus0003" x="64" y="0" width="32" height="32"/>
					<SubTexture name="bonus0004" x="96" y="0" width="32" height="32"/>
				</TextureAtlas>;
			
			var bonusTextureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new bonusTextureClass as Bitmap, true, false), bonusXML);
			var bonusXMLList:XMLList = xml.bloc.(@type == "bonus");
			
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
			
			// lance l'anim du dernier bonus
			// dans le vrai jeu, c'est la 1er bonus ramassé qui conditionne le suivant			
			//bonus.play();
			
			addChild(bonusLayer);
			
			// layer N
			addChild(HUD.instance);
		}
		
		override public function begin():void
		{
			SB.console.addMessage(this, "== NIVEAU-1 SCREEN :: BEGIN ==");
			
			safe.start();
			
			SB.nativeStage.addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown);
			SB.nativeStage.addEventListener(KeyboardEvent.KEY_UP, _onKeyUp);			
			
			gravity = GRAVITY;
			
			startOEF();
		
		   if (SB.debug)
		   {
			   //addChild(new Stats());
			   //SB.addConsole(this, SB.width - (SB.console.width + 5), 10);
			   //SB.console.addMessage(stage.stageWidth, "px * ", stage.stageHeight, "px");
			   
			   //new FastStats( SB.nativeStage );
		   }
		   
		}
		
		// base
		override public function update(e:Event):void
		{
			detectCollisionWithTiles();
			//detectCollisionWithBonus();
			//detectCollisionWithMonsters();
			
			// Touches			
			if (isRight && !isLeft) {
				hero.animation.x += hero.dx;
				hero.animation.scaleX = -1;
				if( hero.state != Hero.WALK ){
					hero.state = Hero.WALK;
					addChild(hero.animation);
				}
			}
			
			if (isLeft && !isRight) {
				hero.animation.x -= hero.dx; 
				hero.animation.scaleX = 1;				
				if( hero.state != Hero.WALK ){
					hero.state = Hero.WALK;
					addChild(hero.animation);
				}
			}
			
			if ( (!isRight && !isLeft) || (isRight && isLeft) ) {
				if ( hero.state != Hero.STAND ) {
					hero.state = Hero.STAND;					
					addChild(hero.animation);
				}
			}
			
			if ( isUp && upIsEnabled ) {
				hero.dy = -hero.JUMP;
			}
			
			// limites HAUTE
			if ( hero.animation.y - hero.dy < 256) {
				upIsEnabled = false;
			}
			
			gravity = GRAVITY;
			if (!upIsEnabled && isUp && hero.dy > 0) {
				hero.dy = 0;
				gravity = LOW_GRAVITY;
			}
			
			// Limite BASSE
			if (hero.animation.y + hero.dy < 640) {
				hero.dy += gravity;
				hero.animation.y += hero.dy;
				hero.onGround = false;
			}else {
				hero.animation.y = 640;
				hero.onGround = true;
				upIsEnabled = true;
			}
			
			//hero.bb.x = hero.animation.x;
			//hero.bb.y = hero.animation.y;
			
			//var p:Point =  getGridFromPosition( hero.animation.x, hero.animation.y );
			//trace( p );
			
		}		
		
		// controles a externaliser
		private function _onKeyUp(e:KeyboardEvent):void
		{
			switchKey(e, false);
			if (e.keyCode == Keyboard.UP) {
				upIsEnabled = false;
			}
		}
		
		private function _onKeyDown(e:KeyboardEvent):void
		{
			switchKey(e, true);
		}
		
		private function switchKey(event:KeyboardEvent, value:Boolean):void
		{
			var keyCode:uint = event.keyCode;
			switch (keyCode)
			{
				case Keyboard.RIGHT: 
					isRight = value;
					break;
				case Keyboard.LEFT: 
					isLeft = value;
					break;
				case Keyboard.UP: 
					isUp = value;
					break;
				case Keyboard.DOWN: 
					isDown = value;
					break;
				default: 
					break;
			}
		}		
		
		private function highlightNext(bonus:BonusMC):void
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
		
		// collision		
		// voir si c'est mieux avec un bitmapdata
		private function detectCollisionWithTiles():void
		{
			var directionX:int = -1 * hero.animation.scaleX;
			var directionY:int = ((hero.dy < 0) ? -1 : 1);
			
			var nextX:int = int(hero.animation.x + hero.dx);
			var nextY:int = int(hero.animation.y + hero.dy);
			// mon hero fait 32 * 64
			
			var currentGrid:Point = getGridFromPosition(hero.animation.x, hero.animation.y);
			var edgeNextXGrid:Point = getGridFromPosition(nextX + (directionX * 16), nextY);
			var edgeNextYGrid:Point = getGridFromPosition(nextX, nextY + (directionY * 32));
			var edgeNextXYGrid:Point = getGridFromPosition(nextX + (directionX * 16), nextY + (directionY * 32));
			
			/*
			trace( hero.animation.x, 
			hero.animation.y, 
			directionX, 
			directionY,
			currentGrid, 
			nextX, 
			nextY, 
			edgeNextXGrid, 
			edgeNextYGrid, 
			edgeNextXYGrid );
			*/
			
			// if solid
			if ( tilemap.arr[edgeNextXGrid.y][edgeNextXGrid.x] == 1 )
			{
				trace("HIT X");
				// trace( tilemap.arr[edgeNextXGrid.y][edgeNextXGrid.x], edgeNextXGrid.y, edgeNextXGrid.x );
				//_posx = Math.floor(_posx / 32) * 32 + ((directionX == 1) ? (32 - 16) : 16);
				hero.dx = 0;
			}
			
			/*
			if ( tilemap.arr[edgeNextYGrid.y][edgeNextYGrid.x] == 1 )
			{
				// trace("HIT Y");
				//_posy = Math.floor(_posy / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE + ((directionY == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_HEIGHT) : Plumber.HALF_HEIGHT);
				hero.dy = 0;
				
				//if (directionY == 1)
				//{
				//	_onGround = true;
				//}
			}
			*/
			
			/*
			if ((_dx != 0 && _dy != 0) && map.model[edgeNextXYGrid.y][edgeNextXYGrid.x].isSolid())
			{
				_posx = Math.floor(_posx / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE + ((directionX == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_WIDTH) : Plumber.HALF_WIDTH);
				_dx = 0;
			}
			
			if (_dx != 0)
			{
				_posx = nextX;
			}
			if (_dy != 0)
			{
				_posy = nextY;
			}
			*/
		}		
		
		private function getGridFromPosition(posx:int, posy:int):Point
		{
			var col:int = int(posx / 32);
			var row:int = int(posy / 32);
			
			if (col < 0)
			{
				col = 0;
			}
			if (col > 19)
			{
				col = 19;
			}
			if (row < 0)
			{
				row = 0;
			}
			if (row > 19)
			{
				row = 19;
			}
			
			return new Point(col, row);
		}		
		

	
	}

}