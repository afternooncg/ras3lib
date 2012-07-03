package com.wings.util
{
	import com.wings.util.debug.MyLogger;
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * js通讯联系类,完全使用本类需要配合html上的指定js一起工作
	 * 本类提供1个安全的js调用模式，调用前必须先调用inti方法,并保证在html页面必须先定义能调用getJscallParams方法的jsfun callAsToGetParams
	 * function callAsToGetParams(jsname)
	 * {
	 *   if(!jsname) return;
	 * 	 var ary =  document.getElementById(swfCtId).getJscallParams(jsname);	//注意swfCtId必须是swfobject的flashid参数(ie:objectId,ff:embedid)
	 *   if(ary==null || ary.length==0) return;
	 *   var vardefineStr = "";
	 *   var params = "";
	 *   for(var i:int;i<ary.length;i++)
	 *   {
	 * 		vardefineStr += "var param" + i + "=ary[" + i +"]" + ";";
	 *      params += i==ary.length-1 ? "param" + i : "param" + i + ",";
	 * 	 }
	 *   eval(vardefineStr+";"+jsname + "(" + params + ")");  
	 * }
	 *  
	 * @author hh
	 * 
	 */	
	public class JsCommunicationsUtil
	{
		private static var _dict:Dictionary;
				
		
		public function JsCommunicationsUtil()
		{
		}
				
		/**
		 * 
		 * @return 
		 * 
		 */		
		static private function get dict():Dictionary			
		{
			if(_dict==null) _dict = new Dictionary();
			return _dict;
		}
		
		/**
		 * 调用safeJsCall前请务必先执行且只需执行1次本方法 
		 * 注册getJscallParams方法给html里的js调用
		 */		
		public static function init():void
		{			
			safeAddCallback("getJscallParams",getJscallParams);
		}
		
		/**
		 * 从字典数据中获取指定的方法参数 
		 * @param jsFunName
		 * 
		 */		
		private static function getJscallParams(key:String):Array
		{
			if(key && _dict && _dict.hasOwnProperty(key))
			{
				var arry:Array = _dict[key] as Array;
				delete _dict[key];
				return arry;
			}
			
			return [];
		}
		
		/**
		 * 安全的ExternalInterface.addCallback调用
		 * @param funNameByJs
		 * @param asFun
		 * 
		 */		
		public static function safeAddCallback(funNameByJs:String,asFun:Function):void
		{
			if(ExternalInterface.available)
			{
				if(funNameByJs && asFun!=null)
				{
					ExternalInterface.addCallback(funNameByJs,asFun);
				}
				else
				{
					MyLogger.warnOutput("无效的ExternalInterface.addCallback调用");
				}
			}
			
		}
		
		
		/**
		 * 安全js调用方法,注意调用该方法前，系统初始化时需要执行1次init(),特别提醒.本方法只适合无返回值的js函数调用 
		 * @param jsFunName  js函数名
		 * @param aryParams  调用参数,把js方法参数按调用顺序放到数组里
		 * 
		 */		
		public static function safeCallJs(jsFunName:String,aryParams:Array=null):void
		{
			if(jsFunName && ExternalInterface.available)
			{									
				if(aryParams && aryParams.length>0)
				{
					var str:String = "";
					for(var i:uint;i<aryParams.length;i++)
					{
						switch (typeof(aryParams[i]))
						{							
							case "string": str += "'" + aryParams[i].toString() + "',";
								break;
							case "number": str += aryParams[i].toString() + ",";
								break;
							case "object":								
								default:	//交给js去回调
											var key:String = "key" + (Math.random()*getTimer()).toString();
											dict[key] = aryParams;
											ExternalInterface.call("eval","setTimeout(\"callAsToGetParams('" + jsFunName + "','" + key + "')\",100);");
											return;
								break;
						}
					}						
					str = StringUtil.InterceptString(str);	//去除最后1个","
					ExternalInterface.call("eval","setTimeout(\"" + jsFunName + "(" + str + ")\",100);");
				}
				else
				{	
					ExternalInterface.call("eval","setTimeout('" + jsFunName + "()',100);");
				}
				
			}
			else
			{
				MyLogger.warnOutput("无效的ExternalInterface.safeCallJs调用");
			}
		}
	}
}