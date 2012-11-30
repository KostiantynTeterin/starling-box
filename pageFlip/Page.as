package pageFlip 
{
	import feathers.display.Image;
	import flash.geom.Point;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Page 
	{
		public var corner1:Point;
		public var corner2:Point;
		public var corner3:Point;
		public var corner4:Point;
		
		private var _img:Image;
		
		public function Page(pImg:Image) 
		{
			_img = pImg;
			corner1 = new Point;
			corner2 = new Point(pImg.width, 0);
			corner3 = new Point(pImg.width, pImg.height);
			corner4 = new Point(0, pImg.height );
		}
		
		public function get img():Image 
		{
			return _img;
		}
		
		public function translate( p:Point ):void
		{
			corner1 = corner1.add(p);
			corner2 = corner2.add(p);
			corner3 = corner3.add(p);
			corner4 = corner4.add(p);
			_img.x = corner1.x;
			_img.y = corner1.y;
		}
		
		
	}

}