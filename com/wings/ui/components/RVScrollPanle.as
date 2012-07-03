package com.wings.ui.components
{
	import com.wings.common.IDestroy;
	import com.wings.ui.common.IRComponent;
	import com.wings.ui.common.IRSize;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 提供带竖向滚动掉的容器
	 * 注意.禁止向本容器设置width/height,容器的显示宽度高度需指定,自动判断滚动条是否需要出现 
	 * @author hh
	 * 
	 */	
	public class RVScrollPanle extends Sprite implements IDestroy,IRSize
	{
		private var _scrollbarView:DisplayObjectContainer;
		private var _scrollBar:RVScrollBar;
		private var _onScrollCallBack:Function;
		private var _body:DisplayObject;
		private var _mask:Shape;
		private var _params:Object;
		private var _w:Number=200;
		private var _h:Number=150;
		private var _isForceHandlerSize:Boolean=false;
		/**
		 * 
		 * @param body
		 * @param params 
		 * @param scrollbarSkin
		 * 
		 */
		
		/**
		 *  
		 * @param body  注意body需要有w h>0,如果初始body初始w.h=0,则当bodywh>0后 需额外调用this.body=bodyobj
		 * @param parent
		 * @param params		{x,y,w,h}h是RVScrollPanle高度.注意body的显示宽度=w-scrollbarSkin.visibleWidth
		 * @param scrollbarSkin
		 * @isForceHandlerSize  是否强迫滑动块高度不变
		 */		
		public function RVScrollPanle(body:DisplayObject,parent:DisplayObjectContainer=null, params:Object=null,isForceHandlerSize:Boolean=false,scrollbarSkin:DisplayObjectContainer=null,onScrollCallBack:Function=null)
		{			
			if(parent!=null)
				parent.addChild(this);
			_params = params;
			_body = body;			
			_scrollbarView = scrollbarSkin;
			_isForceHandlerSize = isForceHandlerSize;
			_onScrollCallBack = onScrollCallBack;
			inits();
		}
		
		
		protected function inits():void
		{	
			//this.mouseEnabled = false;
			this.mouseChildren = true;	
			initProps();
			addChildren();
			drawUI();			
		}
		
		/**
		 * 
		 * 必须被子类override 读取params参数,并做初始化工作 建立初始对象（非displayObject类型）
		 */		
		protected function initProps():void
		{	
			if(_params==null) return;				
			if(_params.x) this.x = int(_params["x"]);
			if(_params.y) this.y = int(_params["y"]);			
			if(_params.w) this._w = int(_params["w"]);
			if(_params.h) this._h = int(_params["h"]);			
		}
		
		protected function addChildren():void
		{			
			_scrollBar	= new RVScrollBar(_scrollbarView,{h:_h},_isForceHandlerSize,_onScrollCallBack);
			_onScrollCallBack = null;
			this.addChild(_scrollBar);
			_mask = new Shape();	
			this.mask  = _mask;
			this.addChild(_mask);
		}
		
		public function drawUI():void
		{				
			if(_body)
			{
				this.addChildAt(_body,0);
				_scrollBar.body = _body;						
			}			
			
			_scrollBar.visibleHeight = _h;						
			_scrollBar.x = this._w - _scrollBar.visibleWidth;
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xffffff,0.5);
			_mask.graphics.drawRect(0,0,_w,_h);
			_mask.graphics.endFill();	
			
			this.graphics.clear();
			this.graphics.beginFill(0xffffff,0);
			this.graphics.drawRect(0,0,_w,_h);
			this.graphics.endFill();	
			
		}
		
		
		/**
		 * 可视宽度 (不包含mask部分)
		 * @param value
		 * @return 
		 * 
		 */		
		public function set visibleWidth(value:Number):void
		{		
			if(value<0)
				value=0;
			if(value>4000)
				value=4000;
			
			if(_w!=value)
			{
				_w = Math.round(value);
				drawUI();	
			}
			
		}
		public function get visibleWidth():Number
		{				
			return _w>0?_w:this.width;	
		}
		
		/**
		 * 可视高度 (不包含mask部分)
		 * @param value
		 * @return 
		 * 
		 */		
		public function set visibleHeight(value:Number):void
		{
			if(value<0)
				value=0;
			if(value>4000)
				value=4000;
			
			if(_w!=value)
			{
				_h = Math.round(value);
				drawUI();	
			}
		}
		public function get visibleHeight():Number
		{			
			return  _h>0?_h:this.height;
		}
		
		/**
		 * 内部用计算用高度 
		 * @return 
		 * 
		 */				
		public function set countBodyHeight(value:Number):void
		{			
			_scrollBar.countBodyHeight = value;
		}
		
		public function set body(value:DisplayObject):void
		{
			if(value == null)
			{
				_scrollBar.removeBody();
				_scrollBar.hideScrollBar();
				return;	
			}
			_body = value;
			drawUI();
		}
		public function get body():DisplayObject
		{
			return _body;
		}
		
		/**
		 * 单词滚动高度 
		 * @param value
		 * 
		 */		
		public function set scrollLineHeight(value:Number):void
		{
			_scrollBar.scrollLineHeight = value;
		}
		
		public function set currentLine(value:int):void
		{
			_scrollBar.currentLine = value;
		}
		
		public function get currentLine():int
		{
			return _scrollBar.currentLine;	
		}
		
		public function get bar():RVScrollBar
		{
			return _scrollBar;
		}
		
		/**
		 *是否相识滚动条的背景 
		 */			
		public function set isShowBarBg(value:Boolean):void{
			_scrollBar.isShowBg = value;
		}
		
		/**
		 *是否一直显示滚动条 
		 * @param value
		 * 
		 */		
		public function set isAlwaysShowBar(value:Boolean):void
		{
			_scrollBar.isAlwaysShow = true;
		}
		
		public function destroy():void
		{
			_scrollBar.destroy();
			_scrollBar = null;
			
			_mask.graphics.clear();
			this.removeChild(_mask);
			_mask = null;
			
			if(_body && this.contains(_body))
				this.removeChild(_body);
			_body = null;
			
		}
		
	}
}