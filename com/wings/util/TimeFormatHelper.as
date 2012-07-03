package com.wings.util
{
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * 总秒转日时分秒格式化工具类
	 * 
	 * @author hh
	 * 
	 */	
	public class TimeFormatHelper
	{
		
//		冒号 1:2:3
		static public const HMS:String = "{H}:{M}:{S}";
		
//		英文 时分秒   1days 1:2:3
		static public const DHMS:String = "{d}days {H}:{M}:{S}";		
		
//		中文 时分秒  1小时2分3秒
		static public const CN_HMS:String = "{H}小时{M}分{S}秒";
		
//		中文 时分秒   1天 1小时2分3秒
		static public const CN_DHMS:String = "{d}天 {H}小时{M}分{S}秒";

				

		
		public function TimeFormatHelper()
		{
		}
		
		
		
		/**
		 * 转{H}:{M}:{S} 
		 * @param seconds
		 * @param zeroMode
		 * @return 
		 * 
		 */		
		static public function getHMS(seconds:int,zeroMode:Boolean=true):String
		{
			var tf:TimeFormatter = new TimeFormatter(TimeFormatHelper.HMS,zeroMode);
			return parse(seconds,tf);
		}
		
		/**
		 * {d}days {H}:{M}:{S}
		 * @param seconds
		 * @param zeroMode
		 * @return 
		 * 
		 */		
		static public function getDHMS(seconds:int,zeroMode:Boolean=true):String
		{
			var tf:TimeFormatter = new TimeFormatter(TimeFormatHelper.DHMS,zeroMode);
			return parse(seconds,tf);
		}
		
		
		/**
		 * 转{H}小时{M}分{S}秒 
		 * @param seconds
		 * @param zeroMode
		 * @return 
		 * 
		 */		
		static public function getCnHMS(seconds:int,zeroMode:Boolean=true):String
		{
			var tf:TimeFormatter = new TimeFormatter(TimeFormatHelper.CN_HMS,zeroMode);
			return parse(seconds,tf);
		}
		
		/**
		 * {d}天 {H}小时{M}分{S}秒
		 * @param seconds
		 * @param zeroMode
		 * @return 
		 * 
		 */		
		static public function getCnDHMS(seconds:int,zeroMode:Boolean=true):String
		{
			var tf:TimeFormatter = new TimeFormatter(TimeFormatHelper.CN_DHMS,zeroMode);
			return parse(seconds,tf);
		}
		
		
		
				
		
		
		/**
		 * 秒转时分秒 
		 * @param seconds   秒数
		 * @param zeroFlag  true:补0,false:不补0
		 * @return 
		 * 
		 */			
		static public function parse(seconds:int,tf:TimeFormatter):String
		{			
			if(seconds<0) seconds=0;
			if(tf==null || tf.formatter=="") return getHMS(seconds);
			
			
//			检查formatter参数,格式以查到的最高位为准
			if(tf.formatter.indexOf("{d}") >=0)
			{
				return parse2dHMS(seconds,tf);
			}
			else if(tf.formatter.indexOf("{H}") >=0)
			{
				return parse2HMS(seconds,tf);
			}
			else if(tf.formatter.indexOf("{M}") >=0)
			{
				return parse2MS(seconds,tf);
			}
			else 
			{
//				非法直接返回默认HMS格式
				return getHMS(seconds);
			}			

		}
		
		/**
		 * 日时分秒 
		 * @return 
		 * 
		 */		
		private static function parse2dHMS(seconds:int,tf:TimeFormatter):String
		{
			var vo:TimeVo = new TimeVo();
			vo.d = (int(seconds / (3600*24))).toString();			
			var leftseconds:int = int(seconds % (3600*24));						
			var str :String = parse2HMS(leftseconds,tf);
			
			if(tf.zeroMode)
			{
				if(int(vo.d)< 10) {vo.S = "0" + vo.d;} 
			}
			
			str = str.replace(/{d}/g,vo.d);
            return str;
		}   
	
		/**
		 * 时分秒 
		 * @return 
		 * 
		 */		
		private static function parse2HMS(seconds:int,tf:TimeFormatter):String
		{	
			var vo:TimeVo = new TimeVo();
			vo.S = (int(seconds % 3600 % 60)).toString(); 
			vo.M = (int(seconds % 3600 /60)).toString();
			vo.H = (int(seconds / 3600)).toString();
			if(tf.zeroMode)
			{
				if(int(vo.S)< 10) {vo.S = "0" + vo.S;} 
				if(int(vo.M)< 10){ vo.M = "0" + vo.M;} 
				if(int(vo.H) < 10) {vo.H = "0" + vo.H;}
			}
			var str :String = tf.formatter;
			str = str.replace(/{H}/g,vo.H).replace(/{M}/g,vo.M).replace(/{S}/g,vo.S);
            return str;
			
		} 
		
		/**
		 * 分秒 
		 * @return 
		 * 
		 */		
		private static function parse2MS(seconds:int,tf:TimeFormatter):String
		{	
			var vo:TimeVo = new TimeVo();
			vo.S = (int(seconds % 3600 % 60)).toString(); 
			vo.M = (int(seconds % 3600 /60)).toString();
			
			if(tf.zeroMode)
			{
				if(int(vo.S)< 10){vo.S = "0" + vo.S;} 
				if(int(vo.M)< 10){vo.M = "0" + vo.M;}
			}
			
            var str :String = tf.formatter;
			str = str.replace(/{M}/g,vo.M).replace(/{S}/g,vo.S);
            return str;
		}   
	
	}
}


class TimeVo
{	
	public  var d:String;
	public  var H:String;
	public  var M:String;
	public  var S:String;
		
}