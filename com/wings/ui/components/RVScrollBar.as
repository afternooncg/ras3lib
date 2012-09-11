package com.wings.ui.components
{
	import com.wings.ui.common.RUIAssets;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	/**
	 * 针对sprite的垂直滚动条，和RVScrollPanle配合使用
	 * (new RVScrollBar()).body = target
	 * 注意对scrollBarMc制作要求，要求scrollBarMc.widht应和mc内所有的子元素width都想等
	 * @author hh
	 * 
	 */	
	public class RVScrollBar extends RBaseComponents
	{
		public function RVScrollBar(scrollBarMc:DisplayObjectContainer=null,params:Object=null,isForceHandlerSize:Boolean=false,onScrollCallBack:Function=null)
		{
			_isForceHandlerSize = isForceHandlerSize;
			_view = scrollBarMc==null ? RUIAssets.getInstance().GetObject("ScrollBar_mc") as DisplayObjectContainer : scrollBarMc;
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			_onScrollCallBack = onScrollCallBack;
			super(null, params);
		}
		
		protected function handleAddToStage(event:Event):void
		{	
			if(event.type == Event.ADDED_TO_STAGE)
			{
				this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
				this.addEventListener(Event.REMOVED_FROM_STAGE,handleAddToStage);
				this.parent.addEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
				this.removeEventListener(Event.REMOVED_FROM_STAGE,handleAddToStage);
				this.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);				
			}
		}
		
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
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{	
			super.inits();			
			this.mouseChildren = true;	
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		////接口元件
		private var _view : DisplayObjectContainer;		
		private var _btnUp:SimpleButton;
		private var _btnDown:SimpleButton;
		private var _draghandle:Sprite;		 //拖动块		
		private var _bgBar:Sprite;				//接受点击事件的背景条		
		
		private var _scrollContent:DisplayObject;			//待滚动目标存放容器
		private var _isPressed:Boolean = false;		//是否在btnUp或btnDown上按住鼠标左键
		
		private var _position:Number = 0;
		private var _movingTarget:Number = 0;		//单次滚动预定位置
		private var _scrollLineHeight:Number = .1;			//单击上下按钮移动距离控制
		private var _isForceStep:Boolean = false;		//是否指定滚动步长
		private var _currentLine:int = 0;				//只有指定了步长才有效
		private var _tmpy:Number=0;					//存在鼠标点击临时值
		private var _tmpy1:Number=0;					//存临时滚动值。为了解决被重写的displayObject.y为int的情况，导致判断值不变的情况
		private var _direction:int = 1;			//方向1是向下 -1.是向上
		
		private var _offerWidth:int=0;				//设定滚动条平移位置.
		private var _page:Number;					//点击上下按钮默认滚动距离
		
		private var _isAlwaysShow:Boolean = false;
		private var _bgDisplayObj:DisplayObject;
		private var _isForceHandlerSize:Boolean = false;
		private var _countBodyHeight:Number=-1;			//计算高度
		private var _longPressTime:int = 150;			//避免长按过于灵敏.默认设0.15
		private var _pressTime:int = 0;				//按下计时
		private var _onScrollCallBack:Function;
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		/**
		 * 内部用计算用高度 
		 * @return 
		 * 
		 */				
		private function get countHeight():Number
		{			
			if(_countBodyHeight!=-1 && _countBodyHeight >_h)
			{
				return _countBodyHeight;
			}
			else if(_scrollContent)
				return _scrollContent.height;
			else
				return _h;
		}
		
		public function get countBodyHeight():Number
		{
			return _countBodyHeight;
		}
		
		/**
		 * 计算用高度  
		 * @param value
		 * 
		 */		
		public function set countBodyHeight(value:Number):void
		{
			_countBodyHeight = value;
		}
		
		/**
		 * 当前行 
		 * @param value
		 * 
		 */		
		public function set currentLine(value:int):void
		{
			if(_isForceStep)
			{
				//var tick:Number = _scrollLineHeight* (this.countHeight-_h); //实际单行高度		
				var total:int = 1/_scrollLineHeight;
				if(value<0)
					value=0;
				if(value>total)
					value=total;
				
				_position = value/total;
				_currentLine = value;
				invalidate();
			}
			
		}
		
		public function get currentLine():int
		{
			if(_isForceStep)
			{
				return _currentLine;
			}
			else
			{
				if(_scrollContent)
					return _scrollContent.y;
				else
					return _currentLine;
			}
		}
		
		/**
		 *设置被滚动的对象 
		 * @param baby
		 * 
		 */		
		public function set body(baby:DisplayObject):void
		{
			if(!body)
			{	
				return;
			}
			_movingTarget = 0;
			_scrollContent= baby ;//as Sprite;			
			
			//while (_contentCt.numChildren > 0) _contentCt.removeChildAt(0);
			_scrollContent.y=0;
			baby.x = baby.y = 0;
			if(_draghandle!=null)
			{
				_draghandle.y = _btnUp.height;							
			}
			_position=0;
			//_contentCt.addChild(baby);			
			invalidate();
		}
		
		/**
		 * 获取被滚动的对象 
		 * @return 
		 * 
		 */		
		public function get body():DisplayObject
		{
			return _scrollContent;
			//	return (_contentCt.numChildren > 0) ?	 _contentCt.getChildAt(0) : null;			
		}		
		
		
		
		/**
		 * 滚动条和显示内容间距
		 * @param value
		 * 
		 */		        
		public function set offerWidth(value:int):void{
			_offerWidth=value;
			_view.x = _offerWidth;
		}
		
		
		public function hideScrollBar():void
		{
			if(!_isAlwaysShow) 
				_view.visible = false;  
		}
		
		
		/**
		 * 点击上下按钮滚动距离
		 * 
		 */		
		public function set scrollLineHeight(value:Number):void
		{
			if(_scrollContent) _scrollLineHeight = value/(this.countHeight-_h);
			_isForceStep = true;
		}
		public function get scrollLineHeight():Number
		{
			return _scrollLineHeight;		
		}
				
		/**
		 * 是否开启上下按钮长按 
		 * @param value
		 * 
		 */		
		public function set isOpenLongPress(value:Boolean):void
		{
			_isForceStep = value;
		}
		public function get isOpenLongPress():Boolean
		{
			return _isForceStep; 
		}
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{
			_btnUp.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnGoUp);
			_btnDown.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnGoDown);
			if(_draghandle!=null){
				_draghandle.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnDargHanleMouseDown);
			}
			//this.removeEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);
			removeEventListener(Event.ENTER_FRAME, moving);				
			
			if(this.parent)
				this.parent.removeEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);			
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,handleAddToStage);
			
			_bgBar = null;
			_btnDown = null;
			_btnUp = null;
			_draghandle = null;			
			_view = null;
			
			//if(_contentCt.numChildren>0) _contentCt.removeChildAt(0);
			_scrollContent = null;
			
			super.destroy();
		}
		
		
		override public function drawUI():void
		{	_w = _w==0 ? _view.width : _w;
			_h = _h==0 ? _view.height : _h;			
			
			_bgBar.width = _w;
			_bgBar.y = _draghandle.y = _btnUp.height;
			_bgBar.height = _h - _btnUp.height*2;
			_bgDisplayObj.height = _h;			
			
			_btnDown.y = _bgBar.y + _bgBar.height;
			countDragHandleHeight();	
			
			if(!_isAlwaysShow) _view.visible  =  this.countHeight >_h  ? true : false;
			
			_draghandle.visible = _view.mouseEnabled =_view.mouseChildren=  this.countHeight >_h  ? true : false;
			
			if(_isForceStep)
			{
				var segmentation:int = 1/_scrollLineHeight;				
				_position = _currentLine /segmentation;
				var tmpy:Number = -(this.countHeight)*_position;
				fixLastPosi(tmpy);
			}
			
			
			//			fordebug
			//			this.graphics.clear();
			//			this.graphics.beginFill(0x0000ff,0);
			//			this.graphics.drawRect(0,0,this.width,this.height);
			//			this.graphics.endFill();
			super.drawUI();
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		override protected function addChildren():void
		{	
			super.addChildren();
			
			_btnUp = SimpleButton(_view.getChildByName("up_btn"));
			_btnDown = SimpleButton(_view.getChildByName("down_btn"));
			_draghandle = Sprite(_view.getChildByName("pole_mc"));
			_bgBar = Sprite(_view.getChildByName("bg_mc"));
			_bgBar.alpha = 0;
			_bgDisplayObj = Sprite(_view.getChildByName("bgForShow"));
			
			
			configEventListeners();
			
			_scrollContent = new Shape();		//临时替代物		
			//			this.addChildAt(_contentCt,0);			
			this.addChild(_view);
			
			
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		
		/**
		 * 添加各种侦听 
		 * 
		 */		
		private function configEventListeners():void
		{
			_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, handleOnGoUp);
			_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, handleOnGoDown);
			if(_draghandle!=null){
				_draghandle.addEventListener(MouseEvent.MOUSE_DOWN, handleOnDargHanleMouseDown);
			}
			_bgBar.addEventListener(MouseEvent.MOUSE_DOWN, handleOnBgBarMouseDown);
			//this.addEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);
		}
		
		
		/**
		 * 移除各种侦听 
		 * 
		 */		
		private function removeEventListeners():void
		{
			_btnUp.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnGoUp);
			_btnDown.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnGoDown);
			if(_draghandle!=null){
				_draghandle.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnDargHanleMouseDown);
			}
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, handleOnMouseWheelForContent);
		}
		
		/**
		 * 计算滑块高度 
		 * 
		 */		
		private function countDragHandleHeight():void
		{	
			if(_draghandle && this.countHeight>0)
			{
				var poleStartHeight:Number = Math.floor(_btnDown.y - _btnUp.y - _btnUp.height);
				//初始化滑块的高度
				if(!_isForceHandlerSize)
				{
					_draghandle.height = this.visibleHeight * poleStartHeight / this.countHeight;
					_draghandle.y = (_bgBar.height - _draghandle.height) * _position + _btnUp.height;
				}
			}
		}		
		
		private function startMovingWithStep():void
		{			
			var tmpy:Number = countSegmentation(_position);			
			fixLastPosi(tmpy);
			if (!hasEventListener(Event.ENTER_FRAME))
			{
				addEventListener(Event.ENTER_FRAME, movingSetp);
			}
		}
		
		/**
		 * 指定步长移动后计算位置 ,这种模式要求设置配套正确的countBodyHeight和scolllineheight,才能得到精确的移到位置
		 * @param tmpy
		 * 
		 */		
		private function fixLastPosi(tmpy:Number):void
		{
			var oldscY:Number = _scrollContent.y; 
			if(tmpy<(_h - this.countHeight))
				tmpy = _h- this.countHeight  ;
			if(tmpy>0)	
				tmpy = 0;
			_scrollContent.y = tmpy;
			
			_position = Math.abs(tmpy)/(this.countHeight-_h);
			if(_draghandle!=null)
				_draghandle.y = (_bgBar.height - _draghandle.height) * _position + _btnUp.height;
			
			if(_onScrollCallBack!=null && oldscY!=_scrollContent.y)
				_onScrollCallBack();
		}
		
		protected function movingSetp(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, movingSetp);			
			
			//				如果长按,继续滚动
			if(_isPressed)
			{
				if((getTimer()-_pressTime)>=_longPressTime)
				{
					_pressTime = getTimer();
					_position += _scrollLineHeight * _direction;
					startMovingWithStep();
				}
				else
					addEventListener(Event.ENTER_FRAME, movingSetp);	
			}				
			
		}
		
		/**
		 * 开始滚动之前的准备工作 
		 * 
		 */		
		private function startMoving():void
		{
			//			纠正控制position为0或1
			_position < 0 && (_position = 0);
			_position > 1 && (_position = 1);
			
			_movingTarget = -(this.countHeight - _h) * _position;
						
			if(_draghandle!=null){
				_draghandle.y = (_bgBar.height - _draghandle.height) * _position + _btnUp.height;				
			}
			
			if (!hasEventListener(Event.ENTER_FRAME) && (_scrollContent.y != _movingTarget))
			{
				addEventListener(Event.ENTER_FRAME, moving);
			}
		}
		
		
		/**
		 * 移动被滚动的显示对象
		 * @param evt
		 * 
		 */		
		private function moving(evt:Event):void
		{
			_tmpy1 += (_movingTarget - _tmpy1) * .8
			_scrollContent.y += (_movingTarget - _scrollContent.y) * .8;			
			if (Math.abs(_tmpy1 - _movingTarget)<=1)
			{
				removeEventListener(Event.ENTER_FRAME, moving);			
				_scrollContent.y = _movingTarget;								
				//				如果长按,继续滚动
				if(_isPressed)
				{
					if((getTimer()-_pressTime)>=_longPressTime)
					{
						_pressTime = getTimer();
						_position += _scrollLineHeight * _direction;
						startMoving();						
					}
					else
						addEventListener(Event.ENTER_FRAME, moving);
				}				
			}
		}
		
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
		 * 向上按钮 
		 * @param evt
		 * 
		 */
		private function handleOnGoUp(event:MouseEvent):void
		{
			_pressTime = getTimer();
			_tmpy1 = 0;
			stage.addEventListener(MouseEvent.MOUSE_UP, handleOnStageMouseUp);			
			_isPressed = true;
			_direction = -1;
			_position -= _scrollLineHeight;
			if(_isForceStep)
				startMovingWithStep();
			else
				startMoving();
		}
		
		/**
		 * 向下按钮 
		 * @param evt
		 * 
		 */
		private function handleOnGoDown(event:MouseEvent):void
		{
			_pressTime = getTimer();
			_tmpy1 = 0;
			stage.addEventListener(MouseEvent.MOUSE_UP, handleOnStageMouseUp);			
			_isPressed = true;
			_direction = 1;
			_position += _scrollLineHeight;			
			if(_isForceStep)
				startMovingWithStep();
			else
				startMoving();
			
		}
		
		/**
		 * 当点击拖拉滑动块 DOWN 
		 * @param event
		 * 
		 */		
		private function handleOnDargHanleMouseDown(event:MouseEvent):void
		{
			_tmpy1 = 0;
			_tmpy = mouseY;
			if(_draghandle!=null){
				_draghandle.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnDargHanleMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, handleOnStageMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, handleOnStageMouseUp);
			}
		}
		
		/**
		 * stage鼠标move,控制滑块位置,并滚动目标对象 
		 * @param event
		 * 
		 */		
		private function handleOnStageMouseMove(event:MouseEvent):void
		{			
			if (mouseY > _btnUp.height && mouseY < _btnDown.y)
			{
				_draghandle.y += mouseY - _tmpy;
				_tmpy = mouseY;
				
				_draghandle.y < _btnUp.height && (_draghandle.y = _btnUp.height);
				_draghandle.y > (_btnDown.y - _draghandle.height) && (_draghandle.y = _btnDown.y - _draghandle.height);
				
				_position = (_draghandle.y - _btnUp.height) / (_bgBar.height - _draghandle.height);
				_movingTarget = -(this.countHeight - _h) * _position;
				startMoving();	
			}		
		}
		
		/**
		 * content侦听滚轮滚动 
		 * @param event
		 * 
		 */		
		private function handleOnMouseWheelForContent(event:MouseEvent):void
		{			
			if(this.countHeight<_h)
				return;
			if(_isForceStep)
			{
				_position -= event.delta * _scrollLineHeight /3;
				startMovingWithStep();
			}
			else
			{
				_position -= event.delta * _scrollLineHeight /6;
				startMoving();
			}
		}
		
		
		
		/**
		 * 停止拖动滚动条 
		 * @param evt
		 * 
		 */		
		private function handleOnStageMouseUp(event:MouseEvent):void
		{
			_isPressed = false;
			if(stage != null){
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleOnStageMouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleOnStageMouseMove);
				_draghandle.addEventListener(MouseEvent.MOUSE_DOWN, handleOnDargHanleMouseDown);
			}
						
			if(_isForceStep)
				startMovingWithStep();
			
			removeEventListener(Event.ENTER_FRAME, moving);
			removeEventListener(Event.ENTER_FRAME, movingSetp);
			
		}
		
		/**
		 * 点击背景条 
		 * @param evt
		 * 
		 */		
		private function handleOnBgBarMouseDown(evt:MouseEvent):void
		{	
			if(_draghandle!=null)
			{
				if (mouseY < _draghandle.y)
				{					
					_direction = -1;
					//_position -= _scrollLineHeight;
					//_position = mouseY/(_bgBar.height - _btnUp.height - _btnDown.height);	
				}
				else
				{
					_direction = 1;
					//_position += _scrollLineHeight;
				}
				var p:Point = new Point(evt.stageX,evt.stageY);
				p = this.globalToLocal(p);
				_position = (p.y-_btnUp.height)/_bgBar.height;
				
				if(_isForceStep)
					startMovingWithStep();
				else
					startMoving();
			}		
		}
		
		/**
		 * 用于处理当指定了滚动高度后，滚动到位置为行中间的情况
		 * 
		 */		
		protected function countSegmentation(num:Number):Number
		{			
			//取精确值
			var mov:Number = -(this.countHeight - _h) * _position;			
			var tick:Number = _scrollLineHeight* (this.countHeight-_h); //实际单行高度			
			var checkvar:Number = mov/tick;//
			var begin:int = int(Math.floor(checkvar));
			var end:int = int(Math.ceil(checkvar));
			
			if(begin==end)
			{
				_currentLine = begin;
				return tick*begin;
			}
			else if(checkvar < (end-begin)/2+begin)
			{
				_currentLine = begin;
				return tick*begin;
			}
			else
			{
				_currentLine = end;
				return tick*end;
			}
			
		}
		
		//		是否显示滚动条的背景
		public function set isShowBg(value:Boolean):void{
			_bgDisplayObj.visible = value;
		}
		
		/**
		 *是否一直显示滚动条 
		 */		
		public function set isAlwaysShow(value:Boolean):void{
			_isAlwaysShow = value;
			if(_isAlwaysShow)  
			{
				_view.visible = true;
				_draghandle.visible = false;
				_view.mouseEnabled = false;
			}
		}
		
		/**
		 *移除滚动对象 
		 * 
		 */		
		public function removeBody():void{
			//	while (_contentCt.numChildren > 0) _contentCt.removeChildAt(0);
		}
		
		public function startScrollByExternal(direction : String) : void
		{
			if(direction == "up")
				handleOnGoUp(null);
			else if(direction == "down")
				handleOnGoDown(null);
		}
		
		public function stopScrollByExternal() : void
		{
			handleOnStageMouseUp(null);
		}
	}
}