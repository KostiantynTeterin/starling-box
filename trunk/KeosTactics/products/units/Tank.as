package KeosTactics.products.units 
{
	import starling.display.Image;
	import KeosTactics.players.Player;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Tank extends AbstractUnit
	{
		[Embed(source = "../../assets/pretre.png")]
		private const TankClass:Class;
		
		public function Tank(owner:Player) 
		{
			super(owner);
		}	
		
		override protected function drawMe():void
		{
			addChild( new Image( Texture.fromBitmap( new TankClass ) ) );
		}
		
		override public function speech():void
		{
			trace(this,_owner.id, "Yes sir ?");
		}
		
	}

}