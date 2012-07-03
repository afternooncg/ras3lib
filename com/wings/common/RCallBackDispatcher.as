package com.wings.common
{
	
	import flash.utils.Dictionary;

	/**
	 * 回调函数管理器
	 * @author hh
	 * 
	 */	
	public class RCallBackDispatcher implements IDestroy
	{
		private var _dict:Dictionary;		
		public function RCallBackDispatcher()
		{
			_dict = new Dictionary();
		}
		
		/**
		 * 增加回调 
		 * @param type
		 * @param listener
		 * @param priority
		 * 
		 */		
		public function addEventListener(type:String, listener:Function, priority:int = 0):void
		{
			if(listener==null)
				return;
			var vt:Vector.<Function>;
			if(!_dict.hasOwnProperty(type))
			{				
				vt = new Vector.<Function>();
				_dict[type] = vt;
			}
			else
				vt = _dict[type] as Vector.<Function>;				
			vt.push(listener);	 
		}
		
		/**
		 * 移除侦听 
		 * @param type
		 * @param listener
		 * 
		 */		
		public function removeEventListener(type:String, listener:Function):void
		{
			if(_dict.hasOwnProperty(type))
			{	
				var vt:Vector.<Function> = _dict[type] as Vector.<Function>;
				var index:int = vt.indexOf(listener);
				if(index!=-1)
					vt.splice(index,1);
				if(vt.length==0)
					delete _dict.hasOwnProperty(type)
			}
		}
		
		
		/**
		 * 是否持有侦听  
		 * @param type
		 * @return 
		 * 
		 */		
		public function hasEventListener(type :String,listener:Function):Boolean
		{
			if(_dict.hasOwnProperty(type))
				return (_dict[type] as Vector.<Function>).indexOf(listener)>=0 ? true : false;
			else
				return false;
		}
		
		
		/**
		 * 回调 
		 * @param type
		 * @param param
		 * 
		 */		
		public function onCallBack(type:String,param:*):void
		{
			if(_dict.hasOwnProperty(type))
			{
				var vt:Vector.<Function> = _dict[type] as Vector.<Function>;
				for (var i:int = 0; i < vt.length; i++) 
				{
					vt[i](param);
				}
				
			}
		}
		
		public function destroy():void
		{
		
			for (var key:String in _dict) 
			{
				if(_dict[key])				
					(_dict[key] as Vector.<Function>).length = 0;
				delete _dict[key];
			}
			
			_dict = null;
		}
	}
}