package KeosTactics.products.units
{
	import KeosTactics.players.Player
	/**
	 * ...
	 * @author YopSolo
	 */
	public interface IUnit 
	{
		function speech():void;
		function get owner():Player;
		function set owner(value:Player):void;
		function get lig():int;		
		function set lig(value:int):void; 
		function get col():int;
		function set col(value:int):void;
	}
	
}