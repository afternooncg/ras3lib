package com.wings.ui.components.combox
{
	import com.wings.ui.common.IRListItem;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.components.RMovieClipButton;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	/**
	 * 基于MovieClip的combox item  强制要求有个txtLabel名称的TextField资源
	 * @author hh
	 * 
	 */	
	public class RBaseMcComboxItem extends RMovieClipButton implements IRListItem
	{
		public function RBaseMcComboxItem(button:MovieClip, data:*, index:int=0,parent:DisplayObjectContainer=null, params:Object = null)
		{
			super(button, parent, params);
			_itemData = data;
			_index = index;
			if(button)
			{
				_txtLabel = button.getChildByName("txtLabel") as TextField;				
			}	
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		protected var _itemData:Object;  //{label:*,data:*}
		protected var _index:int;
		protected var _txtLabel:TextField;
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
		
		public function set label(str:String):void
		{
			if(_txtLabel)
				_txtLabel.htmlText = str;
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