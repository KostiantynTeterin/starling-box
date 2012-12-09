package KeosTactics.ui
{
	/**
	 * ...
	 * @author YopSolo
	 */
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FenetrePiege extends Sprite
	{
		protected var theme:MetalWorksMobileTheme;
		protected var button:Button;
		
		public function FenetrePiege()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			this.theme = new MetalWorksMobileTheme(this.stage);
			
			this.button = new Button();
			this.button.label = "Click Me";
			
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			this.addChild(this.button);
			
			this.button.validate();
			
			this.button.x = (this.stage.stageWidth - this.button.width) / 2;
			this.button.y = (this.stage.stageHeight - this.button.height) / 2;
		}
		
		protected function button_triggeredHandler(event:Event):void
		{
			const label:Label = new Label();
			label.text = "Hi, I'm Feathers!\nHave a nice day.";
			Callout.show(label, this.button);
		}
	
	}

}