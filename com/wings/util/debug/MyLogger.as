package com.wings.util.debug
{	
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.net.*;
	
	
	
	
	/**
	 *  本类提供1个可自定义配置输出方式的日志功能，本期仅提供本地文本输出的支持(Html),未来或许启用服务端写库支持
	 *  
	 * @author hh
	 * 
	 */	
	public class MyLogger
	{	
		private static var INSTANCE: MyLogger;
		
		private static var _loader:URLLoader;
		private static var _url:String="";
		private static var _enable:Boolean = true;
		
//		输出模式 0 本地 1 远程
		private static var _outputMode:int = 0;
		/**
		 * Constructor.
		 */
		public function MyLogger( se : SingletonEnforcerer ) {
			if( se != null ){
				init();
			}
		}
		/**
		 * Generates and returns an instance on the singleton.
		 */
		public static function getInstance() : MyLogger {
			if( INSTANCE == null ){
				INSTANCE = new MyLogger( new SingletonEnforcerer() );
			}
			return INSTANCE;
		}
		/**
		 * Inits the singleton.
		 */
		
		private static function init():void {
			
			//			_url = PublicResource.LOGURL;
			//			_enable = PublicResource.LOGENABLE;
//			if(_url=="") 
//			{
//				warnOutput("LogUrl为空");
//				return;
//			}
//			//创建URLLoader对象;
//			_loader = new URLLoader();
//			//设置接收数据方式(文本、原始二进制数据、URL 编码变量);
//			_loader.dataFormat = URLLoaderDataFormat.TEXT;
//			
//			//设置事件侦听器
//			configureListeners(_loader);
			
		}
		
		private static function log(msg:String):void
		{
			//配置未开启
			if(!_enable) return;
			
			if(_outputMode==0)
			{
				
			}
			
//			if(_loader==null) init();
//			
//			
//			
//			//设置传递参数;
//			var params:URLVariables = new URLVariables();
//			
//			params.content=msg;
			
			 
			//			//建立Request访问对象;
			//			var request:URLRequest = new URLRequest(_url);
			//			//设置参数;
			//			request.data = params;			
			//			//设置访问模式(POST,GET);
			//			request.method = URLRequestMethod.POST;			
			//			
			//            try {
			//            	//navigateToURL(request);            	
			//                _loader.load(request);
			//            } catch (error:Error) {
			//                output(error);
			//            }
			
			
		}
		
		private static function configureListeners(dispatcher:IEventDispatcher):void 
		{
			//加载完成事件;
			dispatcher.addEventListener(Event.COMPLETE, loaderHandler);
			//开始访问事件;
			dispatcher.addEventListener(Event.OPEN, loaderHandler);
			//加载进度事件;
			dispatcher.addEventListener(ProgressEvent.PROGRESS, loaderHandler);
			//跨域访问安全策略事件;
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loaderHandler);
			//Http状态事件;
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, loaderHandler);
			//访问出错事件;
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, loaderHandler);
		}
		
		
		public static function set enabled(value:Boolean):void
		{
			_enable = value;
		}
		
		public static function get enabled():Boolean
		{
			return _enable;			 
		}
		
		
		/**
		 * 普通输出 
		 * @param str
		 * 
		 */		
		public static function traceOutput(obj:Object):void
		{
			if(_enable)
			{
				trace("EasyLogger:" + obj.toString());
				ExternalInterface.call("loggerDebugFromAs","EasyLogger" + obj.toString());
//				MonsterDebugger.trace(MyLogger.getInstance(),obj);
			}
		}
		
		/**
		 * 排桌输出 
		 * @param str
		 * 
		 */		
		public static function traceSgsOutput(obj:Object):void
		{
			if(_enable)
			{
//				trace("牌桌输出" + obj.toString());
				ExternalInterface.call("loggerDebugFromAsSgs",obj.toString());
//				MonsterDebugger.trace(MyLogger.getInstance(),obj);
			}
		}
		
		/**
		 * 警告/异常输出 
		 * @param str
		 * 
		 */		
		public static function warnOutput(obj:Object):void
		{
			if(_enable)
			{
				//myTrace(str);				 
//				trace("EasyLogger:异常或不期望逻辑:" + obj.toString());
				ExternalInterface.call("loggerDebugFromAs","EasyLogger:异常或不期望逻辑:" + obj.toString());
//				MonsterDebugger.trace(MyLogger.getInstance(),obj);
			}
		}
		
		
		
		
		private static function loaderHandler(event:*):void 
		{
			trace("MyLogger IOError") ;
			switch(event.type) {
				case Event.COMPLETE:
					//output(_loader.data);
					break;
				case Event.OPEN:
					//output("open: " + event);					
					break;
				case ProgressEvent.PROGRESS:
					//output("progress: " + event);					
					break;
				case SecurityErrorEvent.SECURITY_ERROR:
					//output("securityError: " + event);
					break;
				case HTTPStatusEvent.HTTP_STATUS:
					//output("httpStatus: " + event);
					break;
				case IOErrorEvent.IO_ERROR:
					//output("ioError: " + event);					
					break;
				
			}
		}      
		
	}
}

/**
 * The SingletonEnforcerer class is located outside the package to block external access.
 */
class SingletonEnforcerer {}