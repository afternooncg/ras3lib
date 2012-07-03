package com.wings.ui.components
{
	
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUICssHelper;
	import com.wings.ui.components.RTextVScrollBar;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	 * 多行输入表单并支持滚动条
	 * @author hh
	 * 
	 */	
	
	
	public class RTextArea extends RComponent
	{
		private var _margin:Number = 0;
		private var _txtScroll:RTextVScrollBar;
		private var _sc:DisplayObjectContainer;		
		private var _isShowBar:Boolean = false;
		private var _isForceHandlerSize:Boolean = false;
		protected var _txt:TextField;
		protected var _txtStr:String;
		protected var _isHtml:Boolean = true;
		/**
		 *  
		 * @param text      
		 * @param params
		 * @param parent
		 * @param defaultHandler
		 * @param barSkin                    barUI
		 * @param isForceHandlerSize      滑块高度限定   
		 * 
		 */		
		public function RTextArea(text:String="", params:Object=null, parent:DisplayObjectContainer=null,defaultHandler:Function=null,barSkin:DisplayObjectContainer=null,isForceHandlerSize:Boolean=false)
		{				
			_isForceHandlerSize = isForceHandlerSize;
			_sc = barSkin;
			super(parent, params);
			this.mouseChildren = true;
			
		}
		
		override protected function initProps():void
		{
			super.initProps();
			
			if(_params==null) return;
			if(_params.hasOwnProperty("isHtml")) 
				_isHtml = Boolean(_params["isHtml"]);
			
		}
		
		override protected function addChildren():void
		{
			_txt = new TextField();
			_txt.defaultTextFormat = RUICssHelper.getInstance().ruiTf.lableTextFormat;
			this.addChild(_txt);			
			_txt.wordWrap = true;			
			_txt.multiline =true;			
			if(_sc==null)
				_sc = RUIAssets.getInstance().GetObject("ScrollBar_mc") as DisplayObjectContainer;
			this.addChild(_sc);						
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
		}
		
		
		
//		/**
//		 * 与 drawUI具体执行外观描绘动作不同,callDrawUI是加了enterframe侦听,在下一帧才执行drawUI.这样可以提高性能，避免drawUI方法被多次调用 
//		 * 
//		 */		
//		override protected function invalidate():void
//		{
//			drawUI();
//		}
		public function set isReadOnly(bool:Boolean):void
		{
			
		}
		
		
		
		override public function drawUI():void
		{	
			if(_w>0)
				_txt.width = _w;
			if(_h>0)
				_txt.height = _h;
//			
//			if(_isHtml)
//			{				
//				_txt.htmlText = _txtStr;
//			}
//			else 
//			{
//				var tf:TextFormat = _txt.defaultTextFormat;
//				_txt.defaultTextFormat = tf;
//				_txt.setTextFormat(tf);
//				_txt.text = _txtStr;
//			}
			
			if(_txtScroll)
			{
				_txt.width -=_txtScroll.visibleWidth;
				_txtScroll.onUpdateTextHeight();
			}						
			_sc.x = _txt.width+_margin;
		}
		
		private function handleAddToStage(event:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			_txtScroll = new RTextVScrollBar(_txt,_sc,_h,0,_isShowBar,_isForceHandlerSize);
//			_txtScroll.isEnabledMask = false;
			drawUI();
		}
		
		public function get textField():TextField
		{
			return _txt;
		}
		
		public function set htmlText(str:String):void
		{	
			_isHtml = true;
			_txt.htmlText = str;
			if(_txtScroll)
				_txtScroll.checkTextAndUpdateState();
		}
		
		
		
		public function set text(str:String):void
		{	
			_isHtml = false;
			_txt.text = str;
			if(_txtScroll)
				_txtScroll.checkTextAndUpdateState();
		}
		
		public function clearTxtStr():void
		{			
			if(_isHtml)
				_txt.htmlText ="";
			else
				_txt.text = "";
		}
		
		/**
		 * 设置滚动条和文本框的距离
		 * @param value
		 * 
		 */		
        public function  set scrollBarMargin(value:Number):void{
			_margin = value;
		}
		
		/**
		 * 下一行 
		 */		
		public function moveNextLine():void
		{
			if(_txtScroll)_txtScroll.moveNextLine();
		}
		
		/**
		 * 第一行 
		 * 
		 */		
		public function moveFirstLine():void
		{
			if(_txtScroll)_txtScroll.moveFirstLine();
		}
		
		/**
		 * 最后一行 
		 */		
		public function moveLastLine():void
		{
			if(_txtScroll)_txtScroll.moveLastLine();
		}
		
		/**
		 * 上一行 
		 * 
		 */		
		public function movePrevLine():void
		{
			if(_txtScroll)_txtScroll.movePrevLine();
		}
		
		/**
		 *是否默认显示滚动条 
		 */		
		public function set isShowBar(value:Boolean):void
		{
			_isShowBar = value;
			_sc.visible = value;
		}
		
		override public function destroy():void
		{
			_sc = null;
			_txtScroll.destroy();			
			if(_txtScroll.parent)
				_txtScroll.parent.removeChild(_txtScroll);
			_txtScroll = null;
			super.destroy();	
		}
		
	}
}