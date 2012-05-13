/*
package 
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    [SWF(width="465", height="465", frameRate="60", backgroundColor="0xffffff")]
    public class WonderflWorld extends Sprite {
        public static const STAGE_SIZE:int = 465;        // ステージの大きさ
        public static const STAGE_CENTER:int = 232;        // ステージの中心（STAGE_SIZE / 2）
        public static const GRID_SIZE:int = 32;            // グリッドの大きさ
        public static const GRID_COLS:int = 90;            // グリッドの横の数
        public static const GRID_ROWS:int = 15;            // グリッドの縦の数
        public static const PLUMBER_DEFX:int = 16;        // 配管工の初期のX座標の位置
        public static const PLUMBER_DEFY:int = 402;        // 配管工の初期のY座標の位置
        public static const GRAVITY:Number = 0.1125;    // 重力
        public static const MAX_SPEED:Number = 13;        // 最高速度
        // 以下の2つの値は2880（BitmapDataオブジェクトの最大サイズ）を超えないようにする 
        public static const MAP_WIDTH:int = 2880;        // マップ全体の幅（GRID_SIZE * GRID_COLS）
        public static const MAP_HEIGHT:int = 480;        // マップ全体の高さ（GRID_SIZE * GRID_ROWS）
        
        private var _map:Map;
        private var _plumber:Plumber;
        
        public function WonderflWorld() {
            _map = new Map();
            _plumber = new Plumber();
            
            addChild(_map);
            addChild(_plumber);
            y = WonderflWorld.STAGE_SIZE - WonderflWorld.MAP_HEIGHT;
            
            Input.enable(this.stage); // 入力を有効にする
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        // メインループ
        private function onEnterFrame(e:Event):void {
            _plumber.update(_map);
            _map.update(_plumber.posx);
        }
    }
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import flash.geom.Point;

class Map extends Bitmap {
    public static const data:Array = [
[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2],
[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2],
[0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,1,1,4,0,0,0,0,0,0,0,4,0,0,0,0,0,0,1,1,0,0,1,4,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2],
[0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2],
[0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2],
[0,0,0,4,0,1,4,1,4,1,0,0,0,0,0,3,0,0,0,0,0,0,1,4,1,0,0,0,0,0,0,0,1,0,1,1,0,0,4,0,4,0,4,0,0,1,0,0,0,0,0,0,1,1,0,0,0,2,0,0,2,0,0,0,0,0,2,0,0,2,0,0,0,0,0,1,4,1,0,0,0,0,0,2,2,2,2,2,2,2],
[0,0,0,4,0,0,0,0,0,0,0,0,0,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,0,0,2,2,0,0,0,2,2,0,0,2,2,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,2],
[0,0,0,0,0,0,0,0,0,0,0,3,0,3,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,2,2,2,0,2,2,2,0,0,2,2,2,0,3,0,0,0,0,0,3,0,2,2,2,2,2,2,2,2,2],
[1,1,1,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    ];

    private var _model:Array;            // マップのモデル
    private var _outScreen:BitmapData;    // マップ全体の画像
    private var _gameScreen:BitmapData;    // 画面に表示する部分の画像
    
    public function get model():Array { return _model; }
    
    public function Map() {
        initializeModel();
        initializeScreen();
    }
    
    // XY座標値に対応するマップモデルのグリッドの位置を求めて返す
    public function getGridFromPosition(posx:int, posy:int):Point {
        // 座標値をマップのモデルの範囲内に収まるようにする
        if (posx < -(WonderflWorld.GRID_SIZE)) {
            posx = -(WonderflWorld.GRID_SIZE);
        }else if (posx > WonderflWorld.MAP_WIDTH + WonderflWorld.GRID_SIZE) {
            posx = WonderflWorld.MAP_WIDTH + WonderflWorld.GRID_SIZE;
        }
        if (posy < -(WonderflWorld.GRID_SIZE * 2)) {
            posy = -(WonderflWorld.GRID_SIZE * 2);
        }else if (posy > WonderflWorld.MAP_HEIGHT + (WonderflWorld.GRID_SIZE * 2)) {
            posy = WonderflWorld.MAP_HEIGHT + (WonderflWorld.GRID_SIZE * 2);
        }
        
        var col:int = Math.floor((posx + WonderflWorld.GRID_SIZE) / WonderflWorld.GRID_SIZE);
        var row:int = Math.floor((posy + (WonderflWorld.GRID_SIZE * 2)) / WonderflWorld.GRID_SIZE);
        return new Point(col, row);
    }
    
    // 更新処理
    public function update(plumberXPos:int):void {
        var screenPos:int = plumberXPos - WonderflWorld.STAGE_CENTER;
        if (screenPos < 0) {
            screenPos = 0;
        }else if (screenPos > WonderflWorld.MAP_WIDTH - WonderflWorld.STAGE_SIZE) {
            screenPos = WonderflWorld.MAP_WIDTH - WonderflWorld.STAGE_SIZE;
        }
        
        var sourceRect:Rectangle = new Rectangle(screenPos, 0, WonderflWorld.STAGE_SIZE, WonderflWorld.MAP_HEIGHT);
        _gameScreen.copyPixels(_outScreen, sourceRect, new Point(0, 0));
    }
    
    // マップのモデルを作成する
    private function initializeModel():void {
        _model = new Array();
        
        for (var row:int = 0; row < WonderflWorld.GRID_ROWS + 4; row++) {
            _model[row] = new Array();
            for (var col:int = 0; col < WonderflWorld.GRID_COLS + 2; col++) {
                // 画面外の最外周を通行不可能な壁で囲み、配管工が変な場所に行かないようにする
                if ((row == 0) || (row == WonderflWorld.GRID_ROWS + 3) || (col == 0) || (col == WonderflWorld.GRID_COLS + 1)) {
                    _model[row][col] = new MapChip(MapChip.BRICK);
                // 画面外の上下に、ジャンプ・落下を不自然に見せない為のマージンを設ける
                }else if ((row == 1) || (row == WonderflWorld.GRID_ROWS + 2)) {
                    _model[row][col] = new MapChip(MapChip.NULL);
                // マップデータに応じたマップチップを作成する
                }else{
                    _model[row][col] = new MapChip(Map.data[row - 2][col - 1]);
                }
            }
        }
    }
    
    // マップの画像を作成する
    private function initializeScreen():void {
        _outScreen = new BitmapData(WonderflWorld.MAP_WIDTH, WonderflWorld.MAP_HEIGHT, false, 0x9999ff);
        _gameScreen = new BitmapData(WonderflWorld.STAGE_SIZE, WonderflWorld.MAP_HEIGHT, false, 0xffffff);
        this.bitmapData = _gameScreen;
        
        // BitmapData.coypPixels()に使う
        var sourceRect:Rectangle = new Rectangle(0, 0, WonderflWorld.GRID_SIZE, WonderflWorld.GRID_SIZE);
        var destPoint:Point = new Point(0, 0);
        
        for (var row:int = 0; row < WonderflWorld.GRID_ROWS; row++) {
            for (var col:int = 0; col < WonderflWorld.GRID_COLS; col++) {
                var tile:MapChip = _model[row + 2][col + 1];
                
                if(tile.type != MapChip.NULL){
                    var sourceBitmapData:BitmapData = tile.image;
                    destPoint.x = col * WonderflWorld.GRID_SIZE;
                    destPoint.y = row * WonderflWorld.GRID_SIZE;
                    
                    _outScreen.copyPixels(sourceBitmapData, sourceRect, destPoint);
                }
            }
        }
    }
}

import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.BevelFilter;
import flash.filters.DropShadowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class MapChip {
    public static const NULL:int = 0;        // 何も無し
    public static const BRICK:int = 1;        // レンガブロック
    public static const STAIR:int = 2;        // 階段ブロック
    public static const PIPE:int = 3;        // 土管
    public static const QUESTION:int = 4;    // ？ブロック
    
    private static var _images:Object = new Object(); // 画像を登録しておくための連想配列
    
    private var _type:int;            // マップチップの種類を保持する
    private var _isSolid:Boolean;    // 固いかどうか（通行不可能なのかどうか）
    
    public function get image():BitmapData { return MapChip._images[_type]; }
    public function get type():int { return _type; }
    public function isSolid():Boolean { return _isSolid; }
    
    // コンストラクタ
    public function MapChip(type:int) {
        _type = type;
        
        var drawFunction:Function; // どの画像を描画する関数を呼び出すかを保持する
        switch(_type) {
            case MapChip.NULL:
                _isSolid = false;
                drawFunction = drawNull;
                break;
            case MapChip.BRICK:
                _isSolid = true;
                drawFunction = drawBrick;
                break;
            case MapChip.STAIR:
                _isSolid = true;
                drawFunction = drawStair;
                break;
            case MapChip.PIPE:
                _isSolid = true;
                drawFunction = drawPipe;
                break;
            case MapChip.QUESTION:
                _isSolid = true;
                drawFunction = drawQuestion;
                break;
        }
        
        // 画像が連想配列に登録されていなければ、画像を作成して連想配列に登録しておく
        if (MapChip._images[_type] === undefined) {
            var bitmapData:BitmapData = new BitmapData(WonderflWorld.GRID_SIZE, WonderflWorld.GRID_SIZE, true, 0x00ffffff);
            drawFunction(bitmapData);
            MapChip._images[_type] = bitmapData;
        }
    }
    
    // 何も無しの為のダミー
    private function drawNull(bitmapData:BitmapData):void {  }
    
    // レンガブロックの画像を描画する
    private function drawBrick(bitmapData:BitmapData):void {
        var sprite:Sprite = new Sprite();
        for (var row:int = 0; row < 2; row++) {
            for (var col:int = 0; col < 2; col++) {
                var piece:Shape = new Shape();
                piece.graphics.beginFill(0xcc6600);
                piece.graphics.drawRect(col * 16, row * 16, 16, 16);
                piece.graphics.endFill();
                piece.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 255)];
                sprite.addChild(piece);
            }
        }
        bitmapData.draw(sprite);
    }
    
    // 階段ブロックの画像を描画する
    private function drawQuestion(bitmapData:BitmapData):void {
        var sprite:Sprite = new Sprite();
        sprite.graphics.beginFill(0xcc6600);
        sprite.graphics.drawRect(0, 0, 32, 32);
        sprite.graphics.endFill();
        sprite.filters = [new BevelFilter(4, 45, 0xffffff, 1, 0x000000, 1, 8, 8, 255)];
        bitmapData.draw(sprite);
    }
    
    // 土管の画像を描画する
    private function drawStair(bitmapData:BitmapData):void {
        var sprite:Sprite = new Sprite();
        sprite.graphics.beginFill(0x000000);
        sprite.graphics.drawRect(0, 0, 32, 32);
        sprite.graphics.endFill();
        sprite.graphics.beginFill(0x99cc00);
        sprite.graphics.drawRect(1, 1, 30, 30);
        sprite.graphics.endFill();
        sprite.graphics.beginFill(0x009900);
        sprite.graphics.drawRect(8, 1, 16, 30);
        sprite.graphics.endFill();
        bitmapData.draw(sprite);
    }
    
    // ？ブロックの画像を描画する
    private function drawPipe(bitmapData:BitmapData):void {
        var sprite:Sprite = new Sprite();
        sprite.graphics.beginFill(0xcc9933);
        sprite.graphics.drawRect(0, 0, 32, 32);
        sprite.graphics.endFill();
        sprite.graphics.beginFill(0x000000);
        sprite.graphics.drawCircle(4, 4, 1);
        sprite.graphics.drawCircle(28, 4, 1);
        sprite.graphics.drawCircle(4, 28, 1);
        sprite.graphics.drawCircle(28, 28, 1);
        sprite.graphics.endFill();
        var questionText:TextField = new TextField();
        questionText.text = "?";
        questionText.width = 32;
        questionText.autoSize = TextFieldAutoSize.CENTER;
        var format:TextFormat = new TextFormat();
        format.size = 26;
        format.bold = true;
        format.color = 0xcc6600;
        questionText.setTextFormat(format);
        questionText.filters = [new DropShadowFilter(1, 45, 0x000000, 1, 1, 1, 2)];
        sprite.addChild(questionText);
        sprite.filters = [new BevelFilter(1, 45, 0xffffff, 1, 0x000000, 1, 1, 1, 255)];
        bitmapData.draw(sprite);
    }
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

class Plumber extends Sprite {
    public static const HALF_WIDTH:int = 8;            // 幅の半分
    public static const HALF_HEIGHT:int = 14;        // 高さの半分
    public static const WALKING_SPEED:Number = 3;    // 歩く速さ
    public static const JUMPING_ABILITY:Number = 8;    // ジャンプ力
    
    private var _image:BitmapData;    // 配管工の画像を保持する
    
    private var _posx:int;            // X座標の位置
    private var _posy:int;            // Y座標の位置
    private var _dx:Number;            // X方向の速度
    private var _dy:Number;            // Y方向の速度
    private var _onGround:Boolean;    // 地に足が着いているか
    
    public function get posx():int { return _posx; }
    public function get posy():int { return _posy; }
    
    public function Plumber() {
        initialize();
        
        drawImage();
        var bitmap:Bitmap = new Bitmap(_image);
        bitmap.x = -(Plumber.HALF_WIDTH);
        bitmap.y = -(Plumber.HALF_HEIGHT);
        addChild(bitmap);
    }
    
    // 配管工を初期位置に配置する
    public function initialize():void {
        x = _posx = WonderflWorld.PLUMBER_DEFX;
        y = _posy = WonderflWorld.PLUMBER_DEFY;
        _dx = 0;
        _dy = 0;
        _onGround = true;
    }
    
    public function update(map:Map):void {
        changeVelocity();
        detectCollision(map);
        adjustDisplayPosition();
        
        // ステージ外に落下したら初期位置に戻る
        if (_posy > WonderflWorld.MAP_HEIGHT + Plumber.HALF_HEIGHT) {
            initialize();
        }
    }
    
    // 入力を受けて配管工の速度を変更する
    private function changeVelocity():void {
        if (Input.rightKey) {
            _dx = Plumber.WALKING_SPEED;
        }else if (Input.leftKey) {
            _dx = -(Plumber.WALKING_SPEED);
        }else {
            _dx = 0;
        }
        
        // 地面に立っている状態でAボタンを押すとジャンプ
        if (_onGround && Input.aButton) {
            _dy = -(Plumber.JUMPING_ABILITY);
        }
        _dy += WonderflWorld.GRAVITY;
        _onGround = false;
    }
    
    // マップとの当たり判定処理
    private function detectCollision(map:Map):void {
        var directionX:int = ((_dx < 0) ? -1 : 1);
        var directionY:int = ((_dy < 0) ? -1 : 1);
        
        // 次に移動予定の場所
        var nextX:int = Math.floor(_posx + _dx);
        var nextY:int = Math.floor(_posy + _dy);
        
        var edgeNextXGrid:Point = map.getGridFromPosition(nextX + (directionX * Plumber.HALF_WIDTH), nextY);
        var edgeNextYGrid:Point = map.getGridFromPosition(nextX, nextY + (directionY * Plumber.HALF_HEIGHT));
        var edgeNextXYGrid:Point = map.getGridFromPosition(nextX + (directionX * Plumber.HALF_WIDTH), nextY + (directionY * Plumber.HALF_HEIGHT));
        
        // 横方向の進行不可能な壁に当たった場合の処理
        if(map.model[edgeNextXGrid.y][edgeNextXGrid.x].isSolid()){
            _posx = Math.floor(_posx / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE
                    + ((directionX == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_WIDTH) : Plumber.HALF_WIDTH);
            _dx = 0;
        }
        
        // 縦方向の進行不可能な壁に当たった場合の処理
        if(map.model[edgeNextYGrid.y][edgeNextYGrid.x].isSolid()){
            _posy = Math.floor(_posy / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE
                    + ((directionY == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_HEIGHT) : Plumber.HALF_HEIGHT);
            _dy = 0;
            
            // 落下中に壁に当たったら着地
            if (directionY == 1) {
                _onGround = true;
            }
        }
        
        // 斜め方向の進行不可能な壁の角に当たった場合の処理
        if((_dx != 0 && _dy != 0) && map.model[edgeNextXYGrid.y][edgeNextXYGrid.x].isSolid()){
            _posx = Math.floor(_posx / WonderflWorld.GRID_SIZE) * WonderflWorld.GRID_SIZE
                    + ((directionX == 1) ? (WonderflWorld.GRID_SIZE - Plumber.HALF_WIDTH) : Plumber.HALF_WIDTH);
            _dx = 0;
        }
        
        // 壁に当たっていなかったら普通に移動する
        if (_dx != 0) { _posx = nextX; }
        if (_dy != 0) { _posy = nextY; }
    }
    
    // 画面上での表示位置を調整する
    private function adjustDisplayPosition():void {
        // マップ右端での挙動
        if (_posx > WonderflWorld.MAP_WIDTH - WonderflWorld.STAGE_CENTER) {
            x = _posx - (WonderflWorld.MAP_WIDTH - WonderflWorld.STAGE_SIZE);
        // マップ道中での挙動
        }else if (_posx > WonderflWorld.STAGE_CENTER) {
            x = WonderflWorld.STAGE_CENTER;
        // マップ左端での挙動
        }else {
            x = _posx;
        }
        
        y = _posy;
    }
    
    // 配管工の画像を描画する
    private function drawImage():void {
        _image = new BitmapData(Plumber.HALF_WIDTH * 2, Plumber.HALF_HEIGHT * 2, true, 0x00ffffff);
        
        var sprite:Sprite = new Sprite();
        sprite.graphics.beginFill(0xcc3333);
        sprite.graphics.drawRect(3, 0, 10, 24);
        sprite.graphics.endFill();
        sprite.graphics.beginFill(0xcc9933);
        sprite.graphics.drawRect(3, 4, 10, 6);
        sprite.graphics.drawRect(0, 17, 3, 3);
        sprite.graphics.drawRect(13, 17, 3, 3);
        sprite.graphics.endFill();
        sprite.graphics.beginFill(0x666600);
        sprite.graphics.drawRect(6, 10, 4, 5);
        sprite.graphics.drawRect(0, 10, 3, 7);
        sprite.graphics.drawRect(13, 10, 3, 7);
        sprite.graphics.drawRect(3, 24, 10, 4);
        sprite.graphics.endFill();
        
        _image.draw(sprite);
    }
}

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

class Input {    
    private static var _leftKey:Boolean;    // 左キー
    private static var _rightKey:Boolean;    // 右キー
    private static var _aButton:Boolean;    // Aボタン
    
    public static function get leftKey():Boolean { return Input._leftKey; }
    public static function get rightKey():Boolean { return Input._rightKey; }
    public static function get aButton():Boolean { return Input._aButton; }
    
    public static function enable(target:Stage):void {
        target.addEventListener(KeyboardEvent.KEY_DOWN, Input.onKeyDown);
        target.addEventListener(KeyboardEvent.KEY_UP, Input.onKeyUp);
    }
    
    private static function onKeyDown(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case Keyboard.LEFT:
                Input._leftKey = true;
                break;
            case Keyboard.RIGHT:
                Input._rightKey = true;
                break;
            case 90:    // Z
                Input._aButton = true;
                break;
        }
    }
    
    private static function onKeyUp(e:KeyboardEvent):void {
        switch(e.keyCode) {
            case Keyboard.LEFT:
                Input._leftKey = false;
                break;
            case Keyboard.RIGHT:
                Input._rightKey = false;
                break;
            case 90:    // Z
                Input._aButton = false;
                break;
        }
    }
}
*/