//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Thu Apr 9 13:13:18 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {

	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.utils.*;
	import flash.events.*;

	public class VideoPlayer extends Video {
		
		//getter only
		private var _url:String;
		private var _duration:Number = 0;
		private var _time:Number = 0;
		private var _bytesLoaded:int = 0;
		private var _bytesTotal:int = 0;
		private var _downPct:Number = 0;
		private var _playPct:Number = 0;
		private var _status:String = VideoPlayer.PLAY_STOP;
		
		private var _videoWidth:int = 0;
		private var _videoHeight:int = 0;
		
		//getter and setter
		private var _bufferTime:Number;
		private var _volume:Number;
		

		//private
		private var netConnection:NetConnection;
		private var netStream:NetStream;
		
		private var progressIntervalId:uint;
		
		public static const METADATA:String              = "metadata";
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
		
		function VideoPlayer(width:int=320, height:int=240) {
			super(width, height);
			
			
			netConnection = new NetConnection();
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            netConnection.connect(null);

			netStream = new NetStream(netConnection);
            netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			netStream.client = {"onMetaData":onMetaData, "onCuePoint":onCuePoint};
			
			bufferTime = 5;
			
            this.attachNetStream(netStream); 
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		//getter
		public function get url():String {
            return _url;
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
		
		public override function get videoWidth():int {
			return _videoWidth;
		}
		public override function get videoHeight():int {
			return _videoHeight;
		}
		
		
		//getter and setter
		public function get bufferTime():Number {
            return _bufferTime;
        }
		
		public function set bufferTime(num:Number):void {
            _bufferTime = num;
			netStream.bufferTime = _bufferTime;
        }

		public function get volume():Number{
			return _volume;
		}
		
		public function set volume(num:Number):void{
			_volume = volume;
			netStream.soundTransform.volume = num;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
                case "NetStream.Play.Start":
					setStatus(VideoPlayer.PLAY_START);
                    break;
				case "NetStream.Play.Stop":
					setStatus(VideoPlayer.PLAY_COMPLETE);
                    break;
                case "NetStream.Play.StreamNotFound":
					setStatus(VideoPlayer.PLAY_STREAM_NOT_FOUND);
                    break;
				case "NetStream.Seek.Notify":
					setStatus(VideoPlayer.SEEK_NOTIFY);
                    break;
				case "NetStream.Buffer.Full":
					setStatus(VideoPlayer.BUFFER_FULL);
                    break;
				case "NetStream.Buffer.Empty":
					setStatus(VideoPlayer.BUFFER_EMPTY);
                    break;
            }
        }
		
		private function onMetaData(info:Object):void {
			_duration = info.duration;
			_videoWidth = info.width;
			_videoHeight = info.height;
			dispatchEvent(new Event(VideoPlayer.METADATA));
			trace("file = " + url + ", metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    	}
		
    	private function onCuePoint(info:Object):void {
        	trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    	}
		
		private function setStatus(str:String):void {
            _status = str;
			switch(_status) {
				case VideoPlayer.PLAY_START:
					startProgressInterval();
					break;
				case VideoPlayer.PLAY_STOP:
					stopProgressInterval();
					break;
				
			}
			dispatchEvent(new Event(VideoPlayer.STATUS))
        }
		
		public function play(str:String):void {
			this.visible = true;
			_url = str;
			netStream.play(str);
		}
		
		public function pause():void{
			setStatus(VideoPlayer.PLAY_PAUSE);
			netStream.pause();
		}
		
		public function resume():void{
			netStream.resume();
		}
		
		public function togglePause():void{
			netStream.togglePause();
		}
		public function stop():void {
			netStream.close();
			this.clear();
			this.visible = false;
			setStatus(VideoPlayer.PLAY_STOP);
		}
		
		public function seek(num:Number):void{
			netStream.seek(num);
		}

		private function removedFromStageHandler(event:Event):void{
			netStream.close();
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
			_bytesLoaded = netStream.bytesLoaded;
			_bytesTotal = netStream.bytesTotal;
			_time = netStream.time;
			_downPct = netStream.bytesTotal == 0 ? 0 : netStream.bytesLoaded / netStream.bytesTotal;
			_playPct = duration == 0 ? 0 : netStream.time / duration;
			
			dispatchEvent(new Event(VideoPlayer.PROGRESS));
		}
	}
}