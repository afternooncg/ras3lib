package com.wings.ui.common
{
	
	/**
	 * 实现了displayobject可视长宽属性
	 * @author hh
	 * 
	 */	
	public interface IRSize
	{
		/**
		 * 可视宽度 
		 * @param value
		 * @return 
		 * 
		 */		
		function set visibleWidth(value:Number):void;		
		function get visibleWidth():Number;
		
		
		/**
		 * 可视高度
		 * @param value
		 * @return 
		 * 
		 */		
		function set visibleHeight(value:Number):void;
		function get visibleHeight():Number;
	}
}