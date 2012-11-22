package screens
{
	
	import AirStick.Etoile;
	import AirStick.Tir;
	import com.bit101.components.PushButton;
	import feathers.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starlingBox.game.controller.Keypad;
	import starlingBox.game.controller.VirtualButton;
	import starlingBox.game.controller.VirtualJoystick;
	import starlingBox.game.pooling.Pool;
	import starlingBox.SB;
	import starlingBox.Screen;
	
	public class AirStick extends Screen
	{
		private var joy:VirtualJoystick;
		private var ship:Image;
		
		private var DIR8_CONTROL:Boolean = false;
		private const MAX_SPEED:int = 8;
		private var btnA:VirtualButton;
		private var btnB:VirtualButton;
		
		// fond
		[Embed(source="../AirStick/blue.atf", mimeType="application/octet-stream")]
		private static const fondClass:Class;
		private var starfield:Image;
		
		// TIR
		[Embed(source="../../../media/tir.png")]
		private const TirClass:Class;
		[Embed(source="../../../media/tir.xml",mimeType="application/octet-stream")]
		private const TirXML:Class;
		private var atlasTir:TextureAtlas;
		private var limiter:int = 25;
		
		// ETOILES
		[Embed(source="../../../media/star32.png")]
		private const starTexture:Class;
		[Embed(source="../../../media/star32.xml",mimeType="application/octet-stream")]
		private const starAtlas:Class;
		private var atlasStar:TextureAtlas;
		private var limiter2:int = 3;
		
		protected var button:PushButton;
		protected var atlas:TextureAtlas;
		protected var font:BitmapFont;
		
		private var keypad:Keypad;
		
		public function AirStick()
		{
			if (SB.mobile)
			{
				this.scaleX = SB.ratioX;
				this.scaleY = SB.ratioY;
			}
			
			//addChild ( new Image( Texture.fromBitmapData( new Fond as BitmapData) ) );
			
			var ba:ByteArray = new fondClass();
			var texture:Texture = Texture.fromAtfData(ba as ByteArray);
			texture.repeat = true;
			starfield = new Image(texture);
			addChild( starfield );
			
			// --
			joy = new VirtualJoystick(150, 350, .5);
			addChild(joy);
			
			btnA = new VirtualButton(550, 250);
			addChild(btnA);
			btnB = new VirtualButton(650, 350);
			addChild(btnB);
			
			// --
			var shipData:Vaisseau = new Vaisseau;
			ship = new Image(Texture.fromBitmapData(shipData));
			ship.pivotX = ship.width >> 1;
			ship.pivotY = ship.height >> 1;
			ship.x = 500;
			ship.y = 250;
			addChild(ship);
			
			/*
			   atlas = new TextureAtlas(Texture.fromBitmap(new ATLAS_IMAGE(), false), XML(new ATLAS_XML()));
			   font = new BitmapFont(this.atlas.getTexture("tahoma30_0"), XML(new FONT_XML()));
			   button = new Button();
			   button.label = "Click Me";
			   button.defaultSkin = new Image(this.atlas.getTexture("button-up-skin"));
			   button.downSkin = new Image(this.atlas.getTexture("button-down-skin"));
			   button.defaultLabelProperties.textFormat = new BitmapFontTextFormat(this.font, 30, 0x000000);
			   //button.addEventListener(Event.TRIGGERED, _onClickButton);
			   addChild(button);
			   //button.validate();
			   button.x = (SB.width - button.width) - 30;
			   button.y = 30;
			 */
			
			button = new PushButton(SB.nativeStage, 30, 30, "Normal", _onClickButton);
			button.scaleX = button.scaleY = 2;
			
			atlasTir = new TextureAtlas(Texture.fromBitmap(new TirClass() as Bitmap), XML(new TirXML));
			atlasStar = new TextureAtlas(Texture.fromBitmap(new starTexture() as Bitmap), XML(new starAtlas));
			// --
			
			keypad = new Keypad(SB.nativeStage);
			
			if (SB.debug)
				SB.addConsole();
			
			addEventListener(Event.ENTER_FRAME, _oef);
		}
		
		private function _onClickButton(e:MouseEvent):void
		{
			if (button.label == "DIR-8")
			{
				button.label = "Normal";
				DIR8_CONTROL = false;
			}
			else
			{
				button.label = "DIR-8";
				DIR8_CONTROL = true;
			}
		
		}
		
		private function _oef(e:Event):void
		{
			var v:Number = MAX_SPEED * joy.speed_factor;
			if (DIR8_CONTROL)
			{
				if (joy.RG)
				{
					ship.x += v;
				}
				
				if (joy.LF)
				{
					ship.x += -v;
				}
				
				if (joy.UP)
				{
					ship.y += -v;
				}
				
				if (joy.DW)
				{
					ship.y += v;
				}
			} else {
				
				if (!joy.NONE)
				{
					ship.x += Math.cos(joy.angle) * v;
					ship.y += Math.sin(joy.angle) * v;
				}
			}
			// --
			if (joy.NONE)
			{
				ship.rotation = Math.PI * 3 / 2;
			} else {
				ship.rotation = joy.angle;
			}
			
			if ( btnA.isDown || keypad.isDown(Keyboard.SPACE) )
			{
				//SB.console.addMessage(btnA, "#A OPEN FIRE !");
				if (limiter > 5)
				{
					var tir:Tir = Pool.instance.pool("tirs").length ? Pool.instance.pool("tirs").pop() as Tir : new Tir(atlasTir);
					tir.init(ship.x, ship.y, ship.rotation);
					addChild(tir);
					limiter = 0;
				}
				limiter++;
			}
			
			if (btnB.isDown || keypad.isDown(Keyboard.A))
			{
				if (limiter2 > 1)
				{
					var etoile:Etoile = Pool.instance.pool("etoiles").length ? Pool.instance.pool("etoiles").pop() as Etoile : new Etoile(atlasStar);					
					etoile.init(ship.x, ship.y);
					addChild(etoile);
					limiter2 = 0;
				}
				limiter2++;
			}
			
			if (ship.x < 0)
				ship.x += SB.width;
			if (ship.x > SB.width)
				ship.x -= SB.width;
			if (ship.y < 0)
				ship.y += SB.height;
			if (ship.y > SB.height)
				ship.y -= SB.height;
			
			if (!joy.NONE)
			{				
				var p:Point;
				for (var i:int = 0; i < 4; i++)
				{
					p = starfield.getTexCoords(i);
					p.x += (v * Math.cos(joy.angle) * .001);
					p.y += (v * Math.sin(joy.angle) * .001);
					starfield.setTexCoords(i, p);
				}			
			}
		}	
	}

}