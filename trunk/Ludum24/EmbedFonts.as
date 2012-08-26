package Ludum24 
{
	import flash.text.Font;
	/**
	 * ...
	 * @author YopSolo
	 */
	public class EmbedFonts 
	{
		static private var _instance:EmbedFonts;
		[Embed(source = "../../media/fonts/MetalMania-Regular.ttf", embedAsCFF = 'false', fontName = 'MetalMania')]
		private static var MetalMania:Class;
		private static var _metalmania:Font;
		
		[Embed(source = "../../media/fonts/Geo-Regular.ttf", embedAsCFF = 'false', fontName = 'Geo')]
		private static var Geo:Class;	
		private static var _geo:Font;
		
		public function EmbedFonts( lock:SingletonLock ) { }
		
		public static function get instance():EmbedFonts
		{
            if (_instance == null){
                _metalmania = new MetalMania;
				_geo = new Geo;
				
				_instance = new EmbedFonts(new SingletonLock());				
            };
            return (_instance);
        }
		
		public function get geo():String
		{
			return _geo.fontName;
		}
		
		public function get metalmania():String 
		{
			return _metalmania.fontName;
		}
		
	}

}

internal class SingletonLock { }