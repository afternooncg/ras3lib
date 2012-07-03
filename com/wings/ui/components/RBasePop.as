package com.wings.ui.components
{
	import com.wings.ui.common.IPop;
	import com.wings.ui.common.IStageResize;
	import com.wings.ui.components.constdefine.PopOpenType;
	import com.wings.ui.manager.RPopWinManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * 弹窗容器基类无默认UI效果,需要外部传入disp参数或设置displayObject属性
	 * open和close为不带特效的窗体开启关闭功能 
	 * @author hh
	 * 
	 */	
	public class RBasePop extends RBaseComponents implements IStageResize,IPop
	{
		public function RBasePop(disp:DisplayObject=null, isAutoDestroyOnClose:Boolean=false)
		{			
			if(disp) _disp = disp;
			_isAutoDestroyOnClose = isAutoDestroyOnClose;
			super(null,null);			
		}
			
		protected var _disp:DisplayObject;
		protected var _isAutoDestroyOnClose:Boolean = false;		//是否在关闭窗口时,从RUIManger的记录数组里去除对象引用，通常在需要销毁窗体时做
		protected var _ispopUp:Boolean = false;		//是否打开/关闭状态
		protected var _isCanDrag:Boolean = true;	
		protected var _isDestroyed:Boolean = false;
		protected var _popOpenType:String = PopOpenType.MASK;	//pop type
		public function get isPopUp():Boolean
		{
			return _ispopUp;
		}
		
		
		/**
		 * 是否允许拖动 
		 * @return 
		 * 
		 */		
		public function get isCanDrag():Boolean
		{
			return _isCanDrag;	
		}
		
		public function set isCanDrag(value:Boolean):void
		{
			_isCanDrag=value;	
		}
		
		/**
		 * 提供弹窗可拖动对象,若不指定该对象。则整个窗体任意部位都可以被拖动 
		 * @return 
		 * 
		 */		
		public function get dragTarget():DisplayObject
		{
			return _disp;
		}
		
		
			
		
		/**
		 * 打开弹窗对象 带 effect
		 * @param isShowMask 是否在窗口底部显示蒙版效果
		 * 
		 */		
		public function open(enumType:String= "PopOpenType_mask"):void    
		{	
			_ispopUp = true;
			this.removeEventListener(Event.ENTER_FRAME,handleCloseEffect);
			_popOpenType = enumType;
			executeOpen(_popOpenType);
			if(this.hasEventListener(Event.ENTER_FRAME) && this.alpha!=1)
				return;
			this.alpha = 0.5;
			this.addEventListener(Event.ENTER_FRAME,handleOpenEffect);
		}		
		
		/**
		 * 关闭 带 effect
		 * @param isRemove ture销毁对象/false不销毁 
		 * 
		 */		
		public function close(isRemove:Boolean=false):void
		{ 
			if(_isDestroyed)
				return;
			_isAutoDestroyOnClose = isRemove;
			_ispopUp = false;
			this.removeEventListener(Event.ENTER_FRAME,handleOpenEffect);
			if(this.hasEventListener(Event.ENTER_FRAME) && this.alpha!=1)
				return;
			this.alpha = 0.5;
			this.addEventListener(Event.ENTER_FRAME,handleCloseEffect);
		}			
		
		/**
		 * 执行具体的加入场景动作 
		 * 
		 */		
		public function executeOpen(enumType:String= "PopOpenType_mask"):void
		{			
			if(_isDestroyed)
				return;
			_ispopUp=true;
			RPopWinManager.getInstance().showUI(this,enumType);		
		}
		
		/**
		 * 执行具体的移出场景动作 
		 * 
		 */
		public function executeClose(isRemove:Boolean=false):void
		{
			_ispopUp = false;			
			RPopWinManager.getInstance().closeUI(this);
			if (isRemove) this.destroy();
			dispatchEvent(new Event(Event.CLOSE));			
		}
		
		
		/**
		 * zindex提升到顶层 
		 * 
		 */		
		public function setToTop():void
		{
			RPopWinManager.getInstance().setToTop(this);
		}
	
		/**
		 * 当场景发生size变化时调用充值.需要被override 重置位置 
		 * @param w
		 * @param h
		 * 
		 */		
		public function onStageResize(w:Number,h:Number):void
		{
			this.x = (w-this.visibleWidth)/2;
			this.y = (h-100-this.visibleHeight)/2;
		}

		override protected function addChildren():void
		{
			super.addChildren();
			if(_disp)
			{
				this.addChild(_disp);
			}
		
		}
		
		override public function destroy():void
		{
			super.destroy();
			_isDestroyed = true;
		}
		
		
		/**
		 * 开启特效处理 
		 * @param event
		 * 
		 */		
		protected function handleOpenEffect(event:Event):void
		{
			this.alpha += 0.1;
			//			trace(alpha);
			if(this.alpha>=1) 
			{				
				this.alpha = 1;					
				this.removeEventListener(Event.ENTER_FRAME,handleOpenEffect);				
				dispatchEvent(new Event(Event.OPEN));
			}
		}
		
		
		
		/**
		 * 关闭特效处理 
		 * @param event
		 * 
		 */		
		protected function handleCloseEffect(event:Event=null):void
		{
			this.alpha -= 0.1;			
			if(this.alpha<=0) 
			{				
				//this.isPopUp = true;
				this.removeEventListener(Event.ENTER_FRAME,handleCloseEffect);
				executeClose(_isAutoDestroyOnClose);
				this.alpha = 1;
				
			}
		}
		
		
	}
}