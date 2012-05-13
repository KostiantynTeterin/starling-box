package flashjack
{
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	class MapChip
	{
		public static const NULL:int = 0;
		public static const BRICK:int = 1;
		public static const STAIR:int = 2;
		public static const PIPE:int = 3;
		public static const QUESTION:int = 4;
		
		private static var _images:Object = new Object();
		
		private var _type:int;
		private var _isSolid:Boolean;
		
		public function get image():BitmapData
		{
			return MapChip._images[_type];
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function isSolid():Boolean
		{
			return _isSolid;
		}
		
		public function MapChip(type:int)
		{
			_type = type;
			
			var drawFunction:Function;
			switch (_type)
			{
				case MapChip.NULL: 
					_isSolid = false;
					drawFunction = drawNull;
					break;
				case MapChip.BRICK: 
					_isSolid = true;
					drawFunction = drawBrick;
					break;
				case MapChip.STAIR: 
					_isSolid = true;
					drawFunction = drawStair;
					break;
				case MapChip.PIPE: 
					_isSolid = true;
					drawFunction = drawPipe;
					break;
				case MapChip.QUESTION: 
					_isSolid = true;
					drawFunction = drawQuestion;
					break;
			}
			
			if (MapChip._images[_type] === undefined)
			{
				var bitmapData:BitmapData = new BitmapData(Constants.GRID_SIZE, Constants.GRID_SIZE, true, 0x00ffffff);
				drawFunction(bitmapData);
				MapChip._images[_type] = bitmapData;
			}
		}
		
		private function drawNull(bitmapData:BitmapData):void
		{
		}
		
		private function drawBrick(bitmapData:BitmapData):void
		{
			var sprite:Sprite = new Sprite();
			for (var row:int = 0; row < 2; row++)
			{
				for (var col:int = 0; col < 2; col++)
				{
					var piece:Shape = new Shape();
					piece.graphics.beginFill(0xcc6600);
					piece.graphics.drawRect(col * 16, row * 16, 16, 16);
					piece.graphics.endFill();
					piece.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 255)];
					sprite.addChild(piece);
				}
			}
			bitmapData.draw(sprite);
		}
		
		private function drawQuestion(bitmapData:BitmapData):void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xcc6600);
			sprite.graphics.drawRect(0, 0, 32, 32);
			sprite.graphics.endFill();
			sprite.filters = [new BevelFilter(4, 45, 0xffffff, 1, 0x000000, 1, 8, 8, 255)];
			bitmapData.draw(sprite);
		}
		
		private function drawStair(bitmapData:BitmapData):void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawRect(0, 0, 32, 32);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0x99cc00);
			sprite.graphics.drawRect(1, 1, 30, 30);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0x009900);
			sprite.graphics.drawRect(8, 1, 16, 30);
			sprite.graphics.endFill();
			bitmapData.draw(sprite);
		}
		
		private function drawPipe(bitmapData:BitmapData):void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xcc9933);
			sprite.graphics.drawRect(0, 0, 32, 32);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawCircle(4, 4, 1);
			sprite.graphics.drawCircle(28, 4, 1);
			sprite.graphics.drawCircle(4, 28, 1);
			sprite.graphics.drawCircle(28, 28, 1);
			sprite.graphics.endFill();
			var questionText:TextField = new TextField();
			questionText.text = "?";
			questionText.width = 32;
			questionText.autoSize = TextFieldAutoSize.CENTER;
			var format:TextFormat = new TextFormat();
			format.size = 26;
			format.bold = true;
			format.color = 0xcc6600;
			questionText.setTextFormat(format);
			questionText.filters = [new DropShadowFilter(1, 45, 0x000000, 1, 1, 1, 2)];
			sprite.addChild(questionText);
			sprite.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 255)];
			bitmapData.draw(sprite);
		}
	}
}

