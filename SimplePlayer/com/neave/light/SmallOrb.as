/**
 * Neave Light // Small Orb
 * 
 * Copyright (C) 2008 Paul Neave
 * http://www.neave.com/
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation at http://www.gnu.org/licenses/gpl.html
 */

package com.neave.light
{
	import flash.display.*;
	import flash.events.*;
	
	internal class SmallOrb extends Orb
	{
		private var dx:Number;
		private var dy:Number;
		
		/**
		 * Creates a new instance of a SmallOrb
		 */
		public function SmallOrb(color:uint, x:Number, y:Number, dx:Number, dy:Number)
		{
			this.x = x;
			this.y = y;
			this.dx = dx;
			this.dy = dy;
			
			super([0xFFFFFF, color], [0x40, 0xFF], Math.random() * 128 + 32);
			
			alpha = Math.random() * 0.5 + 0.2;
			
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
		
		/**
		 * Updates the position of the SmallOrb
		 */
		private function update(e:Event):void
		{
			x += dx;
			y += dy;
			dx += Math.random() * 16 - 8;
			dy += Math.random() * 16 - 8;
			dx *= 0.9;
			dy *= 0.9;
			width *= 1.1;
			height = width;
			alpha -= 0.05;
			if (alpha < 0.06) destroy();
		}
		
		/**
		 * Removes the small orb from the stage
		 */
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, update);
			if (parent) parent.removeChild(this);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
	}
}