package
{
	import flash.utils.Dictionary;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	
	public class TextureLoader
	{
		
		private static var _instance:TextureLoader;
		private var _textureDictionary:Dictionary;
		
		public function get textureDictionary():Dictionary
		{
			return _textureDictionary;
		}
		
		public function set textureDictionary(value:Dictionary):void
		{
			_textureDictionary = value;
		}
		
		public static function get instance():TextureLoader
		{
			if (_instance == null)
			{
				_instance = new TextureLoader(new SingletonLock());
			}
			return _instance;
		}
		
		public function TextureLoader(p_key:SingletonLock):void
		{
			if (p_key == null)
			{
				throw new Error("This is a Singleton. Use TextureLoader.instance");
			}
		}
		
		public function getBitmapTexture(ARG_name:String, ARG_bmp:Class):Texture
		{
			
			if (textureDictionary == null)
				textureDictionary = new Dictionary();
			
			if (textureDictionary[ARG_name] != null)
			{
				return textureDictionary[ARG_name];
			}
			else
			{
				var bmp:BitmapData = new ARG_bmp();
				var texture:Texture = Texture.fromBitmapData(new ARG_bmp());
				// dispose the bitmap data after it has been applied to a texture
				bmp.dispose();
				bmp = null;
				// assign the texture to the dictionary
				textureDictionary[ARG_name] = texture;
				return texture;
			}
			
			return null;
		}
		
		public function clearTexture(ARG_name:String):void
		{
			if (textureDictionary[ARG_name] != null)
			{
				textureDictionary[ARG_name].dispose();
				delete textureDictionary[ARG_name];
			}
		}
	}
}

internal class SingletonLock{}