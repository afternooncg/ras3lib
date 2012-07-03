package com.wings.ui.components
{
	import com.wings.ui.common.RUITextformat;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.system.Capabilities;
	import flash.system.IME;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * 单行输入表单
	 * @author hh
	 *
	 */
	public class RInputText extends RLabel
	{
		
		protected var _back:Sprite;
		protected var _password:Boolean=false;
		
	
		protected var _selected:Boolean=false;
		protected var _leading:Number=0.5;
		private var _isReadOnly:Boolean=false;
		
		/**
		 * 
		 * @param parent
		 * @param params {x:0,y:0,w:0,h:0,color:0,borderColor:0,background:0,selectColor:0,leading:0}		 
		 * @param text
		 * @param defaultHandler
		 * 
		 */		
		public function RInputText(parent:DisplayObjectContainer=null, params:Object=null,text:String="", defaultHandler:Function=null)
		{
			super(text,parent, params);
			this.text=text;
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}			
			this.mouseEnabled=this.selectable=true;			
			
		}
		
		override protected function initProps():void
		{
			super.initProps();
			if (_params)
			{
				if (_params.hasOwnProperty("color"))
				{
					_tf.color =_params["color"];
					this.defaultTextFormat = _tf;
					this.setTextFormat(_tf);
				}
				//				if(_params.hasOwnProperty("borderColor")) _color = _params["borderColor"];
				//				if(_params.hasOwnProperty("background")) _color = _params["background"];
				//				if(_params.hasOwnProperty("selectColor")) _color = _params["selectColor"];
				//				if(_params.hasOwnProperty("leading")) _color = _params["leading"];
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		public function set align(tfalign:String):void
		{
			var tf:TextFormat=this.defaultTextFormat;
			tf.align=tfalign;
			this.defaultTextFormat=tf;
			tf=null;
			tfalign=null;
		}
		
		
		/**
		 * 选中
		 * @param value
		 *
		 */
		public function set selected(value:Boolean):void
		{
			_selected=value;
			
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		
		
		
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled=value;		
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public function set isReadOnly(value:Boolean):void
		{
			this.selectable=_isReadOnly=value;
			if (_isReadOnly)
			{
				this.type = TextFieldType.DYNAMIC;
				this.selectable = false;
			}
			else
			{
				this.type=TextFieldType.INPUT;
				this.mouseEnabled = true;
				this.selectable = true;
			}
		}
		
		public function get isReadOnly():Boolean
		{
			return _isReadOnly;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		override protected function addChildren():void
		{
			super.addChildren();
			
			_tf=_ruiHelper.ruiTf.inputTextFormat;
			this.border=true;
			this.defaultTextFormat=_tf;
			this.addEventListener(Event.CHANGE, onChange);
			this.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_text= this.text;
		}
		
		/**
		 * 解决10.1输入法不可用问题
		 * @param event
		 *
		 */
		private function handleFocusIn(event:FocusEvent):void
		{
			try
			{
				if (Capabilities.hasIME && this.type == TextFieldType.INPUT)
					IME.enabled=true;
			}
			catch (error:Error)
			{
				
			}
		}
		
		
	}
}