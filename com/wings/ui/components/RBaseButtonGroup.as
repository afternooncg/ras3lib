package com.wings.ui.components
{
	import com.wings.common.IDestroy;
	import com.wings.ui.common.IRButton;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 组合按钮抽象基类
	 * @author hh
	 * 
	 */	
	public class RBaseButtonGroup extends EventDispatcher
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
		
		public function RBaseButtonGroup(buttons:Vector.<IRButton>=null)
		{
			super(null);
			
			if(this["constructor"] == "[RAbstractButtonGroup]"){			 	
				throw new Error("抽象类RAbstractButtonGroup无法实例化！");		        
			}
			_aryBtn = (buttons == null) ? new Vector.<IRButton>() :buttons;
			init();
			
		}
		
		
	

		/**
		 * @private
		 * Initializes the instance.
		 */
		protected function init():void
		{
			for each (var btn:IRButton in _aryBtn)
			{
				(btn as DisplayObject).addEventListener(MouseEvent.CLICK,handleButtonClick);
				btn.isSelected =false;
			}
			_currentIndex = 0;
			if(_aryBtn.length>0)
				_aryBtn[_currentIndex].isSelected = true;
		}		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _aryBtn:Vector.<IRButton>;		
		protected var _currentIndex:int=0;				//当前操作的按钮索引
		
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
		//public function 
		
		public function set aryButtons(ary:Vector.<IRButton>):void
		{
			removeAll();	
			if(ary!=null)
			{	
				_aryBtn = ary;
				init();
			}			
		}
		public function get aryButtons():Vector.<IRButton>
		{
			return _aryBtn;
		}
		
		

		
		/**
		 * 当前选中项 
		 * @return 
		 * 
		 */		
		public function currentSelectedItem():IRButton
		{
			return _aryBtn[_currentIndex];
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
		
		public function add(btn:IRButton):void
		{
			if(btn)
			{
				(btn as DisplayObject).addEventListener(MouseEvent.CLICK,handleButtonClick);
				_aryBtn.push(btn);
				if(_aryBtn.length==1)
					btn.isSelected = true;
			}
		}
		
		public function remove(btn:IRButton):void
		{
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn1:DisplayObject = _aryBtn[i] as  DisplayObject;
				if(btn1 == btn)
				{
					btn1.removeEventListener(MouseEvent.CLICK,handleButtonClick);
					_aryBtn.splice(i,1);
					return;
				}
			}
		}
		
		public function removeAt(index:int):void
		{
			if(index<0 || index>_aryBtn.length-1) return;
			
			for(var i:uint=0;i<_aryBtn.length;i++)
			{				
				if(i == index)
				{
					var btn1:DisplayObject = _aryBtn[i] as  DisplayObject;
					btn1.removeEventListener(MouseEvent.CLICK,handleButtonClick);
					_aryBtn.splice(i,1);
					return;
				}
			}
		}
		
		public function removeAll():void
		{
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn:DisplayObject = _aryBtn[i] as  DisplayObject;
				btn.removeEventListener(MouseEvent.CLICK,handleButtonClick);				
			}			
			_aryBtn.length  = 0;
		}
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{
			removeAll();
			_aryBtn.length = 0;
			_aryBtn = null;
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
		protected function handleButtonClick(event:MouseEvent):void
		{			
			var btn1:IRButton = event.target as IRButton;
			if(!(btn1 is RRadioButton) && (btn1.isSelected || !btn1.enabled))
			{
				_currentIndex = _aryBtn.indexOf(btn1);
				return;
			}
				
						
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn:IRButton = _aryBtn[i];
				if(!btn.enabled)
					continue;
				if(btn==btn1)
				{
					btn.isSelected = true;
					_currentIndex = i;	
				}
				else
				{
					btn.isSelected = false;
				}				
			}			
		}
	}
}