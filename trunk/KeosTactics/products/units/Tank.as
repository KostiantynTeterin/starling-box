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
			var img:Image = new Image( Texture.fromBitmap( new TankClass ) );
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;				
			
			addChild( img );
			this.scaleX = this.scaleY = .5;
			
			super.drawMe();
		}
		
		override public function speech():void
		{
			trace(this,_owner.id, "Yes sir ?");
		}
		
	}

}