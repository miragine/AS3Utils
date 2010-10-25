package{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Flag extends Sprite{
		
		public var source:DisplayObject;
		public var sourceBitmapData:BitmapData;
		
		public var output:Bitmap;
		public var outputBitmapData:BitmapData;
		
		public var perlinNoiseBitmapData:BitmapData;
		public var perlinNoiseFallOff:BitmapData;
		
		public var srcWidth:Number;
		public var srcHeight:Number;
		public var origi:Point;
		public var offsets:Array;
		public var animated:Boolean;
		
		public function Flag(source:DisplayObject, animated:Boolean = false){
			this.source = source;
			this.animated = animated;
			init();
		}
		
		private function init():void{
			assemble();
			
			output = new Bitmap();
			output.bitmapData = outputBitmapData;
			output.filters = [getDisplacementMapFilter(), new DropShadowFilter(4,45,0,0.5)]
			addChild(output);
			
			addEventListener(Event.ENTER_FRAME, render);
			addEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
		
		private function assemble():void{
			x = source.x;
			y = source.y;
			srcWidth = source.width;
			srcHeight = source.height;
			origi = new Point();
			offsets = [new Point()];
			
			sourceBitmapData = new BitmapData(srcWidth, srcHeight,true,0);
			sourceBitmapData.draw(source);
			
			outputBitmapData = new BitmapData(srcWidth, srcHeight,true,0);
			
			perlinNoiseBitmapData = new BitmapData(srcWidth*1.2, srcHeight*1.2);
			perlinNoiseFallOff = new BitmapData(srcWidth*1.2, srcHeight*1.2, true, 0)
			
			var shape:Shape = new Shape();
			var gradientBox:Matrix = new Matrix();
			gradientBox.createGradientBox( srcWidth*1.2, srcHeight*1.2, Math.PI/2, 0, 25 );
			shape.graphics.beginGradientFill( 'linear', [ 0x808080, 0x808080 ], [ 99, 0 ], [ 0, 0x60 ], gradientBox );
			shape.graphics.drawRect(0,0,srcWidth*1.2, srcHeight*1.2 );
			shape.graphics.endFill();
			
			perlinNoiseFallOff.draw(shape);
		}
		 
		private function getDisplacementMapFilter():DisplacementMapFilter{
			return new DisplacementMapFilter(perlinNoiseBitmapData, new Point(0,-srcHeight*0.1),2,4,0.125*srcWidth, 0.125*srcHeight,"color");
		}
		
		private function render(e:Event):void{
			if(animated){
				sourceBitmapData.draw(source);
			}
			offsets[0].y -= .05 * srcWidth;
		 	perlinNoiseBitmapData.perlinNoise(0.55*srcWidth, 0.55*srcHeight, 1, 0, true, true, 1, true, offsets);
			perlinNoiseBitmapData.copyPixels( perlinNoiseFallOff, perlinNoiseFallOff.rect, origi, perlinNoiseFallOff, origi, true );

			outputBitmapData.copyPixels(sourceBitmapData, sourceBitmapData.rect, origi);
			//outputBitmapData.draw(perlinNoiseBitmapData, new Matrix(), new ColorTransform( 1.5, 1.5,1.5 , 0.5, 0, 0, 0, 0 ), "multiply")
		}
		
		private function destory(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, render);
			removeEventListener(Event.REMOVED_FROM_STAGE, destory);
		}
	}
}