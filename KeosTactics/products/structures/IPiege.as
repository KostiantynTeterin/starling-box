package KeosTactics.products.structures 
{
	import KeosTactics.players.Player;
	
	/**
	 * ...
	 * @author YopSolo
	 */
	public interface IPiege
	{
		function get owner():Player;
		function set owner(value:Player):void;
		function get lig():int;		
		function set lig(value:int):void; 
		function get col():int;
		function set col(value:int):void;		
		function speech():void;
	}
	
}