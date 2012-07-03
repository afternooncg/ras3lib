package com.wings.ui.common
{	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * 悬停类接口,实现该接口的显示对象允许被RToolTipManager支持  
	 * @author hh
	 * 
	 */	
	public interface IRToolTips
	{
		/**
		 * 悬停 
		 * @param value
		 * @return 
		 * 
		 */		
		function get toolTip():Object
		function set toolTip(value:Object):void	
		
		/**
		 * 强行enterframe事件内实时更新 仅仅当tooltip是文字时需要启用
		 * @return 
		 * 
		 */					
		function get isUpdateTooltipRealTime():Boolean
		function set isUpdateTooltipRealTime(bool:Boolean):void
		
			
		/**
		 * 固定tooltips位置 x,y坐标以当前坐标系为准
		 * 该坐标的设置以该容器自身的x，y为准
		 * @param point
		 * 
		 */		
		function set fiexedPosi(point:Point):void;
		function get fiexedPosi():Point;
		/**
		 *  
		 * 每次over事件时更新,用于tooltip是单例共享情况,如果是非单例情况,不必实现
		 */		
		function updateEveryShow():void		
			
		
	}
}