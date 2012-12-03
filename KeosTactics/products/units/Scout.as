package KeosTactics.products.units 
{
	import starling.display.Image;
	import KeosTactics.players.Player;
	import starling.textures.Texture;	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Scout extends AbstractUnit
	{
		[Embed(source="../../assets/scout.png")]
		private const ScoutClass:Class;
		
		public function Scout(owner:Player) 
		{
			super(owner);
		}
		
		override protected function drawMe():void
		{
			addChild( new Image( Texture.fromBitmap( new ScoutClass ) ) );
		}		
		
		override public function speech():void
		{
			trace(this, _owner.color.toString(16),"Scout toujours !");
		}		
		
	}

}