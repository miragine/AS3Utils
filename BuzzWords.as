//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

	public class BuzzWords {
		private static const cMin:int = 0x21;
		private static const cMax:int = 0x7e;

		private var txt:TextField;

		private var moveFix:int = 7;
		private var moveRange:int = 10;
		private var moveTrigger:int = 12;
		private var charSpeed:int = 2;
		private var waitChar:String = "_";

		private var description:String;
		private var randomList:Array;
		private var textCount:int;
		private var fixLength:int;
		private var fixStr:String;

		private var typoText:String;
		private var end_charMotion:Boolean;
		private var end_textCount:Boolean;

		public function BuzzWords(t:TextField,s:String=null) {
			txt = t
			txt.autoSize = TextFieldAutoSize.LEFT
			
			//addEventListener(Event.ENTER_FRAME, mainLoop);
			if(s != null) showBuzz(s);
		}
		public function showBuzz(str:String):void {
			description = str;
			randomList = [];
			for (var i:int = 0; i < str.length; i++) {
				var char:String = description.charAt(i);
				if (char != " ") randomList[i] = moveFix - moveRange + int(Math.random() * moveRange * 2);
				else randomList[i] = 0;
			}
			
			textCount = 0;
			fixLength = 0;
			fixStr = "";
			txt.addEventListener(Event.ENTER_FRAME, showRandom);
		}
		private function showRandom(evt:Event) {
			typoText = fixStr;
			end_charMotion = true;
			for (var i:int = fixLength; i < textCount; i++) {
				if (randomList[i]) {
					end_charMotion = false;
					var randomCode:int = randomList[i];
					if (Math.abs(randomCode) <= moveTrigger) {
						var charCode:int = Math.min(Math.max(description.charCodeAt(i) + randomCode, cMin), cMax);
						typoText += String.fromCharCode(charCode);
					} else {
						typoText += waitChar;
					}
					if (randomCode > 0) randomList[i]--;
					else if (randomCode < 0) randomList[i]++;
				} else if (i == fixLength + 1) {
					fixLength = i;
					fixStr = description.slice(0, fixLength);
				}
				typoText += description.charAt(i);
			}
			//for(var j:int = textCount; j<description.length; j++) typoText += waitChar;
			txt.text = typoText;
			if (textCount < description.length) textCount += charSpeed;
			else end_textCount = true;
			if (end_charMotion && end_textCount) txt.removeEventListener(Event.ENTER_FRAME, showRandom);
		}
	}
}
