/**
 * Neave Light // Orb
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
	import flash.geom.*
	
	internal class Orb extends Shape
	{
		/**
		 * Draws an orb shape, a simple coloured gradient in a circle
		 * 
		 * @param	colors	An array of colours for the orb gradient
		 * @param	ratios	An array of ratios for the orb gradient
		 * @param	size	The size of the orb
		 */
		public function Orb(colors:Array, ratios:Array, size:Number)
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(size, size);
			m.translate(size / -2, size / -2);
			graphics.beginGradientFill(GradientType.RADIAL, colors, [1, 0], ratios, m);
			graphics.drawCircle(0, 0, size / 2);
		}
	}
}