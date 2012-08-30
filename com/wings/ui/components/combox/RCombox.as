package com.wings.ui.components.combox
{
	import com.wings.common.IDestroy;
	import com.wings.ui.common.IRButton;
	import com.wings.ui.common.IRList;
	import com.wings.ui.common.IRListItem;
	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.components.RBaseButton;
	import com.wings.ui.components.RBaseList;
	import com.wings.ui.components.RComponent;
	import com.wings.ui.components.RTooltip;
	import com.wings.ui.components.RVScrollPanle;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	import com.wings.ui.manager.RToolTipManager;
	import com.wings.ui.manager.RUIManager;
	import com.wings.util.display.DisplayObjectKit;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	
	/**
	 * 通用下拉菜单
	 * RCollectionChangeEvent的data格式 {label:*,data:*}
	 * @author hh
	 * 
	 */	
	
	[Event(name="onchange", type="com.wings.ui.components.events.RCollectionChangeEvent")]
	
	public class RCombox extends RComponent 
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
		
		/**
		 * 
		 * @param parent 父容器
		 * @param params	{x,y,w,h,lineheight,isMenuOnTop,paddingLeft}参数 isMenuOnTop:true/false是否强行菜单显示在头部 paddingLeft>0则指定文本固定位置，否则默认居中,isHtmlText是否以htmltxt模式渲染按钮文本,一旦设定，不可更改,listh:显示高度
		 * @param defaultLable	默认文本
		 * @param items	数据源[{label:*,data:*,fontcolor:uint},{label:*,data:*,fontcolor:uint},...]
		 * @param createComboxItemFun 渲染回调，这种模式下可以自定义生成item对象 fu():IRListItem  若该参数为null,则item生成参数控制在addChildren/set dataProvitor 两处
		 * @param headerBtnProxy 代理btnHeader 这种模式下，将不显示btnHeader
		 */		
		public function RCombox(parent:DisplayObjectContainer=null, params:Object=null,defaultLable:String="",items:Array=null,createComboxItemFun:Function=null,headerBtnProxy:DisplayObject=null)
		{	
			_createComboxItemFun = createComboxItemFun;
			_headerBtnProxyDisp = headerBtnProxy;
			_items = items;
			if(_items==null)
				_items = [];
			
			super(parent, params);
			this.selectedIndex = 0;
		}
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _header:RHeader;		//默认显示
		private var _thisCt:DisplayObjectContainer;	//自身容器，由于在出现/关闭下拉列表时会被_parent,add/remove.为避免_parent override了addChild带来的问题。 
		private var _itemCt:DisplayObjectContainer;	//菜单容器
		
		private var _list:IRList;
		private var _items:Array;				//原始数据源
		private var _itemHeight:int = 23;		//菜单项高		
		private var _listBg:DisplayObject;
		
		private var _listh:int = 0;
		private var _scrollCt:RVScrollPanle;			//滚动容器
		

		//默认header显示
		private var _isMenuOnTop:Boolean = false;	//是否默认菜单显示在头部
		private var _isOpen:Boolean = false; 
		
		

		private var _createComboxItemFun:Function;
		private var _headerBtnProxyDisp:DisplayObject=null;		//代理header按钮对象
		private var _headerBtnProxy:RCboxHeaderBtnProxy;
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		/**
		 * 设置选中位置
		 * @return 
		 * 
		 */		
		public function get selectedIndex():int
		{
			return _list.selectedIndex; 
		}
		
		
		/**
		 * 指定位置item是否可用  
		 * @param index
		 * @param flag
		 * 
		 */		
		public function updateItemEnable(index:int=0,flag:Boolean=false):void
		{			
			for (var i:int = 0; i < _list.dataProvider.length; i++) 
			{
				if(i==index)
				{
					
					(_list.dataProvider[i]  as IRButton).enabled = flag;
					break;
				}
			}					
		}
		
		/**
		 *  设置选中项
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			if(value>=0 && value<_list.dataProvider.length)
			{
				_list.selectedIndex = value;
				var data:Object = _list.dataProvider[value].data;
				_header.label = data.label;
				
						
				if(data.hasOwnProperty("fontcolor"))
				{
					var tf:TextFormat = _header.textFormat;
					tf.color = uint(data["fontcolor"]);
					_header.textFormat = tf;
					
					tf = _header.textFormatOver;
					tf.color = uint(data["fontcolor"]);
					_header.textFormatOver = tf;					
				}
				
				if(_headerBtnProxy)
				{
					if(data.hasOwnProperty("fontcolor"))									
						_headerBtnProxy.htmlText = "<font color=\"#" + uint(data["fontcolor"]).toString(16)  +  "\">" + data.label + "</font>";					
					else
						_headerBtnProxy.htmlText = data.label;
				}	
				
			}
		}
		
		/**
		 * 更新数据源 
		 * @param ary
		 * 
		 */		
		public function set dataProvider(ary:Array):void
		{
			_items = ary ;			
			while(_itemCt.numChildren>0)
			{
				_itemCt.removeChildAt(0).removeEventListener(MouseEvent.CLICK,handleItemClick);;
			}
			
			_list.removeAll();
			
			if(!_items || _items.length==0)
			{
				_header.label = "";
				return;
			}
				
			createItemBtns();
			
			this.selectedIndex = 0;
			
		}
		
		/**
		 * 当前选中项值 
		 * @return 
		 * 
		 */		
		public function get selectedValue():*
		{
			if(_list.dataProvider)
				return  _list.selectedItem.data;
			else
				return null;
		}		
				
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		override public function destroy():void
		{
			_headerBtnProxyDisp = null;
			if(_headerBtnProxy)
			{
				_headerBtnProxy.destroy();
				_headerBtnProxy  = null;
			}
						
			while(_itemCt.numChildren>0)
			{
				var item:DisplayObject = _itemCt.removeChildAt(0);
				item.removeEventListener(MouseEvent.CLICK,handleItemClick);;
				(item as IDestroy).destroy();
			}
			
			_list.removeAll();
			
			_thisCt.removeEventListener(MouseEvent.ROLL_OUT,handleRollout);
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseUp);		
			_header.removeEventListener(MouseEvent.CLICK,handleHeaderClick);
			
			_header = null;
			while(_thisCt.numChildren>0)
				_thisCt.removeChildAt(0);
			_thisCt = null;  
			_itemCt = null;
			_list = null;
			if(_items)
			{
				_items.length = 0;
				_items = null;
			}
			_createComboxItemFun = null;
			
			if(_scrollCt)
			{
				_scrollCt.destroy();
				_scrollCt=null;
			}
			super.destroy();
		}
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		public function toggleShowList():void
		{
			if(!_isOpen)
			{
				openMenu();
			}
			else
			{
				closeMenu();
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		override protected function initProps():void
		{
			super.initProps();
			if(_params==null) return;				
			if(_params.lineheight) 
				this._itemHeight = int(_params["lineheight"]);
			if(_params.isMenuOnTop) 
				this._isMenuOnTop = Boolean(_params["isMenuOnTop"]);
			if(_params.listh) 
				this._listh = int(_params["listh"]);
			
			if(_w==0)
				_w = 120;
			if(_h==0)
				_h = 30;
		}
		
		override protected function addChildren():void
		{
			super.addChildren();
			_listBg = RUIAssets.getInstance().listBg;
			(_listBg as Sprite).mouseChildren = (_listBg as Sprite).mouseEnabled = false;
			_thisCt = new Sprite();
			this.addChild(_thisCt);
			
			_itemCt = new Sprite();
			_itemCt.mouseEnabled = false;
			
			if(_listh>0)
			{
				_scrollCt = new RVScrollPanle(_itemCt,null,{w:_w,h:_listh,y:(_headerBtnProxyDisp==null ? _h : 0)},true);				
			}
			else
			{						
				_itemCt.y = _headerBtnProxyDisp==null ? _h : 0;
			}
			var isHtmlText_v:Boolean = false;
			if(_params && _params.isHtmlText) 
				isHtmlText_v = Boolean(_params["isHtmlText"]);
			_header = new RHeader(_headerBtnProxyDisp==null?_thisCt:null,{w:_w,h:_h,paddingtop:2,paddingbottom:2,isHtmlText:isHtmlText_v},"",RUIAssets.getInstance().comboxSkin);
			if(_params.paddingLeft)
				_header.paddingLeft = Number(_params.paddingLeft); 
			_header.addEventListener(MouseEvent.CLICK,handleHeaderClick);
			
			if(_headerBtnProxyDisp && _headerBtnProxyDisp is DisplayObjectContainer)
			{
				_headerBtnProxy =  new RCboxHeaderBtnProxy(_headerBtnProxyDisp as DisplayObjectContainer);
				if(!_headerBtnProxy.isFit())
				{
					_headerBtnProxy.destroy();
					_headerBtnProxy = null;
					
				}
				else
				{				
					_headerBtnProxy.view.addEventListener(MouseEvent.CLICK,handleHeaderClick);
				}
			}
			
			_list = new RBaseList(); 
			createItemBtns();

		}			
		
	
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------		
		/**
		 *  生成下拉按钮 
		 * 
		 */		
		private function createItemBtns():void
		{
			var isHtmlText_v:Boolean = false;
			if(_params && _params.isHtmlText) 
				isHtmlText_v = Boolean(_params["isHtmlText"]);
			
			for(var i:uint=0;i<_items.length;i++)
			{				
				var item:IRListItem = _createComboxItemFun==null ? new RComboxItem(_items[i],i,_itemCt,{w:_w,h:_itemHeight,y:i*_itemHeight,paddingtop:3,paddingbottom:1,isHtmlText:isHtmlText_v}) : _createComboxItemFun(_items[i],i,_itemCt,{w:_w,h:_itemHeight,y:i*_itemHeight});
				_list.add(item);				
			}
			
			
		}
		
		private function openMenu():void
		{
			_isOpen = true;
			var p:Point = this.parent.localToGlobal(new Point(this.x,this.y));
			RUIManager.stage.addChild(_thisCt);			
			_thisCt.x = p.x;
			_thisCt.y = p.y;
			if(_scrollCt)
				_thisCt.addChild(_scrollCt);
			else
				_thisCt.addChild(_itemCt);
			
			DisplayObjectKit.moveTopZ(_thisCt);
			
			
			//如有被隐藏情况,菜单飘向顶部
			if(!_scrollCt)
			{
				if((!DisplayObjectKit.isVisibleOnScreen(_thisCt) && (_thisCt.y+_thisCt.height)>_thisCt.stage.stageHeight) || _isMenuOnTop)
					_itemCt.y = -_itemCt.height;  
			}
			else
			{
				if((!DisplayObjectKit.isVisibleOnScreen(_scrollCt) && (_thisCt.y+_scrollCt.visibleHeight)>_thisCt.stage.stageHeight) || _isMenuOnTop)				
					_itemCt.y = -_scrollCt.visibleHeight				
			}
			
			
						
			_thisCt.addChildAt(_listBg,0);			
			_listBg.width = _w;
			if(_scrollCt)
				_listBg.height = _listh;
			else
				_listBg.height = _items.length*_itemHeight;
			
			_listBg.y = _itemCt.y;
			
			
			var dp:Vector.<IRListItem> = _list.dataProvider;
			for (var i:int = 0; i < dp.length; i++) 
			{
				(dp[i] as DisplayObject).addEventListener(MouseEvent.CLICK,handleItemClick);
			}
		
			if(_headerBtnProxyDisp==null)
				_thisCt.addEventListener(MouseEvent.ROLL_OUT,handleRollout);	
			else
				RUIManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseUp);	
			
			RUIManager.stage.addEventListener(Event.RESIZE,handleCloseMenu);
			
			
		}
		
		protected function handleCloseMenu(event:Event):void
		{
			closeMenu();			
		}
		
		/**
		 * 隐藏菜单 
		 * 
		 */		
		public function hideList():void
		{
			if(_thisCt && _thisCt.parent)
			{
				closeMenu();
			}
		}
		
		private function closeMenu():void
		{
			_isOpen = false;			
			if(_scrollCt)
				_thisCt.removeChild(_scrollCt);
			else	
				_thisCt.removeChild(_itemCt);
			_thisCt.removeChild(_listBg);
			if(_headerBtnProxyDisp==null)
				_itemCt.y = _header.visibleHeight;
			else
				_itemCt.y = 0;
			_thisCt.x = _thisCt.y = 0;
			this.addChild(_thisCt);
					
			var dp:Vector.<IRListItem> = _list.dataProvider;
			for (var i:int = 0; i < dp.length; i++) 
			{
				(dp[i] as DisplayObject).removeEventListener(MouseEvent.CLICK,handleItemClick);
			}
			_thisCt.removeEventListener(MouseEvent.ROLL_OUT,handleRollout);
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseUp);
			RUIManager.stage.removeEventListener(Event.RESIZE,handleCloseMenu);
		}		
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		protected function handleItemClick(event:MouseEvent):void
		{
			
			this.selectedIndex = (event.currentTarget as IRListItem).index			 	
			closeMenu();
			dispatchEvent(new RCollectionChangeEvent(RCollectionChangeEvent.ONCHANGE,_list.selectedIndex,_list.selectedItem.data));
		}
		
		/**
		 * 点击combox 
		 * @param event
		 * 
		 */		
		protected function handleHeaderClick(event:MouseEvent):void
		{
			toggleShowList();			
		}
		
		protected function handleRollout(event:MouseEvent):void
		{
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseUp);		
		}
		
		/**
		 * 监控鼠标在控件外区域松开按键的操作,则关闭菜单
		 * @param event
		 * 
		 */		
		protected function handleStageMouseUp(event:MouseEvent):void
		{			
			
			if(_headerBtnProxyDisp==null || (_headerBtnProxy!=null && event.target!= _headerBtnProxy.view) || (_headerBtnProxyDisp!=null && event.target!=_headerBtnProxyDisp))
			{
				if(!_itemCt.hitTestPoint(event.stageX,event.stageY))
				{
					RUIManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN,handleStageMouseUp);
					closeMenu();				
				}
			}	
			event.stopImmediatePropagation();
		}
	}
}
import com.wings.ui.common.RUISkin;
import com.wings.ui.components.RBaseButton;

import flash.display.DisplayObjectContainer;

class RHeader extends RBaseButton
{	
	public var paddingLeft:Number = 0;
	/**
	 *
	 * @param parent		父容器
	 * @param params		{x,y,w,h,iconspacing,value}
	 * @param label			文本
	 * @param skin			背景		 
	 * @param icon			图标
	 * 
	 */				
	public function RHeader(parent:DisplayObjectContainer=null,params:Object=null,label:String = "",skin:RUISkin=null,icon:RUISkin=null)
	{
		super(parent,params,label,skin,icon);	
	}
	
	override public function drawUI():void
	{
		super.drawUI();
		if(paddingLeft>0)
			_labelCt.x = paddingLeft;
	}
	
}