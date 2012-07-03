package com.wings.ui.common.events
{
	
	public class PageCountEvent extends RBaseEasyEvent
	{
		
		
		//上下页事件
		public static const MOVENEXT:String = "rpagecountnavigator_movenext";	
		public static const MOVEPREV:String = "rpagecountnavigator_moveprev";
		public static const GOPAGE:String = "rpagecountnavigator_gopage";
		public static const ONCHANGEPAGE:String = "rpagecountnavigator_gopage";
		
		
		private var _totalPage:int;
		private var _currentPage:int;
		private var _pageSize:int;
		
		public function PageCountEvent(total:int,current:int,size:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_totalPage = total;
			_currentPage = current;
			_pageSize = size;
			super(ONCHANGEPAGE, bubbles, cancelable);
		}
	
		
		public function get totalPage():int
		{
			return _totalPage;
		}
		
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		public function get pageSize():int
		{
			return _pageSize;
		}
			
	}
}