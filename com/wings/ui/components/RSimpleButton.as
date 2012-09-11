package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 本类用于封装flashide制作的simplebutton 
	 * 2012/2/20 升级 注意  simplebutton被封装后，将会被从其父容器移除,而只作为1个UI源提供者 
	 * 目前暂只实现对simplebutton的支持
	 * @author hh
	 * 
	 */	
	public class RSimpleButton extends RComponent implements IRButton
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
		public function RSimpleButton(button:SimpleButton,parent:DisplayObjectContainer=null, params:Object=null,isResetBtnXy:Boolean=true)
		{
			_btn = button;
			if(_btn && isResetBtnXy)
				_btn.x = _btn.y = 0;
			if(_btn && _btn.parent)
				_btn.parent.removeChild(_btn);
			super(parent,params);		
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
//		public function get btn():SimpleButton
//		{
//			return _btn;
//		}

		override protected function inits():void		
		{
			_isEnabledMask = false;			
			_w = _btn.width;			
			_h = _btn.height;
			
			super.inits();
			
			this.addBtnState(_btn.upState);
			setmouseInterActive();
			this.addEventListener(MouseEvent.ROLL_OVER,handleMouseOver);
			this.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoveToStage);	
		}
		
		protected function handleMouseOver(event:MouseEvent):void
		{
			if(_isGray || !_enabled)
				return;
			
			if((!_isSelected || (_isSelected && _isSelecteOver)))
			{			
				this.addBtnState(_btn.overState);
			}
			this.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown) ;
			this.addEventListener(MouseEvent.ROLL_OUT,handleMouseOut) ;
			
		}
		
		protected function handleMouseOut(event:MouseEvent):void
		{			
			this.addBtnState(_btn.upState);
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _btn:SimpleButton;
		protected var _isSelected:Boolean = false;			//是否被选中状态
		private var _buttonId:int;
		protected var _isPressed:Boolean = false;				//鼠标是否被按住		
		private var _pauseMouseEnabled :Boolean = false;     //是否处于暂时屏蔽mouseeanble状态,当_canDbClick=false时启用
		protected var _handleTimeOut:int =0;
		protected var _value:*;
		protected var _isSelecteOver:Boolean = true;				//selecte状态下 over 效果是否启用
		protected var _canDbClick:Boolean = false;
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
			// _btn.enabled = _btn.mouseEnabled = !value;
			
			super.gray = value;
		}
		
		public function set isSelected(bool:Boolean):void
		{
			_isSelected = bool;			
			if(_isSelected) 
			{
				this.addBtnState(_btn.overState);
			}
			else
			{
				this.addBtnState(_btn.upState);
			}
		}
		public function get isSelected():Boolean
		{
			return _isSelected;			
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(data:Object):void
		{
			_value = data;
		}
		
		public function set source(value:SimpleButton):void
		{
			
			for(var i:int=0;i<this.numChildren;i++)
			{
				this.removeChildAt(0);
			}
			if(value) 
			{				
				_btn = value;
				if(_btn.parent)
					_btn.parent.removeChild(_btn);
				this.addChild(_btn.upState);
				this.name = _btn.name;
			}
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
			super.destroy();
			resetEventListener();			
			this.removeEventListener(Event.REMOVED_FROM_STAGE,handleRemoveToStage);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);	
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
		static public function createRmcBtnFromContainer(ct:DisplayObjectContainer,mcName:String,isResetXy:Boolean=true):RSimpleButton
		{
			if(ct && mcName)
			{
				var mc:SimpleButton = ct.getChildByName(mcName) as SimpleButton;
				if(mc)
				{	
					var btn:RSimpleButton = new RSimpleButton(mc,ct,{x:mc.x,y:mc.y, childIndex:ct.getChildIndex(mc)},isResetXy);		
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
		
		override protected function invalidate():void
		{
			drawUI();
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
		 * 该处是配合双击禁用设置，当每次MouseDown后,会短暂设置鼠标感应失效,计时过后，恢复鼠标交互状态 
		 * 
		 */		
		private function setmouseInterActive():void
		{
			this.mouseEnabled = true;			
		}
		
		
		private function addBtnState(state:DisplayObject):void
		{
			if(state)
			{
				if(this.numChildren>0)
					this.removeChildAt(0);
				this.addChild(state);
			}
		}
		
		protected function resetEventListener():void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
			
		
		protected function handleMouseDown(event:MouseEvent):void
		{
			this.addBtnState(_btn.downState)
			_isPressed = true;			
			this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut) ;
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
		}
		
		
		protected function handleMouseUp(event:MouseEvent):void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);			
			_isPressed = false;
			_pauseMouseEnabled = true;			
			
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
					if(_isSelecteOver)
						this.addBtnState(_btn.downState)
					else		
						this.addBtnState(_btn.overState);
					resetEventListener();
				}
				else
				{//普通状态				
					if(!this.hitTestPoint(event.stageX,event.stageY))
					{//鼠标在按钮外释放
						if(_isSelected)
						{
							this.addBtnState(_btn.overState);
						}
						else
							this.addBtnState(_btn.upState)
						resetEventListener();
					}
					else
					{//鼠标在按钮内释放
						if(this.enabled)
						{
							this.addBtnState(_btn.overState);					
							this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
						}	
						RUIManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
					}
				}			
			}
			else
			{
				this.addBtnState(_btn.upState);
				this.enabled = false;				
				clearTimeout(_handleTimeOut);
				resetEventListener();
			}
			
		}
		
		protected function handleMouseMove(event:MouseEvent):void
		{
			if(!this.hitTestPoint(event.stageX,event.stageY))
			{
				this.addBtnState(_btn.upState);		
				enableMouseEvent();
				RUIManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
			}			
		}
		
		override protected function handleMouseRoll(event:MouseEvent):void
		{			
			if(_isSelected)
				return;			
			super.handleMouseRoll(event);			
		}
		
		protected function handleRemoveToStage(event:Event):void
		{
			this.addBtnState(_btn.upState);			
		}
		
		
	
	}
}