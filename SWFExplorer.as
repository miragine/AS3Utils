/**
 * The SWFExplorer class allows you to : 
 * Browse all the exported classes definitions contained in an SWF. The getDefinitions() method returns an array of class definition names
 * @version 0.6
 * @author Thibault Imbert
 * @url www.bytearray.org
 * 
 * Modifier Scile
 * Site www.scile.cn
 * 2009-11-11 14:36
 * 
 * Language Version: 	ActionScript 3.0
 * Runtime Versions: 	Flash Player 9
 */	
package {
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public final class SWFExplorer {
		
		
		private static var criteria:int;
		
		private static const NOT_COMPRESSED:int = 0x46;
		private static const COMPRESSED:int = 0x43;
		private static const FULL:int = 0x3F;
		private static const SYMBOLCLASS:int = 0x4C;
		
		public static const CLASSES:String = "classes";
		
		public function SWFExplorer() {
			throw new Error("You shouldn't use the new operator!");
		}
		
		public static function parse ( stream:ByteArray, type:String="classes" ):Array{
			var arrayClasses:Array = new Array();
				
			stream.position = 0;
				
			var compressed:int = stream.readUnsignedByte();
			
			stream.position += 2;
			
			var version:int = stream.readByte();
			
			stream.endian = Endian.LITTLE_ENDIAN;

			var length:int = stream.readUnsignedInt();
			
			var swf:ByteArray = new ByteArray();
			
			stream.readBytes ( swf, 0 );
			
			if ( compressed == SWFExplorer.COMPRESSED ) swf.uncompress();
			
			swf.endian = Endian.LITTLE_ENDIAN;
			
			var size:int = swf.readUnsignedByte()>>3;

			swf.position += Math.ceil((size*4)/8)+1;

			var frameRate:int = swf.readByte();
			
			var frameCount:int = swf.readShort();
			
			var dictionary:Array = browseTables(swf);
			
			if ( type == SWFExplorer.CLASSES ){
				criteria = SWFExplorer.SYMBOLCLASS;
				
				var symbolClasses:Array = dictionary.filter( filter );
				
				var i:int;
				var count:int;
				var char:int;
				var name:String;
				
				if ( symbolClasses.length ){
					swf.position = symbolClasses[0].offset;
					
					count = swf.readUnsignedShort();
					
					for (i = 0; i< count; i++){
						swf.readUnsignedShort();
					
						char = swf.readByte();
						name = new String();
						
			            while (char != 0){
			                name += String.fromCharCode(char);
			                char = swf.readByte();
			            }
						arrayClasses.push ( name );
					}
				} 
			}
			
			return arrayClasses;
		}
		
		private static function filter (element:TagInfos, index:int, array:Array):Boolean{
			return element.tag == criteria;	
		}
		
		private static function browseTables(swf:ByteArray):Array{
			var currentTag:int;
			var step:int;
			var dictionary:Array = new Array();
			var infos:TagInfos;
			
			while ( currentTag = ((swf.readShort() >> 6) & 0x3FF) ){
				infos = new TagInfos();
			
				infos.tag = currentTag; 
				infos.offset = swf.position;
				swf.position -= 2;
				step = swf.readShort() & 0x3F;
				
				if ( step < SWFExplorer.FULL ){
					swf.position += step;
						
				} else {
					step = swf.readUnsignedInt();
					infos.offset = swf.position;
					swf.position += step;
				}
				
				infos.endOffset = swf.position;		
				dictionary.push ( infos );
				
			}
			
			return dictionary;
		}
	}
}

final class TagInfos{
	public var offset:int;
	public var endOffset:int;
	public var tag:int;	
}