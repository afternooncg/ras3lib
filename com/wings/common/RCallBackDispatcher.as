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
		protected var _dict:Dictionary;		
		protected var _aryDel:Array;	   //在执行onCallBack时 临时存放移除fun
		protected var _dictTmpAdd:Dictionary; //在执行onCallBack时 临时存放新增fun 及  type;
		protected var _isExecuteing:Boolean = false;    //回调执行中
		public function RCallBackDispatcher()
		{
			_dict = new Dictionary();
			_aryDel = [];
			_dictTmpAdd = new Dictionary();
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
			if(!_isExecuteing)
			{
				if(!_dict.hasOwnProperty(type))
				{				
					vt = new Vector.<Function>();
					_dict[type] = vt;
				}
				else
					vt = _dict[type] as Vector.<Function>;
				
				if(vt.indexOf(listener)<0)
					vt.push(listener);	 
			}
			else
			{
				if(!_dictTmpAdd.hasOwnProperty(type))
				{				
					vt = new Vector.<Function>();
					_dictTmpAdd[type] = vt;
				}
				else
					vt = _dictTmpAdd[type] as Vector.<Function>;
				
				if(vt.indexOf(listener)<0)
					vt.push(listener);	 
			}
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
				if(index==-1)
					return;
				if(!_isExecuteing)
				{
					vt.splice(index,1);
					if(vt.length==0)
						delete _dict.hasOwnProperty(type)					
				}
				else
				{
					if(_aryDel.indexOf(type+"&&" + index.toString())==-1)
						_aryDel.push(type+"&&" + index.toString());
				}
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
			_isExecuteing = true;
			if(_dict.hasOwnProperty(type))
			{
				var vt:Vector.<Function> = _dict[type] as Vector.<Function>;
				for (var i:int = 0; i < vt.length; i++)
				{
					if(_aryDel.length==0 || _aryDel.indexOf(type+"&&"+i.toString())==-1)						
						vt[i](param);
				}
				
				var tmp:Array;				
				while(_aryDel.length>0)				 
				{
					tmp = _aryDel.pop().split("&&");
					if(_dict.hasOwnProperty(tmp[0]))
					{
						vt = _dict[tmp[0]] as Vector.<Function>;
						if(vt.length>int(tmp[1]))
							vt.splice(int(tmp[1]),1);
						if(vt.length==0)
						{
							delete _dict[tmp[0]];
						}
					}
				}
			}
			
			var vt1:Vector.<Function> = _dict[type] as Vector.<Function>;
			for (var key:String in _dictTmpAdd) 
			{
				if(!_dict.hasOwnProperty(key))
				{
					_dict[key] = _dictTmpAdd[key];
					delete _dictTmpAdd[key];
				}
				else
				{
					vt = _dict[key] as Vector.<Function>;
					vt1 = _dictTmpAdd[key] as Vector.<Function>;
					for (var j:int = 0; j < vt1.length; j++) 
					{
						if(vt.indexOf(vt1[j])>=0)
						{
							vt1.splice(j,1);
							j--;
						}
					}
					vt = vt.concat(vt1);
					vt1.length = 0;
					delete _dictTmpAdd[key];
				}
			}
			
			
			_isExecuteing = false;
		}
		
		
		public function destroy():void
		{
		
			for (var key:String in _dict) 
			{
				if(_dict[key])				
					(_dict[key] as Vector.<Function>).length = 0;
				delete _dict[key];
			}
			_aryDel.length = 0;
			_aryDel = null;
			_dict = null;
		}
	}
}