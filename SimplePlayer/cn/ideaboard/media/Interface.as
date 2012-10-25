package cn.ideaboard.media{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.BlurFilter;
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	
	public class Interface extends Sprite{
		
		public var title:Sprite;
		public var time:Sprite;
		public var line:Sprite;
		public var controller:Sprite;
		public var buttons:Array;
		
		private var player:Player;
		private var startMoveTime:int;
		private var isShow:Boolean;
		private var blurNum:Number;
		
		function Interface(){
			buttons = [controller.icon_play,
					   controller.icon_pause,
					   controller.icon_stop,
					   controller.icon_prev,
					   controller.icon_next,
					   controller.icon_displayState,
					   controller.icon_list]
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
		}
		
		private function addedToStageHandle(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
			init();
		}
		
		private function init():void {
			this.filters = [new DropShadowFilter(3,45,0,0.6,5,5)]
			title.label.autoSize = "left";
			isShow = true;
			blurNum = 0;
			player = parent;
			buildButtons();
			this.addEventListener(Event.ENTER_FRAME, renderEngine);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandle);
		}
		
		private function renderEngine(e:Event):void{
			if(player.list.length > 0) title.label.text = player.list[player.index].title
			title.label.x = player.playerWidth/2 - title.label.textWidth/2
			title.bg.width = player.playerWidth
			
			line.y = player.playerHeight - 14;
			line.width = player.playerWidth - 40;
			line.downPct.scaleX = player.downPct;
			line.playPct.scaleX = player.playPct;
			
			time.x = player.playerWidth - 105;
			time.y = player.playerHeight - 36;
			time.elapsed.text = secondToTime(player.time);
			time.total.text = secondToTime(player.duration);
			
			controller.x = player.playerWidth/14;
			controller.y = player.playerHeight/7;
			
			if(getTimer() - startMoveTime > 5000 && isShow){
				isShow = false;
				this.visible = false;
				Mouse.hide();
				player.closeList();
			}
			if(getTimer() - startMoveTime < 5000 && !isShow){
				isShow = true;
				this.visible = true;
				Mouse.show();
			}
		}
		
		private function mouseMoveHandle(e:MouseEvent):void{
			startMoveTime = getTimer();
		}
		
		private function secondToTime(s:Number):String{
			s = Math.round(s);
			var theSec = s%60;
			var theMin = (s - theSec)/60;
			if (theSec<10) {
				theSec = "0" + theSec;
			}
			if (theMin<10) {
				theMin = "0" + theMin;
			}
			var theTime = theMin + ":" + theSec;
			return theTime;
		}
		
		private function buildButtons():void{
			for(var i:int = 0; i < buttons.length; i++){
				buttons[i].addEventListener(MouseEvent.ROLL_OVER, bnRollOver);
				buttons[i].addEventListener(MouseEvent.ROLL_OUT, bnRollOut);
				buttons[i].addEventListener(MouseEvent.CLICK, bnClick);
				buttons[i].buttonMode = true;
				buttons[i].rad = 0;
			}
		}
		
		private function bnRollOver(e:Event):void{
			e.currentTarget.addEventListener(Event.ENTER_FRAME, bnRender);
		}
		private function bnRollOut(e:Event):void{
			e.currentTarget.rad = 0;
			e.currentTarget.filters = [];
			e.currentTarget.removeEventListener(Event.ENTER_FRAME, bnRender);
		}
		private function bnRender(e:Event):void{
			e.currentTarget.rad += 0.165;
			var glownum = Math.sin(e.currentTarget.rad)*5+5;
			var strength = glownum/5;
			e.currentTarget.filters = [new GlowFilter(0xffffff, 1, glownum, glownum, strength, 3)]
		}
		private function bnClick(e:Event):void {
			startMoveTime = getTimer();
			switch(e.currentTarget){
				case controller.icon_play:
					player.play();
					break;
				case controller.icon_pause:
					player.pause();
					break;
				case controller.icon_stop:
					player.stop();
					break;
				case controller.icon_prev:
					player.playPrev();
					break;
				case controller.icon_next:
					player.playNext();
					break;
				case controller.icon_displayState:
					player.displayState();
					break;
				case controller.icon_list:
					player.switchList();
					break;
			}
		}
	}
	
}