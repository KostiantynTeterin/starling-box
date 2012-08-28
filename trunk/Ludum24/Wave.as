package Ludum24 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import starling.core.RenderSupport;
	import starling.textures.TextureAtlas;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starling.core.Starling;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Wave extends Sprite
	{
		public static const AMOEBAS:int = 0;
		public static const FISHES:int = 1;
		public static const AMPHIBIANS:int = 2;
		public static const REPTILES:int = 3;
		public static const MAMMALS:int = 4;
		public static const BIRDS:int = 5;
		public static const ZOMBIES:int = 6;
		
		// TIR
		[Embed(source="../../media/ennemies.png")]
		private const AmoebaClass:Class;
		[Embed(source = "../../media/ennemies.xml",mimeType="application/octet-stream")]
		private const AmoebaXML:Class;		
		
		private const GRAVITY:Number = -3/100;
		private const DRAG:Number = .99;		
		private var motion:BitmapData;
		private var bf:BlurFilter;
		private var count:Number = 0;
		private var atlas:TextureAtlas;
		
		private var MAX_SIZE:int = 60;
		
		public var positions:Vector.<Amoeba> = new Vector.<Amoeba>;
		
		public function Wave( type:int = 0 ) 
		{
			bf = new BlurFilter( 32, 32, 3);
			motion = new BitmapData( 600, 800, false, 0x0);
			motion.perlinNoise(300, 400, 6, int(Math.random() * 0xFFFFFF), false, true, 7);
			motion.applyFilter( motion, motion.rect, motion.rect.topLeft, bf );
			atlas = new TextureAtlas(Texture.fromBitmap(new AmoebaClass() as Bitmap), XML(new AmoebaXML));
			for (var i:int = 0 ; i < 40 ; i++ ) {
				positions.push( new Amoeba( atlas ) );
				positions[i].init( 100 + int(Math.random() * 400 ) , 100 + int(Math.random() * 500 ), Math.random() + 0.5 );
			}
			this.addEventListener( Event.ENTER_FRAME, _oef );
		}
		
		private function _oef(e:Event):void 
		{
			e.stopImmediatePropagation();			
			count++;			
			if ( count > 175 ) {
				count = 0;
				motion.perlinNoise(300, 400, 6, int(Math.random() * 0xFFFFFF), false, true, 7, true);
				motion.applyFilter( motion, motion.rect, motion.rect.topLeft, bf );
			}
			
			var n:int = positions.length;
			var p:Amoeba;
			var col:Number;
			var d:Number;
			var count2:int = 0;
			while ( n-- )
			{
				p = positions[n];
				
				if ( !p.flag ) 
				{
					col = motion.getPixel(p.x, p.y);
					p.vx = p.vx * .95 + (( col >> 16 & 0xff) - 128) * 0.004;
					p.vy = p.vy * .95 + (( col >> 8 & 0xff) - 128) * 0.004;	
					p.vy += GRAVITY * p.s;
					d = (1 - (this.motion.getPixel(p.x, p.y) / 0xffffff) * DRAG);
					
					p.x += p.vx * d;
					p.y += p.vy * d;		
					if (p.x < 0) p.x += 600;
					else if (p.x >= 600) p.x -= 600;
					if (p.y < 0) p.y += 800;
					else if (p.y >= 800) p.y -= 800;	
					
					if ( positions.length < MAX_SIZE  ) {
						if (Math.random() < .0008) {
							divide();
						}					
					}
				}else {
					// floating bodies
					if (p.y < 850) {
						p.vy += .005;
						p.y += p.vy;						
					}else {
						p.destroy();
					}
					// -- 
					count2++;
				}
				
				if (count2 == positions.length) {
					this.removeEventListener( Event.ENTER_FRAME, _oef );
					
					var support:RenderSupport = new RenderSupport();
					RenderSupport.clear( p.stage.color, 1.0 );
					support.setOrthographicProjection(SB.width, SB.height);
					p.stage.render(support, 1.0);
					support.finishQuadBatch();
					
					var result:BitmapData = new BitmapData(SB.width, SB.height, false,0x0);
					Starling.context.drawToBitmapData(result);
					
					SB.screen = new EndScreenLD24( new Bitmap(result) );
				}
				
			}			
			
		}
		
		public function incSize():void
		{
			MAX_SIZE++;
		}
		
		private function divide():void 
		{
			var ran:Number = int(Math.random() * positions.length);
			if ( positions[ ran ].y < 600 ) {
				var newComer:Amoeba = new Amoeba( atlas );
				newComer.color = Math.random() * 0xFFFFFF;
				newComer.init( positions[ ran ].x, positions[ ran ].y, positions[0].s * 2 );
				positions.push( newComer );				
			}
		}
		
		public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME, _oef );
			var n:int = positions.length;
			while ( n-- ) {			
				positions[n].dispose();
			}
			positions = null;	
			motion.dispose();
		}
		
	}
}
