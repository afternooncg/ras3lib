package com.wings.util
{
	/**
	 * 配合日期时间格式转化类 TimeFormatHelper用
	 * 本类提供格式符定义
	 * @author hh
	 * 
	 */	
	public class TimeFormatter
	{
		
		
//		单位是否补0
		private var _isZeroMode:Boolean;
	
//		格式串 {d} {M} {H} {S}
//			日 时 分 秒	
		private var _formatter:String;
		
				
		public function TimeFormatter(formatter:String="",zeroMode:Boolean=true)
		{
			_isZeroMode = zeroMode;
			
			_formatter = formatter;
		}
		
		public function set zeroMode(value:Boolean):void
		{
			_isZeroMode = value;
		}
		public function get zeroMode():Boolean
		{
			return _isZeroMode;
		}
		
		public function set formatter(value:String):void
		{
			_formatter = value;	
		}
		public function get formatter():String
		{
			return _formatter;	
		}

	}
}