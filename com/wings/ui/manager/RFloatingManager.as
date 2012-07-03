package com.wings.ui.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 悬浮文字管理
	 * 系统消息、提示、伤害、加血等文字悬浮渐隐效果 
	 * @author dof
	 * 
	 */	
	public class RFloatingManager extends EventDispatcher
	{
		public function RFloatingManager(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}