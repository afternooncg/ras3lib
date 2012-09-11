package com.wings.util.display
{
	import flash.display.*;
	import flash.geom.*;
	
	/**
	 * 针对可视对象DisplayObject的常用操作
	 * @author hh
	 * 
	 */
	public class DisplayObjectKit
	{
		public function DisplayObjectKit()
		{
		}
		
		/**
		 * 移除所有子对象
		 * @param value	目标
		 * 
		 */
		public static function removeAllChild(value:DisplayObjectContainer):void
		{
			if(value==null)
				return;
			while(value.numChildren>0)
				value.removeChildAt(0);	 
		}
		
		/**
		 * 将显示对象移至容器顶端
		 * @param displayObj	目标
		 * 
		 */        
		public static function moveTopZ(value:DisplayObject):void
		{
			if (value.parent)
			{
				var parent:DisplayObjectContainer = value.parent;
				if (parent.getChildIndex(value) < parent.numChildren - 1)
					parent.setChildIndex(value, parent.numChildren - 1);
			}
		}
		/**
		 * 设置对象是否接受鼠标事件
		 * 
		 */        
		public static function setMouseEnabled(value:InteractiveObject,bool:Boolean):void
		{
			value.mouseEnabled = bool;
			if(value is Sprite)Sprite(value).mouseChildren=bool;
		}
		
		/**
		 * 是否支持鼠标按键并显示手型
		 * @param	value
		 * @param	bool
		 */
		public static function setMouseHand(value:Sprite, bool:Boolean):void {
			value.mouseChildren = value.mouseEnabled =	value.useHandCursor=bool
		}
		
		/**
		 * 检测对象是否完全在屏幕中
		 * @param displayObj	显示对象
		 * 
		 */
		public static function isVisibleOnScreen(displayObj:DisplayObject):Boolean
		{
			if (displayObj.stage == null)
				return false;
			var screen:Rectangle = new Rectangle(0,0,displayObj.stage.stageWidth,displayObj.stage.stageHeight)
//				trace("isVisibleOnScreen",displayObj.getBounds(displayObj.stage));
				if(!displayObj.mask)
					return screen.containsRect(displayObj.getBounds(displayObj.stage));
				else
					return screen.containsRect(displayObj.mask.getBounds(displayObj.stage));
		}
		
		
		/**
		 * 复制显示对象
		 * 
		 * @param v
		 * 
		 */
		public static function cloneDisplayObject(v:DisplayObject):DisplayObject
		{
			if(v==null) return null;
			var result:DisplayObject = v["constructor"]();
			result.filters = result.filters;
			result.transform.colorTransform = v.transform.colorTransform;
			result.transform.matrix = v.transform.matrix;
			if (result is Bitmap)
				(result as Bitmap).bitmapData = (v as Bitmap).bitmapData;
			return result;
		}
		
		/**
		 * 显示对象转位图
		 * @param v		
		 * @param isTransparent 是否保持透明区域		 
		 * @param bmp 是否传入容器bmp
		 * @return 
		 * 
		 */				
		public static function displayObjToBitmap(v:DisplayObject,isTransparent:Boolean=false,bmp:Bitmap=null):Bitmap
		{
			if(v==null) return null;			
			var bmpData:BitmapData;
			if(isTransparent)
				bmpData = new BitmapData(v.width,v.height,true,0x00000000);
			else
				bmpData = new BitmapData(v.width,v.height);
				
			bmpData.draw(v);
			if(!bmp)
				return new Bitmap(bmpData);
			else
			{
				bmp.bitmapData = bmpData;
				return bmp;
			}
		}
		
		/**
		 * 获取舞台缩放比
		 *  
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function getStageScale(displayObj:DisplayObject):Point
		{
			var currentTarget:DisplayObject = displayObj;
			var scale:Point = new Point(1.0,1.0);
			
			while (currentTarget && currentTarget.parent != currentTarget)
			{
				scale.x *= currentTarget.scaleX;
				scale.y *= currentTarget.scaleY;
				currentTarget = currentTarget.parent;
			}
			return scale;
		}
		
		
		/**
		 * 自定义注册点缩放
		 * 
		 * @param displayObj	显示对象
		 * @param scaleX	缩放比X
		 * @param scaleY	缩放比Y
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */        
		public static function scaleAt(displayObj:DisplayObject,scaleX:Number,scaleY:Number,point:Point=null):void   
		{   
			if(displayObj==null) return;
			if (!point)	point = new Point();
			
			var m:Matrix = displayObj.transform.matrix;
			m.translate(-point.x,-point.y);  
			m.a = scaleX;
			m.d = scaleY;
			m.translate(point.x,point.y);   
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 自定义注册点旋转
		 * 
		 * @param displayObj	显示对象
		 * @param angle	旋转角度（0 - 360）
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */								
		public static function rotateAt(displayObj:DisplayObject,angle:Number,point:Point=null):void   
		{   
			if(displayObj==null) return;
			if (!point) point = new Point();
			
			var m:Matrix = new Matrix();
			m.translate(-point.x, -point.y); 
			m.rotate(angle / 180 * Math.PI);
			m.translate(point.x, point.y);  
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 水平翻转
		 */
		public static function flipH(displayObj:DisplayObject):void
		{
			if(displayObj==null) return;
			var m:Matrix = displayObj.transform.matrix.clone();
			m.a = -m.a;
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 垂直翻转
		 */		
		public static function flipV(displayObj:DisplayObject):void
		{
			if(displayObj==null) return;
			var m:Matrix = displayObj.transform.matrix.clone();
			m.d = -m.d;
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 斜切
		 * 
		 * @param displayObj
		 * 
		 */
		public static function skew(displayObj:DisplayObject,dx:Number = 0,dy:Number = 0):void
		{
			if(displayObj==null) return;
			var rect:Rectangle = displayObj.getRect(displayObj);
			
			var m:Matrix = displayObj.transform.matrix.clone();
			m.c = Math.tan(Math.atan2(dx,rect.height));
			m.b = Math.tan(Math.atan2(dy,rect.width));
			displayObj.transform.matrix = m;
		}
		
		
		/**
		 *   对容器内的所有child进行Y坐标排序 
		 * 
		 */	
		public static function orderChildrenIndexByY(dispCt:DisplayObjectContainer):void
		{
			if(dispCt==null || dispCt.numChildren<2) return;			
			var ary:Array=[];
			for(var i:int=0;i<dispCt.numChildren;i++)
			{
				ary.push(dispCt.getChildAt(i));
			}
			
			ary = ary.sortOn("y",Array.NUMERIC);
			
			i=0;
			var disp:DisplayObject;
			for each(var child:* in ary)
			{
				disp = child as DisplayObject;
				if(dispCt.getChildAt(i)!=disp)
					dispCt.setChildIndex(disp,i);
				i++;
			}
			
			ary = null;
			dispCt = null;
		}
		
		/**
		 * 获取两个碰撞对象的交集矩形 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */		
		public function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			 
			return bounds1.intersection(bounds2);
		}
		
		
		/**
		 *  检查是否存在指定iframename; 
		 * @param name
		 * @return 
		 * 
		 */		
		static public function checkMcHasIframeName(mc:MovieClip,name:String):Boolean
		{
			if(mc==null)
				return false;
			
			var labels:Array = mc.currentLabels;			
			for (var i:uint = 0; i < labels.length; i++) 
			{
				var label:FrameLabel = labels[i];
				if(label.name == name)
					return true;
			}
			
			return false;
		}
		
				
		/**
		 * 颜色数值转RGB
		 * @param	color
		 * @return
		 */
		public static function color2RGB(color:uint):Array
		{
			var r:Number = (color >> 16) & 0xFF;
			var g:Number = (color >> 8) & 0xFF;
			var b:Number = color & 0xFF;
			return  [r,g,b]			
		}
		
	}
}