//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Fri Feb 02 15:55:15 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package{
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	public class Convert{
		
		public function Convert() {
			throw new Error("You shouldn't use the new operator!");
		}
		
		// millisecond To second
		public static function millisecondToSecond(ms:Number):Number{
			var s = Math.floor(ms/1000);
			return s;
		}
		
		// second To millisecond
		public static function secondToMillisecond(s:Number):Number{
			var ms = Math.floor(s*1000);
			return ms;
		}
		
		// millisecond To time
		public static function millisecondToTime(ms:Number):String{
			var s = millisecondToSecond(ms)
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
		
		// second To time
		public static function secondToTime(s:Number):String{
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
		
		
		//displayInBox
		public static function displayInBox(displayObject:DisplayObject, rect:Rectangle):DisplayObject{
			var dwh = displayObject.width/displayObject.height;
			var rwh = rect.width/rect.height;
			
			if(dwh > rwh){
				displayObject.width = rect.width;
				displayObject.height = rect.width / dwh;
			}else{
				displayObject.height = rect.height;
				displayObject.width = rect.height * dwh;
			}
			displayObject.x = rect.x + (rect.width - displayObject.width)/2;
			displayObject.y = rect.y + (rect.height - displayObject.height)/2;
			
			return displayObject;
		}
		
		//formatColorHex24
		public static function formatColorHex24(color:uint):String{
			var r:String = ((color >> 16) & 0xFF).toString(16);
			r = (r.length > 1) ? r : "0" + r;
			var g:String = ((color >> 8) & 0xFF).toString(16);
			g = (g.length > 1) ? g : "0" + g;
			var b:String = (color & 0xFF).toString(16);
			b = (b.length > 1) ? b : "0" + b;
			return "0x" + r.toUpperCase() + g.toUpperCase() + b.toUpperCase();
		}
	}
}