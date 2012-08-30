package com.wings.ui.common
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import com.wings.ui.common.RUISkin;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * 通用组件资源接口 
	 * @author hh
	 * 
	 */	
	
	[Event(name="complete", type="flash.events.Event")]
	public interface IRUIComponentRes extends IEventDispatcher
	{		
		
		/**
		 * 加载内嵌的.swf流 
		 * 
		 */		
		function Load():void;
		
		/**
		 * 获得内嵌的.swf定义的导出资源类 
		 * @param key
		 * 
		 */		
		function GetObject(className:String):Object;		
		
		/**
		 * 窗体背景 
		 * @return 
		 * 
		 */		
		function get WindowBg():DisplayObject;
		
		/**
		 * 窗体背景1 
		 * @return 
		 * 
		 */		
		function get WindowBg1():DisplayObject;
		
		/**
		 * 窗体背景2 
		 * @return 
		 * 
		 */		
		function get WindowBg2():DisplayObject;
		
		/**
		 * 悬停皮肤 
		 * @return 
		 * 
		 */		
		function get ToolTipSkin():DisplayObject;
		
		/**
		 * 新手引导框皮肤 
		 * @return 
		 * 
		 */		
		function get GuideBgSkin():DisplayObject;
		
		/**
		 * 数值调整增加按钮 皮肤1 
		 * @return 
		 * 
		 */		
		function get incBtnSkin1():RUISkin;

		
		/**
		 * 数值调整减少按钮 皮肤1 
		 * @return 
		 * 
		 */		
		function get decBtnSkin1():RUISkin;			
		
		
		
		/**
		 * checkbox 皮肤1 
		 * @return 
		 * 
		 */		
		function get checkBoxSkin1():RUISkin;
		
		
		/**
		 * radiobox 皮肤1 
		 * @return 
		 * 
		 */		
		function get radioButtonSkin1():RUISkin;
		
		
		/**
		 * 默认base按钮样式 
		 * @return 
		 * 
		 */		
		function get baseBtnSkin():RUISkin;
		
		
		/**
		 * 按钮样式1 
		 * @return 
		 * 
		 */		
		function get btnSkin1():RUISkin;
	
		
		function get btnSkin2():RUISkin;
		
		function get btnSkin3():RUISkin;
		
		function get btnSkin4():RUISkin;
		
		function get btnSkin5():RUISkin;		
		
		function get btnSkin6():RUISkin;
		
		function get btnSkin7():RUISkin;
		
		/**
		 * 关闭按钮样式 
		 * @return 
		 * 
		 */		
		function get closeBtnSkin():RUISkin;
		
		
		/**
		 *获取下拉菜单样式 
		 * @return 
		 * 
		 */		
		function get comboxSkin():RUISkin;
		
		/**
		 *列表中子对象的皮肤 
		 * @return 
		 * 
		 */		
		function get comboxItemSkin():RUISkin;
		/**
		 *列表背景 
		 * @return 
		 * 
		 */
		function get listBg():DisplayObject;
		
		
		
		/**
		 * 边框样式1
		 * 
		 */		
		function get borderSkin1():DisplayObject;
		/**
		 * 边框样式2
		 * 
		 */		
		function get borderSkin2():DisplayObject;
		
		/**
		 * 边框样式3
		 * 
		 */		
		function get borderSkin3():DisplayObject;
		
		/**
		 * 边框样式4
		 * 
		 */		
		function get borderSkin4():DisplayObject;
		
		/**
		 *弹出框样式1
		 */		
		function get frameSkin1():DisplayObject;
		/**
		 * 水平滑动条资源皮肤 
		 * @return 
		 * 
		 */		
		function get hsliderSkin1():DisplayObjectContainer;
		/**
		 * 竖立滑动条资源皮肤 
		 * @return 
		 * 
		 */
		function get vsliderSkin1():DisplayObjectContainer;
		
		
		/**
		 * tab切换按钮默认皮肤 
		 * @return 
		 * 
		 */		
		function get tabBtn1():RUISkin;
		
	
		
		/**
		 *数据表格表头的样式 
		 */		
		function get columnSkin():RUISkin;
		
	}
}