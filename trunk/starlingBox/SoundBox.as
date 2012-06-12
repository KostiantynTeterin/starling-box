package starlingBox 
{
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.System;
	import flash.utils.Timer;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.VolumePlugin; 
	TweenPlugin.activate([VolumePlugin]);
	
	// =============================================================
	// Work In Pogress
	//
	// OK ajouter des sons
	// OK jouer un sfx	
	// OK jouer une bgm (en boucle)	
	// OK mute	
	// OK stopall sounds	
	// OK liberation de la mémoire
	// OK pause/resume BGM
	// OK régler le volume
	// OK pan 
	// OK fading
	// 
	// =============================================================
	// Todo
	// embed en base64 d'un sound pour le bip (son par defaut)
	// quand ca boucle est ce que ca repart bien sur pos=0 ?
	
	
	public class SoundBox
	{
		static private var _instance:SoundBox;
		
		private const MAX_TRACK:int = 16;
		
		private var _tracks:Vector.<Sound> 	= new Vector.<Sound>(MAX_TRACK, true);		
		
		private var _muteSfx:Boolean		= false;
		private var _muteBGM:Boolean		= false;		
		
		private var _channelBGM:SoundChannel = new SoundChannel;
		private var _channelSFX:SoundChannel = new SoundChannel;
		
		private var _sfxTransform:SoundTransform = new SoundTransform;
		private var _bgmTransform:SoundTransform = new SoundTransform;
		
		// For the toggle function 
		private var _sfxVolume:Number = 1;		
		private var _bgmVolume:Number = 1;
		
		private var _position:Number	= 0;
		private var _currentBGM:int		= -1;
		
		public static const BIP:int 	= 0;
		
		// Description
		public static const BGM1:int 	= 1;
		public static const BGM2:int 	= 2;
		public static const BGM3:int 	= 3;
		
		public static const BONUS1:int 	= 4;
		public static const BONUS2:int 	= 5;
		public static const BONUS3:int 	= 6;
		public static const BONUS4:int 	= 7;
		
		public static const ACTION1:int = 8;
		public static const ACTION2:int = 9;
		public static const ACTION3:int = 10;
		public static const ACTION4:int = 11;		
		
		public static const SPECIAL1:int = 12;
		public static const SPECIAL2:int = 13;
		public static const SPECIAL3:int = 14;
		public static const SPECIAL4:int = 15;		
		
		public function SoundBox( singletonLock:SingletonLock ) { }		
		
		static public function get instance():SoundBox {
			if (!_instance) _instance = new SoundBox( new SingletonLock() );			
			return _instance;			
		}		
		
		// -------------------------------------------------------------------
		// -- PUBLIC METHODS
		
		// -------------------------------------------------------		
		// Read Only Getter
		public function get bgmVolume():Number { return _channelBGM.soundTransform.volume }
		public function get sfxVolume():Number { return _channelSFX.soundTransform.volume }
		
		public function get isBgmMute():Boolean { return _muteBGM; }
		public function get isSfxMute():Boolean { return _muteSfx; }
		
		
		// -------------------------------------------------------		
		// OK
		public function addRessource( sound:Sound , idx:uint = ACTION1 ):void {
			if (idx < _tracks.length ) {
				_tracks[idx] = sound;
			}else {
				throw new Error("ERROR: "+_tracks.length+" slots Max.");
			}
		}
		
		// -------------------------------------------------------		
		// OK
		public function playSfx( idx:int = ACTION1 ):void {
			var s:Sound = _tracks[idx];			
			if ( s == null) {
				throw new Error("ERROR: No ressource for track " + idx);
			}else {
				_channelSFX = s.play(0, 0, _sfxTransform);				
			}
		}
		
		// 999, int.MAX_VALUE, or a listener...
		public function playBGM( idx:int = BGM1, repeat:int = 999 ):void {
			var s:Sound = _tracks[idx];			
			if ( s == null) {
				throw new Error("ERROR: No ressource for track " + idx);
			}else {
				_channelBGM.stop();
				if (_currentBGM != idx) { _position = 0 }; // effacer le point de sauvegarde si on switch
				_currentBGM = idx;
				_channelBGM = s.play( _position, repeat, _bgmTransform);	
				_position = 0; // reset de la position 
			}
		}
		
		// -------------------------------------------------------		
		// OK
		public function toggleMuteSFX():void {
			_muteSfx = !_muteSfx;
			if ( _muteSfx ) {
				_sfxVolume = sfxVolume; // save the previous value
				setSFXVolume( 0 );
			}else {
				setSFXVolume( sfxVolume );
			}
		}
		
		// OK
		public function toggleMuteBGM():void {			
			_muteBGM = !_muteBGM;
			if ( _muteBGM ) {
				_bgmVolume = bgmVolume; // save the previous value
				setBGMVolume( 0 );
			}else {
				setBGMVolume( _bgmVolume );
			}
		}		
		
		// -------------------------------------------------------
		// OK, value [0..1]
		public function setSFXVolume( value:Number ):void {
			_sfxTransform.volume = value;
			_channelSFX.soundTransform = _sfxTransform;		
		}
		
		// OK, value [0..1]
		public function setBGMVolume( value:Number ):void {
			_bgmTransform.volume = value;
			_channelBGM.soundTransform = _bgmTransform;			
		}
		
		// -------------------------------------------------------
		// OK
		public function pauseBGM():void {
			_position = _channelBGM.position;
			trace( "+++", _position );
			_channelBGM.stop();			
		}
		
		// OK
		public function resumeBGM():void {
			if (_currentBGM == -1) {
				throw new Error("ERROR: No current track");
			}else {
				playBGM( _currentBGM, 999 );
			}
		}
		
		// -------------------------------------------------------		
		// OK, value [-1..1]
		public function panBGM( value:Number ):void {
			if (value < -1 ) { value  = -1; }
			if (value > 1 ) { value  = 1; }		
			_bgmTransform.pan = value;
			_channelBGM.soundTransform = _bgmTransform;
		}
		
		// -------------------------------------------------------
		// OK
		public function fadeOut( delay_sec:Number = .8 ):void {
			if (delay_sec < .1) { delay_sec = .1 };			
			TweenLite.to( _channelBGM, delay_sec, {volume:0}); 
		}
		
		// OK
		public function fadeIn( delay_sec:Number = .8, vol_value:Number = 1 ):void {
			if (delay_sec < .1) { delay_sec = .1 };	
			TweenLite.to( _channelBGM, delay_sec, {volume:vol_value}); 
		}		
		
		// -------------------------------------------------------		
		// OK
		public function stopAllSound():void {
			SoundMixer.stopAll();		
		}
		
		// -------------------------------------------------------		
		// OK
		public function clearAllSound( callGarbageCollector:Boolean = false ):void {
			stopAllSound();
			for (var i:int = 0 ; i  < 16 ; i++ ) {
				_tracks[i]  = null;
			}			
			if (callGarbageCollector) System.gc();			
		}		
		
	}	
}
internal class SingletonLock { }