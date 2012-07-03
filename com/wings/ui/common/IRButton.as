package com.wings.ui.common
{
	/**
	 * 本接口提供可被选中的对象的属性支持,主要使用场合在于实现一组可单/多选的对象描述
	 * @author hh
	 * 
	 */	
	public interface IRButton  extends ISelected
	{
		/**
		 * 是否启用鼠标交互
		 * @return 
		 * 
		 */		
		function get enabled():Boolean;
		function set enabled(value:Boolean):void
			
		/**
		 * 关联值 
		 * @param data
		 * 
		 */			
		function set value(data:Object):void;
		function get value():Object;
		
		
		/**
		 * 仅外观设灰,保留鼠标功能 
		 * @param value
		 * 
		 */		
		function set gray(value:Boolean):void;
		function get gray():Boolean;
		
		/**
		 * 悬停 。支持文本及displayObject 
		 * @return 
		 * 
		 */		
		function get toolTip():Object;
		function set toolTip(obj:Object):void		
					
	}
}