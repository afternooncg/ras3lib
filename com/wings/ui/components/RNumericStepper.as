package com.wings.ui.components
{
	
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUITextformat;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * 允许输入数据,并支持键盘上下移动键,鼠标点击调整数值
	 * @author hh
	 * 
	 */	
	public class RNumericStepper extends RComponent
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
		 * @param value				初值
		 * @param incButton			加
		 * @param decButton			减
		 * @param params			{x,y,w,h} w h包含incButton按钮的长度 incButton按钮最大不超过20px,否则会被强行缩放成20px;
		 * @param defaultHandler	
		 * 
		 */		
		public function RNumericStepper(value:Number,incButton:RBaseButton=null,decButton:RBaseButton=null,params:Object=null,defaultHandler:Function = null)
		{
			_value = value;
			if(incButton==null)
			{
				_btnInc = new RBaseButton(null,null,"",RUIAssets.getInstance().incBtnSkin1);
			}
			else
			{
				_btnInc = incButton;
			}
			
			if(decButton==null)
			{
				_btnDec = new RBaseButton(null,null,"",RUIAssets.getInstance().decBtnSkin1);
			}
			else
			{
				_btnDec = decButton;
			}
			
			_btnDec.canDbClcik = _btnInc.canDbClcik = true;
			_txtValue = new TextField();
			if(defaultHandler != null)
			{
				_handle = defaultHandler;
				this.addEventListener(Event.CHANGE, defaultHandler);
			}
			
			super(null,params);
		}
		
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{
			if(_w==0 || _w<80)
				_w = 80;
			
			if(_h==0 || _h<18)
				_h = 18;
			
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(_repeatTime);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
			
			super.inits();	
			
			this.mouseChildren = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected const DELAY_TIME:int = 500;						//点击加减按钮超过0.5秒，开始重复执行操作
		protected const UP:String = "up";
		protected const DOWN:String = "down";
		protected var _btnDec:RBaseButton;
		protected var _btnInc:RBaseButton;								//长按加减按钮重复执行操作频率
		
		protected var _repeatTime:int = 100;
		
		protected var _txtValue:TextField;
		protected var _value:Number = 0;
		protected var _step:Number = 1;		
		protected var _maximum:Number = Number.POSITIVE_INFINITY;
		protected var _minimum:Number = Number.NEGATIVE_INFINITY;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		
		protected var _handle:Function;
		
		protected var _isReadOnly:Boolean = false;
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
		
		public function get textField():TextField
		{
			return _txtValue;
		}

		/**
		 * 设置当前值
		 */
		public function set value(val:Number):void
		{
			if(val <= _maximum && val >= _minimum)
			{
				_value = val;
				_txtValue.text = _value.toString();
			}
		}
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * 设置步长
		 */
		public function set step(value:Number):void
		{
			if(value < 0) 
			{
				value = 0;
			}
			_step = value;
		}
		public function get step():Number
		{
			return _step;
		}
		
		
		public function set maximum(value:Number):void
		{
			_maximum = value;
			if(_value > _maximum)
			{
				_value = _maximum;		
				_txtValue.text = _value.toString();
			}
		}
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set minimum(value:Number):void
		{
			_minimum = value;
			if(_value < _minimum)
			{
				_value = _minimum;
				_txtValue.text = _value.toString();
			}
		}
		public function get minimum():Number
		{
			return _minimum;
		}
		
		/**
		 * 长按加减按钮，定时改变value的时间
		 */
		public function get repeatTime():int
		{
			return _repeatTime;
		}
		
		public function set repeatTime(value:int):void
		{
			_repeatTime = Math.max(value, 10);
			_repeatTimer.delay = _repeatTime;
		}
		
		public function set isReadOnly(bool:Boolean):void
		{			 
//			_txtValue.isReadOnly = bool;
		}		
		public function get isReadOnly():Boolean
		{
//			return _txtValue.isReadOnly;
			return true;
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
		
		override public function drawUI():void
		{
			if(stage)
			{
				_btnInc.addEventListener(MouseEvent.MOUSE_DOWN, handelOnClick_Inc);
				_btnInc.width = Math.min(20,_btnInc.width);
				_btnInc.height = Math.min(11,_btnInc.height);
				
				_btnDec.addEventListener(MouseEvent.MOUSE_DOWN, handelOnClick_Dec);
				_btnDec.width = _btnInc.width
				_btnDec.height = _btnInc.height;
				
				_txtValue.width = _w - _btnInc.width;
				_txtValue.height= _h;
				_btnInc.x = _btnDec.x =_txtValue.width;			
				_btnDec.y = _btnInc.height;
			}
		}
		
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			
			if(_handle !=null)
			{
				this.removeEventListener(Event.CHANGE,_handle);
				_handle = null;
			}
			
			_repeatTimer.stop();
			_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);
			_repeatTimer = null;
			
			_delayTimer.stop();
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_delayTimer = null;
				
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
				
		protected override function addChildren():void
		{
			super.addChildren();
			
			_txtValue.type = TextFieldType.INPUT;
			_txtValue.defaultTextFormat = RUITextformat.getInstance().lableTextFormat;
			_txtValue.background = true;
			_txtValue.backgroundColor = 0x1e1e1e;
			
			_txtValue.addEventListener(Event.CHANGE,handleChange);
			_txtValue.restrict = "-0123456789.";
			this.value = _value;
			
			this.addChild(_txtValue);			
			this.addChild(_btnInc);
			this.addChild(_btnDec);
			
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		protected function increment():void
		{
			if(_value + _step <= _maximum)
			{
				_value += _step;				
				this.value = _value;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function decrement():void
		{
			if(_value - _step >= _minimum)
			{
				_value -= _step;
				this.value = _value;
				dispatchEvent(new Event(Event.CHANGE));
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
		
		private function handleAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			drawUI();
		
		}
		
		
		/**
		 * 点减数据
		 */
		protected function handelOnClick_Dec(event:MouseEvent):void
		{
			decrement();
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		/**
		 * 点加数据
		 */
		protected function handelOnClick_Inc(event:MouseEvent):void
		{
			increment();
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		
		/**
		 * 鼠标松开 
		 * @param event
		 * 
		 */		
		protected function handleMouseUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
		}
		
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			_repeatTimer.start();
		}
		
		
		/**
		 * 鼠标长按加减按钮时 
		 * @param event
		 * 
		 */		
		protected function onRepeat(event:TimerEvent):void
		{
			if(_direction == UP)
			{
				increment();
			}
			else
			{
				decrement();
			}
		}
		
		private function handleChange(event:Event):void
		{
			var tmp:Number = Number(_txtValue.text);
			if(tmp<=_maximum && tmp>=_minimum)
			{
				_value = tmp;
				dispatchEvent(new Event(Event.CHANGE));
			}
			else if(tmp>_maximum)
			{
				_txtValue.text = _maximum.toString();
			}
			else if(tmp<_minimum)
			{
				_txtValue.text = _minimum.toString();
			}
			 	
			
		}
	}
}