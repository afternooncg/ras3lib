package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.manager.RUIManager;
	import com.wings.util.display.DisplayObjectKit;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 本类用于封装flashide制作的mcbutton(mcbutton必须支持以下规范:包括up/over/down/disabled4个iframeName）
	 * 	 
	 * @author hh
	 * 
	 */	
	public class RMovieClipButton extends RComponent implements IRButton
	{	
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		/**
		 *
		 * @param button  按钮 
		 * @param parent  父容器
		 * @param params  参数{x,y}
		 * 
		 */		
		public function RMovieClipButton(button:MovieClip,parent:DisplayObjectContainer=null, params:Object=null,isResetBtnXy:Boolean=true)
		{
			_btn = button;			
			if(_btn && isResetBtnXy)
				_btn.x = _btn.y = 0;
			super(parent,params);		
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		override protected function inits():void		
		{
			_isEnabledMask = false;		
			
			if(DisplayObjectKit.checkMcHasIframeName(_btn,_framelableUp))
				_btn.gotoAndStop(_framelableUp);
			else
				_btn.stop();			
			
			_w = _btn.width;			
			_h = _btn.height;
			
			super.inits();
			this.addChild(_btn);
			
			setmouseInterActive();		
			
			this.addEventListener(MouseEvent.ROLL_OVER,handleMouseOver);	
			this.addEventListener(Event.REMOVED_FROM_STAGE,handleOnRemoveToStage);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _framelableUp:String = "up";
		protected var _framelableOver:String = "over";
		protected var _framelableDown:String = "down";
		protected var _framelableSelected:String = "selected";
		protected var _framelableDisabled:String = "disabled";
		
		protected var _btn:MovieClip;
		protected var _isSelected:Boolean = false;			//是否被选中状态
		private var _buttonId:int;
		protected var _isPressed:Boolean = false;				//鼠标是否被按住		
		private var _pauseMouseEnabled :Boolean = false;     //是否处于暂时屏蔽mouseeanble状态,当_canDbClick=false时启用
		protected var _handleTimeOut:int =0;
		protected var _value:Object;
		protected var _canDbClick:Boolean = false;
		
		protected var _isSelecteOver:Boolean = true;				//selecte状态下 over 效果是否启用
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 仅外观设灰,保留鼠标功能,但是嵌入元件鼠标感应静止 
		 * @param value
		 * 
		 */	
		override public function set gray(value:Boolean):void
		{			
//			setmouseInterActive(!value);			
			super.gray = value;
			if(value)
			{
				if(this.checkHasIframeName("disabled"))
				{
					_btn.gotoAndStop("disabled");
					this.filters=null;
				}
				else
				{
					_btn.gotoAndStop(_framelableUp);					
				}				
			}
			else
			{
				if(_isSelected)
				{
					if(checkHasIframeName("selected"))
						_btn.gotoAndStop("selected");
					else if(checkHasIframeName("over"))
						_btn.gotoAndStop("over");
				}
				else
					_btn.gotoAndStop(_framelableUp);
					
			}
			
		}
		
		
		
		public function set isSelected(bool:Boolean):void
		{
			_isSelected = bool;			
			if(_isSelected) 
			{
				if(checkHasIframeName("selected"))
					_btn.gotoAndStop("selected");
				else if(checkHasIframeName("over"))	
					_btn.gotoAndStop("over");		
				if(isAutoGrow)
					this.filters = [getGrow()];
			}
			else
			{
				_btn.gotoAndStop(_framelableUp);
				this.filters = null;
			}
				
				
		}
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		
		public function set source(value:MovieClip):void
		{
			if(value) 
				_btn = value;
			for(var i:int=0;i<this.numChildren;i++)
			{
				this.removeChildAt(0);
			}
			this.addChild(_btn);
			this.name = _btn.name;
		}
		
		/**
		 *按钮ID 
		 * @param value
		 * 
		 */	
		public function set buttonId(value:int):void
		{
			_buttonId = value;
		}
		
		public function get buttonId():int
		{
			return _buttonId;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(data:Object):void
		{
			_value = data;
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if(!enabled)
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown) ;
				this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut) ;
				RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			}
		}
		
		public function set canDbClcik(bool:Boolean):void
		{
			this.doubleClickEnabled = true;
			_canDbClick = bool;
		}
		public function get canDbClcik():Boolean
		{
			this.doubleClickEnabled = false;
			return _canDbClick;
		}
		
		/**
		 * 选中状态是否启用over ui变化 
		 * @param bool
		 * 
		 */		
		public function set isSelectedOver(bool:Boolean):void
		{
			_isSelecteOver = bool;
		}
		
		
		/**
		 * 强行设置mouseenable,绕开 _handleTimeOut 的恢复动作
		 * @param bool
		 * 
		 */		
		public function set forceMouseEnable(bool:Boolean):void
		{
			clearTimeout(_handleTimeOut);
			this.mouseEnabled = bool;
		}
			
			
	

		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		/**
		 * 被子类override,控制 UI 界面绘制
		 */
		override public function drawUI():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000,0);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();
		}
		
		override public function destroy():void
		{		
			_btn.stop();
			this.removeChild(_btn);
			_btn = null;			
			clearTimeout(_handleTimeOut);
			this.removeEventListener(MouseEvent.ROLL_OVER,handleMouseOver);
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleFirstClick);
			this.removeEventListener(MouseEvent.MOUSE_UP,handleFirstClick);
			this.removeEventListener(MouseEvent.CLICK,handleFirstClick);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,handleFirstClick);
			this.removeEventListener(MouseEvent.MOUSE_WHEEL,handleFirstClick);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,handleOnRemoveToStage);
			super.destroy();
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 创建包裹RMovieClipButton 注意,对于父容器资源,如果包含mask的情况，有些时候可能导致被加到mask底下.需要手工调整childIndex或修改资源
		 * @param ct			容器
		 * @param mcName		需要包裹的mc
		 * @return 
		 * 
		 */		
		static public function createRmcBtnFromContainer(ct:DisplayObjectContainer,mcName:String,isResetXy:Boolean=true):RMovieClipButton
		{
			if(ct && mcName)
			{
				var mc:MovieClip = ct.getChildByName(mcName) as MovieClip;				
				if(mc)
				{						
					var btn:RMovieClipButton = new RMovieClipButton(mc,ct,{x:mc.x,y:mc.y,childIndex:ct.getChildIndex(mc)},isResetXy);
					if(isResetXy)
						mc.x = mc.y = 0;
					return btn;
				}				
				return null;
			}
			return null;
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * 必须被子类override 读取params参数,并做初始化工作 建立初始对象（非displayObject类型）
		 */		
		override protected function initProps():void
		{	
			if(_params==null) return;				
			if(_params.x) this.x = int(_params["x"]);
			if(_params.y) this.y = int(_params["y"]);
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		/**
		 * 恢复鼠标交互 
		 * 
		 */		
		protected function enableMouseEvent():void
		{
			setmouseInterActive();			
			_pauseMouseEnabled = false;
			//	this.mouseChildren = false;
			clearTimeout(_handleTimeOut);
		}
		
		/**
		 * 设置鼠标交互 
		 * 
		 */		
		private function setmouseInterActive(value:Boolean=true):void
		{
			this.buttonMode = this.mouseEnabled = value;
			
		}
		
		/**
		 *  检查是否存在指定iframename; 
		 * @param name
		 * @return 
		 * 
		 */		
		protected function checkHasIframeName(name:String):Boolean
		{
			if(_btn==null)
				return false;
			
			var labels:Array = _btn.currentLabels;			
			for (var i:uint = 0; i < labels.length; i++) 
			{
				var label:FrameLabel = labels[i];
				if(label.name == name)
					return true;
			}
			
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		/**
		 * 鼠标移入开始注册 
		 * @param event
		 * 
		 */					 
		protected function handleMouseOver(event:MouseEvent):void
		{
			if(_isGray || !_enabled)
				return;
			
			if((!_isSelected || (_isSelected && _isSelecteOver)) && checkHasIframeName("over"))
				_btn.gotoAndStop("over");
			this.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown) ;
			this.addEventListener(MouseEvent.ROLL_OUT,handleMouseOut) ;			
		}
		
		protected function handleOnRemoveToStage(event:Event):void
		{
			if(_btn.hitTestPoint(RUIManager.stage.mouseX,RUIManager.stage.mouseY))
			{//只有当mouse在btn上引起removestage动作才恢复
				_btn.gotoAndStop(_framelableUp);
			}	
		}
		
		protected function handleMouseDown(event:MouseEvent):void
		{	
			if((!_isSelected || (_isSelected && _isSelecteOver)) && checkHasIframeName("down"))
				_btn.gotoAndStop("down");
		
			_isPressed = true;			
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
		}
		
		
		
		/**
		 * 侦听鼠标释放动作 
		 * @param event
		 * 
		 */		
		protected function handleMouseUp(event:MouseEvent):void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			_isPressed = false;			
			if(!_canDbClick)
			{				
				this.mouseEnabled = false;		
				_pauseMouseEnabled = true;
				_handleTimeOut = setTimeout(enableMouseEvent,300);
			}
			
			if(_enabled)
			{
				if(_isSelected)
				{//按钮处于选中状态
					if(this.checkHasIframeName(_framelableSelected))
						_btn.gotoAndStop(_framelableSelected);
					else (this.checkHasIframeName(_framelableOver))
						_btn.gotoAndStop(_framelableOver);
				}
				else
				{//普通状态				
					if(!this.hitTestPoint(event.stageX,event.stageY))
					{//鼠标在按钮外释放
						if(this.checkHasIframeName(_framelableUp))
							_btn.gotoAndStop(_framelableUp);						
					}
					else
					{//鼠标在按钮内释放
						if(this.checkHasIframeName(_framelableOver))
							_btn.gotoAndStop(_framelableOver);
						RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
					}
				}		
			}
			else
			{
				if(this.checkHasIframeName(_framelableUp))
					_btn.gotoAndStop(_framelableUp);
				this.enabled = false;				
				clearTimeout(_handleTimeOut);
				resetEventListener();
			}
		}
		
		protected function resetEventListener():void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
			
		}		
		
		/**
		 * 释放所有监听 
		 * @param event
		 * 
		 */		
		protected function handleMouseOut(event:MouseEvent):void
		{				
			if(_isPressed)//点击状态,不做处理，交给mouseUp事件处理			
				return;
			onMouseActionCompleteOutBtn();
		}
		
		private function onMouseActionCompleteOutBtn():void
		{
			if(_enabled)
			{
				if(_isSelected)
				{
					if(this.checkHasIframeName("selected"))
						_btn.gotoAndStop("selected");
					else
						_btn.gotoAndStop("over");
				}
				else
					_btn.gotoAndStop(_framelableUp);
			}
			else
			{
				if(_btn.currentFrameLabel != _framelableUp && this.checkHasIframeName("disable"))
					_btn.gotoAndStop("disable");				
			}
			
			resetEventListener();
		}
		
		/**
		 * 如果isgray=true 中断当前节点上注册的鼠标事件 
		 * @param event
		 * 
		 */		
		private function handleFirstClick(event:MouseEvent):void
		{
			if(_isGray) event.stopImmediatePropagation();
		}
		
		override protected function handleMouseRoll(event:MouseEvent):void
		{			
			if(_isSelected)
				return;			
			super.handleMouseRoll(event);			
		}
		
	}
}