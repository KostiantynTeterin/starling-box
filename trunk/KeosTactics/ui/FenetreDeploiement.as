package KeosTactics.ui 
{
	import feathers.controls.Button;
	import feathers.controls.Screen;
	import starling.events.Event;
	import feathers.themes.MetalWorksMobileTheme;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	 
	//[Event(name = "complete", type = "starling.events.Event")]	
	 
	public class FenetreDeploiement extends Screen 
	{
		private var _valider:Button;
		
		public function FenetreDeploiement() 
		{
			
		}
		override protected function initialize():void
		{
			// valider
			_valider = new Button();
			_valider.x = 100;
			_valider.y = 100;
			_valider.height = 50;
			//_valider.isEnabled = false;
			_valider.label = " TEEEEEEEEST ";
			_valider.addEventListener(Event.TRIGGERED, _onTouchValider );
			addChild(_valider);						
		}
		
		private function _onTouchValider(e:Event):void 
		{
			this.dispatchEventWith(Event.COMPLETE);
		}
		
		override protected function draw():void
		{
		
		}			
		
		
	}

}