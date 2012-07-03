package com.wings.common.load
{
	
	
	import com.wings.common.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public interface IResourceQueue extends IDestroy
	{
		// --------------------------------------------------------------------------
		// 
		// Additional getters and setters
		// 
		// --------------------------------------------------------------------------
		function get totalItems():int;
		
		
		// --------------------------------------------------------------------------
		
		// 
		
		// Overridden API: _SuperClassName_
		// --------------------------------------------------------------------------
		
		// --------------------------------------------------------------------------
		// API
		// --------------------------------------------------------------------------
		
		/**
		 *  
		 * @param key				队列指定资源的id
		 * @param className			队列内指定资源的className
		 * @return 
		 * 
		 */		
		function getObject(key:String,className:String):Object;
		
		/**
		 *  
		 * @param key				队列指定资源的id
		 * @param className			队列内指定资源的className
		 * @return 
		 * 
		 */		
		function getBitmapData(key:String,className:String):BitmapData;
		
		
		function getMovieClip(key:String):MovieClip;
		
		function getSprite(key:String):Sprite;
		
		function getXML(key:String):XML;
		
		function getText(key:String):String;     	
		
		function getBitmap(key:String):Bitmap;		
		
		function getDisplayObjectLoader(key:String):Loader;
		
		
		function hasItem(key:String):Boolean;
		
		/**
		 *  
		 * @param queueAry				资源队列
		 * @param isSecurityDomain		是否加载到安全域
		 * 
		 */		
		function startLoad(queueAry:Vector.<ResourceQueueVo>,isSecurityDomain:Boolean=true):void;
		
	}
}