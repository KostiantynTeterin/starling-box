package KeosTactics 
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Background extends Sprite 
	{
		[Embed(source = "assets/layer3.png")]
		private const Layer3Class:Class;
		[Embed(source = "assets/layer1.png")]
		private const Layer1Class:Class; 		
		[Embed(source = "assets/ha.jpg")]
		private const HAClass:Class;
		
		public function Background() 
		{
			var bg:Image = new Image(Texture.fromBitmap(new Layer3Class) );
			bg.scaleX = 1.5;
			bg.scaleY = 1.5;
			addChild(  bg  );
			addChild( new Image( Texture.fromBitmap(new Layer1Class) ) );
			
			var ha:Image = new Image( Texture.fromBitmap(new HAClass) );
			ha.x = -250;
			ha.y = 200;
			//addChild( ha );			
			
			this.touchable = false;
		}
		
	}

}