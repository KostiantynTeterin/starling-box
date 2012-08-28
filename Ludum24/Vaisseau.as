package Ludum24
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	//import starling.extensions.ParticleDesignerPS;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Vaisseau extends Sprite
	{
		// VAISSEAU
		[Embed(source="../../media/vaisseau.png")]
		private var VaisseauClass:Class;
		private var vaisseau:Image;
		
		// REACTEUR A FUSION !
		[Embed(source="../../media/particle2.pex",mimeType="application/octet-stream")]
		private const ParticlesXML:Class;
		[Embed(source="../../media/fire_particle.png")]
		private const ParticleTexture:Class;
		private var particles:PDParticleSystem;	
		
		private var _position:Point = new Point();
		
		private var _destination:Point = new Point();
		
		public function Vaisseau()
		{
			// creation du vaisseau
			vaisseau = new Image(Texture.fromBitmap(new VaisseauClass as Bitmap));
			vaisseau.pivotX = 14;
			vaisseau.pivotY = 20;
			
		   // creation du reacteur
		   particles = new PDParticleSystem(XML(new ParticlesXML), Texture.fromBitmap(new ParticleTexture) );
		   
		   particles.emitterX = vaisseau.x;
		   particles.emitterY = vaisseau.y + 20;
		
		   Starling.juggler.add(particles);
		   particles.start();
			
			// DisplayList
			addChild(vaisseau);
			addChild( particles );
		}
		
		public function get position():Point
		{
			return _position;
		}
		
		public function set position(value:Point):void
		{
			//trace( value.toString() );
			_destination.x = value.x;
			_destination.y = value.y;
			
			vaisseau.x += (_destination.x - vaisseau.x) * .15;
			vaisseau.y += (_destination.y - vaisseau.y) * .15;
			
			_position.x = particles.emitterX = vaisseau.x;
			_position.x = vaisseau.x;
			_position.y = vaisseau.y
			particles.emitterY = vaisseau.y + 20;			
		}
	
	}

}