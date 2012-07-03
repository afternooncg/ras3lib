package com.wings.ui.components.combox
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.common.IRListItem;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.components.RBaseButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	/**
	 * RCombox的下拉单行 
	 * @author hh
	 * 
	 */	
	public class RComboxItem extends RBaseButton implements IRListItem
	{	
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
		public function RComboxItem(data:*, index:int=0,parent:DisplayObjectContainer=null, params:Object = null,skin:RUISkin=null, icon:RUISkin=null)
		{
			_index = index;
			_itemData = data;			
			_skin = _skin==null ? RUIAssets.getInstance().comboxItemSkin : _skin; 
			super(parent,params, String(data.label), _skin, icon);
			
			 if(data.hasOwnProperty("fontcolor"))
			 {
				 var tf:TextFormat = this.textFormat;
				 tf.color = uint(data["fontcolor"]);
				 this.textFormat = tf;
				 
				 tf = this.textFormatOver;
				 tf.color = uint(data["fontcolor"]);
				 this.textFormatOver = tf;				 
			 }
			 
			
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _itemData:Object;  //{label:*,data:*}
		private var _index:int;
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		/**
		 * 设置数据 
		 * @param value 格式{label=""，data=""} 
		 * 
		 */		
		public function set data(value:Object):void
		{			
			this._itemData = value;			
		}
		
		public function get data():Object
		{
			return this._itemData;
		}
		
		public function set index(value:int):void
		{
			this._index = value; 
		}
		
		public function get index():int
		{
			return _index;
		}
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		override public function destroy():void
		{
			super.destroy();
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
		
	}
}