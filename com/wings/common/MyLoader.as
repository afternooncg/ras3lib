package com.wings.common
{
	import com.wings.ui.common.events.RBaseEasyEvent;
	
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import mx.core.Application;
	
	/**
	 *  Rloader简单封装,默认处理捕捉事件，可设置x,y,w,h
	 * @author hh
	 * 
	 */	
	public class MyLoader extends Loader implements IDestroy
	{
		/**
		 *加载失败	 
		 */		
		public static const LOADFAIL:String = "loadfail";
		public static const COMPLETE:String = "complete";
		
		protected var _url:String="";
		protected var _w:Number=0;
		protected var _h:Number=0;
		protected var _x:Number=0;
		protected var _y:Number=0;
		protected var _context:LoaderContext;
				
		protected var _isLoaded:Boolean = false;
		protected var _isBeginLoading:Boolean = false;
		
		/**
		 *  
		 * @param url
		 * @param pramas {x,y,w,h}
		 * @param isSecurityDomain
		 * @param bgw 透明背景绘制长度 当需要图片未加载成功仍支持鼠标点击时启用
		 * @param bgh 透明背景绘制宽度
		 * @return 
		 * 
		 */		
		public function MyLoader(url:String="",pramas:Object=null,isSecurityDomain:Boolean=false,bgw:int=0, bgh:int=0)
		{
			//TODO: implement function
			this.mouseChildren = false;
			_url = url;
			if(pramas)
			{
				if(pramas.hasOwnProperty("x")) _x = int(pramas.x);
				if(pramas.hasOwnProperty("y")) _y = int(pramas.y);
				if(pramas.hasOwnProperty("w")) _w = int(pramas.w);
				if(pramas.hasOwnProperty("h")) _h = int(pramas.h);				
			}
			
			if(isSecurityDomain)
				_context = new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain);
			else
				_context = new LoaderContext(false,ApplicationDomain.currentDomain);
			
			if(bgw>0 && bgh>0)
			{
				var shape:Shape = new Shape();
				this.addChild(shape);
				shape.graphics.beginFill(0xff0000,1);
				shape.graphics.drawRect(0,0,bgw,bgh);
				shape.graphics.endFill();
			}
		}
		
		/**
		 * 是否正在加载中 
		 * @return 
		 * 
		 */		
		public function get isBeginLoading():Boolean
		{
			return _isBeginLoading;
		}

		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		public function get url():String
		{
			return _url;
		}
		public function set url(imgurl:String):void
		{
			_url = imgurl;
		}
		/**
		 * 加载资源 
		 * @param url
		 * @param context
		 * 
		 */		
		public function startload(url:String="", context:LoaderContext=null):void
		{				
			_isLoaded = false;
			_isBeginLoading = true;
//			trace("mloader开始加载:" + url);
//			if(context)
//				_context = context;
			if(url!="") 
				_url = url;
			
			if(_url)
			{
				this.configureListeners(this.contentLoaderInfo);
				super.load(new URLRequest(_url),context?context:_context);		
			}
			
		}
		
		override public function load(request:URLRequest, context:LoaderContext=null):void
		{
			_isBeginLoading = true;
			this.configureListeners(this.contentLoaderInfo);
			super.load(request,context?context:_context);
		}
				
		override public function loadBytes(bytes:ByteArray, context:LoaderContext=null):void
		{			
			_isLoaded = false;
			_isBeginLoading = true;
			this.configureListeners(this.contentLoaderInfo);
			super.loadBytes(bytes,context?context:_context);
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE,handleComplete);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, handleIoError);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);			
			this.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);		
		}
		
		
		private function removeListeners(dispatcher:IEventDispatcher):void
		{
			try
			{
				if(_isBeginLoading)				
					this.close();
			} 
			catch(error:Error) 
			{
				trace("流关闭错误");
			}
			
			dispatcher.removeEventListener(Event.COMPLETE,handleComplete);
			dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, handleIoError);
			dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);			
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);
			
		}		

		/**
		 * 通过反射返回swf里内嵌类实例 
		 * @param skinAsset
		 * @return 
		 * 
		 */				
		public function getObject(skinAsset:String):Object
		{
			
			if(this.contentLoaderInfo.applicationDomain && this.contentLoaderInfo.applicationDomain.hasDefinition(skinAsset))
			{
				var c:Class = this.contentLoaderInfo.applicationDomain.getDefinition(skinAsset) as Class;				
				return new c();
				
			}			
			return null;					
		}
		
		protected function handleComplete(event:Event):void
		{
			_isLoaded = true;
			_isBeginLoading = false;
			this.removeListeners(this.contentLoaderInfo);			
			this.x = _x;
			this.y = _y;
			if(_w>0 && _h>0)
			{				
				this.width = _w;
				this.height = _h;	
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function handleIoError(event:IOErrorEvent):void
		{
			_isBeginLoading = false;
//			以后需要加入Logger管理
			trace("RLoader:加载错误" + event);
			dispatchEvent(new RBaseEasyEvent(MyLoader.LOADFAIL,"ioerrorevent"));
		}
		
							
		protected function handleSecurityError(event:SecurityErrorEvent):void
		{	
			_isBeginLoading = false;
			trace("RLoader:加载安全错误" + event);
			dispatchEvent(new RBaseEasyEvent(MyLoader.LOADFAIL,"securityerrorevent"));
		}		

		public function destroy():void
		{
			this.unloadAndStop();
			this.removeListeners(this.contentLoaderInfo);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,handleSecurityError);			
			_context = null;
		}
		
	}
}


