package KeosTactics.products.units 
{
	import starling.display.Image;
	import KeosTactics.players.Player;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Sniper extends AbstractUnit
	{
		[Embed(source="../../assets/sniper.png")]
		private const SniperClass:Class;
		
		public function Sniper(owner:Player) 
		{
			super(owner);			
		}
		
		override protected function drawMe():void
		{
			addChild( new Image( Texture.fromBitmap( new SniperClass ) ) );
		}		
		
		override public function speech():void
		{
			trace(this, _owner.id, "Dans la ligne de mire.");			
		}
		
	}

}