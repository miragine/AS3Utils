package {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class MiragineFlying extends Sprite {
		
		private var slicing:Vector.<SP> = new Vector.<SP>();
		private var k:int;
		
		function MiragineFlying(mc:Sprite, xx:uint = 1, yy:uint = 1) {
			cutting(mc, xx, yy);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function onRemoved(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, step);
		}
		
		private function cutting(mc:Sprite, xx:uint = 1, yy:uint = 1):void {
			if (slicing.length > 0) slicing = new Vector.<SP>();
			var bitmapdata:BitmapData = new BitmapData(mc.width, mc.height, true, 0);
			bitmapdata.draw(mc);
			
			var t:uint = xx * yy;
			var w:uint = Math.round(mc.width / xx);
			var h:uint = Math.round(mc.height / yy);
			
			var m:Matrix = new Matrix();
			var dx:uint;
			var dy:uint;
			trace(w, h);
			
			for (var i:int = 0; i < t; i++ ) {
				dx = uint(i / yy) * w;
				dy = (i % yy ) * h;
				if (dx > mc.width || dy > mc.height) continue;
				m.identity();
				m.translate( -dx, -dy);
				
				var tmp:SP = new SP();
				tmp.graphics.beginBitmapFill(bitmapdata, m);
				tmp.graphics.drawRect(0,0,w, h);
				tmp.graphics.endFill();
				tmp.targetX = mc.x - m.tx;
				tmp.targetY = mc.y - m.ty;
				tmp.alpha = 0;
				addChild(tmp);
				slicing.push(tmp);
			}
		}
		
		public function fadeIn():void {
			k = 0;
			var tmp:SP;
			for (var i:int = 0; i < slicing.length; i++ ) {
				tmp = slicing[i];
				tmp.endX = tmp.targetX;
				tmp.endY = tmp.targetY;
				tmp.anchorX = Math.random() * 640;
				tmp.anchorY = Math.random() * 480;
				tmp.startX = Math.random() * 640;
				tmp.startY = Math.random() * 480;
				tmp.alphaStart = 0;
				tmp.alphaEnd = 1;
				tmp.v = 0.05 * Math.random() + 0.02;
				tmp.skip = Math.random() >  0.1 ? true : false;
				tmp.pct = 0;
			}
			removeEventListener(Event.ENTER_FRAME, step);
			addEventListener(Event.ENTER_FRAME, step);
		}
		
		public function fadeOut():void {
			k = 0;
			var tmp:SP;
			for (var i:int = 0; i < slicing.length; i++ ) {
				tmp = slicing[i];
				tmp.endX = Math.random() * 640;
				tmp.endY = Math.random() * 480;
				tmp.anchorX = Math.random() * 640;
				tmp.anchorY = Math.random() * 480;
				tmp.startX = tmp.targetX;
				tmp.startY = tmp.targetY;
				tmp.alphaStart = 1;
				tmp.alphaEnd = 0;
				tmp.v = 0.05 * Math.random() + 0.02;
				tmp.skip = Math.random() >  0.1 ? true : false;
				tmp.pct = 0;
			}
			removeEventListener(Event.ENTER_FRAME, step);
			addEventListener(Event.ENTER_FRAME, step);
		}
		
		private function step(e:Event):void {
			k += 70;
			
			var tmp:SP;
			for (var i:int = 0; i < slicing.length; i++ ) {
				if (i < k) {
					tmp = slicing[i];
					if (tmp.pct == 1) continue;
					tmp.pct += tmp.v;
					if (tmp.pct > 1) tmp.pct = 1;
					tmp.alpha = (tmp.alphaEnd - tmp.alphaStart) * tmp.pct + tmp.alphaStart;
					if (tmp.skip) {
						if(tmp.alphaStart < tmp.alphaEnd){
							tmp.x = tmp.endX;
							tmp.y = tmp.endY;
						}
					}else{
						if (tmp.alpha == 1) {
							tmp.rotation = 0;
						}else {
							tmp.rotation += (1 - tmp.pct) * 30;
						}
						tmp.scaleX = tmp.scaleY = (1 - tmp.alpha) * 20 + 1;
						tmp.x = bezier(tmp.pct, tmp.startX, tmp.anchorX, tmp.endX);
						tmp.y = bezier(tmp.pct, tmp.startY, tmp.anchorY, tmp.endY);
					}
				}
			}
		}
		
		private function bezier(pct:Number, start:Number, anchor:Number, end:Number):Number {
			var x:Number = (((end - anchor) * pct + anchor) - ((anchor - start) * pct + start)) * pct + ((anchor - start) * pct + start);
			return x;
		}
	}
}

import flash.display.Shape;

class SP extends Shape {
	
	public var targetX:uint;
	public var targetY:uint;
	public var endX:uint;
	public var endY:uint;
	public var anchorX:uint;
	public var anchorY:uint;
	public var startX:uint;
	public var startY:uint;
	public var alphaStart:Number;
	public var alphaEnd:Number;
	public var pct:Number;
	public var v:Number;
	public var skip:Boolean;
}