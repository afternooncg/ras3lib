package com.wings.ui.components
{
	import com.wings.common.IDestroy;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUICssHelper;
	import com.wings.util.display.BitmapScale9Grid;
	import com.wings.util.display.DisplayObjectKit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 * 鼠标悬停类 比较简单只包含1个txt对象及1个背景对象
	 * @author hh
	 * 
	 */	
	public class RTooltip extends Sprite implements IDestroy
	{
		
		/**
		 * 
		 * @param parent 父容器
		 * @param toolStr 悬停文本
		 * @param skin	 背景皮肤		 
		 */		
		public function RTooltip(toolStr:String="",skin:DisplayObject=null)
		{
			this.mouseChildren = this.mouseEnabled = false;
			_skin = skin==null? RUIAssets.getInstance().ToolTipSkin : skin;
			_toolTip = toolStr;			
			//this.visible = false;
			
			this.mouseChildren = this.mouseEnabled = false;						
			addChildren();
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
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _skin:DisplayObject;				//背景
		private var _text:TextField;		
		private var _maxWidth:Number=300;
		private var _paddingLeft:Number=10;
		private var _paddingRight:Number=10;
		private var _paddingTop:Number=10;
		private var _paddingDown:Number=10;		
		private var _dalayTime:int=0;		
		private var _tf:TextFormat;
		private var _fiexedPosi:Point;
		private var _toolTip:String;
		private var _handleTimeOutId:uint;
		private var _bg:Shape;
		private var _tooltipBgBrushPen:BitmapScale9Grid;
		
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * 悬停文本 
		 * @param value
		 * 
		 */		
		public function set text(value:String):void
		{						
			_text.width = _maxWidth;
			_text.multiline = true;
			_text.wordWrap = true;
			_toolTip = _text.htmlText = value;
			_text.autoSize = "left";
			_text.width = _text.textWidth > _maxWidth?_maxWidth:_text.textWidth+5;
			_text.height = _text.textHeight + 5;				
			drawUI();
		}		
		public function get text():String
		{
			return _toolTip; 
		}
		
		
		/**
		 *悬停的最大显示宽度 
		 * @param value
		 * 
		 */		
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
			_text.width = _maxWidth;
		} 
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		
		/**
		 * 固定位置 
		 * @return 
		 * 
		 */		
		//		public function get fiexedPosi():Point
		//		{
		//			if(_fiexedPosi) return _fiexedPosi.clone();
		//			return null
		//		}
		//		public function set fiexedPosi(p:Point):void
		//		{
		//			if(p!=null) _fiexedPosi = p;
		//		}
		
		
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
		
		
		
		public function destroy():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);	
			this.removeEventListener(Event.REMOVED_FROM_STAGE,handleRemoveFromStage);
			if(this.contains(_text))
				this.removeChild(_text);
			
			if(this.contains(_skin))
				this.removeChild(_skin);
				
			_text = null;
			_skin = null;
			
			_toolTip = "";
			clearTimeout(_handleTimeOutId);
			_tooltipBgBrushPen.destroy();
			_tooltipBgBrushPen = null;
			_bg.graphics.clear();
			_bg = null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		private function addChildren():void
		{   			
		//	this.addChild(_skin);
			_bg = new Shape();
			this.addChild(_bg);
			_tf= RUICssHelper.getInstance().ruiTf.toolTipFormat;			
			_text = new TextField();
			_text.width = _maxWidth;
			_text.multiline = true;
			_text.wordWrap = true;
			_text.x  = _paddingLeft;
			_text.y = _paddingTop;
			_text.defaultTextFormat = _tf;
			this.addChild(_text);
			_tooltipBgBrushPen = new BitmapScale9Grid( DisplayObjectKit.displayObjToBitmap(_skin,true).bitmapData,new Rectangle(5,14,144,108),true,0,_bg.graphics);
			if(_toolTip!="") 
				this.text = _toolTip;
			
		}
		
		
		private function timerOver():void
		{
			this.visible = true;
		}
		
		/**
		 * 更新背景size 
		 * 
		 */		
		private function drawUI():void
		{
			//_skin.width = _text.width +_paddingLeft+_paddingRight;
			//_skin.height = _text.height + _paddingTop +_paddingDown;
			_tooltipBgBrushPen.updateSize(_text.width +_paddingLeft+_paddingRight,_text.height + _paddingTop +_paddingDown,_bg.graphics);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 加入显示列表时显示自己 
		 * @param e
		 * 
		 */		
		private function handleAddToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,handleAddToStage);	
			this.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoveFromStage);
  
			if(_dalayTime <= 0)
			{
				this.visible = true;
			}
			else
			{
				_handleTimeOutId = setTimeout(timerOver,_dalayTime);
			}
		}
		
		private function handleRemoveFromStage(event:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);	
			this.removeEventListener(Event.REMOVED_FROM_STAGE,handleRemoveFromStage);	
			
		}		
	}
}