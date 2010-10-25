package{

	import flash.utils.setInterval;
	import flash.utils.clearInterval;
		
	public class Binder{
		
		private static var index:int = 0;
		private static var intervalId:uint = 0;
		private static var bindList:Array = [];
		
		public function Binder(){
		}
		
		public static function addBind(source:Object, sProp:String, destination:Object, dProp:String, twoWay:Boolean = false):int{
			destination[dProp] = source[sProp];
			var id:int = index++;
			bindList.push(new BinderObject(source, sProp, destination, dProp, twoWay, id));
			
			if(bindList.length == 1){
				intervalId = setInterval(hitTest, 50);
			}
			return id;
		}
		
		
		public static function clearBind(id:int):void{
			for (var i:int = 0; i < bindList.length; i++ ) {
				if(id = bindList[i].id)  bindList.splice(i, 1);
			}
			if(bindList.length == 0){
				clearInterval(intervalId);
				hitTest();
			}
		}
		
		private static function hitTest():void{
			var carrier:*;
			var bo:BinderObject;
			
			for(var i:int=0; i<bindList.length; i++){
				bo = bindList[i];
				
				if(bo.source[bo.sProp] != bo.oldSource){
					carrier = bo.source[bo.sProp];
					
					bo.oldSource = carrier;
					bo.destination[bo.dProp] =  carrier;
					bo.oldDestination = carrier;
				}
				
				if(bo.twoWay){
					if(bo.destination[bo.dProp] != bo.oldDestination){
						carrier = bo.destination[bo.dProp];
					
						bo.oldDestination = carrier;
						bo.source[bo.sProp] =  carrier;
						bo.oldSource = carrier;
					}
				}
			}
		}
	}
}

final class BinderObject{
	
	public var source:Object;
	public var sProp:String;
	public var destination:Object;
	public var dProp:String;
	public var twoWay:Boolean;
	public var oldSource:*;
	public var oldDestination:*;
	public var id:int;
	
	public function BinderObject(source:Object, sProp:String, destination:Object, dProp:String, twoWay:Boolean, id:int){
		this.source = source;
		this.sProp  = sProp;
		this.destination = destination;
		this.dProp  = dProp;
		this.twoWay = twoWay;
		this.oldSource = source[sProp];
		this.oldDestination = destination[dProp];
		this.id = id;
	}
}