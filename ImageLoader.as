//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Fri Feb 02 15:55:15 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;

	public dynamic class ImageLoader extends Loader {

		public var fadeType:String;

		private var initWidth:int;
		private var initHeight:int;
		private var initSmoothing:Boolean;
		private var initNoScale:Boolean;
		private var timer:Timer;
		
		public static const WHITE:String = "white";
		public static const BLACK:String = "black";
		public static const ALPHA:String = "alpha";

		public function ImageLoader(url:String = null, width:Number = 0, height:Number = 0, noScale:Boolean = false, smoothing:Boolean = false) {
			fadeType = ImageLoader.ALPHA;
			
			timer = new Timer(10,51);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			if (url != null) loadImage(url, width, height, noScale, smoothing);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			this.contentLoaderInfo.addEventListener(Event.INIT, initHandler);
		}
		
		public function loadImage(url:String, width:Number = 0, height:Number = 0, noScale:Boolean = false, smoothing:Boolean = false):void{
			initWidth = width;
			initHeight = height;
			initSmoothing = smoothing;
			initNoScale = noScale;
			timer.reset();
			load(new URLRequest(url));
		}
		
		private function initHandler(e:Event):void {
			e.target.content.smoothing = initSmoothing;
			
			if (initNoScale) {
				var dwh = contentLoaderInfo.width/contentLoaderInfo.height;
				var rwh = initWidth / initHeight;
				
				if(dwh > rwh){
					e.target.content.width = initWidth;
					e.target.content.height = initWidth / dwh;
				}else{
					e.target.content.height = initHeight;
					e.target.content.width = initHeight * dwh;
				}
				e.target.content.x = (initWidth - e.target.content.width)/2;
				e.target.content.y = (initHeight - e.target.content.height)/2;
			}else {
				e.target.content.width = initWidth == 0 ? contentLoaderInfo.width : initWidth;
				e.target.content.height = initHeight == 0 ? contentLoaderInfo.height : initHeight;
			}
			
			alpha = 0;
			
			timer.start();
		}
		
		private function timerHandler(e:TimerEvent):void {
			var ct:ColorTransform = new ColorTransform();
			var pct:Number = timer.currentCount / timer.repeatCount;
			
			switch(fadeType){
				case ImageLoader.WHITE:
					ct.redOffset   = 255 - 255 * pct;
					ct.greenOffset = 255 - 255 * pct;
					ct.blueOffset  = 255 - 255 * pct;
					transform.colorTransform = ct;
					break;
				case ImageLoader.BLACK:
					ct.redOffset   = 255 * pct - 255;
					ct.greenOffset = 255 * pct - 255;
					ct.blueOffset  = 255 * pct - 255;
					transform.colorTransform = ct;
					break;
				case ImageLoader.ALPHA:
					ct.alphaMultiplier = pct;
					transform.colorTransform = ct;
					break;
				default:
					transform.colorTransform = ct;
			}	
		}
		
		private function removedFromStageHandler(e:Event):void {
			this.unloadAndStop();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

	}
}