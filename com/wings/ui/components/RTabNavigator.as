package com.wings.ui.components
{
	import com.wings.ui.common.IRButton;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 提供1个相对简单的tabNavigator导航容器,接收lable,产生容器,并管理切换动作,咱不支持图标
	 * 皮肤不许更新
	 * 方向不许更新
	 * @author hh
	 * 
	 */
	public class RTabNavigator extends RBaseComponents
	{
		
		/**
		 *  @param aryLabel		 
		 *  @param parent  		 
		 * @param params		{只接受x,y,buttonw,buttonh,barpaddingleft,spacing}
		 * @param skin			只允许在初始化接收skin,不允许更改
		 */			
		public function RTabNavigator(aryLabel:Array=null,parent:DisplayObjectContainer=null,params:Object=null,skin:RUISkin=null)
		{
			if(skin)
				_skin = skin;
			else 
				_skin = RUIAssets.getInstance().tabBtn1;
			_arylabel = aryLabel;
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
		
		override protected function initProps():void
		{
			if(_params==null) return;				
			if(_params.x) this.x = int(_params["x"]);
			if(_params.y) this.y = int(_params["y"]);			
			if(_params.buttonw) this._buttonw = int(_params["buttonw"]);
			if(_params.buttonh) this._buttonh = int(_params["buttonh"]);
			if(_params.barpaddingleft) this._barpaddingleft = int(_params["barpaddingleft"]);
			if(_params.spacing) this._spacing = int(_params["spacing"]);
			
		}
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{
			super.inits();			
			_tabCtPoint = new Point(0,_buttonh);
			
			this.mouseChildren = true;
			
			var aryButtons:Vector.<IRButton>  = new Vector.<IRButton>();
			if(aryButtons && aryButtons.length>0)
			{
				for (var i:int = 0; i < _arylabel.length; i++) 
				{					
					var btn:RBaseButton;
					if(_buttonw>0)
						btn = new RBaseButton(null,{w:_buttonw,h:_buttonh},_arylabel[i],_skin);
					else
						btn = new RBaseButton(null,{h:_buttonh},_arylabel[i],_skin);
					aryButtons.push(btn);					
					_dictVo[btn] = createSprite();
				}				
			}
			_arylabel = null;			
			_bar = new RToggleButtonBar(null,aryButtons,{"spacing":_spacing});
			_bar.visibleHeight = _buttonh; 
			_bar.paddingLeft =  _barpaddingleft;
									
			_bar.addEventListener(RCollectionChangeEvent.ONCHANGE,handleTabChange);
			this.addChild(_bar);
			_dictVo = new Dictionary();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _arylabel:Array;
		private var _buttonw:int = 0;			//默认不管理按钮宽
		private var _buttonh:int = 20;			//默认按钮高度为20
		private var _bgBorder:RBorder;
		private var _skin:RUISkin;				//按钮皮肤
		private var _spacing:Number = 2;
		private var _barpaddingleft:int;		//左移距离
		
		private var _bar:RToggleButtonBar;
		private var _dictVo:Dictionary;			//容器字典
		private var _tabCtPoint:Point;
		
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
	
		public function get selectedIndex():int
		{
			return _bar.selectedIndex;
		}		
		public function set selectedIndex(id:int):void
		{			
			_bar.selectedIndex = id;
			changeBox(id);			
			dispatchEvent(new RCollectionChangeEvent(null,id));
		}
		
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		override public function drawUI():void
		{
//			if(_tabCtPoint.x==0 && _tabCtPoint.y==0)
//			{				
//				this.y = _bar.visibleHeight;
//			}
//			else
//			{
//				this.x = _tabCtPoint.x;
//				this.y = _tabCtPoint.y;
//			}
//		
//			this.cacheAsBitmap = true;
//			dispatchEvent(new Event(RBaseComponents.DRAW));
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		/**
		 * 设置tabContainer的相对与左上角的位置 
		 * @param x
		 * @param y
		 * 
		 */		
		public function setTabContainerXy(x:Number,y:Number):void
		{
			_tabCtPoint.x = x;
			_tabCtPoint.y = y;
		}
		
		
		/**
		 * 新增标签页 
		 * @param label		 
		 * @param index
		 * 
		 */		
		public function addTab(label:String, index:int = -1,btnwidth:Number=0):void
		{	
			
			if(label=="")  return;	
						
			var param:Object;
			if(btnwidth>0)
			{
				param={h:_bar.visibleHeight,tf:_ruiHelper.ruiTf.tabButtonTextformat,tfOver:_ruiHelper.ruiTf.tabButtonTextOverformat,w:btnwidth};
			}
			else
			{
				param={h:_bar.visibleHeight,tf:_ruiHelper.ruiTf.tabButtonTextformat,tfOver:_ruiHelper.ruiTf.tabButtonTextOverformat};	
			}
			
			var btn:RBaseButton  = new RBaseButton(null,param,label,_skin);
			
			if(index>-1)
			{
				_bar.addButtonAt(btn,index);
			}
			else
			{
				_bar.addButton(btn);
			}			
			_dictVo[btn] =  createSprite();
				
			invalidate();
		}
		
		/**
		 * 获取容器 
		 * @param id
		 * @return 
		 * 
		 */		
		private function getTabContainerById(id:int):DisplayObjectContainer
		{
			if(_dictVo.hasOwnProperty(_bar.aryButtons[id]))
				return _dictVo[_bar.aryButtons[id]] as DisplayObjectContainer;
			else
				return null;
		}
		
		/**
		 * 删除指定的标签页 
		 * @param index
		 * 
		 */		
		public function removeTabAt(index:int):void
		{			
			var btn:RBaseButton = _bar.removeButtonAt(index) as RBaseButton;
			if(btn)
			{
				delete _dictVo[btn];			
			}
		}
		
		/**
		 * Completely destroys the instance and frees all objects for the garbage
		 * collector by setting their references to null.
		 */
		override public function destroy():void
		{
			super.destroy();
			this.removeChild(_bar);
			_bar.removeEventListener(RCollectionChangeEvent.ONCHANGE,handleTabChange);
			_bar.destroy();
			_bar = null;
			
			for each(var btn:String in _dictVo)
			{
				delete _dictVo[btn];
			}
			_dictVo = null;
			
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
		private function createSprite():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.mouseEnabled = false;
			return sp;
		}
		
		private function changeBox(selectedIndex:int):void
		{			 
			var btn:IRButton = _bar.aryButtons[selectedIndex];
			for (var btnObj:Object in _dictVo)
			{
				if(btnObj != btn)
				{
					if(this.contains(_dictVo[btnObj] as DisplayObject))
						this.removeChild(_dictVo[btnObj] as DisplayObject);										
				}			
			}
			
			if(!this.contains(_dictVo[btn] as DisplayObject))
				this.addChild(_dictVo[btn].box as DisplayObject);
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
		
		public function handleTabChange(event:RCollectionChangeEvent):void
		{			
			var id:int = event.selectedIndex;			
			changeBox(id);
			dispatchEvent(new RCollectionChangeEvent(null,id));			
		}
		
		
	}
}
import com.wings.ui.components.RBaseButton;

import flash.display.DisplayObjectContainer;

class TabVo
{
	public var btn:RBaseButton;
	public var box:DisplayObjectContainer;
	
	public function TabVo(b:RBaseButton,bo:DisplayObjectContainer)
	{
		btn = b;
		box = bo;
	}
	
}
