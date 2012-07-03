package com.wings.ui.common
{
	/**
	 * 本接口提供可被选中的对象的属性支持,主要使用场合在于实现一组可单/多选的对象描述
	 * @author hh
	 * 
	 */	
	public interface ISelected
	{
		function get isSelected():Boolean;
		function set isSelected(value:Boolean):void
	}	
	
}