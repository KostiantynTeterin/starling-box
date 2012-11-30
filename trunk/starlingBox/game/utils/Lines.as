package starlingBox.game.utils
{
	import starlingBox.game.common.EuclideanVector;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Lines
	{
		
		public function Lines()
		{
		
		}
		
		public static function createLineDDA(startVector:EuclideanVector, endVector:EuclideanVector):Vector.<EuclideanVector>
		{
			var points:Vector.<EuclideanVector> = new Vector.<EuclideanVector>();
			
			var dx:Number;
			var dy:Number;
			
			var _x:Number = startPoint.position.x;
			var _y:Number = startPoint.position.y;
			
			var m:Number;
			
			var i:int;
			
			dx = endPoint.position.x - startPoint.position.x;
			dy = endPoint.position.y - startPoint.position.y;
			
			if (Math.abs(dx) >= Math.abs(dy))
				m = Math.abs(dx);
			else
				m = Math.abs(dy);
			
			points.push(new EuclideanVector(new Point(int(_x), int(_y))));
			
			i = 1;
			
			while (i <= m)
			{
				_x += dx / m;
				_y += dy / m;
				
				points.push(new EuclideanVector(new Point(int(_x), int(_y))));
				
				i++;
			}
			
			return points;
		}
		
		public static function createLineBresenham(startVector:EuclideanVector, endVector:EuclideanVector):Vector.<EuclideanVector>
		{
			var points:Vector.<EuclideanVector> = new Vector.<EuclideanVector>();
			
			var steep:Boolean = Math.abs(endVector.position.y - startVector.position.y) > Math.abs(endVector.position.x - startVector.position.x);
			
			var swapped:Boolean = false;
			
			if (steep)
			{
				startVector = new EuclideanVector(new Point(startVector.position.y, startVector.position.x));
				endVector = new EuclideanVector(new Point(endVector.position.y, endVector.position.x));
			}
			
			// Making the line go downward
			if (startVector.position.x > endVector.position.x)
			{
				var temporary:Number = startVector.position.x;
				
				startVector.position.x = endVector.position.x;
				
				endVector.position.x = temporary;
				
				temporary = startVector.position.y;
				
				startVector.position.y = endVector.position.y
				
				endVector.position.y = temporary;
				
				swapped = true;
			}
			
			var deltaX:Number = endVector.position.x - startVector.position.x;
			var deltaY:Number = Math.abs(endVector.position.y - startVector.position.y);
			
			var error:Number = deltaX / 2;
			
			var currentY:Number = startVector.position.y;
			
			var step:int;
			
			if (startVector.position.y < endVector.position.y)
			{
				step = 1;
			}
			else
			{
				step = -1;
			}
			
			var iterator:int = startVector.position.x;
			
			while (iterator < endVector.position.x)
			{
				if (steep)
				{
					points.push(new EuclideanVector(new Point(currentY, iterator)));
				}
				else
				{
					points.push(new EuclideanVector(new Point(iterator, currentY)));
				}
				
				error -= deltaY;
				
				if (error < 0)
				{
					currentY += step;
					error += deltaX;
				}
				
				iterator++;
			}
			
			if (swapped)
			{
				points.reverse();
			}
			
			return points;
		}
	
	}

}