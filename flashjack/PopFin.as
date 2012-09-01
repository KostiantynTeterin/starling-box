package flashjack 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.textures.Texture;
	import flash.display.Bitmap;
	import starling.text.TextField;
	
	public class PopFin extends Sprite 
	{
		[Embed(source = "../../../media/fj-gameOver.png")]
		//[Embed(source = "../../../media/fj-pause.png")]
		private const pauseTextureClass:Class;
		private var pauseBMP:Image;		
		
		public function PopFin() 
		{
			pauseBMP = new Image( Texture.fromBitmap( new pauseTextureClass as Bitmap ) );
			pauseBMP.x = int( (640 - pauseBMP.width) / 2 );
			pauseBMP.y = 100;			
			addChild( pauseBMP );			
		}
		
		public function setFinalScore( score:int ):void
		{
			/*
			var str:String = "TIME BONUS : "+ time +" x 50 = "+String(time*50);
			var _timeBns:TextField = new TextField(300, 30, str , "Verdana", 18, 0xFFFFFF );
			_timeBns.x = int( (640 - 300) / 2 );
			_timeBns.y = pauseBMP.y + 150;
			addChild( _timeBns );
			
			str = "COINS : " + score;
			var _scoreTxt:TextField = new TextField(300, 30, str , "Verdana", 18, 0xFFFFFF );			
			_scoreTxt.x = int( (640 - 300) / 2 );
			_scoreTxt.y = _timeBns.y + 30;
			addChild( _scoreTxt );
			*/
			
			
			var str:String = "FINAL SCORE : " + score + " / 3500";
			var _finalScoreTxt:TextField = new TextField(350, 30, str , "Verdana", 24, 0xFFFFFF );			
			_finalScoreTxt.x = int( (640 - 350) / 2 );
			_finalScoreTxt.y = pauseBMP.y + 150;
			addChild( _finalScoreTxt );
			
		}
		
	}

}