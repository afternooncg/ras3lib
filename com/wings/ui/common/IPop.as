package com.wings.ui.common
{
	import com.wings.ui.components.constdefine.PopOpenType;
	
	import flash.display.DisplayObject;

	/**
	 * 
	 * @author hh
	 * 
	 */	
	public interface IPop extends IStageResize
	{
				
		/**
		 * 是否允许拖动 
		 * @return 
		 * 
		 */		
		function get isCanDrag():Boolean;		
		function set isCanDrag(value:Boolean):void;
		
		/**
		 * 拖拉对象 
		 * @return 
		 * 
		 */		
		function get dragTarget():DisplayObject;
		
//		/**
//		 * 是否弹出状态 
//		 * @return 
//		 * 
//		 */		
//		function get isPopUp():Boolean;		
		/**
		 * 打开弹窗 
		 * @param enumType  打开模式,可用PopOpenType类型的常量
		 * 
		 */		
		function open(enumType:String="PopOpenType_mask"):void;
		
		
		
		/**
		 * 关闭 
		 * @param isRemove ture销毁对象/false不销毁
		 * 
		 */		
		function close(isRemove:Boolean=false):void;		

		
		/**
		 * 执行具体的加入场景动作 
		 * 
		 */	
		function executeOpen(enumType:String= "PopOpenType_mask"):void

		
		/**
		 * 执行具体的移出场景动作 
		 * 
		 */
		function executeClose(isRemove:Boolean=false):void
			
	}
}