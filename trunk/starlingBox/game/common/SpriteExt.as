package starlingBox.game.common
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class SpriteExt extends Sprite
	{
		private static const ORIGIN:Point = new Point();
		private var _scrollRect:Rectangle;
		private var _globalRect:Rectangle;
		
		public function SpriteExt()
		{
			super();
		}
		
		public function get scrollRect():Rectangle
		{
			return this._scrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void
		{
			this._scrollRect = value;
			if (!this._scrollRect)
			{
				this._globalRect = null;
			}
			else if (!this._globalRect)
			{
				this._globalRect = new Rectangle();
			}
		}
		
		override public function render(support:RenderSupport, alpha:Number):void
		{
			if (this._scrollRect)
			{
				support.finishQuadBatch();
				var globalXY:Point = this.localToGlobal(ORIGIN);
				this._globalRect.x = globalXY.x;
				this._globalRect.y = globalXY.y;
				this._globalRect.width = this._scrollRect.width;
				this._globalRect.height = this._scrollRect.height;
				support.translateMatrix(-this._scrollRect.x, -this._scrollRect.y);
				Starling.context.setScissorRectangle(this._globalRect);
			}
			super.render(support, alpha);
			if (this._scrollRect)
			{
				support.finishQuadBatch();
				support.translateMatrix(this._scrollRect.x, this._scrollRect.y);
				Starling.context.setScissorRectangle(null);
			}
		}
	}
}