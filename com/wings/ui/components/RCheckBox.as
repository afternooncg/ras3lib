package com.wings.ui.components
{	
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.components.constdefine.SkinState;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * checkbox
	 * @author hh
	 * 
	 */	
	public class RCheckBox extends RBaseButton
	{
		/**
		 * 
		 * @param label
		 * @param parent			父容器
		 * @param params			{x,y,w,h,ishtml}ishtml:true/false 允许支持htmltext格式的（true情况鼠标感应文本操作无效)
		 * @param icon
		 * @param defaultHandler    点击回调 fun(target:RCheckbox) 
		 * 
		 */				
		public function RCheckBox(label:String = "",index:int=0,btnValue:Object=null,parent:DisplayObjectContainer=null, params:Object=null,icon:RUISkin=null,defaultHandler:Function = null)
		{	
			
			if(icon==null) 
				_icon = RUIAssets.getInstance().checkBoxSkin1;	
			else
				_icon = icon;
			super(parent,params, label,RUIAssets.getInstance().baseBtnSkin,_icon);
			this.value = btnValue;
			_handle = defaultHandler;		
			_index = index;
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
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		override protected function initProps():void
		{
			_paddingLeft = _paddingRight = 0;
			_paddingBottom = _paddingTop = 2;
			super.initProps();			
			
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _index:int=0;		
		protected var _handle:Function;		//鼠标点击回调
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
		 * 当前buttonid 
		 * @return 
		 * 
		 */				
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * Sets/gets whether this component will be enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			mouseChildren = false;
		}
		
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		override public function drawUI():void
		{
//			if(_isSelected)
//			{				
//				_label.setTextFormat(_tfOver);
//			}
//			else
//			{
//				_label.setTextFormat(_tf);
//			}
//			
//			_labelCt.addChild(_icon);
//			
//			if(_labelText!="") 
//			{					
//				_labelCt.addChild(_label);				
//				_label.x = _icon.width + _iconSpacing;
//				_icon.y = (_label.height -_icon.height)/2;
//			}
//			
//			if(_w==0 || _h==0)
//			{
//				_w = _labelCt.width;				
//				_h =  _labelCt.height;	
//			}
//			
//			_skin.width = _w;
//			_skin.height = _h;
//			
//			//_labelCt.x = (_w - _labelCt.width)/2;
//			_labelCt.y = (_h - _labelCt.height)/2;
			super.drawUI();	
			//super.drawUI();			
			//			this.graphics.beginFill(0xFF0000,0.5);
			//			this.graphics.drawRect(0,0,this.width,this.height);
			//			this.graphics.endFill();
			
			_labelCt.x = _paddingLeft; //强行居左
			
			this.mouseChildren = false;
			this.buttonMode = true;
			this.cacheAsBitmap = true;
			
		}	
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{			
			this.removeEventListener(MouseEvent.CLICK, handleOnClick);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates the children for this component
		 */
		override protected function addChildren():void
		{
			super.addChildren();			
			this.addEventListener(MouseEvent.CLICK, handleOnClick,false,1000);
			
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
		
				
		protected function handleOnClick(event:MouseEvent):void
		{
			this.isSelected = !this.isSelected;
			if(_handle!=null)
				_handle(this);
		}
	}
}