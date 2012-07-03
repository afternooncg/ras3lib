package com.wings.ui.components.constdefine
{
	/**
	 *  打开弹窗选项模式
	 * @author hh
	 * 
	 */	
	public class PopOpenType
	{		
		public function PopOpenType()
		{
		}
		/**
		 * 默认 禁止窗体外鼠标交互,pop窗体下显示蒙版效果 
		 */		
		static public const MASK:String = "PopOpenType_mask";
		
		/**
		 *  允许窗体外鼠标交互
		 */		
		static public const WITHOUT_MASK:String = "PopOpenType_withoutmask";
		
		
		/**
		 * 禁止窗体外鼠标交互,pop窗体下不显示蒙版效果 
		 */		
		static public const MASK_ALPHA:String = "PopOpenType_mask_alpha";
		
	}
}