package com.wings.ui.manager
{
	import com.wings.ui.common.IRToolTips;
	import com.wings.ui.components.RTooltip;
	import com.wings.util.display.DisplayObjectKit;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	
	/**
	 * 全局悬停管理对象 使用前应需要先执行静态方法 init(),设置stage的引用
	 * @author hh
	 * 
	 */	
	public class RToolTipManager  
	{
		private static var _instance:RToolTipManager;
		private static var _stage:Stage;
		private static var _container:DisplayObjectContainer;		
		
		private var _currentTarget:DisplayObject;	//当前鼠标悬停对象
		private var _tip:RTooltip;		
		private var _moveCt:DisplayObjectContainer;			//移动用容器
		
		private var _lazyShowHandle:int = 0;				//延迟显示句柄
		private var _lastHideTickTime:int = 0;				//last hide time
		
		public function RToolTipManager(f:ForceClass)
		{
			if(f==null) throw new Error("单例类RToolTipManager不可实例");
			if(_stage==null  || _container==null) 
				throw new Error("先执行init初始化");
			
			_tip = new RTooltip();
			_moveCt = new Sprite();
			_moveCt.visible = _moveCt.mouseChildren = _moveCt.mouseEnabled = _moveCt.tabChildren = _moveCt.tabEnabled = false;
			_stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseDown);
		}
		
		/**
		 * 注意:必须在类实例创建先调用 
		 * @param stage
		 * @param container
		 * 
		 */		
		static public function init(stage:Stage,container:DisplayObjectContainer):void
		{
			if(stage==null || container==null) 
				throw new Error("RToolTipManager 初始化失败");
			_stage = stage;
			_container = container;			
		}
		
		
		
		static public function getInstance():RToolTipManager
		{
			if(_instance==null)
				_instance = new RToolTipManager(new ForceClass());
			return _instance;
		}
		
		/**
		 * 悬停显示对象.请勿操作 
		 * @return 
		 * 
		 */		
		public function globalToLocal(p:Point):Point
		{
			if(p == null)
				p = new Point(0,0);
			return _container.globalToLocal(p);			
		}
		
		/**
		 * 注册悬停 
		 * @param target  目标对象
		 * @param isShowAtOnce	  是否马上显示tip对象
		 * 
		 */		
		public function register(target:DisplayObject,isShowAtOnce:Boolean=false):void
		{
			if(target && (target is IRToolTips))
			{					
				target.addEventListener(MouseEvent.ROLL_OVER,handleMouseEvent);
				if(isShowAtOnce && target.stage && target.hitTestPoint(_stage.mouseX,_stage.mouseY))
					showTipAtonce(target);
			}
		}
		
		
		
		/**
		 * 清除悬停注册 该方法有俩处调用点,第1个是当前对象鼠标移出时调用，另个是RCompent对象被Destroy时调用 
		 * @param target 
		 * @param isHide  true:隐藏状态,消除除over外的所有事件/false，从系统中移除注册
		 * 
		 */		
		public function unregister(target:DisplayObject,isHide:Boolean=false):void
		{	
			if(target==null) return;		
			
			target.removeEventListener(MouseEvent.ROLL_OUT, handleMouseOutMoveEvent);  
			target.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseOutMoveEvent);  
			
			target.removeEventListener(Event.REMOVED_FROM_STAGE,handleRemoveToStage);
				
			if(isHide)
			{//_currentTarget是当前_target说明是当前对象,是isHide=true的情况,否则就是其他对象调用的销毁过程
				//_stage.removeEventListener(MouseEvent.MOUSE_UP,handleRemoveToStage);
				while(_moveCt.numChildren>0)
					_moveCt.removeChildAt(0);
				if(_container.contains(_container))					
					_container.removeChild(_moveCt);
				_currentTarget = null; //注意对_currentTarget的保护,否则可能造成mousemove事件 操作对象丢失
				RUIManager.getInstance().unRegistEnterFrameListener(handleEnterFrame);		
			}
			else
			{//正式销毁	
				if(target==_currentTarget)
				{//如果是自己也应做清理
					while(_moveCt.numChildren>0)
						_moveCt.removeChildAt(0);
					if(_container.contains(_container))					
						_container.removeChild(_moveCt);
					_currentTarget = null; //注意对_currentTarget的保护,否则可能造成mousemove事件 操作对象丢失
					RUIManager.getInstance().unRegistEnterFrameListener(handleEnterFrame);		
				}	
				target.removeEventListener(MouseEvent.ROLL_OVER,handleMouseEvent);
				
			}			
					
		}
		
		private function show():void 
		{   
			if(_currentTarget && (_currentTarget is IRToolTips))
			{
				var tpObj:IRToolTips = _currentTarget as IRToolTips;	
				if(tpObj.toolTip==null || tpObj.toolTip.toString()=="")
					return;
				
				(_currentTarget as IRToolTips).updateTipOnShow();					
				if(!checkIsRichToolTip(tpObj))
				{//优先显示文本悬停
					_tip.text = (_currentTarget as IRToolTips).toolTip.toString();
					if(_tip.text!="" && !_moveCt.contains(_tip))
					{
						_tip.x = _tip.y = 0;
						_moveCt.addChild(_tip);
					}
				}
				else
				{
					if(_moveCt.contains(_tip))
						_moveCt.removeChild(_tip);
					
					if(tpObj.toolTip)
					{
						var disp:DisplayObject = tpObj.toolTip as DisplayObject;	
						_moveCt.addChild(disp);
						disp.x = disp.y = 0;
						for (var i:int = 0; i < _moveCt.numChildren; i++) 
						{
							if(_moveCt.getChildAt(i) != disp)
							{								
								_moveCt.removeChildAt(i);
								i--;
							}
						}
						
						
					}
				}
				
				_currentTarget.addEventListener(MouseEvent.ROLL_OUT, handleMouseOutMoveEvent);  
				_currentTarget.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseOutMoveEvent);				
				_currentTarget.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoveToStage);				
				if(tpObj.isUpdateTooltipRealTime && !checkIsRichToolTip(tpObj))
				{
					RUIManager.getInstance().registEnterFrameListener(handleEnterFrame);
				}
				
				_container.addChild(_moveCt);
				DisplayObjectKit.moveTopZ(_moveCt);
				
				_moveCt.visible = false;
				if(getTimer()-_lastHideTickTime > 200)
				{
					_lazyShowHandle = setTimeout(showMoveCt,200);
				}
				else
					_lazyShowHandle = setTimeout(showMoveCt,50);
			}
		}
		
		private function showMoveCt():void
		{
			_moveCt.visible = true;
			this.move(new Point(RUIManager.stage.mouseX, RUIManager.stage.mouseY));
		}
		
		protected function handleMouseOutMoveEvent(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OUT:  
				case MouseEvent.MOUSE_UP:
					this.hide();  
					break;  
				
				case MouseEvent.MOUSE_MOVE:  
					this.move(new Point(event.stageX, event.stageY));                     
					break;
			}
		}
		
		private function handleEnterFrame(event:Event=null):void
		{
			if(_tip!=null && _currentTarget!=null)
				_tip.text = (_currentTarget as IRToolTips).toolTip.toString();
			else
				RUIManager.getInstance().unRegistEnterFrameListener(handleEnterFrame);
		}
		
		public function hide():void 
		{  	
			clearTimeout(_lazyShowHandle);
			_lastHideTickTime = getTimer();
			if(_currentTarget)
			{			   
				this.unregister(_currentTarget,true);
			}	
		}
		
		
		
		/**
		 *  
		 * @param point
		 * 
		 */	   
		private function move(point:Point):void 
		{               
			if(point && _moveCt)
			{	
				var tpObj:IRToolTips = _currentTarget as IRToolTips;
				if(tpObj==null)
					return;
				if(tpObj.fiexedPosi==null)
				{
					_moveCt.x = point.x + 20;            
					_moveCt.y = point.y + 20;  
					
					//检证坐标 是否_tip完全显示
					if(!DisplayObjectKit.isVisibleOnScreen(_moveCt))
					{
						if(_moveCt.x >= _stage.stageWidth -_moveCt.width) //偏右,调到鼠标左边
							_moveCt.x = point.x -_moveCt.width - 20;
						
						if(_moveCt.x<0)	 //偏左,居中
							_moveCt.x =  (_stage.stageWidth -_moveCt.width)*.5;
						
						if(_moveCt.y >= _stage.stageHeight - _moveCt.height)//偏下,调下鼠标上边
							_moveCt.y = point.y - _moveCt.height - 20;	
						
						if(_moveCt.y<0)	 //偏上,居中
							_moveCt.y =  (_stage.stageHeight -_moveCt.height)*.5;
					}   
				}
				else
				{
					var p:Point  = _currentTarget.localToGlobal(tpObj.fiexedPosi);			
					p = globalToLocal(p);
					_moveCt.x = p.x;            
					_moveCt.y = p.y;  
				}
				
				//				var p1:Point = new Point(_moveCt.x,_moveCt.y);
				//				p1 = _moveCt.parent.localToGlobal(p1);
				//				p1.x = int(p1.x);
				//				p1.y = int(p1.y);
				//				p1 = _moveCt.parent.globalToLocal(p1);
				_moveCt.x = int(_moveCt.x);            
				_moveCt.y = int(_moveCt.y);
				
			}		
		}  
		
		/**
		 * 当鼠标移到目标对象上(产生悬停的显示对象) 
		 * @param event
		 * 
		 */					    	
		private function handleMouseEvent(event:MouseEvent):void
		{
			//			trace(event.type +","+ (event.target as DisplayObject).name +","+ event.target+","+event.currentTarget.name);
			
			var target:DisplayObject = event.currentTarget as DisplayObject;
			showTipAtonce(target);
			
		}
		
		/**
		 * 马上显示对象 
		 * 
		 */		
		private function showTipAtonce(target:DisplayObject):void
		{			
//			while(_moveCt.numChildren)
//				_moveCt.removeChildAt(0);
			
			if(target == null || (_currentTarget!=null && _currentTarget!=target) || _currentTarget==_stage)
			{				
				hide();
				return;
			}
			
			_currentTarget = target;			
			this.show();  
			this.move(new Point(_stage.mouseX,_stage.mouseY));	
		}
		
		
		/**
		 *  检查是否自定义显示tip 
		 * @param target
		 * @return 
		 * 
		 */		
		private function checkIsRichToolTip(target:IRToolTips):Boolean
		{					
			if(target && target.toolTip && (target.toolTip is DisplayObject))			
				return  true;
			else
				return	 false;			
		}
		
		private function handleRemoveToStage(event:Event):void
		{
			this.hide(); 
		}
		
		/**
		 * 只要有点击事件 
		 * @param event
		 * 
		 */		
		protected function handleStageMouseDown(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_DOWN)
				_stage.addEventListener(MouseEvent.MOUSE_UP,handleStageMouseDown);
			else if(event.type == MouseEvent.MOUSE_UP)
				_stage.removeEventListener(MouseEvent.MOUSE_UP,handleStageMouseDown);
			if(_moveCt)
			{
				while(_moveCt.numChildren>0)
					_moveCt.removeChildAt(0);
			}
		}
		
	}
}

class ForceClass{}