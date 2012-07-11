package com.wings.ui.components
{	
	
	import com.wings.common.IDestroy;
	import com.wings.ui.common.IRComponent;
	import com.wings.ui.common.RUICssHelper;
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	/**
	 * 组件基类
	 * 本类提供自定义组件的的1个底层工作方法顺序模板,及UI重绘机制,这个类之后主要产生2个分支.一个基于容器类的(不带悬停感应)，1个是基于特定功能控件类（特征） 容器类w/h由内部填充对象来决定	  
	 * 获取可视长宽请用 visibleWidth/visibleHeight,请维护正确的_w _h值,该值将反应bg的长宽属性
	 * 由于采用异步调用drawUI的模式，因此在设置了涉及_w_h变化的属性,_w_h不会马上改变，而会等到下帧，如果需要马上或得，请在设置属性后,调用drawUI;
	 * 在使用中发现,自动计算_w_h的模式会带来很多麻烦.建议非特殊组件应都给予默认的初始值
	 * 
	 * @author hh
	 * 
	 */	
	
	[Event(name = "resize", type = "flash.evnets.Event")]
	[Event(name = "draw", type = "flash.events.Event")]
	public class RBaseComponents extends Sprite implements IRComponent
	{	
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		/**
		 * 内部_w. _h发生时抛出 
		 */		
		static public const DRAW:String = "components_draw";
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @param parent 父容器对象
		 * @param params {x:0,y:0,w:0,h:0,childIndex:1} mask=0/1 关闭/启用
		 * 
		 */		
		public function RBaseComponents(parent:DisplayObjectContainer=null, params:Object=null)
		{			
			_params = params;
			inits();
			if(parent)
			{	
				if(_params && _params.hasOwnProperty("childIndex"))
				{
					parent.addChildAt(this,int(_params.childIndex));	
				}
				else
					parent.addChild(this);
			}
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
			invalidate();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _params:Object;		
		protected var _w:Number = 0;							//存放可视宽度,在需要内部需要提供mask的组件中及内部对象包含有mask的情况,起存储可视长度的作用
		protected var _h:Number = 0;							//存放可视高度				
		protected var _uniqueid:uint = 0;
		protected var _isEnabledMask:Boolean = false;			
		protected var _ruiHelper:RUICssHelper;
				
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
		
		/**
		 * 为提高效率,将x,y都转成int
		 * @param value
		 * 
		 */		
		override public function set x(value:Number):void
		{			
			super.x = int(value);
		}
		override public function set y(value:Number):void
		{			
			super.y = int(value);
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
				invalidate();	
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
				invalidate();	
			}
		}
		public function get visibleHeight():Number
		{			
			return  _h>0?_h:this.height;
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
		 *  重置长宽
		 * @param	w 
		 * @param	h 
		 */
		public function setVisualSize(w:Number, h:Number):void 
		{
			this.visibleWidth = w;
			this.visibleHeight = h;
		}
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
		 * 被子类override,主要控制UI界面绘制,以及_w/_h的计算，可被多次调用
		 * 注意,drawUI被异步调用,如果子类为容器类,计算子类应调用visibleWidth和visibleHeight
		 */
		public function drawUI():void
		{			
			
			//this.cacheAsBitmap = true;		
			dispatchEvent(new Event(RBaseComponents.DRAW));
			
			//			fordebug
			/*this.graphics.clear();
			this.graphics.beginFill(0x0000ff,0.5);
			this.graphics.drawRect(0,0,this.width,this.height);
			this.graphics.endFill();*/
		}
		
		
		/**
		 * 默认将自动找出所有的RBaseComponents的子对象并执行destroy()
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		public function destroy():void
		{									
			RUIManager.stage.removeEventListener(Event.ENTER_FRAME, handleCallDrawUI);
			var obj:IDestroy; 
			while(this.numChildren>0)
			{
				obj = this.removeChild(this.getChildAt(0)) as IDestroy;
				if(obj) 
					obj.destroy();	
				
			}
			
			if(this.parent && this.parent.contains(this))
				this.parent.removeChild(this);
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
		
		/**
		 * 被子类override,创建displayobject对象,请注意本方法只允许被调用1次
		 */
		protected function addChildren():void
		{			
		
		}
		
		/**
		 * 返回默认发光效果 
		 * @param color
		 * @param alpha
		 * @param blueX
		 * @param blueY
		 * @param strength
		 * @param inner
		 * @param knockout
		 * @return 
		 * 
		 */		
		protected function getGrow(color:uint=0xFFE88B,alpha:Number=1,blueX:Number=6,blueY:Number=6,strength:Number=2,inner:Boolean=false, knockout:Boolean = false):GlowFilter
		{
			return new GlowFilter(color,alpha,blueX,blueY,strength,1,inner,knockout);
		}
		
		
		/**
		 * 与 drawUI具体执行外观描绘动作不同,callDrawUI是加了enterframe侦听,在下一帧才执行drawUI.这样可以提高性能，避免drawUI方法被多次调用 
		 * 
		 */		
		protected function invalidate():void
		{			
			RUIManager.getInstance().registEnterFrameListener(handleCallDrawUI);
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
		
		/**
		 * 异步调用drawUI 
		 * @param event
		 * 
		 */		
		protected function handleCallDrawUI(event:Event=null):void
		{
			RUIManager.getInstance().unRegistEnterFrameListener(handleCallDrawUI);
			drawUI();
		}	
		
		
	}
}