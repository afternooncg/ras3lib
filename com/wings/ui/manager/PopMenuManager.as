package com.wings.ui.manager
{
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 *  弹出菜单管理器,实现对弹出点击场景自动关闭的功能 
	 * @author hh
	 * 
	 */	
	public class PopMenuManager implements IDestroy
	{
		protected var _pop:DisplayObject;
		protected var _callbackOpenFn:Function;	//打开执行
		protected var _clickObj:DisplayObject;  //点击排除点
		
		public function PopMenuManager(pop:DisplayObject,clickObj:DisplayObject,callbackOpenFn:Function=null)
		{
			_pop = pop;
			_clickObj = clickObj;
			_callbackOpenFn = callbackOpenFn;		
		}
		
		
		
		protected function handleAddToStage(event:Event):void
		{			
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseDown,true);			
		}		
		
		protected function handleStageMouseDown(event:MouseEvent):void
		{
			if(!_clickObj.hitTestPoint(event.stageX,event.stageY) && !_pop.hitTestPoint(event.stageX,event.stageY))
				close();
		}	
		
		public function pop():void
		{
			if(_pop)
				_pop.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);	
		}
		
		/**
		 * 关闭菜单 
		 * 
		 */		
		public  function close():void
		{
			if(_callbackOpenFn!=null)
				_callbackOpenFn();
			else
			{
				if(_pop && _pop.parent)
					_pop.parent.removeChild(_pop);
			}
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseDown,true);
			if(_pop)				
				_pop.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			
		}
		
		public function destroy():void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseDown,true);
			if(_pop)
				_pop.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			_pop = null;
			_callbackOpenFn = null;			
		}
			
	}
}