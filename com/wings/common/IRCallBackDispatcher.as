package com.wings.common
{
	/**
	 * 回调订阅接口 
	 * @author hh
	 * 
	 */	
	public interface IRCallBackDispatcher
	{
		/**
		 * 增加回调 
		 * @param type
		 * @param listener
		 * @param priority
		 * 
		 */		
		function addEventListener(type:String, listener:Function, priority:int = 0):void
		
		
		/**
		 * 是否持有侦听  
		 * @param type
		 * @return 
		 * 
		 */		
		function hasEventListener(type :String,listener:Function):Boolean
		
		/**
		 * 移除指定回调 
		 * @param type
		 * @param listener
		 * 
		 */		
		function removeEventListener(type:String, listener:Function):void
		
	}
}