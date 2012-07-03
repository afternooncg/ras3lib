package com.wings.ui.components
{
	import com.wings.ui.common.IRSize;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 本类提供水平摆放对象容器 
	 * @author hh
	 * 
	 * var box:RHBox = new RHBox(container,{x:10,y:10,spacing:10})
	 * box.addChild(someDisp);
	 */	
	public class RHBox extends RVBox
	{
		/**
		 * 
		 * @param parent 父容器
		 * @param params 初始参数{x,y,spacing,itemw,itemh}
		 * 
		 */		
		public function RHBox(parent:DisplayObjectContainer=null, params:Object=null)
		{
			super(parent, params);
		}
				
		override protected function appendChild(child:DisplayObject):void
		{	
			child.y = 0;
			child.x = _w;
			var p:Point = getVisibleWH(child);
			var visiblew:Number = p.x;
			var visibleh:Number = p.y;
				
			_w = child.x  + visiblew + _spacing;
			_h = Math.max(_h,visibleh);			
		}
		
		
		override public function drawUI() : void
		{
			_w = 0;
			_h = 0;
			var xpos:Number = 0;
			for(var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				child.x = xpos;
				
				var p:Point = getVisibleWH(child);
				var visiblew:Number = p.x;
				var visibleh:Number = p.y;
				
				xpos += visiblew;
				xpos += _spacing;
				_w += visiblew;
				_h = Math.max(_h, visibleh);
			}
			if(numChildren>0) _w += _spacing * numChildren - 1;
			dispatchEvent(new Event(Event.RESIZE));
		}
	}
}