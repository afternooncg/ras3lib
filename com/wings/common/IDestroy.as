package com.wings.common
{
	/**
	 * 约定需要从内存里销毁对象,必须要实现的接口
	 * @author hh
	 * 
	 */	
	public interface IDestroy
	{
		function destroy():void;
	}
}