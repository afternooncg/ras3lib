package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 互斥按钮菜单组。本类只提供数据操作,不提供UI布局
	 * @author hh
	 * 
	 */	
	public class RToggleButtonGroup extends RBaseButtonGroup
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
		
		public function RToggleButtonGroup(buttons:Vector.<IRButton>=null)
		{
			super(buttons);
		}
		
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function init():void
		{
			super.init();
			this.selectedIndex = 0; 
		}		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------			
	
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
		
		/**
		 * 当前选中 
		 * @return 
		 * 
		 */		
		public function get selectedIndex():int
		{
			return _currentIndex;
		}		
		public function set selectedIndex(id:int):void
		{	
			if(id==-1)
			{
				_currentIndex=-1;
				for (var j:int = 0; j < _aryBtn.length; j++) 
					_aryBtn[i].isSelected=false;				
				return;
			}
			
			
			if(id==_currentIndex)
			{
				if(_currentIndex>0 && _currentIndex<_aryBtn.length)
					_aryBtn[_currentIndex].enabled = true;  // for this btn which remove from stage, sometime it will be reset uiskin
				return;
			}
			
			_currentIndex = id;			
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn:IRButton = _aryBtn[i] as  IRButton;
				if(!btn.enabled)
					continue;					
				btn.isSelected =  (i == _currentIndex) ?true:false;			
			}			
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
	
		
		/**
		 * 侦听单个按钮事件
		 * @param event
		 * 
		 */	
		override protected function handleButtonClick(event:MouseEvent):void
		{	
			if(_aryBtn.indexOf(event.target as IRButton) != this.selectedIndex)
			{
				super.handleButtonClick(event);
				dispatchEvent(new RCollectionChangeEvent(RCollectionChangeEvent.ONCHANGE,_currentIndex,_aryBtn[_currentIndex].value));			
			}
		}

		
	}
}
