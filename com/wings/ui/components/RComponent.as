package com.wings.ui.components
{
	import com.wings.ui.common.IRToolTips;
	import com.wings.ui.manager.RToolTipManager;
	import com.wings.util.display.BitmapFiltersKit;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	
	/**
	 * 本类为非容器控件的基类,gray/tooltip/mouseSingleClick
	 * 继承自该类的子类请注意对_w,_h值的维护 
	 * @author hh
	 * 
	 */	
	public class RComponent extends RBaseComponents implements IRToolTips
	{
		public function RComponent(parent:DisplayObjectContainer=null, params:Object=null)
		{
			
			super(parent, params);
		}
				
		protected var _toolTip:Object="";		
		protected var _fixedToolTipPosi:Point;					//固定tooltips位置,以当前this坐标系为准
		
		protected var _isGray:Boolean = false;				//鼠标感应有效,并呈现灰色外观
		protected var _enabled:Boolean = true;				//鼠标感应失效,并呈现灰色外观
		protected var _isAutoGrow:Boolean = false;
		private var _isUpdateTooltipRealTime:Boolean=false;		//是否实时更新悬停
		
		

		/**
		 * 是否自动启用发光 
		 * @return 
		 * 
		 */		
		public function get isAutoGrow():Boolean
		{
			return _isAutoGrow;
		}

		public function set isAutoGrow(value:Boolean):void
		{
			_isAutoGrow = value;
			if(value)
			{
				this.addEventListener(MouseEvent.ROLL_OVER,handleMouseRoll);
				this.addEventListener(MouseEvent.ROLL_OUT,handleMouseRoll);
			}
			else
			{
				this.removeEventListener(MouseEvent.ROLL_OVER,handleMouseRoll);
				this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseRoll);
			}
		}
		
		protected function handleMouseRoll(event:MouseEvent):void
		{
			if(!_isAutoGrow || _isGray )
				return;
			if(event.type == MouseEvent.ROLL_OVER)
			{
				this.filters = [getGrow()];	
			}
			else
			{
				this.filters = null;
			}
			
		}
	
	
		/**
		 *  文本悬停,优先级高于 richToolTip,同时设置这两个属性,将只显示richToolTip
		 * @return 
		 * 
		 */		
		public function get toolTip():Object
		{
			return _toolTip;
		}
		public function set toolTip(tipObj:Object):void
		{	
			if(tipObj) 
			{
				_toolTip = tipObj ;
				RToolTipManager.getInstance().register(this);	
			}
			else
			{
				_toolTip = null ;
				RToolTipManager.getInstance().unregister(this);
			}
		}
		
		/**
		 * 丰富的tooltip对象 
		 * @param tip
		 * 
		 */		
		public function set richToolTip(tip:DisplayObject):void
		{
			this.toolTip = tip;
			
		}		
		
		public function get richToolTip():DisplayObject
		{
			return _toolTip as DisplayObject;	
		}
		
		
		/**
		 * 固定tooltips位置 x,y坐标以当前坐标系为准
		 * 该坐标的设置以该容器自身的x，y为准
		 * @param point
		 * 
		 */		
		public function set fiexedPosi(point:Point):void
		{						
			_fixedToolTipPosi=point;
			if(_fixedToolTipPosi)
			{
//				_fixedToolTipPosi = this.localToGlobal(_fixedToolTipPosi);			
//				_fixedToolTipPosi = RToolTipManager.getInstance().globalToLocal(_fixedToolTipPosi);	
			}
		}		
		public function get fiexedPosi():Point{
			return _fixedToolTipPosi;
		}
		
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;			
			if(value)
			{
				this.mouseEnabled = _enabled;	
			}
			else
			{				
				this.mouseEnabled = this.mouseChildren = _enabled;
			}
			
			this.gray = !_enabled;	
		}
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * 仅外观设灰,保留鼠标功能 
		 * @param value
		 * 
		 */		
		public function set gray(value:Boolean):void
		{
			_isGray = value;
			this.filters = _isGray ? [BitmapFiltersKit.getGrayFilter()] : null ;
			if(value)
			{
				this.buttonMode = false;			
				//若有iphone的拖拉操作场合,应去除down up这两个事件的屏蔽
				this.addEventListener(MouseEvent.MOUSE_DOWN,handleFirstClick,false,10000);
				this.addEventListener(MouseEvent.MOUSE_UP,handleFirstClick,false,10000);
				this.addEventListener(MouseEvent.CLICK,handleFirstClick,false,10000);
				this.addEventListener(MouseEvent.DOUBLE_CLICK,handleFirstClick,false,10000);
				this.addEventListener(MouseEvent.MOUSE_WHEEL,handleFirstClick,false,10000);
			}
			else
			{
				this.buttonMode = true;	
				this.removeEventListener(MouseEvent.MOUSE_DOWN,handleFirstClick);
				this.removeEventListener(MouseEvent.MOUSE_UP,handleFirstClick);
				this.removeEventListener(MouseEvent.CLICK,handleFirstClick);
				this.removeEventListener(MouseEvent.DOUBLE_CLICK,handleFirstClick);
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,handleFirstClick);
			}
		}
		
		public function get gray():Boolean
		{
			return _isGray;				
		}
		
		override public function destroy():void
		{
			super.destroy();
			RToolTipManager.getInstance().unregister(this);
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleFirstClick);			
			this.removeEventListener(MouseEvent.MOUSE_UP,handleFirstClick);
			this.removeEventListener(MouseEvent.CLICK,handleFirstClick);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,handleFirstClick);
			this.removeEventListener(MouseEvent.MOUSE_WHEEL,handleFirstClick);
		
		}
		
		/**
		 * 是否强制悬停显示内容(适合于显示倒计时的情况)
		 * 强行enterframe事件内实时更新 仅仅当tooltip是文字时需要启用  
		 * @return 
		 * 
		 */					
		public function get isUpdateTooltipRealTime():Boolean
		{
			return _isUpdateTooltipRealTime;
		}
		public	function set isUpdateTooltipRealTime(bool:Boolean):void
		{
			_isUpdateTooltipRealTime = bool;		
		}
		
		
		/**
		 *  
		 * 每次over事件时更新,用于tooltip是单例共享情况,如果是非单例情况,不必实现
		 */		
		public function updateEveryShow():void
		{
			
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
		
	}
}