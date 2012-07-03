package com.wings.ui.components.combox
{
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;

	public class RCboxHeaderBtnProxy implements IDestroy
	{		
		private var _view:DisplayObjectContainer
		public function RCboxHeaderBtnProxy(view:DisplayObjectContainer)
		{
			_view = view;
		}
		
		public function set htmlText(str:String):void
		{
			(_view.getChildByName("txt_title") as TextField).htmlText = str;
		}
		
		public function get btn():DisplayObject
		{
			if(_view)
				return (_view.getChildByName("btn_dropdown") as DisplayObject);
			return null;
		}
		
		public function isFit():Boolean
		{			
			return _view.getChildByName("txt_title") && _view.getChildByName("btn_dropdown");
		}
		
		public function get view():DisplayObjectContainer
		{
			return _view;
		}
		
		public function destroy():void			
		{
			_view = null;		
		}
	}
}