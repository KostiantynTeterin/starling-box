package starling.extensions
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	import starling.text.BitmapFont;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;
	
	import starling.extensions.TextureItem;
	
	/**
	 * ### Usage ###
	 * 	You can use the following static methods (examples at the gitHub Repo):
	 *
	 * 	[Texture Atlas creation]
	 * 	- DynamicAtlas.fromMovieClipContainer(swf:flash.display.MovieClip, scaleFactor:Number = 1, margin:uint=0, preserveColor:Boolean = true):starling.textures.TextureAtlas
	 * 	- DynamicAtlas.fromClassVector(assets:Vector.<Class>, scaleFactor:Number = 1, margin:uint=0, preserveColor:Boolean = true):starling.textures.TextureAtlas
	 *
	 * [Bitmap Font registration]
	 * - DynamicAtlas.bitmapFontFromString(chars:String, fontFamily:String, fontSize:Number = 12, bold:Boolean = false, italic:Boolean = false, charMarginX:int=0):void
	 * - DynamicAtlas.bitmapFontFromTextField(tf:flash.text.TextField, charMarginX:int=0):void
	 *
	 * 	Enclose inside a try/catch for error handling:
	 * 		try {
	 * 				var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(mc);
	 * 			} catch (e:Error) {
	 * 				trace("There was an error in the creation of the texture Atlas. Please check if the dimensions of your clip exceeded the maximun allowed texture size. -", e.message);
	 * 			}
	 **/
	
	public class DynamicAtlas
	{
		static protected const DEFAULT_CANVAS_WIDTH:Number = 640;
		
		static protected var _items:Array;
		static protected var _canvas:Sprite;
		
		static protected var _currentLab:String;
		
		static protected var _x:Number;
		static protected var _y:Number;
		
		static protected var _bData:BitmapData;
		static protected var _mat:Matrix;
		static protected var _margin:Number;
		static protected var _preserveColor:Boolean;
		
		// Will not be used - Only using one static method
		public function DynamicAtlas()
		{
		
		}
		
		// Private methods
		
		static protected function appendIntToString(num:int, numOfPlaces:int):String
		{
			var numString:String = num.toString();
			var outString:String = "";
			for (var i:int = 0; i < numOfPlaces - numString.length; i++)
			{
				outString += "0";
			}
			return outString + numString;
		}
		
		static protected function layoutChildren():void
		{
			var xPos:Number = 0;
			var yPos:Number = 0;
			var maxY:Number = 0;
			var len:int = _items.length;
			
			var itm:TextureItem;
			
			for (var i:uint = 0; i < len; i++)
			{
				itm = _items[i];
				if ((xPos + itm.width) > DEFAULT_CANVAS_WIDTH)
				{
					xPos = 0;
					yPos += maxY;
					maxY = 0;
				}
				if (itm.height + 1 > maxY)
				{
					maxY = itm.height + 1;
				}
				itm.x = xPos;
				itm.y = yPos;
				xPos += itm.width + 1;
			}
		}
		
		/**
		 * isEmbedded
		 *
		 * @param	fontFamily:Boolean - The name of the Font
		 * @return Boolean - True if the font is an embedded one
		 */
		static protected function isEmbedded(fontFamily:String):Boolean
		{
			var embeddedFonts:Vector.<Font> = Vector.<Font>(Font.enumerateFonts());
			
			for (var i:int = embeddedFonts.length - 1; i > -1 && embeddedFonts[i].fontName != fontFamily; i--)
			{
			}
			
			return (i > -1);
		
		}
		
		static protected function getRealBounds(clip:DisplayObject):Rectangle
		{
			var bounds:Rectangle = clip.getBounds(clip.parent);
			bounds.x = Math.floor(bounds.x);
			bounds.y = Math.floor(bounds.y);
			bounds.height = Math.ceil(bounds.height);
			bounds.width = Math.ceil(bounds.width);
			
			var realBounds:Rectangle = new Rectangle(0, 0, bounds.width + _margin * 2, bounds.height + _margin * 2);
			
			// Checking filters in case we need to expand the outer bounds
			if (clip.filters.length > 0)
			{
				// filters
				var j:int = 0;
				//var clipFilters:Array = clipChild.filters.concat();
				var clipFilters:Array = clip.filters;
				var clipFiltersLength:int = clipFilters.length;
				var tmpBData:BitmapData;
				var filterRect:Rectangle;
				
				tmpBData = new BitmapData(realBounds.width, realBounds.height, false);
				filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
				tmpBData.dispose();
				
				while (++j < clipFiltersLength)
				{
					tmpBData = new BitmapData(filterRect.width, filterRect.height, true, 0);
					filterRect = tmpBData.generateFilterRect(tmpBData.rect, clipFilters[j]);
					realBounds = realBounds.union(filterRect);
					tmpBData.dispose();
				}
			}
			
			realBounds.offset(bounds.x, bounds.y);
			realBounds.width = Math.max(realBounds.width, 1);
			realBounds.height = Math.max(realBounds.height, 1);
			
			tmpBData = null;
			return realBounds;
		}
		
		/**
		 * drawItem - This will actually rasterize the display object passed as a parameter
		 * @param	clip
		 * @param	name
		 * @param	baseName
		 * @param	clipColorTransform
		 * @param	frameBounds
		 * @return TextureItem
		 */
		static protected function drawItem(clip:DisplayObject, name:String = "", baseName:String = "", clipColorTransform:ColorTransform = null, frameBounds:Rectangle = null):TextureItem
		{
			var realBounds:Rectangle = getRealBounds(clip);
			
			_bData = new BitmapData(realBounds.width, realBounds.height, true, 0);
			_mat = clip.transform.matrix;
			_mat.translate(-realBounds.x + _margin, -realBounds.y + _margin);
			
			_bData.draw(clip, _mat, _preserveColor ? clipColorTransform : null);
			
			var label:String = "";
			if (clip is MovieClip)
			{
				if (clip["currentLabel"] != _currentLab && clip["currentLabel"] != null)
				{
					_currentLab = clip["currentLabel"];
					label = _currentLab;
				}
			}
			
			if (frameBounds)
			{
				realBounds.x = frameBounds.x - realBounds.x;
				realBounds.y = frameBounds.y - realBounds.y;
				realBounds.width = frameBounds.width;
				realBounds.height = frameBounds.height;
			}
			
			var item:TextureItem = new TextureItem(_bData, name, label, realBounds.x, realBounds.y, realBounds.width, realBounds.height);
			
			_items.push(item);
			_canvas.addChild(item);
			
			_bData = null;
			
			return item;
		}
		
		// Public methods
		
		/**
		 * This method takes a vector of MovieClip class and converts it into a Texture Atlas.
		 *
		 * @param	assets:Vector.<Class> - The MovieClip classes you wish to convert into a TextureAtlas. Must contain classes whose instances are of type MovieClip that will be rasterized and become the subtextures of your Atlas.
		 * @param	scaleFactor:Number - The scaling factor to apply to every object. Default value is 1 (no scaling).
		 * @param	margin:uint - The amount of pixels that should be used as the resulting image margin (for each side of the image). Default value is 0 (no margin).
		 * @param	preserveColor:Boolean - A Flag which indicates if the color transforms should be captured or not. Default value is true (capture color transform).
		 * @param 	checkBounds:Boolean - A Flag used to scan the clip prior the rasterization in order to get the bounds of the entire MovieClip. By default is false because it adds overhead to the process.
		 * @return  TextureAtlas - The dynamically generated Texture Atlas.
		 */
		static public function fromClassVector(assets:Vector.<Class>, scaleFactor:Number = 1, margin:uint = 0, preserveColor:Boolean = true, checkBounds:Boolean = false):TextureAtlas
		{
			var container:MovieClip = new MovieClip();
			for each (var assetClass:Class in assets)
			{
				var assetInstance:MovieClip = new assetClass();
				assetInstance.name = getQualifiedClassName(assetClass);
				container.addChild(assetInstance);
			}
			return fromMovieClipContainer(container, scaleFactor, margin, preserveColor, checkBounds);
		}
		
		/** Retrieves all textures for a class. Returns <code>null</code> if it is not found.
		 * This method can be used if TextureAtlass doesn't support classes.
		 */
		static public function getTexturesByClass(textureAtlas:TextureAtlas, assetClass:Class):Vector.<Texture>
		{
			return textureAtlas.getTextures(getQualifiedClassName(assetClass));
		}
		
		/**
		 * This method will take a MovieClip sprite sheet (containing other display objects) and convert it into a Texture Atlas.
		 *
		 * @param	swf:MovieClip - The MovieClip sprite sheet you wish to convert into a TextureAtlas. I must contain named instances of every display object that will be rasterized and become the subtextures of your Atlas.
		 * @param	scaleFactor:Number - The scaling factor to apply to every object. Default value is 1 (no scaling).
		 * @param	margin:uint - The amount of pixels that should be used as the resulting image margin (for each side of the image). Default value is 0 (no margin).
		 * @param	preserveColor:Boolean - A Flag which indicates if the color transforms should be captured or not. Default value is true (capture color transform).
		 * @param 	checkBounds:Boolean - A Flag used to scan the clip prior the rasterization in order to get the bounds of the entire MovieClip. By default is false because it adds overhead to the process.
		 * @return  TextureAtlas - The dynamically generated Texture Atlas.
		 */
		static public function fromMovieClipContainer(swf:MovieClip, scaleFactor:Number = 1, margin:uint = 0, preserveColor:Boolean = true, checkBounds:Boolean = false):TextureAtlas
		{
			var parseFrame:Boolean = false;
			var selected:MovieClip;
			var selectedTotalFrames:int;
			var selectedColorTransform:ColorTransform;
			var frameBounds:Rectangle = new Rectangle(0, 0, 0, 0);
			
			var children:uint = swf.numChildren;
			
			var canvasData:BitmapData;
			
			var texture:Texture;
			var xml:XML;
			var subText:XML;
			var atlas:TextureAtlas;
			
			var itemsLen:int;
			var itm:TextureItem;
			
			var m:uint;
			
			_margin = margin;
			_preserveColor = preserveColor;
			
			_items = [];
			
			if (!_canvas)
				_canvas = new Sprite();
			
			swf.gotoAndStop(1);
			
			for (var i:uint = 0; i < children; i++)
			{
				selected = MovieClip(swf.getChildAt(i));
				selectedTotalFrames = selected.totalFrames;
				selectedColorTransform = selected.transform.colorTransform;
				_x = selected.x;
				_y = selected.y;
				
				// Scaling if needed (including filters)
				if (scaleFactor != 1)
				{
					
					selected.scaleX *= scaleFactor;
					selected.scaleY *= scaleFactor;
					
					if (selected.filters.length > 0)
					{
						var filters:Array = selected.filters;
						var filtersLen:int = selected.filters.length;
						var filter:Object;
						for (var j:uint = 0; j < filtersLen; j++)
						{
							filter = filters[j];
							
							if (filter.hasOwnProperty("blurX"))
							{
								filter.blurX *= scaleFactor;
								filter.blurY *= scaleFactor;
							}
							if (filter.hasOwnProperty("distance"))
							{
								filter.distance *= scaleFactor;
							}
						}
						selected.filters = filters;
					}
				}
				
				// Gets the frame bounds by performing a frame-by-frame check
				if (selectedTotalFrames > 1 && checkBounds)
				{
					selected.gotoAndStop(0);
					frameBounds = getRealBounds(selected);
					m = 1;
					while (++m <= selectedTotalFrames)
					{
						selected.gotoAndStop(m);
						frameBounds = frameBounds.union(getRealBounds(selected));
					}
				}
				m = 0;
				// Draw every frame
				
				while (++m <= selectedTotalFrames)
				{
					selected.gotoAndStop(m);
					drawItem(selected, selected.name + "_" + appendIntToString(m - 1, 5), selected.name, selectedColorTransform, frameBounds);
				}
			}
			
			_currentLab = "";
			
			layoutChildren();
			
			canvasData = new BitmapData(_canvas.width, _canvas.height, true, 0x000000);
			canvasData.draw(_canvas);
			
			xml = new XML(<TextureAtlas></TextureAtlas>);
			xml.@imagePath = "atlas.png";
			
			itemsLen = _items.length;
			
			for (var k:uint = 0; k < itemsLen; k++)
			{
				itm = _items[k];
				
				itm.graphic.dispose();
				
				// xml
				subText = new XML(<SubTexture />); 
				subText.@name = itm.textureName;
				subText.@x = itm.x;
				subText.@y = itm.y;
				subText.@width = itm.width;
				subText.@height = itm.height;
				subText.@frameX = itm.frameX;
				subText.@frameY = itm.frameY;
				subText.@frameWidth = itm.frameWidth;
				subText.@frameHeight = itm.frameHeight;
				
				if (itm.frameName != "")
					subText.@frameLabel = itm.frameName;
				xml.appendChild(subText);
			}
			texture = Texture.fromBitmapData(canvasData);
			atlas = new TextureAtlas(texture, xml);
			
			_items.length = 0;
			_canvas.removeChildren();
			
			_items = null;
			xml = null;
			_canvas = null;
			_currentLab = null;
			//_x = _y = _margin = null;
			
			return atlas;
		}
		
		/**
		 * This method will register a Bitmap Font based on each char that belongs to a String.
		 *
		 * @param	chars:String - The collection of chars which will become the Bitmap Font
		 * @param	fontFamily:String - The name of the Font that will be converted to a Bitmap Font
		 * @param	fontSize:Number - The size in pixels of the font.
		 * @param	bold:Boolean - A flag indicating if the font will be rasterized as bold.
		 * @param	italic:Boolean - A flag indicating if the font will be rasterized as italic.
		 * @param	charMarginX:int - The number of pixels that each character should have as horizontal margin (negative values are allowed). Default value is 0.
		 * @param	fontCustomID:String - A custom font family name indicated by the user. Helpful when using differnt effects for the same font. [Optional]
		 */
		static public function bitmapFontFromString(chars:String, fontFamily:String, fontSize:Number = 12, bold:Boolean = false, italic:Boolean = false, charMarginX:int = 0, fontCustomID:String = ""):void
		{
			var format:TextFormat = new TextFormat(fontFamily, fontSize, 0xFFFFFF, bold, italic);
			var tf:flash.text.TextField = new flash.text.TextField();
			
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			// If the font is an embedded one (I couldn't get to work the Array.indexOf method) :(
			if (isEmbedded(fontFamily))
			{
				tf.antiAliasType = AntiAliasType.ADVANCED;
				tf.embedFonts = true;
			}
			
			tf.defaultTextFormat = format;
			tf.text = chars;
			
			if (fontCustomID == "")
				fontCustomID = fontFamily;
			bitmapFontFromTextField(tf, charMarginX, fontCustomID);
		}
		
		/**
		 * This method will register a Bitmap Font based on each char that belongs to a regular flash TextField, rasterizing filters and color transforms as well.
		 *
		 * @param	tf:flash.text.TextField - The textfield that will be used to rasterize every char of the text property
		 * @param	charMarginX:int - The number of pixels that each character should have as horizontal margin (negative values are allowed). Default value is 0.
		 * @param	fontCustomID:String - A custom font family name indicated by the user. Helpful when using differnt effects for the same font. [Optional]
		 */
		static public function bitmapFontFromTextField(tf:flash.text.TextField, charMarginX:int = 0, fontCustomID:String = ""):void
		{
			var charCol:Vector.<String> = Vector.<String>(tf.text.split(""));
			var format:TextFormat = tf.defaultTextFormat;
			var fontFamily:String = format.font;
			var fontSize:Object = format.size;
			
			var oldAutoSize:String = tf.autoSize;
			tf.autoSize = TextFieldAutoSize.LEFT;
			
			var canvasData:BitmapData;
			var texture:Texture;
			var xml:XML;
			
			var myChar:String;
			
			_margin = 0;
			_preserveColor = true;
			
			_items = [];
			var itm:TextureItem;
			var itemsLen:int;
			
			if (!_canvas)
				_canvas = new Sprite();
			
			// Add the blank space char if not present;
			if (charCol.indexOf(" ") == -1)
				charCol.push(" ");
			
			for (var i:int = charCol.length - 1; i > -1; i--)
			{
				myChar = tf.text = charCol[i];
				drawItem(tf, myChar.charCodeAt().toString());
			}
			
			_currentLab = "";
			
			layoutChildren();
			
			canvasData = new BitmapData(_canvas.width, _canvas.height, true, 0x000000);
			canvasData.draw(_canvas);
			
			itemsLen = _items.length;
			
			xml = new XML(<font></font>);var infoNode:XML = new XML(<info />);
			infoNode.@face = (fontCustomID == "") ? fontFamily : fontCustomID;
			infoNode.@size = fontSize;
			xml.appendChild(infoNode);
			//var commonNode:XML = new XML(<common alphaChnl="1" redChnl="0" greenChnl="0" blueChnl="0" />);
			var commonNode:XML = new XML(<common />);
			commonNode.@lineHeight = fontSize;
			xml.appendChild(commonNode);
			xml.appendChild(new XML(<pages><page id="0" file="texture.png" /></pages>));var charsNode:XML = new XML(<chars> </chars>);
			charsNode.@count = itemsLen;
			var charNode:XML;
			
			for (var k:uint = 0; k < itemsLen; k++)
			{
				itm = _items[k];
				
				itm.graphic.dispose();
				
				// xml
				charNode = new XML(<char page="0" xoffset="0" yoffset="0"/>); 
				charNode.@id = itm.textureName;
				charNode.@x = itm.x;
				charNode.@y = itm.y;
				charNode.@width = itm.width;
				charNode.@height = itm.height;
				charNode.@xadvance = itm.width + 2 * charMarginX;
				charsNode.appendChild(charNode);
			}
			
			xml.appendChild(charsNode);
			
			texture = Texture.fromBitmapData(canvasData);
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			_items.length = 0;
			_canvas.removeChildren();
			
			tf.autoSize = oldAutoSize;
			tf.text = charCol.join();
			
			_items = null;
			xml = null;
			_canvas = null;
			_currentLab = null;
		}
	
	}

}

/*
private function addClipsFromContainer():void 
{
	try {
		var mc:SheetMC = new SheetMC();
		var t1:uint = getTimer();
		var atlas:TextureAtlas = DynamicAtlas.fromMovieClipContainer(mc, .5, 0, true, true);
		var total:uint = getTimer() - t1;
		//trace("atlas:", atlas);
		trace(total, "msecs elapsed while converting...");
		
		var boy_mc:MovieClip = new MovieClip(atlas.getTextures("boy"), 60);
		boy_mc.x = boy_mc.y = 10;
		addChild(boy_mc);
		Starling.juggler.add(boy_mc);
		
		var btnSkin:Image = new Image(atlas.getTextures("buttonSkin")[0]);
		btnSkin.x = 30
		btnSkin.y = 80;
		addChild(btnSkin);
		
	} catch (e:Error) {
		trace("There was an error in the creation of the texture Atlas. Please check if the dimensions of your clip exceeded the maximun allowed texture size. -", e.message);
	}
}

private function addTextFields():void 
{
	try {
		var embeddedFont1:Font = new Verdana();
		var embeddedFont2:Font = new ComicSansMSBold();
		
		var chars2Add:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		chars2Add += chars2Add.toLowerCase() + ",.-_!?1234567890: ";

		var cont:flash.display.MovieClip = new TextContainer();
		
		DynamicAtlas.bitmapFontFromString(chars2Add, embeddedFont1.fontName, 16, false, false, -2);
		DynamicAtlas.bitmapFontFromString(chars2Add, "_sans", 16, false, false, -2);
		DynamicAtlas.bitmapFontFromTextField(cont.tf, 0);
		
		var embedded_tf:TextField = new TextField(300, 100, "Here is some dynamically generated text using an embedded Bitmap Font", embeddedFont1.fontName, 16, 0xFF0000, true);
		embedded_tf.x = 150;
		embedded_tf.y = 10;
		embedded_tf.autoScale = true;
		embedded_tf.border = true;
		addChild(embedded_tf);
		//
		var system_tf:TextField = new TextField(300, 100, "Here is some dynamically generated text using a system Bitmap Font.", "_sans", 16, 0x00FF00, false);
		system_tf.x = embedded_tf.x;
		system_tf.y = embedded_tf.y + embedded_tf.height;
		system_tf.autoScale = true;
		system_tf.border = true;
		addChild(system_tf);
		
		var filtered_tf:TextField = new TextField(300, 100, "AND ONE HELLUVA FILTERED TEXT", embeddedFont2.fontName, 16, 0x00FF00);
		// the native bitmap font size, no scaling 
		filtered_tf.fontSize = BitmapFont.NATIVE_SIZE;
		// use white to use the texture as it is (no tinting) 
		filtered_tf.color = Color.WHITE;
		filtered_tf.x = embedded_tf.x;
		filtered_tf.y = system_tf.y + system_tf.height;
		filtered_tf.border = true;
		addChild(filtered_tf);
	} catch (e:Error) {
		trace("There was an error in the creation of one of the Bitmap Fonts. Please check if the dimensions of your clip exceeded the maximun allowed texture size. -", e.message);
	}
}
*/