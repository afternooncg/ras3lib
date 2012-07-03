package com.wings.ui.manager
{
	import com.wings.ui.common.IStageResize;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 本类提供1个UI容器环境定义 从下到上分为分为 
	 * 主界面容器 / POPUI容器 / 悬停容器 / 自定义鼠标容器
	 * 本类执行init后,将在stage次序建立容器,同时还提供RPopWinManager/RToolTipManager 初始化功能
	 *	  
	 * @author hh
	 * 
	 */	
	public class RUIManager extends EventDispatcher
	{
		private static var _instance:RUIManager;
		private static var _stage:Stage;
		private static var _fullScreenMode:int=0;	
		
		private static var _vtUIs:Vector.<IStageResize>;						//存放注册侦听onresize UI
		private static var _vtEnterFrame:Vector.<Function>;						//存放注册侦听enterframe UI
		
//		主界面容器
		private var _mainCt:DisplayObjectContainer;
//		pop容器
		private var _popCt:DisplayObjectContainer;
//		指示器（新手指引等）容器	
		private var _indCt:DisplayObjectContainer;
		
		//系统浮动消息
		private var _systemFloatMsgCt:DisplayObjectContainer;
		
		
//		tooltip容器
		private var _tooltipCt:DisplayObjectContainer;
//		鼠标容器
		private var _mouseCt:DisplayObjectContainer;
		
		private var _newbieGuideCt : DisplayObjectContainer;
				
		static private var _maxW:Number;
		static private var _maxH:Number; 
		
		public function RUIManager(f:ForceClass)
		{
			if(f==null) throw new Error("单例类RUIManager不可实例");
			if(_stage==null) throw new Error("先执行init初始化");
			
			_vtUIs = new Vector.<IStageResize>();
			_vtEnterFrame = new Vector.<Function>();
			_mainCt = new Sprite();
			_stage.addChild(_mainCt);
			
			_popCt = new Sprite();
			
			_stage.addChild(_popCt);
			
			_indCt = new Sprite();
			_stage.addChild(_indCt);
			
			_systemFloatMsgCt = new Sprite();
			_stage.addChild(_systemFloatMsgCt);
			
			_tooltipCt = new Sprite();
			_stage.addChild(_tooltipCt);
			
			_newbieGuideCt = new Sprite();
			_stage.addChild(_newbieGuideCt);
			
			_mouseCt = new Sprite();
			_stage.addChild(_mouseCt);
						
			//容器自身的鼠标感应全部去除
			_mainCt.mouseEnabled = _popCt.mouseEnabled = _tooltipCt.mouseEnabled = _newbieGuideCt.mouseEnabled = _mouseCt.mouseEnabled = _systemFloatMsgCt.mouseEnabled =  false;
			
			RPopWinManager.init(_stage, _popCt,_fullScreenMode,_maxW,_maxH);
			RToolTipManager.init(_stage,_tooltipCt);
			if(_fullScreenMode==1)
			{
				_stage.addEventListener(Event.RESIZE,handleOnResize);
			}
		}
		

		/**
		 * 环境初始化
		 * @param stage
		 * @param fullScreenMode 0 no scale/1 full/2 scale full 
		 * 
		 */		
		static public function init(stage:Stage,fullScreenMode:int=0,maxW:Number=0,maxH:Number=0):void
		{
			if(stage==null) throw new Error("RUIManager 初始化失败");
			_stage = stage;		
			
			_fullScreenMode = fullScreenMode;
			_maxW = maxW;
			_maxH = maxH;
			_instance = new RUIManager(new ForceClass());
		}
		
		static public function getInstance():RUIManager
		{
			if(_instance==null) _instance = new RUIManager(new ForceClass());
			return _instance;
		}
		
		static public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * 主界面容器  
		 * @return 
		 * 
		 */		
		public function get mainCt():DisplayObjectContainer
		{
			return _mainCt;
		}
		
		/**
		 *  pop容器
		 * @return 
		 * 
		 */		
		public function get popCt():DisplayObjectContainer
		{
			return _popCt;
		}
		
		/**
		 * 指示器容器 
		 * @return 
		 * 
		 */		
		public function get indCt():DisplayObjectContainer			
		{
			return _indCt;
		}
		
		/**
		 * 系统浮动消息层 
		 * @return 
		 * 
		 */		
		public function get systemFloatMsgCt():DisplayObjectContainer
		{
			return _systemFloatMsgCt;
		}
		
		/**
		 * 悬停容器
		 * @return 
		 * 
		 */		
		public function get tooltipCt():DisplayObjectContainer
		{
			return _tooltipCt;	
		}
		
		/**
		 * 新手引导层 
		 */		
		public function get newbieGuideCt() : DisplayObjectContainer
		{
			return _newbieGuideCt;
		}
		
		
		/**
		 * 自定义鼠标容器 
		 * @return 
		 * 
		 */		
		public function get mouseCt():DisplayObjectContainer			
		{
			return _mouseCt;
		}
		
		/**
		 * get ui by uid 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getUIByName(name:String):DisplayObject
		{
			for(var i:uint=0;i<_vtUIs.length;i++)
			{
				var disp:DisplayObject = _vtUIs[i] as DisplayObject;
				if(disp && disp.name ==name) return disp; 
			}
			return null;
		}
		
		/**
		 * 注册要侦听stageReize事件的对象,统一管理
		 * @param disp
		 * 
		 */		
		public function registStageResizeUI(disp:IStageResize):void
		{
			if(disp==null)
				return;
			if(_vtUIs.indexOf(disp)<0)
				_vtUIs.push(disp);
		}
		
		/**
		 * 去除要侦听stageReize事件的对象,通常应在该对象被destory时调用
		 * @param disp
		 * 
		 */		
		public function unRegistStageResizeUI(disp:IStageResize):void
		{
			if(disp==null)
				return;
			
			if(_vtUIs.indexOf(disp)>=0)
				_vtUIs.splice(_vtUIs.indexOf(disp),1);
		}
		
		/**
		 * 注册要侦听Enterframe事件的对象,统一管理,fn无参数
		 * @param fn
		 * 
		 */		
		public function registEnterFrameListener(fn:Function):void
		{
			if(fn==null)
				return;			
			if(_vtEnterFrame.indexOf(fn)<0)
			{
				_vtEnterFrame.push(fn);
				_stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
			}			
		}
		public function unRegistEnterFrameListener(fn:Function):void
		{
			if(fn==null)
				return;
			if(_vtEnterFrame.indexOf(fn)>=0)
				_vtEnterFrame.splice(_vtEnterFrame.indexOf(fn),1);
			
			if(_vtEnterFrame.length==0)
				_stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		/**
		 * 场景变换 
		 * @param event
		 * 
		 */				
		private function handleOnResize(event:Event):void
		{
			var w:Number = 0;
			var h:Number = 0;	
						
			if(_stage.displayState == StageDisplayState.NORMAL)
			{
				w = _stage.stageWidth;
				h = _stage.stageHeight;
			}
			else
			{
				w = _stage.fullScreenWidth
				h = _stage.fullScreenHeight;
			}
			
			var vt:Vector.<IStageResize> = _vtUIs.slice();
			var len:int = vt.length;
			for (var i:int = 0; i <len; i++) 
			{
				if(vt[i]!=null && _vtUIs.indexOf(vt[i])>=0)
					vt[i].onStageResize(w,h);				
			}
				
		}
		
		private function handleEnterFrame(event:Event):void
		{
			
			var vt:Vector.<Function> = _vtEnterFrame.slice();
			var len:int = vt.length;
			for (var i:int = 0; i <len; i++) 
			{
				if(vt[i]!=null && _vtEnterFrame.indexOf(vt[i])>=0)
					vt[i](event);				
			}
			
			
			
		}
	}
}

class ForceClass{}
