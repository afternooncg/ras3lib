package com.wings.ui.common.events
{
	import flash.events.Event;
	
	/**
	 * framewokr事件基类 
	 * @author hh
	 * 
	 */	
	public class RBaseEasyEvent extends Event
	{
		protected var _data:Object;
		
		public function RBaseEasyEvent(type:String,dataParam:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = dataParam;
			super(type, bubbles, cancelable); 
		}

		public function get data():Object
		{
			return _data;
		}
		
		override public function clone():Event
		{
			return new RBaseEasyEvent(type, _data, bubbles,cancelable);
		}

	}
}