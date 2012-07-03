package com.wings.ui.common
{	
	import com.wings.common.IDestroy;

	/**
	 * List类接口 
	 * @author hh
	 * 
	 */	
	public interface IRList 
	{
		/**
		 * 数据源 
		 * @return 
		 * 
		 */		
		function get dataProvider():Vector.<IRListItem>;
		function set dataProvider(value:Vector.<IRListItem>):void;
		/**
		 * 增 
		 * @param item
		 * 
		 */		
		function add(item:IRListItem):void
			
		/**
		 * 插入 
		 * @param item
		 * @param index
		 * 
		 */			
		function addAt(item:IRListItem,index:int):void
		
		/**
		 * 删除指定项 
		 * @param item
		 * 
		 */			
		function remove(item:IRListItem):void;
		
		/**
		 * 删除指定位置 
		 * @param value
		 * @return 
		 * 
		 */		
		function removeAt(value:int):IRListItem
			
		/**
		 *  全部清除 
		 * 
		 */			
		function removeAll():void
			
		/**
		 * 返回指定项 
		 * @return 
		 * 
		 */			
		function get selectedItem():IRListItem;
		
		/**
		 * 设置当前项目 
		 * @param item
		 * 
		 */		
		function set selectedItem(item:IRListItem):void;
		
		/**
		 * 设置选中位置
		 * @return 
		 * 
		 */		
		function get selectedIndex():int;
		
		/**
		 *  设置选中项
		 * @param value
		 * 
		 */		
		function set selectedIndex(value:int):void;
	}
}