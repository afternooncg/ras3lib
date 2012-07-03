package com.wings.ui.components
{
	import com.wings.ui.common.RUIAssets;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 垂直滚动 默认底部是最小值 
	 * @author hh
	 * 
	 */	
	public class RVSlider extends RHSlider
	{
		public function RVSlider(view:DisplayObjectContainer=null, params:Object=null)
		{
			if(view==null) view = RUIAssets.getInstance().vsliderSkin1;			
			if(_w ==0) _w = 10;
			if(_h ==0) _h = 100;
			
			super(view, params);
		}
		
		
		
		/**
		 * Draws the visual ui of the component.
		 */
		override protected function drawBar():void
		{	
			_bgBar.height = _h;
			_bgBar.width = _w;			
		}
		
		
		/**
		 * 重设置滑块位置 
		 *
		 */
		override protected function setHandlePosition():void
		{
			var range:Number = _h - _handle.height;
			_handle.y = _h - _handle.height - (_value - _min) / (_max - _min) * range;
		}
		
		/**
		 * 开始拖动 
		 * 
		 */		
		override protected function beginDrag():void
		{			
			_handle.startDrag(false, new Rectangle(0, 0, 0, _h - _handle.height));
		}
		
		
		/**
		 * 鼠标点击背景条 
		 * 
		 */
		override protected function handleOnClickBgBar(event:MouseEvent):void
		{
			_handle.y = mouseY - _handle.height / 2;
			_handle.y = Math.max(_handle.y, 0);
			_handle.y = Math.min(_handle.y, _h - _handle.height);
			_value = (_h - _handle.height - _handle.y) / (height - _handle.height) * (_max - _min) + _min;
		
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		
		/**
		 * 
		 * 鼠标移动时,实时调整滑块位置
		 */
		override protected function handleMouseMove(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			_value = (_h - _handle.height - _handle.y) / (_h - _handle.height) * (_max - _min) + _min;
			
			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			
		}
	}
}