package screens
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import nape.callbacks.CbType;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import nape.space.Space;
	import starling.display.graphics.Fill;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starlingBox.SB;
	import starlingBox.Screen;
	import NapeHills.Player;
    import starling.textures.GradientTexture;
    import starling.textures.Texture;
    import starling.utils.Color;	
	import flash.display.GradientType;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import starling.display.BlendMode;	
    import starling.display.shaders.fragment.TextureVertexColorFragmentShader;
    import starling.display.shaders.fragment.VertexColorFragmentShader;	

	public class NapeHillsMain extends Screen 
	{
		private const SLICE_HEIGHT				:int = 600;
		private const SLICE_WIDTH				:int = 30;
		private const INTERVAL					:Number = 1 / 60;

		private var _space						:Space;
		private var _characterCbType			:CbType;
		private var _character					:Body;
		private var _hills						:Sprite;

		private var _groundTexture				:Texture;
		private var _slicesCreated				:int;
		private var _currentAmplitude			:Number;
		private var _slicesInCurrentHill		:int;
		private var _indexSliceInCurrentHill	:int;
		private var _currentYPoint				:Number = 600;
		private var _slices						:Vector.<Body>;
		private var _sliceVectorConstructor		:Vector.<Vec2>;
		private var skyFill:Fill;

		public function NapeHillsMain():void 
		{			
			skyFill = new Fill();
            // Create a gradient texture, 1x4 px.
            // It doesn't need to be high resolution, as the texture's linear interpolation
            // will produce a gradient between pixel values anyway.
            var m:Matrix = new Matrix();
            m.createGradientBox( 1, 4, Math.PI*0.5 );
            var skyGradientTexture:Texture = GradientTexture.create( 2, 4, GradientType.LINEAR, [ 0x8ac9d2, 0xf4a886, 0xfec28c ], [1, 1, 1], [0, 128, 255], m );
            skyFill.uvMatrix.scale( SB.width / skyGradientTexture.width, SB.height / skyGradientTexture.height );
            skyFill.material.fragmentShader = new TextureVertexColorFragmentShader();
            skyFill.material.textures[0] = skyGradientTexture;
            skyFill.addVertex( 0, 0 );
            skyFill.addVertex( SB.width, 0 );
            skyFill.addVertex( SB.width, SB.height );
            skyFill.addVertex( 0, SB.height );
            addChild(skyFill);
			
			//Initialize Nape Space
			_space = new Space(new Vec2(0, 2000));

			_hills = new Sprite();
			addChild(_hills);

			_slices = new Vector.<Body>();
			
			//Generate a rectangle made of Vec2
			_sliceVectorConstructor = new Vector.<Vec2>();
			_sliceVectorConstructor.push(new Vec2(0, SLICE_HEIGHT));
			_sliceVectorConstructor.push(new Vec2(0, 0));
			_sliceVectorConstructor.push(new Vec2(SLICE_WIDTH, 0));
			_sliceVectorConstructor.push(new Vec2(SLICE_WIDTH, SLICE_HEIGHT));

			//Create the texture of the ground
			_groundTexture = Texture.fromBitmapData(new BitmapData(SLICE_WIDTH, SLICE_HEIGHT, false, 0xA2610D));

			//fill the stage with slices of hills
			for (var i:int = 0; i < SB.width / SLICE_WIDTH*1.2; i++) {
				createSlice();
			}

			_character = new Player();
			_character.space = _space;
			addChild(_character.graphic);

			startSimulation();
		}

		private function createSlice():void 
		{
			//Every time a new hill has to be created this algorithm predicts where the slices will be positioned
			if (_indexSliceInCurrentHill >= _slicesInCurrentHill) {
				_slicesInCurrentHill = Math.random() * 40 + 10;
				_currentAmplitude = Math.random() * 60 - 20;
				_indexSliceInCurrentHill = 0;
			}

			//Calculate the position of the next slice
			var nextYPoint:Number = _currentYPoint + (Math.sin(((Math.PI / _slicesInCurrentHill) * _indexSliceInCurrentHill)) * _currentAmplitude);

			_sliceVectorConstructor[2].y = nextYPoint - _currentYPoint;

			var slicePolygon:Polygon = new Polygon(_sliceVectorConstructor);
			var sliceBody:Body = new Body(BodyType.STATIC);
			sliceBody.shapes.add(slicePolygon);
			sliceBody.position.x = _slicesCreated * SLICE_WIDTH;
			sliceBody.position.y = _currentYPoint;
			sliceBody.space = _space;

			var image:Image = new Image(_groundTexture);
			sliceBody.graphic = image;
			_hills.addChild(image); 

			//Skew and position the image with a matrix
			var matrix:Matrix = image.transformationMatrix;
			matrix.translate(sliceBody.position.x, sliceBody.position.y);
			matrix.a = 1.04;
			matrix.b = (nextYPoint-_currentYPoint) / SLICE_WIDTH;
			image.transformationMatrix.copyFrom(matrix);

			_slicesCreated++;
			_indexSliceInCurrentHill++;
			_currentYPoint = nextYPoint;

			_slices.push(sliceBody);
		}

		private function startSimulation():void
		{			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e:Event):void
		{
			_space.step(INTERVAL);
			checkHills();
			panForeground();
		}

		private function checkHills():void 
		{
			for (var i:int = 0; i < _slices.length; i++) {
				if (_character.position.x - _slices[i].position.x > 400) {
					_space.bodies.remove(_slices[i]);
					if (_slices[i].graphic.parent) {
						_slices[i].graphic.parent.removeChild(_slices[i].graphic);
					}
					_slices.splice(i, 1);
					i--;
					createSlice();
				}
				else {
					break;
				}
			}
		}

		private function panForeground():void
		{
			this.x = SB.width / 2 - _character.position.x;
			this.y = SB.height / 2 - _character.position.y;
			skyFill.x = _character.position.x - SB.width / 2;
			skyFill.y = _character.position.y - SB.height / 2;
		}

	}

}