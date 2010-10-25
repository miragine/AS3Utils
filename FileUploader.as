package {
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class FileUploader extends EventDispatcher {

		public function FileUploader() {
		}

		public static const boundaryLength:int = 0x12;
		public static const defaultContentType:String = "application/octet-stream";

		public static function uploadFiles(loader:URLLoader,
											request:URLRequest,
											files:/*ByteArray*/Array,
											fileNames:/*String*/Array = null,
											fieldNames:/*String*/Array = null,
											contentTypes:/*String*/Array = null):void {
												
			var req:URLRequest = packRequest(request, files, fileNames, fieldNames, contentTypes);
			loader.load(req);
		}

		public static function packRequest(request:URLRequest,
											files:/*ByteArray*/Array,
											fileNames:/*String*/Array = null,
											fieldNames:/*String*/Array = null,
											contentTypes:/*String*/Array = null):URLRequest {
												
			var i:int;
			var tmp:String;

			// generate boundary
			var boundary:ByteArray = new ByteArray();
			boundary.endian = Endian.BIG_ENDIAN;
			boundary.writeShort(0x2d2d);
			for (i = 0; i < boundaryLength-2; i++) {
				boundary.writeByte(int(97 + Math.random() * 26));
			}
			boundary.position = 0;

			// prepare new request
			var req:URLRequest = new URLRequest(request.url);
			req.contentType = 'multipart/form-data; boundary=' +
				boundary.readUTFBytes(boundaryLength);
			req.method = URLRequestMethod.POST;

			// prepare post data
			var postData:ByteArray = new ByteArray();
			postData.endian = Endian.BIG_ENDIAN;

			// write parameters
			var pars:URLVariables = request.data as URLVariables;
			if (pars) {
				for (var par:String in pars) {
					// -- + boundary
					postData.writeShort(0x2d2d);
					postData.writeBytes(boundary);

					// line break
					postData.writeShort(0x0d0a);

					// content disposition
					tmp = 'Content-Disposition: form-data; name="' + par + '"';
					postData.writeUTFBytes(tmp);

					// 2 line breaks
					postData.writeInt(0x0d0a0d0a);

					// parameter
					postData.writeUTFBytes(pars[par]);

					// line break
					postData.writeShort(0x0d0a);
				}
			}

			// write files
			for (i = 0; i < files.length; ++i) {
				// -- + boundary
				postData.writeShort(0x2d2d);
				postData.writeBytes(boundary);

				// line break
				postData.writeShort(0x0d0a);

				// content disposition
				var fieldName:String = "Filedata" + i;
				if (fieldNames && fieldNames[i]) fieldName = fieldNames[i];
				tmp = 'Content-Disposition: form-data; name="' + fieldName + '"; filename="';
				postData.writeUTFBytes(tmp);

				// file name
				var fileName:String = "Filename" + i;
				if (fileNames && fileNames[i]) fileName = fileNames[i];
				postData.writeUTFBytes(fileName);

				// missing "
				postData.writeByte(0x22);

				// line break
				postData.writeShort(0x0d0a);

				// content type
				var contentType:String = defaultContentType;
				if (contentTypes && contentTypes[i]) contentType = contentTypes[i];
				tmp = 'Content-Type: ' + contentType;
				postData.writeUTFBytes(tmp);

				// 2 line breaks
				postData.writeInt(0x0d0a0d0a);

				// file data
				var file:ByteArray = files[i];
				postData.writeBytes(file/*, 0, file.length*/);

				// line break
				postData.writeShort(0x0d0a);
			}
			// end of writting files

			// -- + boundary + --
			postData.writeShort(0x2d2d);
			postData.writeBytes(boundary);
			postData.writeShort(0x2d2d);

			// line break
			postData.writeShort(0x0d0a);

			req.data = postData;
			return req;
		}
	}
}
