package alienfleet
{
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Circle;
	import nape.space.Space;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class PhysParticle extends Sprite
	{
		[Embed(source="../../../media/particles.png")]
		private const physParticleClass:Class;
		private var physBody:Body;
		public var flag:Boolean = false;
		
		public function PhysParticle()
		{
			addChild(Image.fromBitmap(new physParticleClass));
			pivotX = width >> 1;
			pivotY = height >> 1;
		}
		
		public function init(x:int, y:int, space:Space):void
		{
			flag = false;
			// --
			physBody = new Body(BodyType.DYNAMIC, new Vec2(x, y));
			physBody.shapes.add(new Circle(16, null, new Material(3)));
			physBody.graphic = this;
			physBody.space = space;
			physBody.graphicUpdate = _onUpdate;
		}
		
		private function _onUpdate(b:Body):void
		{
			if (b.position.x < -16 || b.position.x > 496)
			{
				b.position.x = -1000;
				b.position.y = -1000;
				b.type = BodyType.STATIC;
				b.graphicUpdate = null;
				flag = true;
			}
			
			b.graphic.x = b.position.x;
			b.graphic.y = b.position.y;
			b.graphic.rotation = b.rotation;
		
		}
	
	}

}