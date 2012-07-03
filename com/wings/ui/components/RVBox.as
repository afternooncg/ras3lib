package com.wings.ui.components
{
	import com.wings.ui.common.IRSize;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;
	
	
	/**
	 * 本类提供垂直摆放对象容器
	 * @author hh
	 * 
	 * var box:RVBox = new RVBox(container,{x:10,y:10,spacing:10})
	 * box.addChild(someDisp);
	 */	
	
	public class RVBox extends RBaseComponents
	{				
		/**
		 * 
		 * @param parent 父容器
		 * @param params 初始参数{x,y,spacing}
		 * 
		 */		
		public function RVBox(parent:DisplayObjectContainer=null, params:Object=null)	
		{
			super(parent,params);	
		}
		
		
		protected var _spacing:Number = 5;
		
		override protected function inits():void
		{			
			_isEnabledMask = false;
			//do nothing
			super.inits();
			
		}
		
		override protected function initProps():void
		{	
			if(_params==null) return;				
			if(_params.x) 
				this.x = int(_params["x"]);
			if(_params.y)
				this.y = int(_params["y"]);
			if(_params.spacing) 
				_spacing = int(_params["spacing"]);
		}
		
		
		/**
		 * 新增
		 */
		override public function addChild(child:DisplayObject) : DisplayObject
		{
			if(this.contains(child))
				removeChild(child);
			super.addChild(child);		
			appendChild(child);			
			return child;
		}
		
		
		
		
		/**
		 * 在指定深度增加,此处映射为顺序 本方法实时重绘
		 */
		override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
		{
			super.addChildAt(child, index);			
			drawUI();
			return child;
		}
		
		/**
		 * 删除（本方法实时重绘）
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			super.removeChild(child);            
			drawUI();			
			return child;
		}
		
		/**
		 * 删除指定位置（本方法实时重绘）
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject = super.removeChildAt(index);		
			drawUI();
			return child;
		}		
		
		
		
		/**
		 * Draws the visual ui of the component, in this case, laying out the sub components.
		 */
		override public function drawUI() : void
		{
			_w = 0;
			_h = 0;
			var ypos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.y = ypos;				
				var p:Point = getVisibleWH(child);
				var vsiblew:Number = p.x;
				var visibleh:Number = p.y;
				ypos += visibleh;
				ypos += _spacing;
				_h += visibleh;
				_w = Math.max(_w, vsiblew);
			}
			if(numChildren>0) _h += _spacing * (numChildren - 1);
			dispatchEvent(new Event(Event.RESIZE));
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xff0000,0.2);
//			this.graphics.drawRect(0,0,_w,_h);
//			this.graphics.endFill();
		}
		
		public function removeAll():void
		{
			_w = _h = 0;
			while(this.numChildren>0)
			{				
				this.removeChildAt(0);
			}			
		}
		
		override public function destroy():void
		{
			removeAll();
			super.destroy();			
		}
		
		
		
		/**
		 * Gets / sets the spacing between each sub component.
		 */
		public function set spacing(s:Number):void
		{
			_spacing = s;
			drawUI();
		}
		public function get spacing():Number
		{
			return _spacing;
		}
		
		/**
		 * 每增加1个子对象,实时更新 _w,_h 
		 * @param child
		 * 
		 */		
		protected function appendChild(child:DisplayObject):void
		{			
			child.x = 0;			
			child.y = _h;
			
			var p:Point = getVisibleWH(child);
			var visiblew:Number = p.x;
			var visibleh:Number = p.y;
			_h = child.y + visibleh + _spacing;
			_w = Math.max(_w,visiblew);
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xff0000,0.2);
//			this.graphics.drawRect(0,0,_w,_h);
//			this.graphics.endFill();
		}
		
		/**
		 * 获取可视长宽 
		 * @param disp
		 * @return 
		 * 
		 */		
		protected function getVisibleWH(disp:DisplayObject):Point
		{
			var w:Number = 0;
			var h:Number = 0;
			if(disp is IRSize)
			{
				w = (disp as IRSize).visibleWidth;
				h = (disp as IRSize).visibleHeight;
			}			
			else
			{
				w = disp.width;
				h = disp.height;
			}
			
			if(_params)
			{
				if(_params.itemw)
					w = int(_params.itemw);
				if(_params.itemh)
					h = int(_params.itemh);
			}	
			
			return new Point(w,h);
		}
		
	}
}