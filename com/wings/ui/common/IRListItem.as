package com.wings.ui.common
{
	import com.wings.ui.components.RBaseButton;

	/**
	 * 列表项接口 
	 * @author hh
	 * 
	 */	
	public interface IRListItem
	{	
		function get data():Object;
		function set data(value:Object):void;
		
		function get index():int;
		function set index(value:int):void;			
	}
}