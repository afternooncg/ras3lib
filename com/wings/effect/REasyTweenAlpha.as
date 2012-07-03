package com.wings.effect
{
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	
	/**
	 * 简单的透明度缓动类,用于要求保持输出体积的场合下 提供1个从快到慢的变换 
	 * @author hh
	 * 
	 */	
	public class REasyTweenAlpha implements IDestroy
	{
		private var _mulSpeed:Number=0.1;
		private var _completeFun:Function;
		private var _disp:DisplayObject;
		private var _stage:Stage;
		private var _start:Number = 0;
		private var _end:Number = 1;

		
		/**
		 * 注意,需要加入stage后再启用
		 * @param disp			显示对象
		 * @param completeFun   结束回调
		 * @param start			开始状态
		 * @param end			结束状态		 
		 * @param mulSpeed		缓动系数		 
		 * 
		 */		
		public function REasyTweenAlpha(disp:DisplayObject,completeFun:Function=null,start:Number=0,end:Number=1,mulSpeed:Number=0.15)
		{
			update(disp,completeFun,start,end,mulSpeed);
		}
		
		public function start():void
		{
			if(_stage)
				_stage.addEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		public function stop():void			
		{
			if(_stage)
				_stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
		}
		
		public function get disp():DisplayObject
		{
			return _disp;
		}
		
		/**
		 * @param disp			显示对象
		 * @param completeFun   结束回调
		 * @param start			开始状态
		 * @param end			结束状态		 
		 * @param mulSpeed		缓动系数		 
		 * 
		 */		
		public function update(disp:DisplayObject,completeFun:Function=null,start:Number=0,end:Number=1,mulSpeed:Number=0.15):void
		{
			//_isToAlpha = isToAlpha;
			_disp = disp;
			_completeFun = completeFun;
			_mulSpeed = mulSpeed;
			_start = start;
			_end = end;
			if(_disp)
			{
				_disp.alpha = _start;
				if(_disp.stage && _stage==null)
					_stage = _disp.stage;
			}
		}
		
		
		/**
		 * loading条进入 
		 * @param event
		 * 
		 */		
		protected function handleEnterFrame(event:Event):void
		{
			var v:Number = (_end - _disp.alpha) * _mulSpeed;			
			_disp.alpha += v;
			if(Math.abs(_disp.alpha-_end)<0.01 || (v>0 && _disp.alpha>=_end) || (v<0 && _disp.alpha<=_end))
			{
				_stage.removeEventListener(Event.ENTER_FRAME,handleEnterFrame);
				if(_completeFun!=null)
					_completeFun();
			}
			else if(v==0)
			{
				trace("缓动参数无效,速度增量为0");
			}			
		}		
		
		
		
		public function destroy():void
		{
			stop();
			_disp = null;
			_completeFun = null;
		}
	}
}