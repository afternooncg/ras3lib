package com.wings.ui.common
{
	import com.wings.common.IDestroy;	
	import com.wings.ui.components.constdefine.SkinState;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * 基本皮肤状态管理实现 
	 * @author hh
	 * 
	 */	
	public class RUISkin extends Sprite implements IDestroy
	{	
		
		private var _state:String = SkinState.UPSTATE;
		
		public function RUISkin()
		{
		}
		
		//弹起状态
		private var _upState:DisplayObject;
		public function set upState(disp:DisplayObject):void
		{
			if(disp)
			{
				_upState = disp;
				if(this.numChildren==0) this.addChild(this.upState);				
			}
			
		}		
		public function get upState():DisplayObject
		{
			return _upState;	
		}
		
		//经过状态
		private var _overState:DisplayObject;
		public function set overState(disp:DisplayObject):void
		{
			if(disp) _overState = disp;	
		}		
		public function get overState():DisplayObject
		{
			return _overState == null ? _upState : _overState;	
		}
		
		//按下”状态
		private var _downState:DisplayObject;
		public function set downState(disp:DisplayObject):void
		{
			if(disp) _downState = disp;	
		}		
		public function get downState():DisplayObject
		{
			return _downState == null ? this.overState : _downState;	
		}
		
		
		//“禁止使用”状态
		private var _disableState:DisplayObject;
		public function set disableState(disp:DisplayObject):void
		{
			if(disp) _disableState = disp;	
		}		
		public function get disableState():DisplayObject
		{
			return _disableState == null ? _upState : _disableState;	
		}
	
		/**
		 * 皮肤状态 
		 * @param value
		 * 
		 */		
		public function set state(value:String):void
		{			
			if(this.numChildren>0) this.removeChildAt(0);
			
			if(value == SkinState.UPSTATE)
			{				
				this.addChildAt(this.upState,0);
			}
			else if(value ==  SkinState.OVERSTATE)
			{			
				this.addChildAt(this.overState,0);	
			}	
			else if(value ==  SkinState.DOWNSTATE)
			{				
				this.addChildAt(this.downState,0);	
			}
			else if(value ==  SkinState.DISABLESTATE)
			{			
				this.addChildAt(this.disableState,0);	
			}			
			_state = value;	
		}
		public function get state():String
		{
			return _state;
		}
		
		/**
		 * 覆写width,设置全部的state宽度 
		 * @param value
		 * 
		 */		
		override  public function set width(value:Number):void
		{			
			this.upState.width = this.overState.width = this.downState.width = this.disableState.width = value;	
		}
		
		/**
		 * 覆写height,设置全部的state高度 
		 * @param value
		 * 
		 */
		override  public function set height(value:Number):void
		{			
			this.upState.height = this.overState.height = this.downState.height = this.disableState.height = value;
		}
		
		public function destroy():void
		{
			if(_upState) upState = null;
			if(_overState) overState = null;
			if(_downState) downState = null;
			if(_disableState) disableState = null;
		}
		
		/**
		 * 克隆自身 注意,只支持嵌入与compentRes的资源
		 * @return 
		 * 
		 */		
		public function clone():RUISkin
		{
			var skin:RUISkin = new RUISkin();			
			skin.upState = RUIAssets.getInstance().GetObject(getQualifiedClassName(_upState)) as DisplayObject;
			skin.overState = RUIAssets.getInstance().GetObject(getQualifiedClassName(_overState)) as DisplayObject;
			skin.downState =  RUIAssets.getInstance().GetObject(getQualifiedClassName(_downState)) as DisplayObject;
			skin.disableState = RUIAssets.getInstance().GetObject(getQualifiedClassName(_disableState)) as DisplayObject;
			return skin;
		}
		
	}
	
}