/**
 * Neave Light ...light up your music
 * 
 * @version		1.0.0
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation at http://www.gnu.org/licenses/gpl.html
 */

package com.neave.light
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	
	
	public class NeaveLight extends Sprite
	{
		// Main variables
		private var canvasWidth:int;
		private var canvasHeight:int;
		private var light:Sprite;
		private var redOrb1:BigOrb;
		private var redOrb2:BigOrb;
		private var blueOrb1:BigOrb;
		private var blueOrb2:BigOrb;
		private var greenOrb1:BigOrb;
		private var greenOrb2:BigOrb;
		private var whiteOrb1:BigOrb;
		private var whiteOrb2:BigOrb;
		private var bmp:Bitmap;
		private var blackBitmap:BitmapData;
		private var m:Matrix;
		private var p:Point;
		private var blur:BlurFilter;
		private var max:Number;
		
		/**
		 * Creates a new instance of Neave Light on the stage
		 * 
		 * @param	width		The width of Neave Light
		 * @param	height		The height of Neave Light
		 */
		public function NeaveLight(width:int = 770, height:int = 400)
		{
			canvasWidth = width;
			canvasHeight = height;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initialize);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			this.visible = false;
			
			max = 0
		}
		
		/**
		 * Sets up initialize
		 */
		private function initialize(e:Event):void
		{
			initLights();
			initBitmap();
			stage.addEventListener(Event.RESIZE,stageResizeListener)
			stage.align = "TL"
			stage.scaleMode = "noScale"
		}
		
		/**
		 * Sets up light properties
		 */
		private function initLights():void
		{
			var midX:Number = canvasWidth / 2;
			var midY:Number = canvasHeight / 2;
			
			// Create the orbs
			redOrb1 = new BigOrb(0xFF0000, midX, midY);
			redOrb2 = new BigOrb(0xFF0000, midX, midY);
			blueOrb1 = new BigOrb(0x00FF00, midX, midY);
			blueOrb2 = new BigOrb(0x00FF00, midX, midY);
			greenOrb1 = new BigOrb(0x0000FF, midX, midY);
			greenOrb2 = new BigOrb(0x0000FF, midX, midY);
			whiteOrb1 = new BigOrb(0xFFFFFF, midX, midY);
			whiteOrb2 = new BigOrb(0xFFFFFF, midX, midY);
			
			// Add the orbs
			light = new Sprite();
			light.addChild(redOrb1);
			light.addChild(redOrb2);
			light.addChild(blueOrb1);
			light.addChild(blueOrb2);
			light.addChild(greenOrb1);
			light.addChild(greenOrb2);
			light.addChild(whiteOrb1);
			light.addChild(whiteOrb2);
		}
		
		/**
		 * Sets up the main bitmap
		 */
		private function initBitmap():void
		{
			// Stage sizes
			var sw:int = canvasWidth;
			var sh:int = canvasHeight;
			var sw4:int = Math.ceil(sw / 4);
			var sh4:int = Math.ceil(sh / 4);

			// Create the main bitmap to draw into (and quarter the size to run faster)
			bmp = new Bitmap(new BitmapData(sw4, sh4, false, 0xFF000000));
			bmp.smoothing = true;
			bmp.scaleX = bmp.scaleY = 4;
			//bmp.x = (canvasWidth - sw) / 2;
			//bmp.y = (canvasHeight - sh) / 2;
			this.addChild(bmp);
			
			// Create bitmap data for fading into black
			blackBitmap = new BitmapData(sw4, sh4, false, 0xFF000000);
			
			// Bitmap is moved over into position then quartered in size to run faster
			m = new Matrix();
			//m.translate(-bmp.x, -bmp.y);
			m.scale(0.25, 0.25);
			
			// Origin and blur filter
			p = new Point(0, 0);
			blur = new BlurFilter(64, 64, 2);
		}
		

		
		/**
		 * Draws the light animation
		 */
		private function drawLight(a:Number):void
		{
			var w:Number = canvasWidth;
			var h:Number = canvasHeight;
			
			// Draw the orbs
			redOrb1.draw(a * Math.random(), w, h);
			redOrb2.draw(a * Math.random(), w, h);
			blueOrb1.draw(a * Math.random(), w, h);
			blueOrb2.draw(a * Math.random(), w, h);
			greenOrb1.draw(a * Math.random(), w, h);
			greenOrb2.draw(a * Math.random(), w, h);
			whiteOrb1.draw(a * Math.random(), w, h);
			whiteOrb2.draw(a * Math.random(), w, h);
		}
		
		/**
		 * Draw the orbs into the main bitmap and repeatedly fades them out
		 */
		private function drawBitmap():void
		{
			// Repeatedly fade out and blur
			var b:BitmapData = bmp.bitmapData;
			b.lock();
			b.merge(blackBitmap, b.rect, p, 8, 8, 8, 0);
			b.applyFilter(b, b.rect, p, blur);
			b.draw(light, m, null, BlendMode.ADD);
			b.unlock();
		}
		
		/**
		 * Listens for mouse press
		 */
		private function mouseDownListener(e:MouseEvent):void
		{
			// Fake a microphone respone on mouse press
			for (var i:int = 5; i--; ) drawLight(1);
		}
		
		/**
		 * Frees up memory by disposing all bitmap data
		 */
		private function disposeBitmaps():void
		{
			bmp.bitmapData.dispose();
			bmp.bitmapData = null;
			blackBitmap.dispose();
			blackBitmap = null;
		}
		
		/**
		 * Remove light orbs and all other objects
		 */
		public function destroy():void
		{
			stage.removeEventListener(Event.RESIZE, stageResizeListener);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			stage.removeEventListener(Event.ENTER_FRAME, update);
			this.removeChild(bmp);
			disposeBitmaps();
			
		}
		public function start():void {
			this.addEventListener(Event.ENTER_FRAME, update);
			this.visible = true;
		}
		public function stop():void {
			this.removeEventListener(Event.ENTER_FRAME, update);
			this.visible = false;
		}
		
		/**
		 * Listens for stage resize
		 */
		private function stageResizeListener(e:Event):void
		{
			// Start again with the bitmap if the stage is resized
			this.removeChild(bmp);
			disposeBitmaps();
			canvasWidth = stage.stageWidth;
			canvasHeight = stage.stageHeight;
			initialize(e)
			
			
		}
		
		/**
		 * Updates the animation
		 */
		private function update(e:Event):void
		{
			//var arr = SoundProcessor.getSegmentVolume(5)
			var vol = isNaN(SoundProcessor.getSoundVolume()) ? 0 : SoundProcessor.getSoundVolume()
			
			/*if(vol>48){
				for (var k:int = 4; k--; ) drawLight(1);
			}else if(vol>38){
				for (var i:int = 3; i--; ) drawLight(1);
			}else if(vol >28){
				for (var j:int = 2; j--; ) drawLight(1);
			}else if(vol >18){
				for (var m:int = 1; m--; ) drawLight(1);
			}else{
				
			}*/
			
			max = Math.max(vol,max)
			if(vol == max && vol != 0){
				for (var k:int = 5; k--; ) drawLight(1);
			}
			drawLight(0.1);
			
			max -= max/36
			
			/*var num1 = Math.round(arr[1]/64)
			for (var n:int = num1; n--; ) drawLight(num1);
			
			var num2 = Math.round(arr[2]/32)
			for (var m:int = num2; m--; ) drawLight(num2);
			
			var num3 = Math.round(arr[3]/16)
			for (var i:int = num3; i--; ) drawLight(num3);
			
			var num4 = Math.round(arr[4]/8)
			for (var j:int = num4; j--; ) drawLight(num4);*/

			drawBitmap();
		}
	}
}