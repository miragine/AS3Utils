//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Thu Feb 08 15:04:52 2007
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package {
	
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	public class SoundProcessor {
		
		private static var byteArr:ByteArray = new ByteArray();
		
		public function SoundProcessor(){
			
		}
		
		// Method
		private static function getSection(bArr:ByteArray, sectionLength:uint):Array {
			var spectrumArray:Array = new Array();
			for (var i = 0; i < sectionLength; i++) {
				spectrumArray.push(bArr.readFloat());
			}
			return spectrumArray;
		}
		
		// Spectrum
		public static function getLeftSpectrum(fourier:Boolean = true):Array {
			SoundMixer.computeSpectrum(byteArr, fourier, 0);
			return getSection(byteArr, 256);
		}
		
		public static function getRightSpectrum(fourier:Boolean = true):Array {
			SoundMixer.computeSpectrum(byteArr, fourier, 0);
			byteArr.position = 1024;
			return getSection(byteArr, 256);
		}
		
		public static function getSoundSpectrum(fourier:Boolean = true):Array {
			SoundMixer.computeSpectrum(byteArr, fourier, 0);
			return getSection(byteArr, 512);
		}
		
		public static function getAverageSpectrum(fourier:Boolean = true):Array {
			var sArr = getSoundSpectrum(fourier)
			var averageArr = new Array()
			for(var i = 0; i < 256; i++){
				var average = (sArr[i] + sArr[256+i])/2
				averageArr.push(average)
			}
			return averageArr
		}
		
		// Volume
		
		private static function getVolume(sArr:Array):Number {
			var vol:Number = 0;
			for (var i in sArr) {
				vol += sArr[i];
			}
			vol /= sArr.length;
			return vol*100;
		}
		
		public static function getLeftVolume():Number {
			var spectrumArray   = getLeftSpectrum()
			return getVolume(spectrumArray)
		}
		
		public static function getRightVolume():Number {
			var spectrumArray   = getRightSpectrum()
			return getVolume(spectrumArray)
		}
		
		public static function getSoundVolume():Number {
			var spectrumArray   = getSoundSpectrum()
			return getVolume(spectrumArray)
		}
		
		public static function getSegmentVolume(segment:int = 1):Array {
			var spectrumArray   = getAverageSpectrum()
			var segLenth = Math.floor(256/segment)
			var sArr = new Array()
			for(var i=0; i<segment; i++){
				var vol = 0
				for(var j=segLenth*i; j<segLenth*(i+1); j++){
					vol += spectrumArray[j];
				}
				vol /= segLenth
				sArr.push(vol*100)
			}
			return sArr
		}

	}
	
}