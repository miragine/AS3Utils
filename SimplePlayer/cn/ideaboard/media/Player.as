package cn.ideaboard.media{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.neave.light.*;
	
	public class Player extends Sprite{
		
		public var _playerWidth:Number = 360;
		public var _playerHeight:Number = 240;
		public var index:int = 0;
		public var list:Array = [];
		public var autoPlay:Boolean = true;
		public var scaleMode:String = Player.MAINTAIN_ASPECT_RATIO;
		
		public var url:String = "";
		public var duration:Number = 0;
		public var time:Number = 0;
		public var bytesLoaded:int = 0;
		public var bytesTotal:int = 0;
		public var downPct:Number = 0;
		public var playPct:Number = 0;
		public var status:String= Player.PLAY_STOP;
		
		private var nLight:NeaveLight;
		private var ui:Interface;
		private var pl:PlayList;
		private var playback:*;
		private var videoPlayer:VideoPlayer;
		private var soundPlayer:SoundPlayer;
		
		private static const MP3:String = "mp3";
		private static const FLV:String = "flv";
		private static const MOV:String = "mov";
		
		public static const EXACT_FIT:String = "exactFit";
		public static const MAINTAIN_ASPECT_RATIO:String = "maintainAspectRatio";
		public static const NO_SCALE:String = "noScale";
		
		public static const METADATA:String              = "metadata";
		public static const PLAY_START:String            = "playStart";
		public static const PLAY_PAUSE:String            = "playPause";
		public static const PLAY_STOP:String             = "playStop";
		public static const PLAY_COMPLETE:String         = "playComplete";
		public static const PLAY_STREAM_NOT_FOUND:String = "playStreamNotFound";
		public static const SEEK_NOTIFY:String           = "seekNotify";
		public static const BUFFER_FULL:String           = "bufferFull";
		public static const BUFFER_EMPTY:String          = "bufferEmpty";
		
		function Player(w:Number = 480, h:Number = 272) {
			videoPlayer = new VideoPlayer();
			videoPlayer.addEventListener(VideoPlayer.PROGRESS, progressHandle);
			videoPlayer.addEventListener(VideoPlayer.STATUS, statusHandle);
			videoPlayer.addEventListener(VideoPlayer.METADATA, metadataHandle);
			
			soundPlayer = new SoundPlayer();
			soundPlayer.addEventListener(SoundPlayer.PROGRESS, progressHandle);
			soundPlayer.addEventListener(SoundPlayer.STATUS, statusHandle);
			
			playerWidth = w;
			playerHeight = h;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
		}
		
		private function addedToStageHandle(e:Event):void{
			init();
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
		}
		
		private function progressHandle(e:Event):void {
			url         = playback.url;
			duration    = playback.duration;
			time        = playback.time;
			bytesLoaded = playback.bytesLoaded;
			bytesTotal  = playback.bytesTotal;
			downPct     = playback.downPct;
			playPct     = playback.playPct;
			status      = playback.status;
		}
		private function statusHandle(e:Event):void {
			switch(e.currentTarget.status){
				case Player.PLAY_COMPLETE:
					playNext();
					break;
				case Player.PLAY_STREAM_NOT_FOUND:
					playNext();
					break;
			}
		}
		
		private function metadataHandle(e:Event):void {
			setScreen();
		}
		
		private function init():void{
			buildLoaderInfo();
			
			nLight = addChild(new NeaveLight(playerWidth, playerHeight));
			addChild(videoPlayer);
			pl = addChild(new PlayList());
			ui = addChild(new Interface());
			
			if(autoPlay && list.length > 0) play();
		}
		
		
		private function buildLoaderInfo():void{
			var pathArr:Array = [];
			var titleArr:Array = [];
			if (stage.loaderInfo.parameters.scaleMode) {
				var sm:String = stage.loaderInfo.parameters.scaleMode;
				if (sm == Player.EXACT_FIT || sm == Player.MAINTAIN_ASPECT_RATIO || sm == Player.NO_SCALE) {
					scaleMode = sm;
				}
			}
			if(stage.loaderInfo.parameters.path){
				pathArr = stage.loaderInfo.parameters.path.split("|");
			}
			if(stage.loaderInfo.parameters.title){
				titleArr = stage.loaderInfo.parameters.title.split("|");
			}
			
			if(pathArr.length > 0){
				for(var i:int = 0; i < pathArr.length; i++){
					var listObj:Object = {};
					listObj.path = pathArr[i];
					listObj.title = (titleArr[i] == undefined) ? pathArr[i] : titleArr[i];
					list.push(listObj);
				}
			}
		}
		
		public function set playerWidth(num:Number):void{
			_playerWidth = num;
			setScreen();
		}
		public function get playerWidth():Number{
			return _playerWidth;
		}
		
		public function set playerHeight(num:Number):void{
			_playerHeight = num;
			setScreen();
		}
		public function get playerHeight():Number{
			return _playerHeight;
		}
		
		private function setScreen():void{
			switch(scaleMode){
				case Player.EXACT_FIT:
					screenSize(playerWidth, playerHeight);
					break;
				case Player.MAINTAIN_ASPECT_RATIO:
					var dwh:Number = videoPlayer.videoWidth/videoPlayer.videoHeight;
					var rwh:Number = playerWidth/playerHeight;
					var w:Number = (dwh > rwh) ? playerWidth : playerHeight * dwh;
					var h:Number = (dwh > rwh) ? playerWidth / dwh : playerHeight;
					screenSize(w,h);
					break;
				case Player.NO_SCALE:
					screenSize(videoPlayer.videoWidth, videoPlayer.videoHeight);
					break;
			}
		}
		  
		private function screenSize(w:Number, h:Number):void{
			videoPlayer.width = w;
			videoPlayer.height = h;
			videoPlayer.x = playerWidth/2 - videoPlayer.width/2;
			videoPlayer.y = playerHeight / 2 - videoPlayer.height / 2;
		}
		
		public function play():void {
			if(status == Player.PLAY_STOP){
				playItem(index);
			}else{
				resume();
			}
		}
		public function pause():void{
			playback.pause()
		}
		public function resume():void{
			playback.resume()
		}
		public function stop():void{
			playback.stop()
		}
		public function playItem(i:int):void {
			if (playback != undefined) stop();
			index = i;
			var extension:String = list[index].path.split(".").reverse()[0].toLowerCase();
			switch(extension) {
				case Player.MP3:
					playback = soundPlayer;
					break;
				case Player.FLV:
					playback = videoPlayer;
					break;
				case Player.MOV:
					playback = videoPlayer;
					break;
				default:
					return;
			}
			
			playback.play(list[index].path);
			if (pl) pl.itemMoveTo(index);
			if (playback == soundPlayer) {
				nLight.start();
			}else {
				nLight.stop();
			}
		}
		
		public function playNext():void{
			index ++
			if(index > list.length -1) index = 0;
			playItem(index);
		}
		public function playPrev():void{
			index --
			if(index < 0) index = list.length -1;
			playItem(index);
		}
		
		public function displayState():void{
			switch(stage.displayState) {
                case "normal":
                    stage.displayState = "fullScreen";    
                    break;
                case "fullScreen":
                default:
                    stage.displayState = "normal";    
                    break;
            }

		}
		
		public function switchList():void{
			if(pl) pl.switchList();
		}
		
		public function closeList():void{
			if(pl) pl.closeList();
		}
		
		
	}
}