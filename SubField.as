//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Thu May 21 11:34:18 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package{
	
	import flash.system.System;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class SubField extends Sprite{
		
		private var textField:TextField;
		private var loader:URLLoader;
		
		private var regExp:RegExp = /\d{1,5}\n(\d{2}:\d{2}:\d{2}),(\d{3}) --> (\d{2}:\d{2}:\d{2}),(\d{3})\n((.+\n)*)/g;
		private var timer:Timer;
		private var index:int = 0;
		
		private var subArray:Array = [];
		private var subLength:int;
		private var subWidth:Number;
		private var subHeight:Number;
		private var subBackground:Sprite;
		private var subBackgroundAlpha:Number;
		
		public var getPosition:Function;
		public var align:String = SubField.BOTTOM;
		
		public static var TOP:String = "top";
		public static var CENTER:String = "center";
		public static var BOTTOM:String = "bottom";
		
		
		public function SubField(w:Number = 320, h:Number = 100, a:Number = 0){
			
			subWidth = w;
			subHeight = h;
			subBackgroundAlpha = a;
			
			createBackground();
			createText();
			
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, render);
		}
		

		public override function set width(num:Number):void{
			subWidth = num;
			subBackground.width = subWidth;
		}
		public override function set height(num:Number):void{
			subHeight = num;
			subBackground.height = subHeight;
		}
		
		public override function set alpha(num:Number):void{
			subBackgroundAlpha = num;
			subBackground.alpha = subBackgroundAlpha;
		}
		
		private function createBackground():void{
			subBackground = new Sprite();
			subBackground.graphics.beginFill(0x000000);
			subBackground.graphics.drawRect(0,0,subWidth,subHeight);
			subBackground.graphics.endFill();
			subBackground.alpha = 0;
			addChild(subBackground);
		}
		
		private function createText():void{
			textField = new TextField();
			textField.filters = [new DropShadowFilter(0,0,0,0.9,2,2,2),new DropShadowFilter(0,0,0,0.8)]
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.selectable = false;

			var tf:TextFormat =  textField.defaultTextFormat;
			tf.align = TextFormatAlign.CENTER;
			tf.color = 0xfefefe;
			tf.size = 20;
			tf.leading = 5;
			tf.font = "Arial,SimHei";
			textField.defaultTextFormat = tf;
			addChild(textField)
		}
		
		public function load(str:String):void{
			System.useCodePage = true;
			loader = new URLLoader(new URLRequest(str));
			loader.addEventListener(Event.COMPLETE, completeHandle);
		}
		
		private function completeHandle(event:Event):void{
			parse(event.target.data.replace(/\r\n/g, "\n").replace(/\r/g, "\n"));
			
			if(getPosition != null){
				start();
			}
		}
		
		private function start():void{
			timer.start();
		}
		
		private function stop():void{
			timer.stop();
		}
		
		private function parse(sub:String):void{
			var line:Object = { };
			while(line) {
				line = regExp.exec(sub);
				if(line){
					var subObject:Object = {};
					subObject.startTime = timeCalculate(line[1],line[2]);
					subObject.endTime = timeCalculate(line[3],line[4]);
					subObject.content = line[5];
					subArray.push(subObject);
				}
			}
			
			subLength = subArray.length;
			System.useCodePage = false;
		}
		
		private function render(event:TimerEvent):void{
			var t:int = getPosition();
			
			if(t <subArray[index].startTime){
				seek(t);
			}
			
			if (index < subLength-1) {
				if(t > subArray[index+1].endTime){
					seek(t);
				}else if(t > subArray[index+1].startTime && t < subArray[index+1].endTime){
					index = index + 1;
				}
			}
			
			if (t > subArray[index].startTime && t < subArray[index].endTime) {
				setText(subArray[index].content);
			}else{
				setText("");
			}
			
		}
		
		private function setText(str:String):void{
			textField.htmlText = str;
			
			var amendment:Number
			switch(align){
				case SubField.TOP:
					amendment = textField.textHeight;
					break;
				case SubField.CENTER:
					amendment = textField.textHeight / 2;
					break;
				case SubField.BOTTOM:
					amendment = 0;
					break;
			}
			
			textField.x = (subWidth - textField.textWidth)/2;
			textField.y = amendment - textField.textHeight;
			
			subBackground.y = textField.y - 10;
			subBackground.height = textField.textHeight + 20;
			subBackground.alpha = (str == "") ? 0 : subBackgroundAlpha;
		}
		
		private function seek(t:int):void{
			for(var i:int = 0; i < subLength-1; i++){
				if(t > subArray[i].startTime && t < subArray[i+1].startTime){
					index = i;
					return;
				}
			}
		}
		
		private function timeCalculate(time1:String,time2:String):int{
			var tmp:Array = time1.split(":");
			return int(tmp[0])*3600000 + int(tmp[1])*60000 + int(tmp[2]) *1000 + int(time2);
		}
	}
}