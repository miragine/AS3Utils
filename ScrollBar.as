//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 2.0
// Wed Apr 22 17:06:52 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {

	import flash.display.*;
	import flash.text.TextField;
	import flash.geom.Rectangle;
	import flash.events.*;
	import flash.utils.*;

	public class ScrollBar extends Sprite {

		private var startScope:Number;
		private var endScope:Number;
	 	private var delta:Number;
		private var putTime:Number;
		private var prop:String;
		private var axis:String;
		private var scale:String;
		private var dragRect:Rectangle;
		private var direction:String;
		private var useSkinLayout:Boolean = false;
		
		public var upBtn:Sprite;
		public var bg:Sprite;
		public var downBtn:Sprite;
		public var slider:Sprite;
		
		//get
		private var _value:Number;
		
		//set & get
		private var _showArray:Boolean = true;
		private var _scrollTarget:*;
		private var _sliderResizeEnabled:Boolean = true;
		
		//const
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		public static const MAPPING:String = "mapping";
		
		public function ScrollBar(dir:String = ScrollBar.VERTICAL) {
			direction = dir;
			
			bg      = addChild(new Sprite()) as Sprite;
			slider  = addChild(new Sprite()) as Sprite;
			upBtn   = addChild(new Sprite()) as Sprite;
			downBtn = addChild(new Sprite()) as Sprite;
			
			prop    = (direction == ScrollBar.VERTICAL) ? "height" : "width";
			axis    = (direction == ScrollBar.VERTICAL) ? "y"      : "x";
			scale   = (direction == ScrollBar.VERTICAL) ? "scaleY" : "scaleX";
			
			setSkin(new DefaultSkin(dir))
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage)
		}
		
		private function addedToStage(event:Event):void{
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
		}
		
		//get
		public function get value():Number {
			return _value;
		}
		
		//set & get method
		public override function set width(num:Number):void{
			if (!useSkinLayout) {
				if(direction == ScrollBar.VERTICAL){
					upBtn.width = num;
					bg.width = num;
					downBtn.width = num;
					slider.width = num;
				}else{
					bg.width = num;
					buildParts();
					update();
				}
			}
		}
		
		public override function set height(num:Number):void{
			if (!useSkinLayout) {
				if(direction == ScrollBar.VERTICAL){
					bg.height = num;
					buildParts();
					update();
				}else{
					upBtn.height = num;
					bg.height = num;
					downBtn.height = num;
					slider.height = num;
				}
			}
		}
		
		public function set showArray(bool:Boolean):void{
			_showArray = bool;
			
			if(showArray){
				upBtn.visible = true;
				downBtn.visible = true;
			}else{
				upBtn.visible = false;
				downBtn.visible = false;
			}
		}
		public function get showArray():Boolean{
			return _showArray;
		}
		
		public function set scrollTarget(target:*):void{
			_scrollTarget = target;
			update();
			
			slider[axis] = bg[axis];
			mapping(slider[axis]);
		}
		public function get scrollTarget():*{
			return _scrollTarget;
		}
		
		public function set sliderResizeEnabled(bool:Boolean):void{
			_sliderResizeEnabled = bool;
			update();
		}
		public function get sliderResizeEnabled():Boolean{
			return _sliderResizeEnabled;
		}
		
		//public method
		public function setSkin(skin:DisplayObjectContainer, _useSkinLayout:Boolean = false):void {
			useSkinLayout = _useSkinLayout
			
			if (skin.getChildByName("bg") != null) {
				removeChild(bg);
				bg = addChild(skin.getChildByName("bg")) as Sprite;
			}
			if (skin.getChildByName("slider") != null) {
				removeChild(slider);
				slider = addChild(skin.getChildByName("slider")) as Sprite;
			}
			if (skin.getChildByName("upBtn") != null) {
				removeChild(upBtn);
				upBtn = addChild(skin.getChildByName("upBtn")) as Sprite;
			}
			if (skin.getChildByName("downBtn") != null) {
				removeChild(downBtn);
				downBtn = addChild(skin.getChildByName("downBtn")) as Sprite;
			}
			
			if (!useSkinLayout) {
				buildParts();
			}
			
			update();
			initEventListener();
		}
		
		public function setScope(form:Number, to:Number):void{
			startScope = form;
			endScope = to;
			slider.visible = true;
			
			update();
		}
		
		//private method
		private function buildParts():void {
			upBtn.x    = 0;
			upBtn.y    = 0;
			bg.x       = 0;
			bg.y       = 0;
			slider.x   = 0;
			slider.y   = 0;
			downBtn.x  = 0;
			downBtn.y  = 0;
			
			bg[axis]      = upBtn[prop];
			slider[axis]  = upBtn[prop];
			downBtn[axis] = upBtn[prop] + bg[prop]
		}
		
		public function update():void{
			var pct:Number
			
			if(scrollTarget is TextField){
				scrollTarget.mouseWheelEnabled = false;
				pct = (scrollTarget.bottomScrollV - scrollTarget.scrollV + 1) / (scrollTarget.maxScrollV + scrollTarget.bottomScrollV - scrollTarget.scrollV);
				pct = (pct > 1) ? 1 : pct;
					
				//slider[axis] = bg[axis];
				if(sliderResizeEnabled){
					slider[prop] = int(bg[prop] * pct);
				}else{
					slider[scale] = 1;
				}
				slider.visible = (pct == 1) ? false : true;
				
				startScope = 1;
				endScope = scrollTarget.maxScrollV;
			}else if(scrollTarget is DisplayObject){
				var rect = (scrollTarget.scrollRect == null) ? new Rectangle() : scrollTarget.scrollRect;
				scrollTarget.scrollRect = null;
					
				//强制更新scrollRect
				var bmpData:BitmapData = new BitmapData(1, 1);
				bmpData.draw(scrollTarget);
				bmpData.dispose();
					
				pct = rect[prop] / scrollTarget[prop];
				pct = (pct > 1) ? 1 : pct;
					
				//slider[axis] = bg[axis];
				if(sliderResizeEnabled){
					slider[prop] = int(bg[prop] * pct);
				}else{
					slider[scale] = 1;
				}
				slider.visible = (pct == 1 || pct == 0) ? false : true;
					
				startScope = 0;
				trace(startScope)
				endScope = rect[prop] - scrollTarget[prop];
				scrollTarget.scrollRect = rect;
			}
			var rect_x:Number      = (direction == ScrollBar.VERTICAL) ? bg.x                      : bg.x;
			var rect_y:Number      = (direction == ScrollBar.VERTICAL) ? bg.y                      : bg.y;
			var rect_width:Number  = (direction == ScrollBar.VERTICAL) ? 0                         : bg.width - slider.width;
			var rect_height:Number = (direction == ScrollBar.VERTICAL) ? bg.height - slider.height : 0;
			
			rect_x = int(rect_x);
			rect_y = int(rect_y);
			rect_width = int(rect_width);
			rect_height = int(rect_height);
			
			dragRect = new Rectangle(rect_x, rect_y, rect_width, rect_height);
			delta = dragRect[prop] / 20;
			//mapping(slider[axis]);
		}
		
		private function initEventListener():void{
			bg.addEventListener(MouseEvent.MOUSE_DOWN, onBgDown);
			slider.addEventListener(MouseEvent.MOUSE_DOWN, onSliderDown);
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onUpBtnDown);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onDownBtnDown);
			
			upBtn.buttonMode = true;
			downBtn.buttonMode = true
		}
		
		//**
		//* 鼠标滚轮事件
		//**
		private function mouseWheel(event : MouseEvent) : void {
			var dir:int;
			var position:Number;
			
			if(scrollTarget is DisplayObject){
				if(scrollTarget.hitTestPoint(event.stageX,event.stageY)){
					dir = (event.delta >0) ? -1 : 1;
					position = slider[axis] + dir * delta;
					mapping(position)
				}
			}else{
				if(this.hitTestPoint(event.stageX,event.stageY) && !isNaN(startScope) && !isNaN(endScope)){
					dir = (event.delta >0) ? -1 : 1;
					position = slider[axis] + dir * delta;
					mapping(position)
				}
			}
		}
		
		//**
		//* 上滚动按钮
		//**
		private function onUpBtnDown(event : MouseEvent) : void {
			var position = slider[axis] - delta
			mapping(position)
			
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, upBtnDowning);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUpBtnUp);
		}

		private function upBtnDowning(event : Event) : void {
			if(getTimer() - putTime > 500) {
				var position = slider[axis] - delta
				mapping(position)
			}
		}

		private function onUpBtnUp(event : MouseEvent) : void {
			this.removeEventListener(Event.ENTER_FRAME, upBtnDowning);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUpBtnUp);
		}
		
		//**
		//* 下滚动按钮
		//**
		private function onDownBtnDown(event : MouseEvent) : void {
			var position = slider[axis] + delta
			mapping(position)
			
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, downBtnDowning);	
			stage.addEventListener(MouseEvent.MOUSE_UP, onDownBtnUp);
		}

		private function downBtnDowning(event : Event) : void {
			if(getTimer() - putTime > 500) {
				var position = slider[axis] + delta
				mapping(position)
			}
		}	

		private function onDownBtnUp(event : MouseEvent) : void {
			this.removeEventListener(Event.ENTER_FRAME, downBtnDowning);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDownBtnUp);
		}
		
		//**
		//* 滑块滚动
		//**
		private function onSliderDown(event : MouseEvent) : void {
			//限定拖动范围
			slider.startDrag(false, dragRect);
			
			this.addEventListener(Event.ENTER_FRAME, sliderDowning);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSliderUp);
		}

		private function sliderDowning(event : Event) : void {
			//在滚动过程中及时获得滑块所处位置
			mapping(slider[axis])
		}
		
		private function onSliderUp(event : MouseEvent) : void {
			slider.stopDrag();
			
			this.removeEventListener(Event.ENTER_FRAME, sliderDowning);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSliderUp);
		}
		
		//**
		//* 滑块背景点击
		//**
		private function onBgDown(event : MouseEvent) : void {
			var position = (direction == ScrollBar.VERTICAL) ? this.mouseY : this.mouseX;
			mapping(position)
		}
		
		//**
		//* mapping
		//**
		private function mapping(position:Number):void{
			
			position = Math.min(position , dragRect[axis] + dragRect[prop]);
			position = Math.max(position , dragRect[axis]);
			
			slider[axis] = position;
			
			var pct:Number = (position - dragRect[axis]) / dragRect[prop]
			pct = isNaN(pct) ? 0 : pct;
			var newPosition:Number = pct * (endScope - startScope) + startScope;
			
			if(scrollTarget is TextField){
				scrollTarget.scrollV = int(newPosition);
			}else if(scrollTarget is DisplayObject){
				var rect = scrollTarget.scrollRect;
				rect[axis] = -newPosition;
				scrollTarget.scrollRect = rect;
			}
			
			_value = newPosition;
			dispatchEvent(new Event(ScrollBar.MAPPING));
		}
		
		public override function toString():String {
			var str:String = "(upBtn=" + (upBtn is MovieClip).toString() + 
							 ", downBtn="+ (downBtn is MovieClip).toString() +
							 ", slider="+ (slider is MovieClip).toString() +
							 ", bg="+ (bg is MovieClip).toString() + ")"
			return str;
		} 
	}
}

import flash.display.Sprite;
class DefaultSkin extends Sprite {

	private var defaultColor:int = 0x666666;
	private var defaultAlpha:Number = 0.5;

	private var upBtnWidth:int = 12;
	private var upBtnHeight:int = 12;
	
	private var bgWidth:int = 12;
	private var bgHeight:int = 200;
	
	private var downBtnWidth:int = 12;
	private var downBtnHeight:int = 12;
	
	private var sliderWidth:int = 12;
	private var sliderHeight:int = 30;
	
	

	public function DefaultSkin(dir:String) {
		if(dir == ScrollBar.VERTICAL){
			addChild(buildBody("upBtn", upBtnWidth, upBtnHeight))
			addChild(buildBody("bg", bgWidth, bgHeight))
			addChild(buildBody("downBtn", downBtnWidth, downBtnHeight))
			addChild(buildBody("slider", sliderWidth, sliderHeight))
		}else{
			addChild(buildBody("upBtn", upBtnHeight, upBtnWidth))
			addChild(buildBody("bg", bgHeight, bgWidth))
			addChild(buildBody("downBtn", downBtnHeight, downBtnWidth))
			addChild(buildBody("slider", sliderHeight, sliderWidth))
		}
		getChildByName("slider").visible = false;
	}
	
	private function buildBody(n:String, w:int, h:int):Sprite{
		var tmp:Sprite = new Sprite();
		tmp.name = n;
		tmp.graphics.lineStyle(0,defaultColor);
		tmp.graphics.beginFill(defaultColor, defaultAlpha);
		tmp.graphics.drawRect(0,0,w,h);
		tmp.graphics.endFill();
		return tmp;
	}
}