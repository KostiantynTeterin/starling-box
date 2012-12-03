package KeosTactics 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Config 
	{
		public static const ARENA_4_6:Point = new Point(6, 4);
		public static const ARENA_4_7:Point = new Point(7, 4);
		public static const ARENA_5_7:Point = new Point(7, 5);		
		
		public static const PHASE_PIEGE:int = 0;
		public static const PHASE_DEPLOIEMENT:int = 1;
		public static const PHASE_ACTION:int = 2;
		public static const PHASE_RESOLUTION:int = 3;
		
		public static const RACE_DEFAUT:int = -1;
		public static const RACE_DOUR:int = 0;
		public static const RACE_GWAZH:int = 1;
		public static const RACE_GWERN:int = 2;
		public static const RACE_LENN:int = 3;
		public static const RACE_STANG:int = 4;		
		
		public function Config() 
		{
			
		}
		
	}

}