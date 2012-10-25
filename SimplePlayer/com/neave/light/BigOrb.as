/**
 * Neave Light // Big Orb
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
	
	internal class BigOrb extends Orb
	{
		private var color:uint;
		private var aa:Number;
		private var dx:Number;
		private var dy:Number;
		private var midX:Number;
		private var midY:Number;
		
		/**
		 * Creates a new instance of a BigOrb
		 */
		public function BigOrb(color:uint, midX:Number, midY:Number)
		{
			this.color = color;
			this.midX = x = midX;
			this.midY = y = midY;
			
			dx = dy = aa = 0;
			
			super([color, color], [0x00, 0xFF], 128);
		}
		
		/**
		 * Updates the BigOrb graphics
		 * 
		 * @param	a			The amount to disturb the orb, between 0 and 1
		 * @param	maxWidth	The maximum range to move in width
		 * @param	maxHeight	The maximum range to move in height
		 */
		internal function draw(a:Number, maxWidth:Number, maxHeight:Number):void
		{
			// Restrict the amount
			if (a < 0) a = 0;
			if (a > 1) a = 1;
			
			// And now for some smoke and mirrors mathematics...
			dx += a * a / 2;
			dy += a / 16;
			
			var ox:Number = x;
			var oy:Number = y;
			x += (Math.cos(dx) * maxWidth * a * a + midX - x) / 4;
			y += (Math.sin(dy) * maxHeight * a * a + midY - y) / 4;
			
			alpha = (alpha + a + Math.random() * 0.1) / 2;
			
			width = height += (a * (maxWidth + maxHeight) + 10 - width) / 8;
			
			if (parent)
			{
				// Smooth the volume so small orbs appear less often
				aa = (a + aa) / 2;
				
				if (aa > 0.4 && width > 350 && parent.numChildren < 24)
				{
					// Create a small orb eminating out from the big orb when volume is loud enough
					var orb:SmallOrb = new SmallOrb(color, x, y, (x - ox) / 8, (y - oy) / 8);
					parent.addChildAt(orb, 0);
				}
			}
		}
	}
}