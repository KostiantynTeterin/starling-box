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
			var img:Image = new Image( Texture.fromBitmap( new ScoutClass ) );
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;			
			addChild( img );
			
			this.scaleX = this.scaleY = .6;		
			super.drawMe();
		}		
		
		override public function speech():void
		{
			trace(this, _owner.id,"Scout toujours !");
		}		
		
	}

}