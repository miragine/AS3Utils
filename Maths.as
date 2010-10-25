//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Thu Aug 20 12:14:15 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package{
	
	
	public class Maths{
		
		public function Maths() {
			throw new Error("You shouldn't use the new operator!");
		}
		
		public static function gaussrand(mu:Number = 0, sigma:Number = 1):Number{  
			var r1:Number = Math.random();
			var r2:Number = Math.random();
			return (Math.sqrt( -2 * Math.log(r1)) * Math.cos(2 * Math.PI * r2) * sigma + mu);
		}
	}
}