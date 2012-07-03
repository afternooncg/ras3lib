package com.wings.util.rmath
{
	/**
	 * 数值表示对象 
	 * @author hh
	 * 
	 */	
	public class NumObject implements IArithmetic
	{
		private var _str:String="";
		public function NumObject(str:String)
		{
			_str=str;
		}
		
		/**
		 * 新增解析到的数值文本 
		 * @param value
		 * 
		 */		
		public function appendChar(value:String):void
		{
			_str += value;
		}
		
		/**
		 * 得到其值 
		 * @return 
		 * 
		 */		
		public function count():Number
		{
			return Number(_str);
		}
	}
}