package com.wings.common.load
{		
	
	import com.wings.common.IDestroy;
	import com.wings.common.MyLoader;
	import com.wings.util.debug.MyLogger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import share.GameSetting;
	import share.ShareObject.LoaderForShareObject;

	
	[Event(name="ResourceProgressEvent", type="flash.events.Event")]
	/**
	 * 并发下载 
	 * @author hh
	 * 
	 */	
	public class ParallelResourceQueue extends EventDispatcher implements IResourceQueue,IDestroy
	{
		/**
		 * 加载事件 
		 */		
		public static const RESOURCE_PROGRESSEVENT:String = "ResourceProgressEvent";
		
		private var _bytesLoaded:Number=0;
		private var _bytesTotal:Number=0;
		private var _timer:Timer;		
		protected var _queueAry:Vector.<ResourceQueueVo>;	//加载队列信息
		protected var _loadingAry:Vector.<ResourceQueueVo>;	//加载队列信息
				
		protected var _dict:Dictionary;
		protected var _loadContxt:LoaderContext;
		protected var _totalItems:int;
		protected var _loadedItems:int;
		
		protected var _paraNum:int = 5;		//并发加载数
		protected var _loadingLastIndex:int = 0;		//并发加载中监控，最后1个loader在数组中的索引
		protected var _isSecurityDomain:Boolean=false;

		private var _loadContxt2:LoaderContext;
		
		/**
		 * 并发加载数 
		 * @param paraNum
		 * 
		 */		
		public function ParallelResourceQueue(paraNum:int = 5)
		{			
			_paraNum = paraNum;
			if(_paraNum <=0)
				_paraNum = 5;
			_dict = new Dictionary();
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER,handleTimer);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------

		public function get queueAry():Vector.<ResourceQueueVo>
		{
			return _queueAry.slice();
		}

		public function get totalItems():int
		{
			return _queueAry.length;
		}
		
		public function get loadedItems():int
		{
			return _loadedItems;
		}
		
		
		public function get bytesTotal():Number
		{			
			return _bytesTotal;
		}

		public function set bytesTotal(value:Number):void
		{
			_bytesTotal = value;
		}

		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		
		public function getObject(key:String,className:String):Object
		{
			var loader : Loader = _dict[key] as Loader;
			if(loader)
			{
				var app : ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
				// 使用getDefinition返回.swf的库中链接名的Class				
				if (app.hasDefinition(className))
				{
					var c : Class;
					c = app.getDefinition(className) as Class;
					return new c();
				}
				return null;
			}
			
			return null;	
			
		}
		
		/**
		 *  
		 * @param key				队列指定资源的id
		 * @param className			队列内指定资源的className
		 * @return 
		 * 
		 */		
		public function getBitmapData(key:String,className:String):BitmapData
		{
			return getObject(key,className)	 as BitmapData;
		}
		
		public function getMovieClip(key:String):MovieClip
		{
			return _dict[key] as Loader	 as MovieClip;
		}
		
		
		public function getSprite(key:String):Sprite
		{
			return _dict[key] as Sprite;
		}
		
		public function getXML(key:String):XML
		{
			return _dict[key] as XML;
		}
		
		public function getText(key:String):String
		{
			return _dict[key] as String;
		}
		
		
		public function getBitmap(key:String):Bitmap
		{
			return _dict[key] as Bitmap;
		}
		
		
		public function getDisplayObjectLoader(key:String):Loader
		{
			return _dict[key] as Loader
		}
		
		
		public function hasItem(key:String):Boolean
		{
			return _dict.hasOwnProperty(key);			
		}
		
		
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Broadcasting
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
				

		/**
		 *  
		 * @param queueAry				资源队列
		 * @param isSecurityDomain		是否加载到安全域
		 * 
		 */		
		public function startLoad(queueAry:Vector.<ResourceQueueVo>,isSecurityDomain:Boolean=true):void
		{
			if(_timer.running)
			{
//				MyLogger.traceOutput("对列数据还没加载完!");
				//trace("对列数据还没加载完!");
				return;
			}
			
			if (!queueAry || queueAry.length==0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return; 
			}
			_isSecurityDomain = isSecurityDomain; 
			_loadingAry = new Vector.<ResourceQueueVo>();					    
			_loadContxt2= _isSecurityDomain ? new LoaderContext(false,ApplicationDomain.currentDomain,SecurityDomain.currentDomain):new LoaderContext(false, ApplicationDomain.currentDomain);
//			_loadContxt2= new LoaderContext(false, ApplicationDomain.currentDomain);
			
			var tmp:Array =new Array();			
			for each (var vo : ResourceQueueVo in queueAry) 
			{				
				if (!_dict.hasOwnProperty(vo.id))
				{
					_loadingAry.push(vo);
//					var loader:MyLoader = new MyLoader();
//					loader.name = vo.id;
//					loader.addEventListener(MyLoader.COMPLETE,handleItmeComplete);
//					loader.addEventListener(MyLoader.LOADFAIL,handleItmeFail);
					//loader.load(new URLRequest(vo.url),loadContxt);
					var loader:LoaderForShareObject =  new LoaderForShareObject();
					loader.name = vo.id;
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleItmeComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,handleItmeFail);
//					if(GameSetting.DEBUG && ExternalInterface.available)
//						loader.load(new URLRequest(vo.url),_loadContxt2);
//					else
				//		loader.LoadForShareObject(vo.id,new URLRequest(vo.url),_loadContxt2);					
					_dict[vo.id] = loader;
				}
				else
				{
					tmp.push(vo.id);
				}
			}
			
			//			全部都是已加载完毕
			if(tmp.length==queueAry.length) 
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return; 
			}
			
			if(_queueAry)
			{
				_queueAry = _queueAry.concat(queueAry);
			}
			else
			{
				_queueAry = queueAry;
			}
			
			_totalItems = _loadingAry.length;
			_loadedItems = 0;
			_loadingLastIndex = 0 ;
			
			for (var i:int = 0; i < _paraNum; i++) 
			{
				if(i<_loadingAry.length)
				{	
//					loadNextItme();
					setTimeout(loadNextItme,100); //避免so的写入导致浏览器debug失败
				}	
			}
			
			_timer.start();
		}
		
		/**
		 * 加载下1项 
		 * 
		 */		
		private function loadNextItme():void
		{
			if(_loadingLastIndex<_loadingAry.length)
			{	
				var vo:ResourceQueueVo = _loadingAry[_loadingLastIndex];
				//(_dict[vo.id] as MyLoader).startload(vo.url,_loadContxt2);
				//(_dict[vo.id] as LoaderForShareObject).load(new URLRequest(vo.url),_loadContxt2);
//				if(GameSetting.DEBUG && ExternalInterface.available)
//					(_dict[vo.id] as LoaderForShareObject).load(new URLRequest(vo.url),_loadContxt2);
//				else
					(_dict[vo.id] as LoaderForShareObject).LoadForShareObject(vo.id,new URLRequest(vo.url),_loadContxt2);				
				_loadingLastIndex++;
			}
		}
		
		
		/**
		 * 单项加载完毕 
		 * @param event
		 * 
		 */		
		private function handleItmeComplete(event:Event):void
		{
			//(event.target as MyLoader).removeEventListener(MyLoader.COMPLETE,handleItmeComplete);
			(event.target as LoaderInfo).removeEventListener(Event.COMPLETE,handleItmeComplete);
			_loadedItems++;
			
			if(_loadedItems<_totalItems)
				loadNextItme();
			else
				complete();				
		}
		
		/**
		 * 加载失败 
		 * @param event
		 * 
		 */		
		private function handleItmeFail(event:Event):void   
		{
			//(event.target as MyLoader).removeEventListener(MyLoader.LOADFAIL, handleItmeFail);
			(event.target as LoaderInfo).removeEventListener(IOErrorEvent.IO_ERROR,handleItmeFail);			
			trace("加载失败"+(event.target as LoaderInfo).url); 
			
		}
			
		
		/**
		 * 计算
		 * @param event
		 * 
		 */		
		private function handleTimer(event:TimerEvent):void
		{
			var loaded:Number=0;
			var total:Number=0;
			for(var i:uint=0;i<_loadingAry.length;i++)
			{				
				var loader:Loader = _dict[_loadingAry[i].id] as Loader;  
				if(loader)
				{
					loaded += loader.contentLoaderInfo.bytesLoaded;
					total += loader.contentLoaderInfo.bytesTotal;
				}				
			}			
			
			if(loaded==0)
				loaded=0.01;
			if(total==0)
				total=1;		
			
			_bytesLoaded=loaded;
			_bytesTotal=total;
			
			dispatchEvent(new Event(RESOURCE_PROGRESSEVENT));
			
//			if(_bytesLoaded==_bytesTotal && _bytesLoaded>1)
//				complete();
		
		}
		
		/**
		 * 组加载完成事件
		 * @param event
		 * 
		 */		
		private function complete() : void
		{	
			_timer.stop();
			_timer.reset();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function Destory():void
		{
			_timer.removeEventListener(TimerEvent.TIMER,handleTimer);
			_timer = null;
			_queueAry.length = 0;
			_queueAry = null;
			_loadingAry.length=0;
			_loadingAry =null;			
			_dict = null;
			_loadContxt = null;			
			_loadContxt2 = null;
			
		}
	}
}