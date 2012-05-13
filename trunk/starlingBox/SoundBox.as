package starlingBox 
{
	// encapsulation de la la classe SoundManager dans un pseudo singleton
	
	import com.rafaelrinaldi.sound.SoundManager;
	
	public class SoundBox
	{
		public static var BG_MUSIC:String	= "bgMusic";
		
		static private var _instance:SoundManager;
		
		public function SoundBox( singletonLock:SingletonLock ) { }
		
		static public function get instance():SoundManager {
			if (!_instance) _instance = new SoundManager("StarlingBox");
			return _instance;			
		}
	}	
}

internal class SingletonLock { }
