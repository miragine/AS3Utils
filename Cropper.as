package{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class Cropper extends Sprite{
		
		private var cropTarget:DisplayObject;
		private var cropWidth:Number;
		private var cropHeight:Number;
		private var pixelSnapping:String;
		private var smoothing:Boolean;
		
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
				
		public function Cropper(target:DisplayObject, width:Number = 100, height:Number = 100, _pixelSnapping:String = "auto", _smoothing:Boolean = false){
			cropTarget = target;
			cropWidth  = width;
			cropHeight = height;
			
			pixelSnapping = _pixelSnapping;
			smoothing = _smoothing;
			
			init();
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
		
		private function init():void{
			bitmapData = new BitmapData(cropWidth, cropHeight, true, 0x00000000);
			bitmap = new Bitmap(bitmapData, pixelSnapping, smoothing);
			addChild(bitmap);
		}
		
		public function cropRect(tx:Number = 0, ty:Number = 0):void{
			bitmapData.fillRect(new Rectangle(0, 0, cropWidth, cropHeight), 0x00000000);
			
			var matrix:Matrix = new Matrix();
			matrix.createBox(1, 1, 0, -tx, -ty);
			bitmapData.draw(cropTarget, matrix);
		}
		
		private function removedFromStageHandler(e:Event):void{
			bitmapData.dispose();
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
	}
}