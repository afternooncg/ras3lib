package com.wings.ui.common
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	
	
	/**
	 * UI库资源,注意项目中使用必须在Complete事件抛出后，才能使用嵌入uiskin.swf资源部分
	 * @author hh
	 * 
	 */	
	public class RUIAssets 
	{	
		
		private static var _instance:IRUIComponentRes;
		
		public function RUIAssets(f:Force = null)
		{
			if(!f) throw new Error("单例实例错误");	
		}
		
		public static function init(res:IRUIComponentRes):void
		{
			_instance = res;
		}
		
		static public function getInstance():IRUIComponentRes
		{
			if(_instance==null)
			{
				throw new Error("请先执行init方法");
			}
			return _instance;
		}	
		
	}
}

class Force{}