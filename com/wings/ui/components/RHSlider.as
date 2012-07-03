package com.wings.ui.components
{
	
	import com.wings.ui.common.RUIAssets;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 水平滑动条 
	 * @author hh
	 * 
	 */	
	public class RHSlider extends RBaseComponents
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
		 * @param view     
		 * @param params {x,y,w,h,min:Number, max:Number, value:Number}
		 * @param onMouseMoveCallBack 当鼠标移动时回调
		 */		
		public function RHSlider(view:DisplayObjectContainer=null,params:Object=null,onMouseMoveCallBack:Function=null,isDragInCenter:Boolean=false)
		{
			if(params)
			{
				if(params.hasOwnProperty("min")) _min = params["min"];
				if(params.hasOwnProperty("max")) _max= params["max"];
				if(params.hasOwnProperty("value")) _value = params["value"];
				correctValue();				
			}
			if(view==null) view = RUIAssets.getInstance().hsliderSkin1;
			_view = view;
			view.x=view.y=0;
			_onMouseMoveCallBack = onMouseMoveCallBack;
			_isDragInCenter = isDragInCenter;
			super(null,params);
			this.mouseChildren = true;
		}

		

		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{
						
			if(_w ==0) _w = _view.width;
			if(_h ==0) _h = _view.height;
			
			_handle = new Sprite();
			_handle.addChild(_view.getChildByName("handleMc"));
			_view.addChild(_handle);
			_bgBar = _view.getChildByName("bgbarMc");
			_bgBar.y = (_h-_bgBar.height)/2;
			this.addEventListener(Event.ADDED_TO_STAGE, handleAddToStage);
			super.inits();	
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _view:DisplayObjectContainer;
		protected var _handle:Sprite;						//小方块
		protected var _bgBar:DisplayObject;						//背景条
		protected var _canClickBar:Boolean = true;
		protected var _value:Number = 0;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _orientation:String;
		protected var _segmentation:int=0;					//分割 =0 则无
		private var _onMouseMoveCallBack:Function;
		protected var _isDragInCenter:Boolean = false;	//滑块注册点是否在中间，如果在中间，算总长度不必减滑块宽
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
		 * 真实的显示长度，去除被滑块遮蔽的长度 
		 * @return 
		 * 
		 */		
		public function get len():Number
		{
			return counteMaxSliderLen();
		}
		
		
		
		/**
		 * 是否允许点击背景条
		 */
		public function set canClickBar(b:Boolean):void
		{
			_canClickBar = b;
			
		}
		public function get canClickBar():Boolean
		{
			return _canClickBar;
		}
		
		/**
		 * 值设置
		 */
		public function set value(v:Number):void
		{
			_value = v;
			correctValue();
			setHandlePosition();
			
		}
		public function get value():Number
		{
			return _value+ + _min;
		}
		
		/**
		 * Gets / sets the maximum value of this slider.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			correctValue();
			setHandlePosition();
		}
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the minimum value of this slider.
		 */
		public function set minimum(m:Number):void
		{
			_min = m;
			correctValue();
			setHandlePosition();
		}
		public function get minimum():Number
		{
			return _min;
		}
		
		/**
		 *  分割段数 
		 * @return 
		 * 
		 */		
		public function get segmentation():int
		{
			return _segmentation;
		}
		
		public function set segmentation(value:int):void
		{
			_segmentation = value;
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
		 *下级 
		 * 
		 */		
		public function moveNextCurr():void
		{
			if(_segmentation==0 || _value>=_max)
				return;
			
			_value  =  countSegmentation(_value + (_max-_min)/_segmentation);
			setHandlePosition();
		}
		
		public function movePrevCurr():void
		{
			if(_segmentation==0 || _value<=_min)
				return;
			
			_value  =  countSegmentation(_value - (_max-_min)/_segmentation);
			setHandlePosition();
			
		}
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			}
			
			this.removeEventListener(Event.ADDED_TO_STAGE, handleAddToStage);
			_bgBar.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnClickBgBar);
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownHandle);
			
			_view = null;
			_handle = null;
			_bgBar = null;
			_handle = null;
			
			super.destroy();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			super.addChildren();						
			this.addChild(_view);
			_handle.buttonMode = true;			
		}
		
	
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
	
		

		
		/**
		 * 校验
		 */
		protected function correctValue():void
		{
			if(_max > _min)
			{
				_value = Math.min(_value, _max);
				_value = Math.max(_value, _min);
			}
			else
			{
				_value = Math.max(_value, _max);
				_value = Math.min(_value, _min);
			}
		}
		
		/**
		 * 重设置滑块位置 
		 *
		 */
		protected function setHandlePosition():void
		{
			var range:Number = counteMaxSliderLen();
			_handle.x = (_value - _min) / (_max - _min) * range;
			_handle.x = Math.max(_handle.x, 0);
			_handle.x = Math.min(_handle.x, counteMaxSliderLen());
		}
		
		private function counteMaxSliderLen():Number
		{
			return _isDragInCenter==false ? (_w - _handle.width) : _w;
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		protected function drawBar():void
		{	
			_bgBar.width = _w;
			//_handle.height = _bgBar.height = _h;		
		}
		//--------------------------------------------------------------------------
		//
		//  Broadcasting
		//
		//--------------------------------------------------------------------------
		/**
		 * Draws the visual ui of the component.
		 */
		override public function drawUI():void
		{	
			drawBar();
			setHandlePosition();
			super.drawUI();
		}
		
		/**
		 * 设置参数		 
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum = min;
			this.maximum = max;
			this.value = value;
		}

		
		
		/**
		 * 开始拖动 
		 * 
		 */		
		protected function beginDrag():void
		{
			
			_handle.startDrag(false, new Rectangle(0, 0, counteMaxSliderLen(), 0));			
		}
			
		
		/**
		 * 检查是否存在分割 ,如果存在分割做强制百分比处理,计算新值
		 * 
		 */		
		protected function countSegmentation(num:Number):Number
		{			
			if(_segmentation==0)
				return num;
			else
			{//取精确值
				
				var tick:Number = (_max-_min)/_segmentation;				
				var checkvar:Number = num/tick; 
				var begin:int = int(Math.floor(checkvar));
				var end:int = int(Math.ceil(checkvar));
				
				if(begin==end)
					return num;
								
				return (checkvar < (end-begin)/2+begin) ? tick*begin : tick*end;
			}
		}
		
		/**
		 * 计算 
		 * @param oldValue
		 * 
		 */		
		private function count(oldValue:Number):void
		{
			_handle.x = Math.max(_handle.x, 0);
			_handle.x = Math.min(_handle.x, counteMaxSliderLen());
			
			var checkval:Number = _value = _handle.x / counteMaxSliderLen() * (_max - _min);			
			_value = countSegmentation(_value);
 			if(checkval!=_value)//重置handlex
				_handle.x= _value*counteMaxSliderLen()/_max;
					
			dispatchEvent(new Event(Event.CHANGE));
		}
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		/**
		 * 加入场景 
		 * @param event
		 * 
		 */			
		private function handleAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, handleAddToStage);
			_handle.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownHandle);
			if(_canClickBar)
			{
				_bgBar.addEventListener(MouseEvent.MOUSE_DOWN, handleOnClickBgBar);
			}
			else
			{
				_bgBar.removeEventListener(MouseEvent.MOUSE_DOWN, handleOnClickBgBar);
			}
		}
		
		
		/**
		 * 鼠标松开停止拖动
		 * 
		 */
		protected function handleMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			_handle.stopDrag();
			count(_value);
		}
		
		/**
		 * 鼠标点击背景条 
		 * 
		 */
		protected function handleOnClickBgBar(event:MouseEvent):void
		{	
			var oldValue:Number = _value;
			_handle.x = mouseX - _handle.width / 2;
			count(oldValue);
		}
		
		
		
		
		/**
		 * 鼠标在滑块上按下
		 * 
		 */
		protected function handleMouseDownHandle(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			beginDrag();
		}
		
		/**
		 * 
		 * 鼠标移动时,实时调整滑块位置 把实际时刻的value
		 */
		protected function handleMouseMove(event:MouseEvent):void
		{			
			_value = _handle.x / counteMaxSliderLen() * (_max - _min);			
			if(_onMouseMoveCallBack!=null)
				_onMouseMoveCallBack(_value);
		}

	}
}