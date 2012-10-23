package starlingBox.game.pooling
{
	
	public interface IPoolable 
	{
		function get destroyed():Boolean;
		
		function init():void;
		function destroy():void;
	}
	
}