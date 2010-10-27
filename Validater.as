package {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class Validater extends Sprite {
		
		private var a0:Array = [120, -38, -117, -53, 40, 41, 41, -48, -88, 41, -42, -76, -46, -41, -41, -120, 41, -41, -46, -77, 79, -73, -80, 52, -48, 75, -50, -49, -83, 1, -13, 114, 51, -117, 18, -45, 51, -13, 82, 17, 34, 38, -58, -106, -106, 72, -14, -107, -88, 124, 35, 67, 19, 19, -67, -28, 60, 77, 125, 0, 12, 45, 27, -29];
		private var a1:Array = [120, -38, 43, -49, -52, 75, -55, 47, -41, -53, -55, 79, 78, 44, -55, -52, -49, -45, -53, 40, 74, 77, -45, 43, -55, 15, 46, 41, -54, -52, 75, 7, 0, -83, 6, 11, 123];
		private var a2:Array = [120,-38,93,-112,65,107,-61,48,12,-123,-1,-118,-106,-5,-102,123,73,-61,78,-125,65,119,41,-37,-71,40,-114,98,-117,-58,-106,-111,-43,-122,-3,-5,-59,-123,-116,-80,-109,-48,-29,123,15,-23,117,8,65,105,58,53,-63,44,31,-37,118,89,-106,67,100,69,-49,-119,14,78,98,3,-122,-22,-55,78,-51,117,-104,49,-35,-102,-66,-53,-3,-25,14,-24,-38,-36,119,-125,86,-7,43,112,1,-113,-111,32,96,-127,-127,40,-63,-9,-27,-4,122,22,119,-93,-15,101,7,126,76,-16,35,119,64,37,80,-62,-111,-109,7,-85,-34,72,-91,-96,-89,117,89,-83,79,-27,65,90,88,18,-56,84,-59,127,-31,-59,100,94,7,-90,17,-126,20,-93,17,86,18,-95,-80,17,44,108,65,-18,-10,116,101,101,81,-56,-92,-111,-53,-106,-74,-67,-80,-69,-22,125,-123,102,118,-108,92,61,-120,-45,36,26,-47,42,-97,103,-62,66,-32,36,25,58,59,-62,86,-48,-101,-113,-56,-13,95,11,45,-10,-65,-29,2,118,-96];
		private var a3:Array = [120,-38,77,-112,-31,78,-126,96,20,-122,111,-59,113,1,-14,-97,33,-21,6,-70,-122,-122,-51,-112,37,-58,24,27,127,69,115,-125,82,108,43,67,19,91,-106,107,-82,18,92,-74,-4,74,-51,-117,-119,-17,-16,-15,-53,91,-24,35,-54,-15,-9,-68,-49,121,-10,-98,-61,-117,-71,-78,86,58,42,48,101,93,87,57,-106,53,12,35,-81,-56,-102,40,-55,-43,82,-2,-16,68,97,114,-70,-88,73,37,-67,-64,28,20,43,98,-11,-104,17,120,85,-64,31,75,64,-120,-37,-49,112,60,-85,10,124,81,75,82,-104,-114,105,10,86,7,-36,59,-104,119,-55,-3,51,76,31,48,66,100,115,65,70,-83,-19,-54,-52,-80,120,125,9,-11,73,-28,-99,99,107,70,54,-3,16,61,-63,-69,5,102,64,-126,55,-24,57,73,52,-16,-79,-35,38,-2,38,118,-3,-24,-26,-12,-113,-7,-43,71,-74,5,-34,11,-18,4,-92,-79,-122,94,16,13,92,58,-95,-52,118,-43,2,-21,-102,-44,-102,-40,-101,-64,-21,8,60,59,-87,-32,88,48,108,-48,20,123,51,60,-84,-123,-24,44,-83,-77,43,-5,93,-85,83,57,-11,-124,-88,77,121,-36,52,-119,-113,-88,42,-18,-113,-29,-31,45,113,22,-8,-53,77,-17,-90,-110,-44,70,87,-78,-89,52,-25,-31,-89,-125,31,-21,-31,-70,-101,-59,83,-106,4,11,98,94,69,-13,37,-105,-5,127,-17,-98,-92,-120,114,101,-9,60,81,-8,1,-89,-83,-21,-103];
		
		function Validater(parent:DisplayObjectContainer) {
			var parentStage:Object = parent.stage;
			if (!parentStage) return;
			
			var url:String = "";
			try {
				url = ExternalInterface.call(AtoString(a1));
			}catch (e:Error) {
				//trace(e);
			}
			
			var lang:String = Capabilities.language == "zh-CN" ? AtoString(a3) : AtoString(a2);
			var langCheck:RegExp = new RegExp(AtoString(a0), "i");
			
			if (!langCheck.test(url)){
				var tt:TextField = new TextField();
				tt.defaultTextFormat = new TextFormat("Verdana", 12, 0xffffff, true, null, null, null, null, "center", null, null, null, 8);;
				tt.selectable = false;
				tt.width = 300;
				tt.multiline = true;
				tt.wordWrap = true;
				tt.autoSize = "left";
				tt.htmlText = lang;
				tt.x = (parentStage.stageWidth  - tt.width) / 2;
				tt.y = (parentStage.stageHeight - tt.height) / 2;
				addChild(tt);
				
				graphics.beginFill(0x0e0e0e)
				graphics.drawRect(0, 0, parentStage.stageWidth, parentStage.stageHeight);
				graphics.endFill();
				
				parentStage.addChild(this);
				parentStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandle);
			}
		}
		
		private function keyDownHandle(e:KeyboardEvent):void {
			if (e.shiftKey && e.ctrlKey && e.keyCode == 77) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandle);
				stage.removeChild(this);
			}
		}
		
		private function AtoString(arr:Array):String {
			var ba:ByteArray = new ByteArray();
			for(var i:int = 0; i< arr.length; i++){
				ba.writeByte(arr[i]);
			}
			ba.uncompress();
			ba.position = 0;
			return ba.readUTFBytes(ba.length);
		}
	}
}