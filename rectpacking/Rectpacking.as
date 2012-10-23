package rectpacking 
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import flash.display.MovieClip;
	import starling.textures.TextureAtlas;
	import starlingBox.SB;
	import starlingBox.Screen;
	import starling.text.TextField;
	import starling.extensions.DynamicAtlas;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Rectpacking extends Screen 
	{
		public function Rectpacking() 
		{
			var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(new Container as flash.display.MovieClip, 1, 0, true, true);
			var cyclope:starling.display.MovieClip = new starling.display.MovieClip(atlas.getTextures("cyclope"), 24);
			var kliff:starling.display.MovieClip = new starling.display.MovieClip(atlas.getTextures("kliff"), 12);			
			var bg:starling.display.MovieClip = new starling.display.MovieClip(atlas.getTextures("background"), 1);			
			
			bg.stop();
			
			cyclope.x = SB.centerX;
			cyclope.y = SB.centerY;
			
			bg.x = 0;
			bg.y = 0;
			
			//addChild(bg);
			//addChild(mc);
			
			Starling.juggler.add( cyclope );	
			Starling.juggler.add( kliff );	
			
			SB.nativeStage.addChild( DynamicAtlas.spriteSheet );
		}
		
	}

}