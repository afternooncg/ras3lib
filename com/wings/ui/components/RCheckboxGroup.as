package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	
	import flash.events.MouseEvent;
	
	import mx.core.IButton;
	
	/**
	 * 封装checkbox 
	 * @author hh
	 * 
	 */	
	public class RCheckboxGroup extends RBaseButtonGroup
	{
		public function RCheckboxGroup(buttons:Vector.<IRButton>=null)
		{
			super(buttons);
		}
		
		
		private var _selectedIndexs:String = ""; //"1,3,5";
		
		public function get selectedIndexs():String
		{ 
			return _selectedIndexs;
		}
		
		/**
		 *  设置选中项目
		 * @param indexs "1,3,5";
		 * 
		 */		
		public function set selectedIndexs(indexs:String):void
		{
			_selectedIndexs = indexs;
			var len:int = _aryBtn.length;
			for(var i:uint=0;i<len;i++)
			{
				if((","+ indexs +",").indexOf("," + i.toString()+",")>=0)
					_aryBtn[i].isSelected = true;	
				else
					_aryBtn[i].isSelected = false;
			}			
		}
		
		public function get selecteItems():Vector.<IRButton>
		{	
			var vt:Vector.<IRButton> = new Vector.<IRButton>();
			var ary:Array = _selectedIndexs.split(",");
			for(var i:uint=0;i<ary.length;i++)
			{
				if(_aryBtn[i].isSelected)
					vt.push(_aryBtn[i]);
			}
			return vt;
		}
		
		/**
		 * 侦听单个按钮事件
		 * @param event
		 * 
		 */	
		override protected function handleButtonClick(event:MouseEvent):void
		{			
			_selectedIndexs = "";
			var btn1:IRButton = event.target as IRButton;
			for(var i:uint=0;i<_aryBtn.length;i++)
			{
				var btn:IRButton = _aryBtn[i];
				_selectedIndexs += btn.isSelected ? (i.toString() + ",") : "" ;
				if(btn==btn1)									
					_currentIndex = i;									
			}			
			
			if(_selectedIndexs!="")
				_selectedIndexs = _selectedIndexs.substr(0,_selectedIndexs.length-1);
			dispatchEvent(new RCollectionChangeEvent(RCollectionChangeEvent.ONCHECKBOX_CHANGE,_currentIndex,this.selectedIndexs));
		}
	}
}