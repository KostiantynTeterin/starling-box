package starlingBox.game.common
{
    import flash.geom.Point;
     
    public class EuclideanVector
    {
        public var position:Point;
        public var angle:Number;
         
        public function EuclideanVector(endPoint:Point)
        {
            position = endPoint;
        }
         
        public function inverse():EuclideanVector
        {
            return new EuclideanVector(new Point(-position.x, -position.y));
        }
         
        public function sum(otherVector:EuclideanVector):EuclideanVector
        {
            position.x += otherVector.position.x;
            position.y += otherVector.position.y;
             
            return this;
        }
         
        public function subtract(otherVector:EuclideanVector):EuclideanVector
        {
            position.x -= otherVector.position.x;
            position.y -= otherVector.position.y;
             
            return this;
        }
         
        public function multiply(number:Number):EuclideanVector
        {
            position.x *= number;
            position.y *= number;
             
            return this;
        }
         
        public function magnitude():Number
        {
            return Math.sqrt((position.x * position.x) + (position.y * position.y));
        }
         
        public function angle():Number
        {
            var angle:Number = Math.atan2(position.y, position.x);
             
            if (angle < 0)
            {
                angle += Math.PI * 2;
            }
             
            return angle;
        }
         
        public function dot(otherVector:EuclideanVector):Number
        {
            return (position.x * otherVector.position.x) + (position.y * otherVector.position.y);
        }
         
        public function angleBetween(otherVector:EuclideanVector):Number
        {
            return Math.acos(dot(otherVector) / (magnitude() * otherVector.magnitude()));
        }
         
        public function rangedAngleBetween(otherVector:EuclideanVector):Number
        {
            var firstAngle:Number;
            var secondAngle:Number;
             
            var angle:Number;
             
            firstAngle = Math.atan2(otherVector.position.y, otherVector.position.x);
            secondAngle = Math.atan2(position.y, position.x);
             
            angle = secondAngle - firstAngle;
             
            while (angle > Math.PI)
                angle -= Math.PI * 2;
            while (angle < -Math.PI)
                angle += Math.PI * 2;
             
            return angle;
        }
         
        public function normalize():EuclideanVector
        {
            position.x /= magnitude();
            position.y /= magnitude();
             
            return this;
        }
         
        public function normalRight():EuclideanVector
        {
            return new EuclideanVector(new Point(-position.y, position.x));
        }
         
        public function normalLeft():EuclideanVector
        {
            return new EuclideanVector(new Point(position.y, -position.x));
        }
         
        public function rotate(angleInRadians:Number):EuclideanVector
        {
            var newPosX:Number = (position.x * Math.cos(angleInRadians)) - (position.y * Math.sin(angleInRadians));
            var newPosY:Number = (position.x * Math.sin(angleInRadians)) + (position.y * Math.cos(angleInRadians));
             
            position.x = newPosX;
            position.y = newPosY;
             
            return this;
        }
    }
}