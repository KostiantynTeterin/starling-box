package NapeHills 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;	
	import starlingBox.game.utils.XORTexture;
	import starlingBox.SB;

	public class Player extends Body
	{
		private const SPAWN_POSITION			:Vec2 = new Vec2(SB.width / 2 + 100, 200);
		private var _characterCbType			:CbType;
		private var _impulse					:Vec2;
		private var _jump						:Vec2;
		private var _stage						:Stage;

		public function Player() 
		{
			super(BodyType.DYNAMIC, SPAWN_POSITION)

			_characterCbType = new CbType();
			var material:Material = new Material(Number.NEGATIVE_INFINITY, .1, 2, 1);
			_impulse = new Vec2(30, 0);
			_jump = new Vec2(0, -5000);

			shapes.add(new Circle(50, null, material));
			
			var xorTexture:XORTexture = new XORTexture( 64, 64, 0xDEDEDE );
			
			var sh:Shape = new Shape;
			sh.graphics.beginBitmapFill( xorTexture );
			sh.graphics.drawCircle( 50, 50, 50 );
			sh.graphics.endFill();
			
			var dat:BitmapData = new BitmapData(100, 100, true, 0x0);
			dat.draw( sh );
			var texture:Texture = Texture.fromBitmapData( dat );
			var image:Image = new Image(texture);			
			image.pivotX = 50;
			image.pivotY = 50;
			graphic = image;
			graphicUpdate = onCharacterUpdate;
			
			// clean
			xorTexture.dispose();
			dat.dispose();			
			
			_stage = Starling.current.stage;
			_stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}

		private function onTouch(e:TouchEvent):void 
		{
			if (e.getTouch(_stage, TouchPhase.BEGAN)) {
				applyLocalImpulse(_jump);
			}
		}

		private function onCharacterUpdate(b:Body):void 
		{
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			(b.graphic as Image).rotation = b.rotation * .5;
			//gives a local impulse to make its velocity stable
			applyLocalImpulse(_impulse);
			if (velocity.x < 350) {
				velocity.x = 350;
			}
		}

	}

}