//****************************************************************************
// Author Scile
// Site www.scile.cn
// Version 1.0
// Wed May 06 14:52:52 2009
//****************************************************************************
// Language Version: 	ActionScript 3.0
// Runtime Versions: 	Flash Player 9
//****************************************************************************

package{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	public class Transformer extends Sprite{
		
		public var TL:Sprite;
		public var TM:Sprite;
		public var TR:Sprite;
		public var ML:Sprite;
		public var MR:Sprite;
		public var BL:Sprite;
		public var BM:Sprite;
		public var BR:Sprite;
		public var simpleMode:Boolean = true;
		
		private var point_TL:Point;
		private var point_TM:Point;
		private var point_TR:Point;
		private var point_ML:Point;
		private var point_MM:Point;
		private var point_MR:Point;
		private var point_BL:Point;
		private var point_BM:Point;
		private var point_BR:Point;
		
		private var body:Sprite;
		private var rotor_TL:Sprite;
		private var rotor_TR:Sprite;
		private var rotor_BL:Sprite;
		private var rotor_BR:Sprite;
		private var targetRect:Rectangle;
		private var targetBevelAngle:Number;
		private var targetBevelEdge:Number;
		private var targetCenterPoint:Point;
		private var targetRotation:Number;
		private var targetMatrix:Matrix;
		private var targetScaleX:Number;
		private var targetScaleY:Number;
		private var repairRadian:Number;
		private var currentTarget:Sprite;
		
		//set & get
		private var _transformTarget:DisplayObject = null;
		private var _constrain:Boolean = false;
		
		public function Transformer(){
			visible = false;
			
			rotor_TL = addChild(new Sprite()) as Sprite;
			rotor_TR = addChild(new Sprite()) as Sprite;
			rotor_BL = addChild(new Sprite()) as Sprite;
			rotor_BR = addChild(new Sprite()) as Sprite;
			body = addChild(new Sprite()) as Sprite;
			TL = addChild(new Sprite()) as Sprite;
			TM = addChild(new Sprite()) as Sprite;
			TR = addChild(new Sprite()) as Sprite;
			ML = addChild(new Sprite()) as Sprite;
			MR = addChild(new Sprite()) as Sprite;
			BL = addChild(new Sprite()) as Sprite;
			BM = addChild(new Sprite()) as Sprite;
			BR = addChild(new Sprite()) as Sprite;
				
			setSkin(new DefaultSkin());
		}
		
		//set & get method
		public function set transformTarget(target:DisplayObject):void{
			_transformTarget = target;
			if(target == null){
				visible = false;
			}else{
				visible = true;
				initBody();
			}
		}
		public function get transformTarget():DisplayObject{
			return _transformTarget;
		}
		
		public function set constrain(bool:Boolean):void{
			_constrain = bool;
			TM.visible = !bool;
			ML.visible = !bool;
			MR.visible = !bool;
			BM.visible = !bool;
		}
		public function get constrain():Boolean{
			return _constrain;
		}
		
		//public method
		public function setSkin(skin:DisplayObjectContainer):void {			
			if (skin.getChildByName("TL") != null) {
				removeChild(TL);
				TL = addChild(skin.getChildByName("TL")) as Sprite;
			}
			if (skin.getChildByName("TM") != null) {
				removeChild(TM);
				TM = addChild(skin.getChildByName("TM")) as Sprite;
			}
			if (skin.getChildByName("TR") != null) {
				removeChild(TR);
				TR = addChild(skin.getChildByName("TR")) as Sprite;
			}
			if (skin.getChildByName("ML") != null) {
				removeChild(ML);
				ML = addChild(skin.getChildByName("ML")) as Sprite;
			}
			if (skin.getChildByName("MR") != null) {
				removeChild(MR);
				MR = addChild(skin.getChildByName("MR")) as Sprite;
			}
			if (skin.getChildByName("BL") != null) {
				removeChild(BL);
				BL = addChild(skin.getChildByName("BL")) as Sprite;
			}
			if (skin.getChildByName("BM") != null) {
				removeChild(BM);
				BM = addChild(skin.getChildByName("BM")) as Sprite;
			}
			if (skin.getChildByName("BR") != null) {
				removeChild(BR);
				BR = addChild(skin.getChildByName("BR")) as Sprite;
			}
			
			initEventListener();
		}
		
		private function initBody():void{
			targetRect = transformTarget.getRect(transformTarget);
			
			point_TL = new Point(targetRect.x , targetRect.y);
			point_TM = new Point(targetRect.x + targetRect.width/2, targetRect.y);
			point_TR = new Point(targetRect.x + targetRect.width,   targetRect.y);
			point_ML = new Point(targetRect.x , targetRect.y + targetRect.height/2);
			point_MM = new Point(targetRect.x + targetRect.width/2, targetRect.y + targetRect.height/2);
			point_MR = new Point(targetRect.x + targetRect.width,   targetRect.y + targetRect.height/2);
			point_BL = new Point(targetRect.x , targetRect.y + targetRect.height);
			point_BM = new Point(targetRect.x + targetRect.width/2, targetRect.y + targetRect.height);
			point_BR = new Point(targetRect.x + targetRect.width ,  targetRect.y + targetRect.height);
			
			body.graphics.clear();
			body.graphics.lineStyle(0,0x000000)
			body.graphics.beginFill(0xff0000, 0);
			body.graphics.drawRect(targetRect.x,targetRect.y,targetRect.width,targetRect.height);
			body.graphics.endFill();
			
			rotor_TL.graphics.clear();
			rotor_TL.graphics.beginFill(0xff0000, 0);
			rotor_TL.graphics.drawCircle(0, 0, 16);
			rotor_TL.graphics.endFill();
			
			rotor_TR.graphics.clear();
			rotor_TR.graphics.beginFill(0xff0000, 0);
			rotor_TR.graphics.drawCircle(0, 0, 16);
			rotor_TR.graphics.endFill();
			
			rotor_BL.graphics.clear();
			rotor_BL.graphics.beginFill(0xff0000, 0);
			rotor_BL.graphics.drawCircle(0, 0, 16);
			rotor_BL.graphics.endFill();
			
			rotor_BR.graphics.clear();
			rotor_BR.graphics.beginFill(0xff0000, 0);
			rotor_BR.graphics.drawCircle(0, 0, 16);
			rotor_BR.graphics.endFill();
			
			mapping(transformTarget.transform.matrix)
		}
		
		private function initEventListener():void{
			TL.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			TR.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			BL.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			BR.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			ML.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			MR.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			TM.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			BM.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			body.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rotor_TL.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rotor_TR.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rotor_BL.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			rotor_BR.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			TL.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			TR.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			BL.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			BR.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			ML.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			MR.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			TM.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			BM.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			body.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			rotor_TL.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			rotor_TR.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			rotor_BL.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			rotor_BR.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			
			TL.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			TR.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			BL.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			BR.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			ML.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			MR.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			TM.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			BM.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			body.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			rotor_TL.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			rotor_TR.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			rotor_BL.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			rotor_BR.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			
			TL.buttonMode = true;
			TR.buttonMode = true;
			BL.buttonMode = true;
			BR.buttonMode = true;
			ML.buttonMode = true;
			MR.buttonMode = true;
			TM.buttonMode = true;
			BM.buttonMode = true;
			rotor_TL.buttonMode = true;
			rotor_TR.buttonMode = true;
			rotor_BL.buttonMode = true;
			rotor_BR.buttonMode = true;
		}
		
		
		private function mouseDownHandler(e:MouseEvent):void {
			currentTarget = e.currentTarget as Sprite;
			setTargetStatus();
			
			switch(e.currentTarget) {
				case body:
					body.startDrag();
					break;
				case TL:
					repairRadian = Math.PI - targetBevelAngle;
					break;
				case TR:
					repairRadian = targetBevelAngle;
					break;
				case BL:
					repairRadian = targetBevelAngle - Math.PI;
					break;
				case BR:
					repairRadian = -targetBevelAngle;
					break;
				case rotor_TL:
					repairRadian = Math.PI - targetBevelAngle;
					break;
				case rotor_TR:
					repairRadian = targetBevelAngle;
					break;
				case rotor_BL:
					repairRadian = targetBevelAngle - Math.PI;
					break;
				case rotor_BR:
					repairRadian = -targetBevelAngle;
					break;
			}
			
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function rollOverHandler(e:Event):void {
			/*switch(e.currentTarget) {
				case body:
					Mouse.cursor = MouseCursor.HAND
					break;
				
			}*/
		}
		
		private function rollOutHandler(e:Event):void {
			/*switch(e.currentTarget) {
				case body:
					Mouse.cursor = MouseCursor.ARROW
					break;
				
			}*/
		}
		
		private function enterFrameHandler(e:Event):void {
			switch(currentTarget) {
				case body:
					mapping(body.transform.matrix);
					break;
				case TL:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateScale();
					}
					break;
				case TR:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateScale();
					}
					break;
				case BL:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateScale();
					}
					break;
				case BR:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateScale();
					}
					break;
				case ML:
					calculateWidth();
					break;
				case MR:
					calculateWidth();
					break;
				case TM:
					calculateHeight();
					break;
				case BM:
					calculateHeight();
					break;
				case rotor_TL:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateRotation();
					}
					break;
				case rotor_TR:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateRotation();
					}
					break;
				case rotor_BL:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateRotation();
					}
					break;
				case rotor_BR:
					if(simpleMode){
						calculateRotationScale();
					}else {
						calculateRotation();
					}
					break;
			}
		}
		
		private function mouseUpHandler(e:MouseEvent):void {
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			switch(currentTarget) {
				case body:
					body.stopDrag();
					mapping(body.transform.matrix);
					break;
			}
			
			
		}
		
		private function mapping(_matrix:Matrix):void{
			body.transform.matrix = _matrix;
			transformTarget.transform.matrix = _matrix;
			
			var PTL:Point = body.localToGlobal(point_TL);
			PTL = this.globalToLocal(PTL)
			TL.x = PTL.x;
			TL.y = PTL.y;
			rotor_TL.x =  PTL.x;
			rotor_TL.y =  PTL.y;
			
			var PTM:Point = body.localToGlobal(point_TM);
			PTM = this.globalToLocal(PTM)
			TM.x = PTM.x;
			TM.y = PTM.y;
			
			var PTR:Point = body.localToGlobal(point_TR);
			PTR = this.globalToLocal(PTR)
			TR.x = PTR.x;
			TR.y = PTR.y;
			rotor_TR.x =  PTR.x;
			rotor_TR.y =  PTR.y;
			
			var PML:Point = body.localToGlobal(point_ML);
			PML = this.globalToLocal(PML)
			ML.x = PML.x;
			ML.y = PML.y;
			
			var PMR:Point = body.localToGlobal(point_MR);
			PMR = this.globalToLocal(PMR)
			MR.x = PMR.x;
			MR.y = PMR.y;
			
			var PBL:Point = body.localToGlobal(point_BL);
			PBL = this.globalToLocal(PBL)
			BL.x = PBL.x;
			BL.y = PBL.y;
			rotor_BL.x =  PBL.x;
			rotor_BL.y =  PBL.y;
			
			var PBM:Point = body.localToGlobal(point_BM);
			PBM = this.globalToLocal(PBM)
			BM.x = PBM.x;
			BM.y = PBM.y;
			
			var PBR:Point = body.localToGlobal(point_BR);
			PBR = this.globalToLocal(PBR)
			BR.x = PBR.x;
			BR.y = PBR.y;
			rotor_BR.x =  PBR.x;
			rotor_BR.y =  PBR.y;
		}
		
		private function setTargetStatus():void{
			targetMatrix = transformTarget.transform.matrix.clone();
			targetRotation = transformTarget.rotation/180*Math.PI;
			targetCenterPoint = body.localToGlobal(point_MM);
			targetCenterPoint = this.globalToLocal(targetCenterPoint);
			targetScaleX = transformTarget.scaleX;
			targetScaleY = transformTarget.scaleY;
			targetBevelEdge = Math.sqrt(Math.pow(targetRect.width*targetScaleX,2) + Math.pow(targetRect.height*targetScaleY,2))/2;
			targetBevelAngle = Math.atan2(targetRect.height * targetScaleY / 2, targetRect.width * targetScaleX / 2);
		}
		
		private function calculateRotationScale():void{
			var dis:Number = Math.sqrt(Math.pow(mouseY - targetCenterPoint.y,2) + Math.pow(mouseX - targetCenterPoint.x,2));
			var rad:Number = Math.atan2(mouseY - targetCenterPoint.y, mouseX - targetCenterPoint.x)
			var mat:Matrix = targetMatrix.clone()
			
			mat.translate(-targetCenterPoint.x, -targetCenterPoint.y);
			mat.scale((dis/targetBevelEdge), (dis/targetBevelEdge));
			mat.rotate(rad + repairRadian - targetRotation);
			mat.translate(targetCenterPoint.x, targetCenterPoint.y);
			
			mapping(mat);
		}
		
		private function calculateRotation():void{
			var rad:Number = Math.atan2(mouseY - targetCenterPoint.y, mouseX - targetCenterPoint.x)
			var mat:Matrix = targetMatrix.clone()
			
			mat.translate(-targetCenterPoint.x, -targetCenterPoint.y);
			mat.rotate(rad + repairRadian - targetRotation);
			mat.translate(targetCenterPoint.x, targetCenterPoint.y);
			
			mapping(mat);
		}
		
		private function calculateScale():void{
			var dis:Number = Math.sqrt(Math.pow(mouseY - targetCenterPoint.y,2) + Math.pow(mouseX - targetCenterPoint.x,2));
			var mat:Matrix = targetMatrix.clone()
			
			mat.translate(-targetCenterPoint.x, -targetCenterPoint.y);
			mat.scale((dis/targetBevelEdge), (dis/targetBevelEdge));
			mat.translate(targetCenterPoint.x, targetCenterPoint.y);
			
			mapping(mat);
		}
		
		private function calculateWidth():void{
			var dis:Number = Math.sqrt(Math.pow(mouseY - targetCenterPoint.y,2) + Math.pow(mouseX - targetCenterPoint.x,2));
			var mat:Matrix = targetMatrix.clone()
			
			mat.translate(-targetCenterPoint.x, -targetCenterPoint.y);
			mat.rotate(-targetRotation);
			mat.scale(dis/(targetRect.width/2*targetScaleX), 1);
			mat.rotate(targetRotation);
			mat.translate(targetCenterPoint.x, targetCenterPoint.y);
			
			mapping(mat);
		}
		
		private function calculateHeight():void{
			var dis:Number = Math.sqrt(Math.pow(mouseY - targetCenterPoint.y,2) + Math.pow(mouseX - targetCenterPoint.x,2));
			var mat:Matrix = targetMatrix.clone()
			
			mat.translate(-targetCenterPoint.x, -targetCenterPoint.y);
			mat.rotate(-targetRotation);
			mat.scale(1, dis/(targetRect.height/2*targetScaleY));
			mat.rotate(targetRotation);
			mat.translate(targetCenterPoint.x, targetCenterPoint.y);
			
			mapping(mat);
		}
		
		public override function toString():String {
			var str:String = "(TL=" + (TL is MovieClip).toString() + 
							 ", TM="+ (TM is MovieClip).toString() +
							 ", TR="+ (TR is MovieClip).toString() +
							 ", ML="+ (ML is MovieClip).toString() +
							 ", MR="+ (MR is MovieClip).toString() +
							 ", BL="+ (BL is MovieClip).toString() +
							 ", BM="+ (BM is MovieClip).toString() +
							 ", BR="+ (BR is MovieClip).toString() + ")"
			return str;
		} 
	}
}

import flash.display.Sprite;
class DefaultSkin extends Sprite {

	private var defaultColor1:int = 0xffffff;
	private var defaultWidth1:int = 8;
	private var defaultHeight1:int = 8;
	
	private var defaultColor2:int = 0x000000;
	private var defaultWidth2:int = 4;
	private var defaultHeight2:int = 4;
	
	private var defaultAlpha:Number = 1;

	public function DefaultSkin() {
		addChild(buildBody("TL"))
		addChild(buildBody("TM"))
		addChild(buildBody("TR"))
		addChild(buildBody("ML"))
		addChild(buildBody("MR"))
		addChild(buildBody("BL"))
		addChild(buildBody("BM"))
		addChild(buildBody("BR"))
	}
	
	private function buildBody(n:String):Sprite{
		var tmp:Sprite = new Sprite();
		tmp.name = n;
		tmp.graphics.beginFill(defaultColor1, defaultAlpha);
		tmp.graphics.drawRect(-defaultWidth1/2,-defaultHeight1/2,defaultWidth1,defaultHeight1);
		tmp.graphics.endFill();
		
		tmp.graphics.beginFill(defaultColor2, defaultAlpha);
		tmp.graphics.drawRect(-defaultWidth2/2,-defaultHeight2/2,defaultWidth2,defaultHeight2);
		tmp.graphics.endFill();
		return tmp;
	}
}