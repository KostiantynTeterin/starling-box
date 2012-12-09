package KeoS 
{
	/**
	 * ...
	 * @author YopSolo
	 */
	public class Config 
	{
		public static var LANG:String = "FR";
		
		public static const ROOT_URL:String = "http://127.0.0.1/lockpickers/index.php?action=";
		
		// scripts
		public static const A_LOGMEIN:String = "logMeIn";
		public static const A_DECO:String = "deco";
		public static const A_INSCRIPTION:String = "addHero";
		public static const A_PASSRECOVER:String = "recover";
		public static const A_DESTINATION:String = "destination";		
		public static const A_SEARCH:String = "search";
		public static const A_OPEN:String = "open";
		public static const A_GETINFOS:String = "getInfos";
		
		// -- context et events
		public static const C_GUILD_SCREEN:String = "context_guild_screen";
		
		public static const E_RESET:String = "event_panelReset";
		public static const E_DESTINATION:String = "event_destination";
		// --
		public static const E_UPDATE_COMM:String = "event_update_comm";
		// --
		public static const E_GETINFOS:String = "event_getInfos"; // get infos
		public static const E_UPDATE:String = "event_update"; // update when infos ready
		
		
		public function Config() { }
		
	}

}