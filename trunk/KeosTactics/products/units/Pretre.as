package KeosTactics.products.units 
{
	import starling.display.Image;
	import KeosTactics.players.Player;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Pretre extends AbstractUnit
	{
		[Embed(source = "../../assets/pretre.png")]
		private const PretreClass:Class;
		
		public function Pretre(owner:Player) 
		{
			super(owner);
		}	
		
		override protected function drawMe():void
		{
			addChild( new Image( Texture.fromBitmap( new PretreClass ) ) );
		}
		
		override public function speech():void
		{
			trace(this,_owner.color.toString(16), "Yes sir ?");
		}
		
	}

}