package com.wings.ui.manager
{
	import com.wings.ui.common.IPop;
	import com.wings.ui.common.IStageResize;
	import com.wings.ui.components.RBaseButton;
	import com.wings.ui.components.RSimpleButton;
	import com.wings.ui.components.constdefine.PopOpenType;
	import com.wings.util.display.DisplayObjectKit;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	/**
	 * 弹窗管理
	 * @author hh
	 * 
	 */	
	
	public class RPopWinManager extends EventDispatcher implements IStageResize
	{
		private static var _instance:RPopWinManager;
		private static var _stage:Stage;
		private static var _popContainer:DisplayObjectContainer;			//pop容器
		private var _menuCt:DisplayObjectContainer;		//菜单容器
		private var _winCt:DisplayObjectContainer;			//非模式弹窗对象容器	
		private var _modalCt:DisplayObjectContainer;		//模式弹窗对象容器
		private var _newbieGuideCt : DisplayObjectContainer;
		
		/**
		 *0.无缩放 1无缩放全屏 2等比缩放全屏 
		 */		
		private static var _fullScreenMode:int = 0; 				
		 
		
		private var _maskLayer:Sprite;		//蒙版效果层;	
		
		
		private var _w:Number = 0;
		private var _h:Number = 0;	
		private var _currentUi:Sprite;
		
		
		static private var _maxW:Number=0;
		static private var _maxH:Number=0;
		
		public function RPopWinManager(f:ForceClass)
		{
			if(f==null) throw new Error("单例类PopWinManager不可实例");
			if(_stage==null || _popContainer == null) throw new Error("先执行init初始化");
			 
			_winCt = new Sprite();
			_popContainer.addChild(_winCt);
			_menuCt = new Sprite();
			_popContainer.addChild(_menuCt);
			_newbieGuideCt = new Sprite();
			_popContainer.addChild(_newbieGuideCt);
			_modalCt = new Sprite();
			_popContainer.addChild(_modalCt);
			
			_popContainer.mouseEnabled = _popContainer.tabChildren = _popContainer.tabEnabled = _modalCt.mouseEnabled = _modalCt.tabChildren = _modalCt.tabEnabled
				= _modalCt.mouseEnabled = _modalCt.tabChildren = _modalCt.tabEnabled = _menuCt.mouseEnabled = _menuCt.tabChildren = _menuCt.tabEnabled
				= _newbieGuideCt.mouseEnabled = _newbieGuideCt.tabChildren = _newbieGuideCt.tabEnabled = false;
			
						
			_maskLayer = new Sprite();
			
			countNowWH();
			RUIManager.getInstance().registStageResizeUI(this);
			onStageResize(0,0);
		}
		
		
		
//		public function get maxH():Number
//		{
//			return _maxH;
//		}
//
//		public function set maxH(value:Number):void
//		{
//			_maxH = value;
//		}
//
//		public function get maxW():Number
//		{
//			return _maxW;
//		}
//
//		public function set maxW(value:Number):void
//		{
//			_maxW = value;
//		}
		
		/**
		 * 菜单对象容器
		 * @return 
		 * 
		 */		
		public function popMenu(menu:DisplayObject):void
		{
			if(_menuCt.numChildren>0)
				_menuCt.removeChildAt(0);
			_menuCt.addChild(menu);
		}

		/**
		 * 
		 * @param stage
		 * @param container
		 * @param fullScreenMode  0.无缩放 1无缩放全屏 2等比缩放全屏
		 * @param maxW  fullScreenMode=2才有用  
		 * @param maxH	fullScreenMode=2才有用
		 * 
		 */		
		static public function init(stage:Stage,container:DisplayObjectContainer,fullScreenMode:int=0,maxW:Number=0,maxH:Number=0):void
		{
			if(stage==null || container==null) throw new Error("PopWinManager 初始化失败");
			_stage = stage;
			_popContainer = container;
			
			_fullScreenMode = fullScreenMode;
			
			_maxW = maxW;
			_maxH = maxH;			
		
		}
		
		static public function getInstance():RPopWinManager
		{
			if(_instance==null) _instance = new RPopWinManager(new ForceClass());
			return _instance;
		}
		
		/**
		 * 返回非modal窗体容器 
		 * @return 
		 * 
		 */		
		public function get winCt():DisplayObjectContainer
		{
			return _winCt;
		}
			
		/**
		 * 新手引导层 
		 */		
		public function get newbieGuideCt() : DisplayObjectContainer
		{
			return _newbieGuideCt;
		}
		
		/**
		 * 显示弹窗
		 * @param ui			弹窗
		 * @param isShowMask	是否显示蒙版效果
		 * @param isForceMadal			是否显示与顶层 false,按正常的流程置放于_winCt/_modalCt顶层  true 否则强制置于_madalCt顶层 用于避免项目引导模式遮挡可点击区域
		 */		
		public function showUI(ui:IPop, enumType:String="PopOpenType_mask",isForceMadal:Boolean = false):void
		{			
			var cui:Sprite = ui as Sprite;
			if(ui && cui)
			{	
				
				if(enumType!=PopOpenType.WITHOUT_MASK || isForceMadal)
				{
					_maskLayer.alpha = enumType==PopOpenType.MASK_ALPHA ? 0:1;
					_modalCt.addChild(_maskLayer);	
					_modalCt.addChild(cui);
					Mouse.show() ;
				}
				else
				{
					_winCt.addChild(cui);
				}
				
				
				
				if(_stage.displayState == StageDisplayState.NORMAL)
				{
					_w = _stage.stageWidth;
					_h = _stage.stageHeight;
				}
				else
				{
					_w = _stage.fullScreenWidth
					_h = _stage.fullScreenHeight;
				}
				
				if((cui.x ==0 && cui.y==0) || !DisplayObjectKit.isVisibleOnScreen(cui))					
					ui.onStageResize(_w,_h);	
				_currentUi = cui;
				
				cui.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownToTop,true);
				if(ui.isCanDrag)
				{
					if(ui.dragTarget)
						ui.dragTarget.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown,false,0,true);
					else
						cui.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);					
				}
					
			}	
		}
		
		/**
		 * 提升到第1级 
		 * @param disp
		 * 
		 */		
		public function setToTop(disp:DisplayObject):void
		{
			if(disp && disp.parent)
				disp.parent.addChild(disp);		
		}
		
		
		/**
		 * 关闭指定窗体（需要对模式/非模式窗体容器做不同处理); 
		 * @param ui
		 * @param isRemove  从Manager的列表中去除该对象
		 * 
		 */
		public function closeUI(ui:IPop):void
		{
			var cui:DisplayObject = ui as DisplayObject;
			
			if(cui && cui.parent && cui.parent.contains(cui))
			{
				cui.parent.removeChild(cui);
				
				if(ui.isCanDrag)
				{
					if(ui.dragTarget)
						ui.dragTarget.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
					cui.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);					
				}
				
				cui.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDownToTop);
				
				if(_modalCt.contains(_maskLayer))
				{
					_modalCt.removeChild(_maskLayer);
					if(_modalCt.numChildren>0)
					{						 
						_modalCt.addChildAt(_maskLayer,_modalCt.numChildren-1);	
						_currentUi = _popContainer.getChildAt(_popContainer.numChildren-1) as Sprite; 	
					}	
				}
				
				if(_winCt.numChildren>0)
					_winCt.getChildAt(_winCt.numChildren-1).alpha=1;
			}
		}
		
		
		public function closeAllPopUI():void
		{	
			if(_maskLayer && _maskLayer.parent)
				_maskLayer.parent.removeChild(_maskLayer);
			
			var vt:Vector.<IPop> = new Vector.<IPop>();
			
			for (var j:int = 0; j < _winCt.numChildren; j++) 
			{				
				if(_winCt.getChildAt(j) is IPop)
					vt.push(_winCt.getChildAt(j) as IPop);
				else
				{
					_winCt.removeChildAt(j);
					j--;
				}
			}
			
			while(vt.length>0)
			{
				vt.pop().executeClose();
			}
			
			
		}
		
		
		
		public function onStageResize(w:Number,h:Number):void
		{
			if(w==0 && h==0)
			{
				
			}
			else
			{
				_w = w;
				_h = h;
			}
			
			_maskLayer.graphics.clear();
			_maskLayer.graphics.beginFill(0x000000,0.5);
			_maskLayer.graphics.drawRect(0,0,_w,_h);
			_maskLayer.graphics.endFill();
			
			//_maskLayer.x = -(rw-_stage.stageWidth)/2;
			//_maskLayer.y = -(rh-_stage.stageHeight)/2;
			updatePosi(_winCt);
			updatePosi(_modalCt);
			
		}
		
		/**
		 * 即时计算当前场景w/h 
		 * 
		 */		
		private function countNowWH():void
		{
			if(_stage.displayState == StageDisplayState.NORMAL)
			{
				_w = _stage.stageWidth;
				_h = _stage.stageHeight;
			}
			else
			{
				_w = _stage.fullScreenWidth
				_h = _stage.fullScreenHeight;
			}
		}
		
		/**
		 * 遍历更新位置 
		 * @param ct
		 * 
		 */		
		private function updatePosi(ct:DisplayObjectContainer):void
		{	
			for (var i:int = 0; i < ct.numChildren; i++) 
			{
				var o:DisplayObject  = ct.getChildAt(i);
				var ui:IStageResize = ct.getChildAt(i) as IStageResize;
				if(ui!=null)
					ui.onStageResize(_w,_h);
			}			
		}
		
		private function mouseUpHander(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHander);
			_currentUi.stopDrag();
			
			var rect:Rectangle = _currentUi.getBounds(_currentUi.parent);
			var rw:Number = rect.width;
			var rh:Number = rect.height;
			
			
			if(_currentUi.x < -(rw-20))
			{	
				_currentUi.x =-(rw-20);
			}
			else if(_currentUi.x >= _w)
			{
				_currentUi.x =_w -20;
			}
						 
			if(_currentUi.y < -(rh-20))
			{
				_currentUi.y =-(rh-20);	
			}
			else if(_currentUi.y >= _h)
			{
				_currentUi.y = _h -20;	
			}
			
			_currentUi.alpha=1;
		}
		
		/**
		 * 鼠标点击UI 
		 * @param event
		 * 
		 */		
		private function handleMouseDown(event:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHander);		
			
			var rect:Rectangle = _currentUi.getBounds(_currentUi.parent);
			var rw:Number = rect.width;
			var rh:Number = rect.height;
			_currentUi.startDrag(false,new Rectangle(-rw+10,-rh+10,_w+rw-10,_h+rh-10));
			_currentUi.alpha=.6;
		}
		
		/**
		 * 移动到顶部 
		 * @param event
		 * 
		 */		
		private function handleMouseDownToTop(event:MouseEvent):void
		{			
			_currentUi = event.currentTarget as Sprite;
			setToTop(_currentUi);						
		}
	}
}

class ForceClass{}
	