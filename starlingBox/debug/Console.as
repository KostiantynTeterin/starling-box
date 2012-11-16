// ========================================================
// v 0.1, 10/02/08
// @auteur: YopSolo
// @mail: mail@yopsolo.fr
// @site: http://www.yopsolo.fr
// ========================================================

package starlingBox.debug
{

	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;

	public class Console extends Sprite 
	{
		private var VERSION:String = "v 1.0";
		private var tf:TextField;
		
		private static var _instance:Console;
		
		public function Console( se:SingletonEnforcer ) 
		{
			const couleur_text:uint = 0xFFFFFF;
			const couleur_fond:uint = 0x0000CC;
			const largeur:uint = 350;
			const hauteur:uint = 200;
			
			this.name = "Console";
			this.filters = [ new DropShadowFilter(0, 0, 0x0, 33, 4, 4, 2, 3) ];
			this.x = 20;
			this.y = 120;
			
			// création du sprite de drag
			var bg:Sprite = new Sprite();
			bg.graphics.lineStyle(1, couleur_text, 1, true, LineScaleMode.NONE );
			bg.graphics.beginFill( couleur_fond, 1 );
			bg.graphics.drawRect( 0, 0, 15, 15);
			bg.graphics.endFill();
			
			bg.x = -1;
			bg.y = -18;
			
			bg.buttonMode = true;
			bg.doubleClickEnabled = true;
			bg.addEventListener( MouseEvent.DOUBLE_CLICK, switchMe, false, 0, true );
			bg.addEventListener( MouseEvent.MOUSE_DOWN, startDragMe, false, 0, true );
			bg.addEventListener( MouseEvent.MOUSE_UP, stopDragMe, false, 0, true );			
			
			this.addChild( bg );	
			
			// ============================
			
			// création du textField
			tf 			= new TextField();
			tf.width 	= largeur;
			tf.height 	= hauteur;
			tf.wordWrap = true;
			
			tf.border			= true;
			tf.borderColor		= 0xFFFFFF;
			tf.background 		= true;
			tf.backgroundColor 	= couleur_fond;
			
			// création du format
			var fmt:TextFormat 		= new TextFormat();
			fmt.font 				= "_sans";
			fmt.color 				= couleur_text;
			fmt.size 				= 12;
			tf.defaultTextFormat 	= fmt ;		
			
			this.addChild( tf );
			
			// message d'accueil
			this.addMessage("~ DEBUG CONSOLE ~ ", this.VERSION);
			this.addMessage();
		}
		
		// -- methodes
		public function addMessage(...data):void 
		{
			var s:String = "";
			if (data) 
			{	
				if (data.length > 1){
					var i:int = 0;
					while (i < data.length)
					{
						if (i > 0) s += " ";
						s += data[i ++].toString();
					}
				} else {
					s = data.toString();
				}
			}
			
			tf.appendText( s + "\n" );
			tf.scrollV = tf.maxScrollV;					
		}
		
		public function message( ...data ):void 
		{
			tf.text = "";
			addMessage( data );
		}
		
		// -- 
		
		private function switchMe(e:MouseEvent):void
		{
			tf.visible = !tf.visible;
		}		
		
		private function startDragMe(e:MouseEvent):void 
		{
			this.startDrag();
		}		
		
		private function stopDragMe(e:MouseEvent):void 
		{
			this.stopDrag();
		}		
		
		static public function get instance():Console 
		{
			if (_instance == null) {
				_instance = new Console( new SingletonEnforcer );
			}
			return _instance;
		}
	}
}

internal class SingletonEnforcer {}