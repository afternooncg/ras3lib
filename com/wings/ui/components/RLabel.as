package com.wings.ui.components
{
	import com.wings.ui.common.IRComponent;
	import com.wings.ui.common.IRToolTips;
	import com.wings.ui.common.RUICssHelper;
	import com.wings.ui.common.RUITextformat;
	import com.wings.ui.manager.RToolTipManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * 用于显示不可编辑的文本字符串 
	 * 
	 * @author hh
	 * 
	 */	
	
	public class RLabel extends TextField implements IRComponent,IRToolTips
	{
		public function RLabel(text:String="",parent:DisplayObjectContainer=null,params:Object=null)
		{				
			_text = text;
			if(parent)
			{	
				if(_params && _params.hasOwnProperty("childIndex"))
				{
					parent.addChildAt(this,int(_params.childIndex));	
				}
				else
					parent.addChild(this);
			}
			inits();			
		}
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		protected function inits():void
		{	
			_ruiHelper = RUICssHelper.getInstance();
			_uniqueid = uint((new Date()).valueOf()*Math.random());			
			initProps();
			addChildren();			
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _autoSize:Boolean = true;
		protected var _text:String = "";		
		protected var _tf:TextFormat;		
		private var _isUpdateTooltipRealTime:Boolean=false;		//是否实时更新悬停
		protected var _toolTip:Object="";		
		protected var _fixedToolTipPosi:Point;					//固定tooltips位置,以当前this坐标系为准
		
		protected var _parent:DisplayObjectContainer;
		protected var _params:Object;		
		protected var _uniqueid:uint = 0;
		protected var _ruiHelper:RUICssHelper;
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		/**
		 * 设置component唯一识别码.
		 */
		public function set uniqueid(value:int):void
		{
			_uniqueid = value;
		}
		public function get uniqueid():int
		{
			return _uniqueid;
		}
		
		
		
		public function get visibleWidth():Number
		{
			return this.width;
		}
		public function set visibleWidth(value:Number):void
		{
			this.width = value;			
		}
				
		/**
		 * 可视高度  在 addChildren() 调用前不得调用
		 * @param value
		 * @return 
		 * 
		 */		
		public function set visibleHeight(value:Number):void
		{
			this.height = value;			
		}
		
		public function get visibleHeight():Number
		{
			return this.height;
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
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * 设置xy 
		 * @param xpos
		 * @param ypos
		 * 
		 */		
		public function setLocationXY(xpos:Number, ypos:Number):void
		{
			x = Math.round(xpos);
			y = Math.round(ypos);
		}
		
		
		
		/**
		 *  
		 * 每次over事件时更新,用于tooltip是单例共享情况,如果是非单例情况,不必实现
		 */		
		public function updateEveryShow():void
		{
			
		}
		
		
		/**
		 * 对于Lable,就算text="",只要指定了_w和_h,还是设置textField的宽，和自身的高 
		 * 
		 */		
		public function drawUI():void
		{				
			
		}
	
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{
			RToolTipManager.getInstance().unregister(this);
			if(this.parent && this.parent.contains(this))
				this.parent.removeChild(this);
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		/**
		 * 
		 * 必须被子类override 读取params参数,并做初始化工作 建立初始对象（非displayObject类型）
		 */		
		protected function initProps():void
		{	
			if(_params==null) return;				
			if(_params.x) this.x = int(_params["x"]);
			if(_params.y) this.y = int(_params["y"]);			
			if(_params.w) this.width = int(_params["w"]);
			if(_params.h) this.height = int(_params["h"]);
			
		}
		/**
		 * Creates and adds the child display objects of this component.
		 */
		protected function addChildren():void
		{		
			
			//_txt = new TextField();
			this.selectable = false;
			
//			_txt.autoSize = "left";
//			_txt.wordWrap = true;
//			_txt.border = true;
			_tf = _ruiHelper.ruiTf.lableTextFormat;				
			this.defaultTextFormat = _tf;
			this.text = _text;
			
			drawUI();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
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
		
	}
}