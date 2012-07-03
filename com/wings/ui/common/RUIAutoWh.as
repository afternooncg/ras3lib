package com.wings.ui.common
{
	/**
	 * 定义默认组件的长宽 
	 * @author Administrator
	 * 
	 */	
	public class RUIAutoWh
	{
		public function RUIAutoWh()
		{
		}
		
		/**
		 * 默认按钮长宽  
		 * @return {x,y}
		 * 
		 */		
		public function get button():Object
		{
			return {w:111,h:40}
		}
		
		
		/**
		 * 默认combox长宽  
		 * @return {x,y,arroww箭头宽}
		 * 
		 */		
		public function get combox():Object
		{
			return {w:120,h:22,arroww:24}
		}
		
	}
}