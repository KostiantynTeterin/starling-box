package KeosTactics.ui
{
	/**
	 * ...
	 * @author YopSolo
	 */
	
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import flash.geom.Point;
	import KeosTactics.board.Arena;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starlingBox.SB;
	
	//[Event(name = "complete", type = "starling.events.Event")]
	
	public class FenetrePiege extends Screen
	{
		[Embed(source="../assets/trou.png")]
		private const TrouGFXClass:Class;
		[Embed(source="../assets/mur.png")]
		private const MurGfxClass:Class;
		[Embed(source="../assets/bomb.png")]
		private const MineGfxClass:Class;
		
		private var _grid:Arena;
		
		private var _valider:Button;
		private var _reset:Button;
		
		private var _tb:AbstractDescBox;
		private var _mb:AbstractDescBox;
		private var _mdb:AbstractDescBox;
		
		private var _memo:Point;
		
		public function FenetrePiege()
		{
			// afficher la grille, ok
			_grid = Arena.instance;
			_grid.y = 250;			
			
			// afficher les 3 pieges dispo (image, description)
			_tb = new TrouDescBox();
			_tb.x = 120;
			_tb.y = 80;
			_tb.addEventListener(TouchEvent.TOUCH, _onTouchMe);
			addChild(_tb);
			
			_mb = new MurDescBox();
			_mb.x = 325;
			_mb.y = 80;
			_mb.addEventListener(TouchEvent.TOUCH, _onTouchMe);
			addChild(_mb);
			
			_mdb = new MineDescBox();
			_mdb.x = 530;
			_mdb.y = 80;
			_mdb.addEventListener(TouchEvent.TOUCH, _onTouchMe);
			addChild(_mdb);
			
			// valider
			_valider = new Button();
			_valider.x = 770;
			_valider.y = 180;
			_valider.height = 50;
			_valider.isEnabled = false;
			_valider.label = " SUIVANT ";
			_valider.addEventListener(Event.TRIGGERED, _onTouchValider );
			addChild(_valider);
			
			// reset
			_reset = new Button();
			_reset.x = 770;
			_reset.y = 120;
			_reset.height = 50;
			_reset.isEnabled = false;
			_reset.label = " ANNULER ";
			_reset.addEventListener(Event.TRIGGERED, _onTouchAnnuler );
			addChild(_reset);			
		}
		
		override protected function initialize():void
		{
			_memo = null;
			_valider.isEnabled = false;
			_reset.isEnabled = false;			
			SB.nativeStage.addChild(_grid.debug);
		}
		
		// que mettre ici ? :p
		override protected function draw():void
		{
		
		}			
		
		// Actions
		private function _onTouchAnnuler(e:Event):void 
		{
			
		}
		
		private function _onTouchValider(e:Event):void 
		{
			SB.nativeStage.removeChild(_grid.debug);
			_reset.isEnabled = false;
			_valider.isEnabled = false;			
			this.dispatchEventWith(Event.COMPLETE);
			
			trace( _grid.dump() );
		}		
		
		private function _onTouchMe(e:TouchEvent):void
		{
			if (e.currentTarget is AbstractDescBox)
			{
				var ct:AbstractDescBox = e.currentTarget as AbstractDescBox;				
				var touch:Touch = e.getTouch(this);
				if (touch)
				{
					if (touch.phase == TouchPhase.BEGAN)
					{
						_memo = new Point( ct.image.x , ct.image.y );
						ct.image.x = touch.globalX - ct.image.pivotX * .5;
						ct.image.y = touch.globalY - ct.image.pivotY * .5;
						addChild(ct.image);						
						_tb.visible = false;
						_mb.visible = false;
						_mdb.visible = false;						
					}
					else if (touch.phase == TouchPhase.MOVED)
					{
						ct.image.x = touch.globalX - ct.image.pivotX * .5;
						ct.image.y = touch.globalY - ct.image.pivotY * .5;
					}
					else if (touch.phase == TouchPhase.ENDED)
					{
						// magnet sur la grille
						var destCaseX:int = int( (touch.globalX - _grid.x) / _grid.SIZE);
						var destCaseY:int = int( (touch.globalY - _grid.y) / _grid.SIZE);
						if (destCaseX == 2 || destCaseX == 3) {
							ct.image.x = ((_grid.SIZE - ct.image.pivotX)* .5) + _grid.x + destCaseX * _grid.SIZE;
							ct.image.y = ((_grid.SIZE - ct.image.pivotY) * .5) + _grid.y + destCaseY * _grid.SIZE;							
							_grid.setValeur( destCaseX, destCaseY, ct.image );
							_valider.isEnabled = true;
						}else {
							ct.addChildAt(ct.image,0);
							ct.image.x = _memo.x;
							ct.image.y = _memo.y;
							_tb.visible = true;
							_mb.visible = true;
							_mdb.visible = true;		
							_valider.isEnabled = false;
						}
					}					
				}
			}
		}
		
	}

}