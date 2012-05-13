package starlingBox.malbolge
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import starlingBox.SB;
	
	public class Safe extends Timer
	{
		// TODO
		// Signer les valeurs en mémoire ?
		
		public static const SCORE:int = 0;
		public static const COMP1:int = 1;
		public static const COMP2:int = 2;
		public static const COMP3:int = 3;
		public static const COMP4:int = 4;
		public static const COMP5:int = 5;
		
		private var stage:Stage;
		
		// Entrees souris
		private var _mouseMove:int	= 0;	// deplacement souris
		private var _mouseClick:int	= 0;	// nombre de clicks
		
		// factoriser une liste de points
		private var _points:Vector.<Point> = new Vector.<Point>;
		
		// Valeurs secure
		//private var _safe:Vector.<Dante> = new Vector.<Dante>;
		
		// Back 2 the future
		private var _b2tf:Boolean = false;
		private var _oldDate:Date;
		
		// CPU Killer ! TODO !!!!
		private var _startTime:Number;
		private var _startGetTimer:Number;
		private var _cpu:Boolean = false;		
		
		// Clavier
		private var _keys:Vector.<int> = new Vector.<int>;
		
		// motifs
		private var _tr:String;
		
		// Encrypteur
		private var _aes:Rijndael = new Rijndael( 128, 128 ); // keySize (16 carac * 8 = 128), blockSize
		
		// donnees
		private var _datas:Vector.<Digits> = new Vector.<Digits>;
		
		// ----------------------------------------------------------------------------------------
		// CONSTRUCTEUR

		public function Safe( interval:int, repeat:int ) {	
			super( interval, repeat );
			_oldDate	= new Date();
			stage = SB.nativeStage;
			addLocker( SCORE );
			addLocker( COMP1 );
			addLocker( COMP2 );
			addLocker( COMP3 );
			addLocker( COMP4 );
			addLocker( COMP5 );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseIsMoving );
			stage.addEventListener( MouseEvent.CLICK, _onMouseIsClicked );
			stage.addEventListener( KeyboardEvent.KEY_UP, _onKeyIsUp );
		}
		
		// ----------------------------------------------------------------------------------------
		// ACCESSEURS
		public function setValue ( key:int, value:Number ):void {
			_datas[key].value = value;
		}
		
		public function incValue ( key:int, value:Number ):void {
			_datas[key].addValue( value );
		}
		
		public function getValue( key:int ):Number {
			return _datas[key].value;			
		}
		
		public function get b2tf():Boolean { return _b2tf; }		
		
		public function get mouseMove():int { return _mouseMove; }
		
		public function get mouseClick():int { return _mouseClick; }
		
		// a travailler
		public function get tr():String { 
			return ""; // b2tf.toString() + ';' + _cpu.toString();
		}
		
		public function get keys():Vector.<int> { return _keys; }
		
		public function get points():String { 
			return _points.toString();
		}
		
		public function addLocker(idx:int):void {
			_datas[idx] = new Digits(0);
		}
		
		public function addTime( value:uint ):void {
			this.repeatCount += value;
		}	
		
		// mhhhh
		public function setTotalTime( value:uint ):void {
			this.repeatCount = value;
		}		
		
		// ----------------------------------------------------------------------------------------
		// OVERRIDE
		override public function start():void {
			_startTime = new Date().getTime();
			_startGetTimer = getTimer();
			super.start();			
		}		
		
		// ----------------------------------------------------------------------------------------
		// METHODES PUBLIQUES		
		public function encryptMe( couples:Object, clefPrivee:String ):String {
			var rien:Object = creerChaineAleatoireHexa( 8 );
			couples.RI = rien;
			
			couples.ST = getValue( Safe.SCORE ).toString();
			couples.S1 = getValue( Safe.COMP1 ).toString();
			couples.S2 = getValue( Safe.COMP2 ).toString();
			couples.S3 = getValue( Safe.COMP3 ).toString();
			couples.S4 = getValue( Safe.COMP4 ).toString();
			couples.S5 = getValue( Safe.COMP5 ).toString();
			couples.TR = tr;
			couples.UR = SB.nativeStage.loaderInfo.url;
			
			var couplesStrings:Array = new Array;
			for( var identifiant:* in couples ){
				couplesStrings.push( String(identifiant)+"="+String(couples[identifiant]) );
			}
			// On les sort dans le désordre, dans un nouveau String
			var chaine:String = "";
			while( couplesStrings.length){
				var indice:Number = Math.floor( couplesStrings.length*Math.random() );
				var couple:String = couplesStrings.splice( indice, 1 );
				chaine += couple;
				if( couplesStrings.length > 0 ){
					chaine += ";";
				}
			}
			// On encrypte
			return encrypterComplet( chaine , clefPrivee );			
		}		
		
		private function creerChaineAleatoireHexa( taille:Number=16 ):String
		{
			var clef:String = "";
			for( var i:int=0 ; i<taille ; i++ ){
				clef += creerCharAleatoire();
			}
			return clef;
		}		
		
		private function checkTimeLine():void
		{
			var d:Date = new Date;
			/*
			// dernier check quand le temps est terminé
			var ms:Number = (d.getTime() - _startTime) / 1000;			
			var ms2:Number = (getTimer() - _startGetTimer) / 1000;
			
			if ( Math.abs( ms - ms2) > 1 ) {
				_cpu = true;
			}
			*/
			
			// verifie que les secondes s'écoulent dans le bon sens	
			if ( d > _oldDate) {
				_oldDate = d;
			} else {
				_b2tf = true;
			}
		}		
		
		// ----------------------------------------------------------------------------------------
		// METHODES PRIVEES	ENCRYPT
		
		private function creerCharAleatoire():String {
			var caracteres:Array = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];			
			return caracteres[ int( Math.random() * caracteres.length ) ];			
		}		
		
		// methodes d'encrypt
		private function encrypterChaine( chaine:String, clefPrivee:String ):String {
			return _aes.encrypt( chaine, clefPrivee, "ECB" ); // src, key, mode;
		}
		
		private function encrypterComplet( chaine:String, clefPrivee:String ):String {
			var clefPublique:String = creerChaineAleatoireHexa( 16 ); // 16 caractères
			var clefComplete:String = encrypterChaine( clefPublique, clefPrivee );
			var nfoCrypte:String = encrypterChaine( chaine, clefComplete );
			var nfoComplet:String = clefPublique.concat(nfoCrypte);
			
			return nfoComplet; 
			//return LZW.compress(nfoComplet); 
		}
		
		// ----------------------------------------------------------------------------------------
		// METHODES PRIVEES UI
		
		private function _onMouseIsMoving(e:MouseEvent):void {
			_mouseMove++;
		}
		
		private function _onMouseIsClicked(e:MouseEvent):void {
			_points.push( new Point(e.stageX, e.stageY ) );
			_mouseClick++;			
		}
		
		private function _onKeyIsUp(e:KeyboardEvent):void 
		{
			_keys.push( e.keyCode );
		}		
		
	}
}