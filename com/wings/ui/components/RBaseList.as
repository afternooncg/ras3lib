package com.wings.ui.components
{
	import com.wings.ui.common.IRList;	
	import com.wings.ui.common.IRListItem;
	
	/**
	 * 列表基类 
	 * @author hh
	 * 
	 */	
	public class RBaseList implements IRList
	{
		protected var _dataProvider:Vector.<IRListItem>
		protected var _selectedIndex:int; //被选中的菜单子项
		
		public function RBaseList(dataProvider:Vector.<IRListItem>=null)
		{
			_dataProvider = dataProvider;	
			if(_dataProvider==null)
				_dataProvider = new Vector.<IRListItem>();
		}
		
		public function get dataProvider():Vector.<IRListItem>
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Vector.<IRListItem>):void
		{
			_dataProvider = value;
		}

		public function add(item:IRListItem):void
		{
			_dataProvider.push(item);
		}
		
		public function addAt(item:IRListItem, index:int):void
		{
			_dataProvider.splice(index,0,item);
		}
		
		public function remove(item:IRListItem):void
		{
			var id:int = _dataProvider.indexOf(item);
			if(id>-1)
				_dataProvider.splice(id,1);
		}
		
		public function removeAt(value:int):IRListItem
		{
			if(value>-1 && value<_dataProvider.length)
				return _dataProvider.splice(value,1)[0];
			return null;
		}
		
		public function removeAll():void
		{
			_dataProvider.length = 0;
		}
		
		public function get selectedItem():IRListItem
		{
			return _dataProvider[_selectedIndex];
		}
		
		public function set selectedItem(value:IRListItem):void
		{
			var id:int = _dataProvider.indexOf(value);
			if(id>-1)
				_selectedIndex = id;
		}		
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{			
			if(value>-1 && value<_dataProvider.length)
				_selectedIndex = value;
		}		
	}
}