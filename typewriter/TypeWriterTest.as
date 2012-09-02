package typewriter 
{
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.BlendMode;
	import starling.textures.Texture;
	import starlingBox.game.effects.TypeWriter;
	import starlingBox.SB;
	import starlingBox.Screen;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class TypeWriterTest extends Screen 
	{
        [Embed(source = "../../../media/textures/2x/background.png")]
        public static const Background:Class;		
		
		private var _tw:TypeWriter;
		
		public function TypeWriterTest() 
		{
			const text:String = "Starling does not cost a dime.\nStarling is a pure ActionScript 3 library that mimics the conventional Flash display list architecture.\nIn contrast to conventional display objects, however, all content is rendered directly by the GPU — providing a rendering performance unlike anything before. This is made possible by Flash's 'Stage3D' technology.Adobe supports the development of Starling and plans to integrate it tightly into its tools.\nYou get the best of both worlds: corporate commitment and a vivid community.\nStarling's community is praised for its friendliness and is always there for you when you need help — 24 / 7.";
			
            var bg:Image = new Image( Texture.fromBitmap(new Background));
            bg.blendMode = BlendMode.NONE;
            addChild(bg);
			
			_tw = new TypeWriter();
			_tw.x = 15.0;
			_tw.init( text, 20.0 );			
			addChild( _tw );			
			
			_tw.start();
			
			
			// la transition ( combo )
			// duree de la transition (slider)
			// anim d'apparition ( combo )
			// text editing
			// reset
			// start
			
			var resetBTN:PushButton = new PushButton( SB.nativeStage, 10, 450, "PLAY");
			var speed:HSlider = new HSlider(SB.nativeStage, 125, 455);
			var lblSpeed:Label = new Label(SB.nativeStage, 125, 435, 'SPEED');
			var transition:List = new List( SB.nativeStage, 240, 370, ["transition1", "transition2", "transition3"] );
			var animation:List = new List( SB.nativeStage, 350, 370, ["NONE", "animation1", "animation2", "animation3"] );
			
		}
		
	}

}