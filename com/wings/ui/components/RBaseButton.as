package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.common.RUITextformat;
	import com.wings.ui.components.constdefine.SkinState;
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 按钮基类,默认提供透明皮肤 注意應保持mousechilden=false/否則在buttonskin的狀態改變過程中，可能會出現些比較奇怪的問題(應是鼠標感應區發生了變化導致);
	 * @author hh
	 * 
	 */	
	public class RBaseButton extends RComponent implements IRButton
	{
		/**
		 *
		 * @param parent		父容器
		 * @param params		{x,y,w,h,iconspacing,value,paddingleft,paddingright,paddingtop,paddingbottom,isHtmlText}
		 * @param label			文本
		 * @param skin			背景		 
		 * @param icon			图标
		 * 
		 */				
		public function RBaseButton(parent:DisplayObjectContainer=null,params:Object=null,label:String = "",skin:RUISkin=null,icon:RUISkin=null)
		{						
			_skin = (skin == null) ? RUIAssets.getInstance().btnSkin1 : skin;		
			_skin.state = SkinState.UPSTATE;
			_labelText = label;
			this.addEventListener(Event.ADDED_TO_STAGE,handleAddToStage);
			if(icon!=null) 
			{
				_icon = icon;
				_icon.state = SkinState.UPSTATE;
			}
			
			if(params && _icon) 
			{
				if(params.hasOwnProperty("iconspacing")) 
					_iconSpacing = params("iconspacing"); 
			}
			
			super(parent,params);
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

		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{	
			
			super.inits();			
//			this.isEnabledMask = true;
			this.mouseChildren = false;
			this.buttonMode = true;			
						
		}
		
		override protected function initProps():void
		{
			super.initProps();
			
			if(_params)
			{
				if(_params.tf)
					_tf = _params.tf;					
				
				if(_params.tfOver)
					_tfOver = _params.tfOver;
				
				if(_params.paddingleft)
					_paddingLeft = int(_params.paddingleft);
				
				if(_params.paddingright)
					_paddingRight = int(_params.paddingright);
				
				if(_params.paddingtop)
					_paddingTop = int(_params.paddingtop);
				
				if(_params.paddingbottom)
					_paddingBottom = int(_params.paddingbottom);
				
				if(_params.w)
					_inputw = int(_params["w"]);
				if(_params.h)
					_inputh = int(_params["h"]);
				
				if(_params.isHtmlText)
					_isHtmlText = Boolean(_params.isHtmlText);
				
			}
			
			if(!_tf)				
				_tf = _ruiHelper.ruiTf.buttonTextformat;
			
			if(!_tfOver)
				_tfOver = _ruiHelper.ruiTf.buttonTextOverformat;
			
			_cacheTf[0] = _tf;
			_cacheTf[1] = _tfOver;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _skin:RUISkin;
		protected var _label:TextField;
		protected var _labelText:String = "";
		
		protected var _isPressed:Boolean = false;				//鼠标是否被按住
		protected var _canDbClick:Boolean = false;
		protected var _handleTimeOut:int =0;
		
		protected var _isSelected:Boolean = false;			//是否被选中状态
		protected var _buttonState:String = SkinState.UPSTATE;			//ui状态
		private var _pauseMouseEnabled :Boolean = false;     //是否处于暂时屏蔽mouseeanble状态,当_canDbClick=false时启用
		protected var _icon:RUISkin;		
		protected var _iconSpacing:Number = 5;
		protected var _labelCt:Sprite;
		protected var _labelCtMask:Shape;
		
		protected var _tf:TextFormat;				//默认文字效果
		protected var _tfOver:TextFormat;			//鼠标移上文字效果
		protected var _value:Object;
		
		protected var _paddingTop:int=5,_paddingRight:int=10,_paddingBottom:int=5,_paddingLeft:int=10; //间距
		protected var _inputw:Number=0;	//自行绘制UI w
		protected var _inputh:Number=0;	//自行绘制UI h
		protected var _isSelecteOver:Boolean = true;				//selecte状态下 over 效果是否启用
		
		protected var _isHtmlText:Boolean = false;				//是否htmltxt的模式渲染文本
		protected var _cacheTf:Array = [];							//缓存tf
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
		 * 是否以htmltxt模式渲染 
		 * @return 
		 * 
		 */		
		public function get isHtmlText():Boolean
		{
			return _isHtmlText;
		}
		
		public function set isHtmlText(value:Boolean):void
		{
			_isHtmlText = value;
			if(_isHtmlText)
			{
				_cacheTf[0] = _tf;
				_cacheTf[1] = _tfOver;
				_tf = _tfOver = new TextFormat();
			}
			else
			{
				_tf = _cacheTf[0] as TextFormat;
				_tfOver = _cacheTf[1] as TextFormat;
			}
				
		}
		
		/**
		 * 选中状态是否启用over ui变化 
		 * @param bool
		 * 
		 */		
		public function set isSelectedOver(bool:Boolean):void
		{
			_isSelecteOver = bool;
		}
		
		
		public function set isSelected(bool:Boolean):void
		{
			_isSelected = bool;
			if(_isSelected) {
				this.buttonState = SkinState.DOWNSTATE;
				_label.setTextFormat(_tfOver);
			}
			else{
			  this.buttonState = SkinState.UPSTATE;
			  _label.setTextFormat(_tf);
			}
		}
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */
		public function set label(str:String):void
		{
			if(!_isHtmlText)
				_label.text = _labelText = str;
			else
				_label.htmlText = _labelText = str;
			this.drawUI();
		}
		public function get label():String
		{
			return _labelText;
		}
		
		public function set canDbClcik(bool:Boolean):void
		{
			_canDbClick = bool;
		}
		public function get canDbClcik():Boolean
		{
			return _canDbClick;
		}
		
		public function set buttonState(state:String):void		
		{	
			if(this.numChildren==0) return;
			_skin.state = _buttonState = state;
			if(_icon) _icon.state = state;
		}
		public function get buttonState():String
		{
			return _buttonState;
		}
		
		public function get textFormat():TextFormat
		{
			return _tf;
		}
		public function set textFormat(tf:TextFormat):void
		{
			if(tf)
			{
				_tf = tf;
				_label.setTextFormat(_tf);
				_label.defaultTextFormat = _tf;
			}		
			drawUI();
		}
		
		public function get textFormatOver():TextFormat
		{
			return _tfOver
		}
		public function set textFormatOver(tf:TextFormat):void
		{
			if(tf)
			{
				_tfOver = tf;				
				_label.setTextFormat(_tfOver);
				//_label.defaultTextFormat = _tfOver;
			}
			drawUI();
		}
		
		/**
		 * 按钮值 
		 * @return 
		 * 
		 */		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(data:Object):void
		{
			_value = data;
		}
		
		override public function get visibleWidth():Number
		{				
			if(_inputw<=0)
			{
				if(_w<=0)
					drawUI();				
				return _w;
			}
			else
				return _inputw;
		}
		
		/**
		 * 可视高度 (不包含mask部分)
		 * @param value
		 * @return 
		 * 
		 */		
		override public function get visibleHeight():Number
		{
			if(_inputh<=0)
			{
				if(_h<=0)
					drawUI();				
				return _h;
			}
			else
				return _inputh;
			
		}
		
		/**
		 * 可视宽度 (不包含mask部分)
		 * @param value
		 * @return 
		 * 
		 */		
		override public function set visibleWidth(value:Number):void
		{		
			super.visibleWidth = value;
			_inputw = value;
		}
	
		
		/**
		 * 可视高度 (不包含mask部分)
		 * @param value
		 * @return 
		 * 
		 */		
		override public function set visibleHeight(value:Number):void
		{
			super.visibleHeight = value;
			_inputh = value;
		}
		
		public function get labelTextFild():TextField
		{
			return _label;
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
		 *  布局算法,如果不指定_w/_h,自动计算,如果指定_w/_h,则严格按指定显示区域渲染 
		 * 
		 */		
		override public function drawUI():void
		{				
			if(_isSelected)
				_label.setTextFormat(_tfOver);
			else
				_label.setTextFormat(_tf);
						
			if(_icon)
				_labelCt.addChild(_icon);
			
			var labelCtW:Number = _label.width;
			if(_labelText!="") 
			{					
				_labelCt.addChild(_label);
				if(_icon)				
				{
					_label.x = _icon.width + _iconSpacing;
					_icon.y = (_label.height -_icon.height)/2;
					labelCtW += _icon.width +_iconSpacing
				}
			}
			
			
			
			
			if(_inputw<=0)
			{//自适应宽度
				_w = labelCtW + _paddingLeft+_paddingRight;	
				_labelCtMask.width = labelCtW;								
			}
			else 
			{//指定
				_labelCtMask.width = _w -( _paddingLeft+_paddingRight);
			}
			
			if(_inputh<=0)
			{//自适应高度
				_h = _labelCt.height + _paddingTop + _paddingBottom;
				_labelCtMask.height = _labelCt.height;				
			}
			else
			{//指定				
				_labelCtMask.height = _h - (_paddingTop + _paddingBottom);
			}
				
			_skin.width = _w;
			_skin.height = _h;
			
			if((_w - labelCtW)>=(_paddingLeft+_paddingRight))
				_labelCt.x = (_w - labelCtW)/2;
			else
				_labelCt.x = _paddingLeft;
			
			if((_h - _labelCt.height)>=(_paddingTop+_paddingBottom))	
				_labelCt.y = _paddingTop;
			else
				_labelCt.y = (_h - _labelCt.height)/2+1;
				
		
			if(!_isGray && !_enabled)			
				this.buttonMode = true;			
			
			super.drawUI();			
//			this.graphics.beginFill(0xFF0000,0.5);
//			this.graphics.drawRect(0,0,this.width,this.height);
//			this.graphics.endFill();
			
		}
		
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{			
			_cacheTf.length = 0;
			_cacheTf = null;
			clearTimeout(_handleTimeOut);
			resetEventListener();
			_skin.destroy();
			_skin = null;
			
			if(_icon) 
			{
				_icon.destroy();
				_icon = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		override protected function addChildren():void
		{
			super.addChildren();
			
			this.isHtmlText = _isHtmlText;
			
			_labelCt = new Sprite();
			_labelCt.mouseEnabled = false;
			
			this.addChild(_skin);		
			
			_label = new TextField()
			_label.type = TextFieldType.DYNAMIC;
			_label.autoSize = "left";		//note if use autoSize prop then when text is all space then textwidth/and width is not correct;
			_label.defaultTextFormat = _tf;
			
			//set text after set _tf is safe for text show effect
			if(!_isHtmlText)
				_label.text = _labelText;
			else
				_label.htmlText = _labelText;
			_labelCt.addChild(_label);
			 _label.mouseEnabled = false; 
			 _labelCtMask = new Shape();
			 _labelCtMask.graphics.beginFill(0,0);
			 _labelCtMask.graphics.drawRect(0,0,1,1)
			 _labelCtMask.graphics.endFill();
			 _labelCt.addChild(_labelCtMask);
			 _labelCt.mask = _labelCtMask;			 
			 _label.y = _labelCtMask.y = -2;		//为了调整文字显示偏差
			if(_icon!=null)
			{				
				_labelCt.addChild(_icon);
				_label.x = _icon.width + _iconSpacing;
				_icon.mouseEnabled = false;
			}
			
			this.addChild(_labelCt);
			
			
		}
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		protected function enableMouseEvent():void
		{
			this.mouseEnabled = true;
			_pauseMouseEnabled = false;
		//	this.mouseChildren = false;
			clearTimeout(_handleTimeOut);
		}
		
		protected function resetEventListener():void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			this.removeEventListener(MouseEvent.ROLL_OUT,handleMouseOut);
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
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
		
		public function handleAddToStage(event:Event):void
		{	
			this.addEventListener(MouseEvent.MOUSE_OVER,handleMouseOver);			
		}	
		
		
		/**
		 * 鼠标移入 
		 * @param event
		 * 
		 */		
		protected function handleMouseOver(event:MouseEvent):void
		{			
			if(!_isGray)
			{
				this.removeEventListener(MouseEvent.ROLL_OVER,	handleMouseOver);
				this.addEventListener(MouseEvent.ROLL_OUT,	handleMouseOut);
				this.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);			
				if(!_isSelected)
				{
					_skin.state = SkinState.OVERSTATE;
					_label.setTextFormat(_tfOver);
				}
			}
		}
		
		
		
		
		protected function handleMouseOut(event:MouseEvent):void
		{			
			this.removeEventListener(MouseEvent.ROLL_OUT,	handleMouseOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,	handleMouseDown);
			this.addEventListener(MouseEvent.ROLL_OVER,handleMouseOver);
			
			if(!_isPressed && !_isSelected && !_pauseMouseEnabled)
			{
				_skin.state = SkinState.UPSTATE;
				_label.setTextFormat(_tf);							
			}
			
		}
		
		protected function handleMouseDown(event:MouseEvent):void
		{		
			_isPressed = true;			
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);		
			
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;			
			if(!value)
			{
				clearInterval(_handleTimeOut);	
			}				
		}
		
		protected function handleMouseUp(event:MouseEvent):void
		{	
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
			_isPressed = false;			
			
			if(_enabled)
			{
				if(!_canDbClick)
				{				
					this.mouseEnabled = false;		
					_pauseMouseEnabled = true;
					_handleTimeOut = setTimeout(enableMouseEvent,300);
				}
				
				if(_isSelected)
				{//按钮处于选中状态
					if(_isSelecteOver)
						_skin.state = SkinState.OVERSTATE; //over ui;
					else
						_skin.state = SkinState.DOWNSTATE; //down ui;
					_label.setTextFormat(_tfOver);
					resetEventListener();
				}
				else
				{//普通状态	
					if(!this.hitTestPoint(event.stageX,event.stageY))
					{//鼠标在按钮外释放
						_skin.state = SkinState.UPSTATE;
						_label.setTextFormat(_tf);
						resetEventListener();
					}
					else
					{					
						_skin.state = SkinState.OVERSTATE; //over ui;
						_label.setTextFormat(_tfOver);						
						RUIManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
					}
				}
			}
			else
			{
				_skin.state = SkinState.OVERSTATE; //over ui;
				this.enabled = false;
				_label.setTextFormat(_tfOver);
				clearTimeout(_handleTimeOut);
				resetEventListener();
			}
					
		}		
		
		
		protected function handleMouseMove(event:MouseEvent):void
		{
			if(!this.hitTestPoint(event.stageX,event.stageY))
			{
				_skin.state = SkinState.UPSTATE;
				_label.setTextFormat(_tf);
				enableMouseEvent();
				resetEventListener();
			}			
		}
		
	}
}