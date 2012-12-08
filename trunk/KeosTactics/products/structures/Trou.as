package KeosTactics.products.structures 
{
	import KeosTactics.players.Player;
	import starling.display.Image;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Trou extends AbstractPiege
	{
		[Embed(source = "../../assets/trou.png")]
		private const GfxClass:Class;
		
		public function Trou( owner:Player ) 
		{
			super(owner);
		}
		
		override protected function drawMe():void
		{
			var img:Image = new Image( Texture.fromBitmap( new GfxClass ) );
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;
			addChild( img ) ;
			
			super.drawMe();
		}		
		
		override public function speech():void
		{
			trace(this, _owner.id,"KABOOOOM !");
		}			
		
	}

}