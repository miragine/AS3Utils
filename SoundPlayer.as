//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Tue Jul 28 16:10:18 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {

	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.events.*;

	public class SoundPlayer extends EventDispatcher {
		
		//getter only
		private var _url:String;
		private var _duration:Number = 0;
		private var _time:Number = 0;
		private var _bytesLoaded:int = 0;
		private var _bytesTotal:int = 0;
		private var _downPct:Number = 0;
		private var _playPct:Number = 0;
		private var _status:String;
		
		//getter and setter
		private var _volume:Number;
		
		//private
		private var sound:Sound = new Sound();
		private var soundChannel:SoundChannel = new SoundChannel();
		private var soundPosition:int = 0;
		
		private var progressIntervalId:uint;
		
		public static const ID3:String                   = "id3";
		public static const PLAY_START:String            = "playStart";
		public static const PLAY_PAUSE:String            = "playPause";
		public static const PLAY_STOP:String             = "playStop";
		public static const PLAY_COMPLETE:String         = "playComplete";
		public static const PLAY_STREAM_NOT_FOUND:String = "playStreamNotFound";
		public static const SEEK_NOTIFY:String           = "seekNotify";
		public static const BUFFER_FULL:String           = "bufferFull";
		public static const BUFFER_EMPTY:String          = "bufferEmpty";
		
		public static const PROGRESS:String              = "progress";
		public static const STATUS:String                = "status";
		
		function SoundPlayer() {
		}
		
		//getter
		public function get url():String {
            return sound.url;
        }
		
		public function get duration():Number {
            return _duration;
        }
		
		public function get time():Number {
            return _time;
        }
		public function get bytesLoaded():Number {
            return _bytesLoaded;
        }
		
		public function get bytesTotal():Number {
            return _bytesTotal;
        }
		public function get downPct():Number {
            return _downPct;
        }
		public function get playPct():Number {
            return _playPct;
        }
		public function get status():String {
            return _status;
        }
		
		
		//getter and setter
		public function get volume():Number{
			return _volume;
		}
		
		public function set volume(num:Number):void{
			_volume = volume;
			soundChannel.soundTransform.volume = num;
		}
		
		private function soundStatusHandler(e:Event):void {
			switch (e.type) {
				case Event.SOUND_COMPLETE:
					setStatus(SoundPlayer.PLAY_COMPLETE);
					break;
				case Event.ID3:
					trace("file = " + url + ", metadata: songName=" + sound.id3.songName  + " artist=" + sound.id3.artist );
					dispatchEvent(new Event(SoundPlayer.ID3));
					break;
				case IOErrorEvent.IO_ERROR:
					setStatus(SoundPlayer.PLAY_STREAM_NOT_FOUND);
					break;
            }
        }
		
		private function setStatus(str:String):void {
            _status = str;
			switch(_status) {
				case SoundPlayer.PLAY_START:
					startProgressInterval();
					break;
				case SoundPlayer.PLAY_STOP:
					stopProgressInterval();
					break;
			}
			dispatchEvent(new Event(SoundPlayer.STATUS))
        }
		
		public function play(str:String):void{
			setStatus(SoundPlayer.PLAY_START);
			soundChannel.stop();
			sound = new Sound(new URLRequest(str));
			sound.addEventListener(Event.ID3, soundStatusHandler);
			sound.addEventListener(IOErrorEvent.IO_ERROR, soundStatusHandler);
			soundChannel = sound.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, soundStatusHandler);
		}
		
		public function pause():void{
			setStatus(SoundPlayer.PLAY_PAUSE);
			soundPosition = soundChannel.position;
			soundChannel.stop();
		}
		
		public function resume():void {
			if (status == SoundPlayer.PLAY_PAUSE) {
				setStatus(SoundPlayer.PLAY_START);
				soundChannel = sound.play(soundPosition);
				soundChannel.addEventListener(Event.SOUND_COMPLETE, soundStatusHandler);
			}
		}
		
		public function togglePause():void{
			
		}
		public function stop():void {
			if(sound.bytesLoaded != sound.bytesTotal){
				sound.close();
			}
			soundChannel.stop();
			soundChannel = new SoundChannel();
			soundPosition = 0;
			setStatus(SoundPlayer.PLAY_STOP);
		}
		
		public function seek(num:Number):void{
			soundChannel = sound.play(num*1000);
		}
		
		private function startProgressInterval():void {
			clearInterval(progressIntervalId);
			progressIntervalId = setInterval(progressInterval, 100);
		}
		
		private function stopProgressInterval():void {
			clearInterval(progressIntervalId);
			progressInterval();
		}
		
		private function progressInterval():void {
			_bytesLoaded = sound.bytesLoaded;
			_bytesTotal = sound.bytesTotal;
			_time = soundChannel.position/1000;
			_downPct = sound.bytesTotal == 0 ? 0 : sound.bytesLoaded / sound.bytesTotal;
			_duration = (sound.length / _downPct)/1000;
			_playPct = _duration == 0 ? 0 : _time / _duration;
			
			dispatchEvent(new Event(SoundPlayer.PROGRESS));
		}
	}
}