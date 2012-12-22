package KeosTactics.ui
{
	import feathers.display.Image;
	import feathers.dragDrop.IDragSource;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class AbstractDescBox extends DisplayObjectContainer implements IDragSource
	{
		protected var _GfxObj:Sprite;
		protected var _desc:TextField;
		
		public function AbstractDescBox()
		{
			_desc = new TextField(200, 100, "abstract text", "Verdana", 12, 0xFFFFFF);
			_desc.y = 50;
			_desc.border = true;
		}
		
		public function destroy():void
		{
			removeChildren();
		}
		
		public function get image():Sprite 
		{
			return _GfxObj;
		}
	
	}

}