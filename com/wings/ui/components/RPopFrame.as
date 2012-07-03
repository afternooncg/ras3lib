package com.wings.ui.components
{
	import com.wings.ui.common.IPop;
	import com.wings.ui.common.IStageResize;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.common.RUITextformat;
	import com.wings.ui.components.constdefine.PopOpenType;
	import com.wings.ui.manager.RPopWinManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * 弹出框,显示和关闭,将分别抛出Event.OPEN 和 Event.CLOSE(关闭和确定按钮) Event.CANCEL(取消按钮)事件 
	 * Event.CLOSE和Event.CANCEL的触发都会被自己侦听到，并做关闭窗口(调用close方法)的处理
	 * 新加入1个_childCt.做为外来displayObject的放置容器,从这个级别起,明确划分_container和_childCt的不同用途,前者用于
	 * RBaseContainer本身的修饰对象存放容器(标题/背景/),并提供RPopManager的鼠标拖动事件
	 * handleOpenEffect 及 handleCloseEffect 实现显示/关闭UI特效。允许子类override.如果要取消特效,最快的方法是override open/close方法
	 * @author yying
	 * 
	 */	
	public class RPopFrame extends RBasePop implements IPop
	{		
		protected var _skin:DisplayObject;
		private var _frameBorder:DisplayObject;
		private var _titleBg:DisplayObject;
		protected var _title:RLabel;
		private var _titleStr:String="";		
	
		private var _isShowBtnClose:Boolean = true;		
		protected var _btnClose:DisplayObject;
		protected var _childCt:DisplayObjectContainer; //外部子对象容器基类
		
		
		/**
		 * 
		 * @param title 弹出框标题
		 * @param skin  皮肤样式,注意非popBody替代物
		 * @param params  {x,y,w,h}
		 * 
		 */				
		public function RPopFrame(title:String="",skin:DisplayObject=null,params:Object=null)
		{
			_skin = skin==null?RUIAssets.getInstance().frameSkin1:skin;
//			默认高宽
			if(skin!=null){
				_w =skin.width;
				_h = skin.height;
			}
			
			_w =_w == 0?200:_w;
			_h = _h == 0?150:_h;
			_titleStr=title;
			super(skin,params);
			this.mouseChildren = true;
			this.mouseChildren =false;
			this.addEventListener(Event.OPEN,handleOpen);
			this.addEventListener(Event.CLOSE,handleClose);
			this.addEventListener(Event.CANCEL,handleCancel);
		}				
		
		override protected function addChildren():void{
		  super.addChildren();		  
		  if(_titleStr!=""){
		    this.title = _titleStr;
		  }
		  
		  this.addChild(_skin);
		  _childCt = new Sprite();
		  this.addChild(_childCt);
		  this.isShowCloseBtn = _isShowBtnClose;		  
		}
		
		override public function get dragTarget():DisplayObject
		{
			return _skin;
		}
		
		
		override public function set width(value:Number):void{
		  _w = value;
		  
		  drawUI();		  
		}
		
		override public function set height(value:Number):void{
			_h = value;
			
			drawUI();
		}
		
		
		/**
		 * 
		 * 
		 */		
		override public function drawUI():void
		{	
			
//			this.graphics.beginFill(0xFF,0);
//			this.graphics.drawRect(0,0,this._w,this._h);
//			this.graphics.endFill()
			
			if(_title){
			_title.x = (_w - _title.width)/2;
			_title.y = 10;
			_title.text = _titleStr;
			}
			_skin.width = _w;
			_skin.height = _h;
			
			_btnClose.x = _w - _btnClose.width - 5;
			_btnClose.y = 5;
			
			super.drawUI();
		}
		
		/**
		 *弹出框标题 
		 * @param value
		 * 
		 */		
		public function set title(value:String):void{
			if(_title == null)
			{
				_title=new RLabel();
				_title.setTextFormat(RUITextformat.getInstance().frameTitleFormat);
				this.addChild(_title);
			}
			_title.text = value;
			_titleStr = value;
			
		    _title.x = (_w - _title.width)/2;
			_title.y = 10;
			
		}
		
		public function get title():String{
		  return _titleStr;
		}
		
		/**
		 *是否打开 
		 * @param value
		 * 
		 */		
		public function set isPopUp(value:Boolean):void
		{
			_ispopUp=value;			
			if(_ispopUp)
			{
				super.open();
			}
			else
			{
				super.close();
			}
		}

		
		public function get dragHandle():DisplayObject
		{
			return this;
		}	
	

		/**
		 * 显示效果 
		 * 
		 */		
		override public function open(type:String=PopOpenType.MASK):void
		{
			_popOpenType = type;
			this.alpha = 0.5;
			this.addEventListener(Event.ENTER_FRAME,handleOpenEffect);
			dispatchEvent(new Event(Event.OPEN));
		}
		
	
		
		
		
		
		/**
		 *设置显示对象容器的位置
		 * @param value  {width,height}
		 * 
		 */		
		public function set childXY(value:Object):void{
			_childCt.x = value.width;
			_childCt.y = value.height;
		}
		
		/**
		 * 创建关闭按钮 
		 * 
		 */		
		protected function createCloseBtn():void
		{
			if(_btnClose==null)
			{
				_btnClose = new RBaseButton(null,null,"",RUIAssets.getInstance().closeBtnSkin) as DisplayObject;
				_btnClose.visible = true;
				_btnClose.x = _w - _btnClose.width - 5;
				_btnClose.y = 5;
				this.addChild(_btnClose);
			}
		}
		
		
		/**
		 *是否可以关闭 
		 * 
		 */		
		public function set isShowCloseBtn(value:Boolean):void{
		   _isShowBtnClose = value;
		   if(_isShowBtnClose)
		   {
			   createCloseBtn();
			   _btnClose.addEventListener(MouseEvent.CLICK,handleBtnClose);
			   
		   }
		   else if(_btnClose){
			   if(_btnClose)
			   {
			   	_btnClose.visible = false;
			   	_btnClose.removeEventListener(MouseEvent.CLICK,handleBtnClose);
			   }
		   }
		}
		
				
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get isShowCloseBtn():Boolean{
		  return _isShowBtnClose;
		}
		
		
		private function handleBtnClose(e:MouseEvent):void{
		  this.isPopUp = false;
		}
		
		private function handleOpen(event:Event):void
		{
			super.open(_popOpenType);
		}
		
		private function handleClose(event:Event):void
		{
			super.close(_isAutoDestroyOnClose);
		}
		private function handleCancel(event:Event):void
		{
			RPopWinManager.getInstance().closeUI(this);
		}
		
		override public function destroy():void
		{
			this.removeEventListener(Event.ENTER_FRAME,handleOpenEffect);
			this.removeEventListener(Event.ENTER_FRAME,handleCloseEffect);
			this.removeEventListener(Event.CLOSE,handleClose);
			this.removeEventListener(Event.CANCEL,handleCancel);
			this.removeEventListener(Event.OPEN,handleOpen);
			if(_btnClose) _btnClose.removeEventListener(MouseEvent.CLICK,handleBtnClose);
			super.destroy();
		}
		
		
		
	}
}