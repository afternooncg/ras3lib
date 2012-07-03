package com.wings.ui.components.events
{
	import flash.events.Event;
	
	/**
	 * 集合类选项变化 
	 * @author hh
	 * 
	 */	
	public class RCollectionChangeEvent extends Event
	{
		public var selectedIndex:int = 0;
		public var data:Object;
		
		/**
		 *  普通单选事件 
		 */		
		static public const ONCHANGE:String = "rcollectionchangeevent_onchange";
		
		/**
		 *  多选事件 
		 */		
		static public const ONCHECKBOX_CHANGE:String = "rcollectionchangeevent_oncheckbox_change";
		
		/**
		 *  
		 * @param selectedIndex    选中id
		 * @param data			   关联数据
		 * @param bubbles
		 * @param cancelable
		 * 
		 */		
		public function RCollectionChangeEvent(type:String="rcollectionchangeevent_onchange", selectedIndex:int=0, data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.selectedIndex= selectedIndex;
			this.data = data;
			super(type, bubbles, cancelable);			
		}
	}
}