package{
	
	import flash.text.TextField;
	import flash.text.StyleSheet;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class TextManager{
		
		private static var styleSheet:StyleSheet = new StyleSheet();
		
		function TextManager(){
			throw new Error("You shouldn't use the new operator!");
		}
		
		public static function registerCSS(data:*):void{
			styleSheet.parseCSS(String(data))
		}
		
		public static function createText(style:String):TextField{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = styleSheet.transform(styleSheet.getStyle(style));
			tf.embedFonts = true;
			tf.multiline = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.selectable = false;
			tf.mouseEnabled = false;
			return tf;
		}
		
		public static function createInputText(style:String, length:int = 40):TextField{
			var tf:TextField = new TextField();
			tf.defaultTextFormat = styleSheet.transform(styleSheet.getStyle(style));
			tf.embedFonts = true;
			tf.type = TextFieldType.INPUT;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.maxChars = length;
			return tf;
		}
		
		public static function createHTMLText():TextField{
			var tf:TextField = new TextField();
			tf.styleSheet = styleSheet;
			tf.embedFonts = true;
			tf.multiline = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.selectable = false;
			tf.mouseEnabled = false;
			return tf;
		}
	}
}