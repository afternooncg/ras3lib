package com.wings.ui.common
{
	
	import com.wings.ui.common.events.PageCountEvent;
	import com.wings.ui.components.RBaseButton;
	import com.wings.ui.components.RComponent;
	import com.wings.ui.components.RInputText;
	import com.wings.ui.components.RLabel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * 本类封装分页导航控制,不提供UI布局,提供上页/下页(btn) 页码输入(textField) 当前页面/总页数记录(textField) 提交按钮的交互
	 * @author hh
	 * 
	 */	
	
	[Event(name="movenext", type="com.wings.ui.common.events.PageCountEvent")]
	[Event(name="moveprev", type="com.wings.ui.common.events.PageCountEvent")]
	[Event(name="gopage", type="com.wings.ui.common.events.PageCountEvent")]
	[Event(name="onchangepage", type="com.wings.ui.common.events.PageCountEvent")]		
	
	public class PageCountManger extends EventDispatcher
	{
	
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		/**
		 *  
		 * @param vo				ui关联对象
		 * @param pageSize			每页显示条数
		 * @param isStartZero		第1页是否从0计数 
		 * @param totalPage			总页码
		 * @param currentPange		当前码 
		 */		
		public function PageCountManger(vo:PageCountUIVo,pageSize:int=10,isStartZero:Boolean=false,totalPage:int=0,currentPange:int=0)
		{
			if(!vo || !vo.btnPrev || !vo.btnNext) throw new ArgumentError("无效的翻页控件参数"); 
			_btnPrev = vo.btnPrev;
			_btnNext = vo.btnNext;
			_totalPage = totalPage;
			_isStartZero = isStartZero;
			if(vo.btnSubmit) _btnSubmit = vo.btnSubmit;
			if(vo.label) _labelCount = vo.label;
			if(vo.txtGo) _txtGoPage = vo.txtGo;			
			
			
			init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected function init():void
		{			
			_btnNext.addEventListener(MouseEvent.CLICK,handleNext);
			_btnPrev.addEventListener(MouseEvent.CLICK,handlePrev);			
			if(_btnSubmit) _btnSubmit.addEventListener(MouseEvent.CLICK,handleSubmit);
			drawUI();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		private var _totalPage:int;
		private var _currentPage:int;
		private var _pageSize:int;
		private var _isStartZero:Boolean= false;
		private var _btnPrev:RComponent;
		private var _btnNext:RComponent;
		private var _txtGoPage:TextField;
		private var _labelCount:TextField;
		private var _btnSubmit:RComponent;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		public function set totalPage(value:int):void
		{
			_totalPage = value >0 ? value : 0;
			drawUI();
		}
		public function get totalPage():int
		{
			return _totalPage >0 ? _totalPage : 0;
		}
		
		public function set currentPage(value:int):void
		{
			_currentPage = value >0 ?value :0;
			drawUI();
		}
		public function get currentPage():int
		{			
			return _currentPage >0 ?_currentPage :0;			
		}
		
		public function set pageSize(value:int):void
		{
			_pageSize = value > 0 ? value :10;
			drawUI();
		}
		
		public function get pageSize():int
		{
			return _pageSize;
		}
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
	
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{
			_btnNext.removeEventListener(MouseEvent.CLICK,handleNext);
			_btnNext = null;
			
			_btnPrev.removeEventListener(MouseEvent.CLICK,handlePrev);
			_btnPrev = null;
			
			if(_btnSubmit)
			{
				_btnSubmit.removeEventListener(MouseEvent.CLICK,handleSubmit);	
				_btnSubmit = null;
			}
			
			if(_labelCount) _labelCount = null;
			if(_txtGoPage) _txtGoPage = null;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 是否只有1页 
		 * @return 
		 * 
		 */		
		private function isOnlyOnePage():Boolean
		{
			if(_isStartZero)
				return (_currentPage == 0 && _totalPage == 1);
			else
				return (_currentPage == 1 && _totalPage == 1);
		}
		
		/**
		 *  在totalpage>0情况下,是否位于第1页 
		 * @return 
		 * 
		 */		
		private function isFirstPage():Boolean
		{
			if(_isStartZero)
				return (_currentPage == 0 &&  _currentPage<_totalPage);
			else
				return (_currentPage ==1 &&  _currentPage<_totalPage);
		}
		
		/**
		 * 是否最后1页 
		 * @return 
		 * 
		 */		
		private function isLastPage():Boolean
		{
			if(_isStartZero)
				return (_totalPage>0 && (_currentPage == (_totalPage-1)));
			else
				return (_totalPage>0 && (_currentPage == _totalPage));
		}
		
		private function drawUI():void
		{			
			if(_totalPage==0)
			{
				//直接
				_btnPrev.gray = _btnNext.gray = true;
			}
			else if(this.isOnlyOnePage())
			{
				_btnPrev.gray = _btnNext.gray = true;
			}
			else if(this.isFirstPage())
			{
				_btnPrev.gray = true;
				_btnNext.gray = false;
			}
			else if(this.isLastPage())
			{
				_btnPrev.gray = false;
				_btnNext.gray = true;	
			}
			else 
			{
				_btnPrev.gray = _btnNext.gray = false;	
			}
			
			if(_txtGoPage)
				_txtGoPage.text = (_isStartZero ? _currentPage+1 : _currentPage).toString();
			if(_labelCount)
			{
				if(_totalPage>0)
					_labelCount.text = (_isStartZero ? _currentPage+1 : _currentPage).toString() + "/" + _totalPage.toString();
				else
					_labelCount.text = "";
			}
			
			
		}
		//--------------------------------------------------------------------------
		//
		//  Broadcasting
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		
		private function handleNext(event:MouseEvent):void
		{			
			if(_currentPage<_totalPage)
			{
				_currentPage++;
				drawUI();
				dispatchEvent(new PageCountEvent(_totalPage,_currentPage,_pageSize));
			}
		}
		
		private function handlePrev(event:MouseEvent):void
		{
			if((_isStartZero && _currentPage>0) || (!_isStartZero && _currentPage>1))
			{
				_currentPage--;
				drawUI();
				dispatchEvent(new PageCountEvent(_totalPage,_currentPage,_pageSize));
			}
		}
		
		private function handleSubmit(event:MouseEvent):void
		{
			if(_txtGoPage)
			{
				var cp:int = int(_txtGoPage.text);			
				if(cp<1)
				{
					cp=1;
				}
				else if(cp>_totalPage)
				{	
					cp = _totalPage;
				}					
				_currentPage = cp;
				dispatchEvent(new PageCountEvent(_totalPage,_currentPage,_pageSize));
			}
			
		}
	}
}