package com.wings.ui.components
{
	import com.wings.common.IDestroy;
	import com.wings.ui.common.IRButton;
	import com.wings.ui.components.constdefine.UIDirection;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	
	/**
	 * 按钮切换事件 
	 */	
	[Event(name="rcollectionchangeevent_onchange", type="com.wings.ui.components.events.RCollectionChangeEvent")]
	
	/**
	 *  提供用于RTabNavigator,容器用的可切换菜单
	 * @author hh
	 * 
	 */
	public class RToggleButtonBar extends RBaseComponents
	{
		
		protected var _toggleGroup:RToggleButtonGroup;
		protected var _box:RVBox;
		protected var _spacing:int=5;
		protected var _direction:String = UIDirection.HORIZONTAL;
		
		private var _isDownEffect:Boolean = true;
		protected var _paddingLeft:Number = 0;
		
		
		/**
		 * 
		 * @param buttons
		 * @param params  {x,y,w,h,spacing:5,direction:UIDirection的值}
		 * 
		 */		
		public function RToggleButtonBar(parent:DisplayObjectContainer, buttons:Vector.<IRButton>=null,params:Object=null)
		{
			_toggleGroup = new RToggleButtonGroup(buttons);
			_toggleGroup.addEventListener(RCollectionChangeEvent.ONCHANGE,handleChangeBtn);
			if(params)
			{
				if(params.hasOwnProperty("spacing")) _spacing = params.spacing;
				if(params.hasOwnProperty("direction")) this.direction = params.direction;				
			}
			
			if(this.direction == UIDirection.HORIZONTAL)
			{
				_box = new RHBox();	
			}
			else
			{
				_box = new RVBox();
			}
			 
			_box.spacing = _spacing;
			this.addChild(_box);
			_box.x = _paddingLeft;
			
			super(parent, params);
		}
		
		override protected function inits():void
		{
			super.inits();
			this.mouseEnabled = false;
			this.mouseChildren=true;
		}
		
		/**
		 * 最左边标签距离左侧距离 
		 * @return 
		 * 
		 */		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		public function set paddingLeft(value:Number):void
		{
			_box.x = _paddingLeft = value;
		}
		
		
		public function get selectedIndex():int
		{
			return _toggleGroup.selectedIndex;
		}		
		public function set selectedIndex(id:int):void
		{			
			_toggleGroup.selectedIndex = id;			
		}
		
		
		public function get aryButtons():Vector.<IRButton>
		{
			return _toggleGroup.aryButtons;
		}
		public function set aryButtons(value:Vector.<IRButton>):void
		{
			removeAll();
			_toggleGroup.aryButtons = value;
			invalidate();
		}
		
		public function set direction(uiDirection:String):void
		{
			if(uiDirection== _direction  || (uiDirection!=UIDirection.HORIZONTAL && uiDirection!=UIDirection.VERTICAL)) return;
			_direction = uiDirection;			
			if(_box)
			{
				_box.destroy();
			}	
			_box = (UIDirection.HORIZONTAL == _direction) ? new RHBox() : new RVBox();
			_box.spacing = _spacing;
			this.addChild(_box);
		}		
		
		public function get direction():String
		{
			return _direction;
		}
		
		
		
		/**
		 * Override of addChild to force layout;
		 */
		public function addButton(child:RBaseButton) : DisplayObject
		{			
			if(!child) return null;
			_toggleGroup.add(child);
			_box.addChild(child);
			return child;
		}
		
		
		/**
		 * Override of addChild to force layout;
		 */
		public function addButtonAt(child:RBaseButton, index:int) : DisplayObject
		{			
			if(!child) return null;
			_toggleGroup.add(child);
			_box.addChildAt(child,index);			
			return child;
		}
		
		/**
		 * 删除指定按钮 
		 * @param child
		 * @param isForDisplayObjList
		 * @return 
		 * 
		 */		
		public function removeButton(child:RBaseButton):DisplayObject
		{			    
			if(!child) return null;
			_toggleGroup.remove(child);
			_box.removeChild(child);
			drawUI();
			return child;
		}
		
		/**
		 * 为特殊场合设定,切换显示指定位置的按钮是否存在于stage 
		 * @param index
		 * @param visible 
		 * 
		 */		
		public function toggleBtnVisibleForDisplayList(index:int,visible:Boolean):void
		{
			if(index>=0 && index<_toggleGroup.aryButtons.length)
			{
				var disp:DisplayObject = _toggleGroup.aryButtons[index] as DisplayObject;
				if(visible)
				{
					if(disp.parent!=_box)
						_box.addChildAt(disp,index);
				}
				else
				{
					if(disp.parent == _box)
						_box.removeChild(disp);
				}
			}
		}
		
		
		/**
		 * Override of removeChild to force layout;
		 */
		public function removeButtonAt(index:int):DisplayObject
		{
			_toggleGroup.removeAt(index);
			return _box.removeChildAt(index);
		}
		
		/**
		 * 刪除所有的buttons 
		 * 
		 */		
		public function removeAll():void
		{
			_toggleGroup.removeAll();
			_box.removeAll();
		}
		
		
		/**
		 * Draws the visual ui of the component, in this case, laying out the sub components.
		 */
		override public function drawUI() : void
		{				
			for(var i:int = 0; i < this.aryButtons.length; i++)
			{
				_box.addChild(this.aryButtons[i] as DisplayObject);	
			}
			_w = _box.visibleWidth;
			super.drawUI();
		}
		
		/**
		 * 设置全部按钮为指定长度 
		 * @param w
		 * 
		 */		
		public function averageButtonWidth(w:Number):void
		{
			if(w>0)
			{
				for(var i:uint=0;i<this.aryButtons.length;i++)
				{
					(this.aryButtons[i] as RBaseButton).visibleWidth = w;
				}
				_box.drawUI();
			}			
		}	
		
		
		
		protected function handleChangeBtn(event:RCollectionChangeEvent):void
		{
			dispatchEvent(new RCollectionChangeEvent(RCollectionChangeEvent.ONCHANGE,event.selectedIndex));
		}
		
		
	}
}