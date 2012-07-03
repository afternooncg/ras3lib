package com.wings.ui.components
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	/**
	 * 组合按钮抽象基类
	 * @author hh
	 * 
	 */	
	public class RAbstractButtonGroup extends EventDispatcher
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
		
		public function RAbstractButtonGroup(buttons:Array=null)
		{
			super(null);
			
			if(this["constructor"] == "[RAbstractButtonGroup]"){			 	
				throw new Error("抽象类RAbstractButtonGroup无法实例化！");		        
			}
			_aryBtn = (buttons == null) ? [] :buttons;
			init();
			
		}
		
		
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		protected function init():void
		{
			for each (var btn:RBaseButton in _aryBtn)
			{
				btn.addEventListener(MouseEvent.CLICK,handleButtonClick);	
			}
		}		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _aryBtn:Array = new Array();		
		protected var _currentIndex:int=0;
		
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
		
		
		public function set aryButtons(ary:Array):void
		{
			if(ary!=null) _aryBtn = ary;;		
		}
		public function get aryButtons():Array
		{
			return _aryBtn;
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
		
		public function add(btn:RBaseButton):void
		{
			if(btn)
			{
				btn.addEventListener(MouseEvent.CLICK,handleButtonClick);
				_aryBtn.push(btn);	
			}
		}
		
		public function remove(btn:RBaseButton):void
		{
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn1:RBaseButton = _aryBtn[i] as  RBaseButton;
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
					var btn1:RBaseButton = _aryBtn[i] as  RBaseButton;
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
				var btn:RBaseButton = _aryBtn[i] as  RBaseButton;
				btn.removeEventListener(MouseEvent.CLICK,handleButtonClick);				
			}
			
			_aryBtn.splice(0);
		}
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{
			for each (var btn:RBaseButton in _aryBtn)
			{
				btn.removeEventListener(MouseEvent.CLICK,handleButtonClick,true)	
			}
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
			var btn1:RBaseButton = event.target as RBaseButton;
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn:RBaseButton = _aryBtn[i] as  RBaseButton;
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