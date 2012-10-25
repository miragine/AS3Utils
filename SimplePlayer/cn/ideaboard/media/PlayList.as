package cn.ideaboard.media{
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PlayList extends Sprite{
		
		private var player:Player;
		private var itemList:Array = [];
		private var itemHeight:int = 28;
		private var index:int = 0;
		private var special:int = 40;
		private var isShow:Boolean = false;
		
		public var listBg:Sprite;
		public var msk:Sprite;
		public var space:Sprite;
		public var invert:Sprite;
		
		function PlayList(){
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
		}
		
		private function addedToStageHandle(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandle);
			init();
		}
		
		private function init():void {
			player = parent;
			invert.mouseEnabled = false;
			this.x = player.playerWidth + 5;
			buildList(player.list);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandle);
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandle);
		}
		
		private function buildList(list:Array):void {
			for (var i = 0; i<list.length; i++) {
				var tmp:MC_ListItem = space.addChild(new MC_ListItem());
				tmp.id = i;
				tmp.num.text = getNum(i);
				tmp.title.text = list[i].title;
				tmp.x = 0;
				tmp.y = itemHeight * i;
				tmp.addEventListener(MouseEvent.CLICK, itemClick)
				tmp.buttonMode = true;
				itemList.push(tmp);
			}
		}
		
		private function getNum(id:int):String{
			var num:int = id+1;
			if (num<10) {
				return "00" + num.toString();
			} else if (num<100) {
				return num = "0" + num.toString();
			} else {
				return num.toString();
			}
		}
		
		private function itemClick(e:Event):void {
			player.playItem(e.currentTarget.id);
		}
		
		public function itemMoveTo(num:int):void {
			index = num;
			for (var i:int = 0; i<itemList.length; i++) {
				itemList[i].target = -(index-i)*itemHeight-30;
				if (i>index) {
					itemList[i].target += special;
				}
				itemList[i].addEventListener(Event.ENTER_FRAME, listEnterFrameHandle)
			}
		}
		
		public function switchList():void{
			if(isShow){
				isShow = false;
			}else{
				isShow = true;
			}
		}
		public function closeList():void{
			isShow = false;
		}
		
		private function listEnterFrameHandle(e:Event):void {
			e.currentTarget.y += (e.currentTarget.target-e.currentTarget.y)*0.3;
			if (e.currentTarget.y == e.currentTarget.target) {
				e.currentTarget.y = e.currentTarget.target;
				e.currentTarget.removeEventListener(Event.ENTER_FRAME, enterFrameHandle)
			}
		}
		
		private function mouseWheelHandle(e:MouseEvent):void {
			var increment:int = e.delta/-3;
			var num:int = index + increment;
			if (num<0) {
				num = 0;
			}
			if (num>player.list.length-1) {
				num = player.list.length-1;
			}
			itemMoveTo(num);
		}
		
		private function enterFrameHandle(e:Event):void {
			if(isShow){
				this.x += (player.playerWidth - 240 -this.x)*0.3;
			}else{
				this.x += (player.playerWidth + 5 - this.x)*0.3;
			}
			this.y = player.playerHeight / 2;
			listBg.height = player.playerHeight;
			msk.height = player.playerHeight - 80;
		}

	}
}