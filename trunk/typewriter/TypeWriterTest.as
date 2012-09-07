package typewriter
{
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.List;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.events.Event;
	import starling.extensions.TypeWriter;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class TypeWriterTest extends Screen
	{
		[Embed(source="../../../media/textures/2x/opt-texture.jpg")]
		public static const Background:Class;
		
		private var _tw:TypeWriter;
		private var play:PushButton;
		private var speed:HSlider;
		private var transition:List;
		private var animation:List;
		
		//private var _sc:SoundChannel;
		
		public function TypeWriterTest()
		{
			const text:String = "Starling does not cost a dime.\nStarling is a pure ActionScript 3 library that mimics the conventional Flash display list architecture.\nIn contrast to conventional display objects, however, all content is rendered directly by the GPU — providing a rendering performance unlike anything before. This is made possible by Flash's 'Stage3D' technology.Adobe supports the development of Starling and plans to integrate it tightly into its tools.\nYou get the best of both worlds: corporate commitment and a vivid community.\nStarling's community is praised for its friendliness and is always there for you when you need help — 24 / 7.";
			//_sc = new SoundChannel;
			
			var bg:Image = new Image(Texture.fromBitmap(new Background));
			bg.blendMode = BlendMode.NONE;
			addChild(bg);
			
			_tw = new TypeWriter();
			_tw.x = 15.0;
			_tw.init(text);
			addChild(_tw);
			
			_tw.addEventListener(Event.COMPLETE, _onComplete);
			
			play = new PushButton(SB.nativeStage, 10, 450, "PLAY", _onClickPlay);
			speed = new HSlider(SB.nativeStage, 125, 455);
			speed.minimum = 1;
			speed.value = 5;
			speed.maximum = 15;
			
			var lblSpeed:Label = new Label(SB.nativeStage, 125, 435, 'SPEED');
			
			transition = new List(SB.nativeStage, 240, 370, ["easeIn", "easeInBack", "easeInBounce", "easeInElastic", "easeInOut", "easeInOutBack", "easeInOutBounce", "easeInOutElastic", "easeOut", "easeOutBack", "easeOutBounce", "easeOutElastic", "easeOutIn", "easeOutInBack", "easeOutInBounce", "easeOutInElastic", "linear"]);
			transition.selectedIndex = 0;
			transition.setSize(130, 100);
			animation = new List(SB.nativeStage, 380, 370, ["NONE", "ALPHA", "SCALE", "BOING"]);
			animation.selectedIndex = 1;
		}
		
		private function _onComplete(e:starling.events.Event):void
		{
			play.enabled = true;
			speed.enabled = true;
		}
		
		private function _onClickPlay(e:MouseEvent):void
		{
			play.enabled = false;
			speed.enabled = false;
			
			_tw.updateText();
			_tw.effect = animation.selectedIndex;
			_tw.renderMode = TypeWriter.RENDER_MODE_LETTER; // [TODO] combo box letter / word / line
			_tw.resetTween(Number(speed.value), transition.selectedItem.toString());
			
			_tw.start();
		}
	
	}

}