package com.wings.ui.components
{
	
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	/**
	 * 改编自寂寞火山动态文本竖向滚动条
	 * 使用模式.先addChild textField和scrollbarmc到stage,然后再 实例化本类即可
	 * @author hh
	 */
	public class RTextVScrollBar extends RBaseComponents
	{
		
		//=============本类属性==============
		////接口元件
		private var _txtScroll : TextField;
		private var _view : DisplayObjectContainer;		
		private var _btnUp : SimpleButton;
		private var _btnDown : SimpleButton;
		private var _draghandle : Sprite; //拖动块
		private var _bgBar : Sprite;
		private var _bgforshow:DisplayObject		
		
		////初始数据
		private var poleStartHeight : Number;
		private var poleStartY : Number;
		private var totalPixels : Number;
		private var isSelect : Boolean;
		////上下滚动按钮按钮下时间
		private var putTime : Number;
		
		private var _minHeight:int = 32;			//最小高度
		private var _minShowPoleHeight:int = 50;	//显示滑块最小高度
		
		private var _isAlwayShow:Boolean = false;
		private var _isForceHandlerSize:Boolean = false;
		
		/**
		 * 
		 * @param scrollText_fc:被滚动的文本框
		 * @param scrollBarMc_fc：舞台上与本类所代理的滚动条元件
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽* 
		 * @param isAlwayShow 默认alway show bar
		 * @param isForceHandlerSize 滑块高度限制
		 * 
		 */		
		public function RTextVScrollBar(scrollText_fc : TextField, scrollBarMc_fc : DisplayObjectContainer, height_fc : uint = 0, width_fc : uint = 0,isAlwayShow:Boolean = false,isForceHandlerSize:Boolean=false) {
						
			//if(!scrollBarMc_fc.stage) throw new Error("请先将滚动条addChild到舞台");
			_isForceHandlerSize = isForceHandlerSize;			
			
			//滚动条按钮和滑块mc，被滚动的文本域初始化
			_isAlwayShow = isAlwayShow;
			_txtScroll = scrollText_fc;
			_view = scrollBarMc_fc;
			_btnUp = SimpleButton(_view.getChildByName("up_btn"));
			_btnDown = SimpleButton(_view.getChildByName("down_btn"));
			_draghandle = Sprite(_view.getChildByName("pole_mc"));
			_bgBar = Sprite(_view.getChildByName("bg_mc"));			
			_bgforshow = Sprite(_view.getChildByName("bgForShow"));
			
			_draghandle.visible = false;
			_btnUp.enabled = false;
			_btnDown.enabled = false;

			_bgBar.useHandCursor = false;
			isSelect = _txtScroll.selectable;
			
			if(height_fc == 0) 
				_bgBar.height = _txtScroll.height;
			else
				_bgBar.height = height_fc > _minHeight ? height_fc : _minHeight;
			_h = _bgBar.height;
						
			if(width_fc != 0) 
			{ 
				_bgBar.width = width_fc;
				_draghandle.width=width_fc;
				_btnUp.width = _btnUp.height = _btnDown.width = _btnDown .height = width_fc;	
			}
			_w = _bgBar.width;
			
			if(_bgforshow!=null)
			{
//				_bg.width = _bgBar.width;
				_bgforshow.height = _bgBar.height;
				var bg:Sprite = _bgforshow as Sprite;
				if(bg)
					bg.mouseEnabled = bg.mouseChildren = false;
			}
			
			_btnDown.y = _bgBar.y + _bgBar.height - _btnDown.height;
			poleStartHeight = Math.floor(_btnDown.y - _btnUp.y - _btnUp.height);
			poleStartY = _draghandle.y = Math.floor(_btnUp.y + _btnUp.height);
			
			onUpdateTextHeight();			
			configListeners();
			
		}
		
		/**
		 * 注册 
		 * 
		 */		
		private function configListeners():void
		{
			//文本滚动与鼠标滚轮
			_txtScroll.addEventListener(Event.SCROLL, textScroll);
			_txtScroll.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			//上滚动按钮
			_btnUp.addEventListener(MouseEvent.MOUSE_DOWN, handleBtnUpMouseDown);
			
			//下滚动按钮
			_btnDown.addEventListener(MouseEvent.MOUSE_DOWN, handleBtnDownMouseDown);
			
			//滑块
			_draghandle.addEventListener(MouseEvent.MOUSE_DOWN, handleDangHandlerMouseDown);
			
			//滑块背景点击
			_bgBar.addEventListener(MouseEvent.MOUSE_DOWN, bgDown);
			
			var mystage:Stage = RUIManager.stage;
			if(mystage)
			{
				mystage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
//				mystage.addEventListener(MouseEvent.MOUSE_UP, downBtnUp);
//				mystage.addEventListener(MouseEvent.MOUSE_UP, poleUp);
//				mystage.addEventListener(Event.REMOVED_FROM_STAGE,handleRemoveToStage);
			}
		}
		
		protected function handleStageMouseUp(event:MouseEvent):void
		{
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			//poleUp();
			_draghandle.stopDrag();
			_view.removeEventListener(Event.ENTER_FRAME, onDragHanleMove);		
			
			_txtScroll.addEventListener(Event.SCROLL, textScroll);
			
			_view.removeEventListener(Event.ENTER_FRAME, onBtnDownDownEnterframe);
			_view.removeEventListener(Event.ENTER_FRAME, onBtnUpDownEnterframe);
			
		}
		private function removeListeners():void
		{
			//文本滚动与鼠标滚轮
			_txtScroll.removeEventListener(Event.SCROLL, textScroll);
			_txtScroll.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel);
			
			//上滚动按钮
			_btnUp.removeEventListener(MouseEvent.MOUSE_DOWN, handleBtnUpMouseDown);
			
			//下滚动按钮
			_btnDown.removeEventListener(MouseEvent.MOUSE_DOWN, handleBtnDownMouseDown);
			
			//滑块
			_draghandle.removeEventListener(MouseEvent.MOUSE_DOWN, handleDangHandlerMouseDown);
			
			//滑块背景点击
			_bgBar.removeEventListener(MouseEvent.MOUSE_DOWN, bgDown);
			
			var mystage:Stage = RUIManager.stage;
			if(mystage)
			{
				mystage.removeEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
//				mystage.removeEventListener(Event.REMOVED_FROM_STAGE, handleRemoveToStage);
//				mystage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
//				mystage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
//				mystage.removeEventListener(MouseEvent.MOUSE_UP, upBtnUp);
//				mystage.removeEventListener(MouseEvent.MOUSE_UP, downBtnUp);
				//mystage.addEventListener(MouseEvent.MOUSE_UP, poleUp);			
			}
		}
		
		/**
		 * 当文本框高度变动 
		 * 
		 */		
		public function onUpdateTextHeight():void
		{
			checkTextAndUpdateState();
			if(_txtScroll.maxScrollV != 1 || _isAlwayShow) 
			{
				_view.visible = true;
			}
			else 
			{
				_view.visible = false;
			}			
		}
		
		/**
		 * 下一行 
		 */		
		public function moveNextLine():void
		{
			_txtScroll.scrollV++;
		}
		
		/**
		 * 第一行 
		 * 
		 */		
		public function moveFirstLine():void
		{
			_txtScroll.scrollV = 0;
		}
		
		/**
		 * 最后一行 
		 */		
		public function moveLastLine():void
		{
			_txtScroll.scrollV=_txtScroll.maxScrollV;
		}
		
		/**
		 * 上一行 
		 * 
		 */		
		public function movePrevLine():void
		{
			_txtScroll.scrollV--;
		}
		
		
		/**
		 * 文本滚动事件
		 */
		private function textScroll(event : Event) : void 
		{
			checkTextAndUpdateState();
		}
		
		/**
		 * 
		 * 
		 */		
		public function checkTextAndUpdateState():void
		{
			//判断滑块儿是否显示，并根据文本内容多少定义滑块高度
			if(_txtScroll.maxScrollV != 1)
			{
				_view.visible = true;
				if(_bgBar.height>=_minShowPoleHeight)	_draghandle.visible = true;
				_btnUp.enabled = true;
				_btnDown.enabled = true;
				//定义一个高度因子，此因子随加载文本的增多，将无限趋向于1
				var heightVar : Number = 1 - (_txtScroll.maxScrollV - 1) / _txtScroll.maxScrollV;
				//根据高度因子初始化滑块的高度
				if(!_isForceHandlerSize)
					_draghandle.height = Math.floor(poleStartHeight * Math.pow(heightVar, 1 / 3));
				totalPixels = Math.floor(_btnDown.y - _btnUp.y - _btnUp.height - _draghandle.height);
				_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
			}
			else
			{
				_view.visible = false;
				_draghandle.visible = false;
				_btnUp.enabled = false;
				_btnDown.enabled = false;
			}
			
		}
		
		/**
		 * 滑块点击
		 */
		private function handleDangHandlerMouseDown(event : MouseEvent) : void
		{
			//首先取消文本框滚动侦听，因为文本滚动的时候会设置滑块的位置，而此时是通过滑块调整文本的位置，所以会产生冲突
			_txtScroll.removeEventListener(Event.SCROLL, textScroll);
			//监听舞台，这样可以保证拖动滑竿的时候，鼠标在舞台的任意位置松手，都会停止拖动
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			//限定拖动范围
			var dragRect : Rectangle = new Rectangle(_draghandle.x, poleStartY, 0, totalPixels);
			_draghandle.startDrag(false, dragRect);
			_view.addEventListener(Event.ENTER_FRAME, onDragHanleMove);
		}
		
		/**
		 *  滑块拖动状态中enterframe检查
		 * @param event
		 * 
		 */		
		private function onDragHanleMove(event : Event) : void 
		{
			//在滚动过程中及时获得滑块所处位置
			var nowPosition : Number = Math.floor(_draghandle.y);
			//使文本随滚动条滚动,这里为什么要加1，可见scroll属性值应该是取正的，也就是说它会删除小数部分，而非采用四舍五入制？
			_txtScroll.scrollV = (_txtScroll.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 2;
			//误差校正
			var unitPixels : Number = totalPixels / (_txtScroll.maxScrollV - 1);
			if((nowPosition - poleStartY) < unitPixels)
				_txtScroll.scrollV = (_txtScroll.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels;
		}
		
		private function poleUp(event : MouseEvent=null) : void 
		{
			_draghandle.stopDrag();
			_view.removeEventListener(Event.ENTER_FRAME, onDragHanleMove);			
			RUIManager.stage.removeEventListener(MouseEvent.MOUSE_UP, poleUp);
			_txtScroll.addEventListener(Event.SCROLL, textScroll);
		}
		
		/**
		 * 滑块背景点击
		 */
		private function bgDown(event : MouseEvent) : void {	
			var nowPosition : Number;
			if((_view.mouseY - _btnUp.y) < (_draghandle.height / 2)) {
				nowPosition = Math.floor(_btnUp.y + _btnUp.height);
			}else if((_btnDown.y - _view.mouseY) < _draghandle.height / 2) {
				nowPosition = Math.floor(_btnDown.y - _draghandle.height);
			}else {
				nowPosition = _view.mouseY - _draghandle.height / 2;
			}
			_draghandle.y = nowPosition;
			_txtScroll.scrollV = (_txtScroll.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 2;
			var unitPixels : Number = totalPixels / (_txtScroll.maxScrollV - 1);
			if((nowPosition - poleStartY) < unitPixels) {
				_txtScroll.scrollV = (_txtScroll.maxScrollV - 1) * (nowPosition - poleStartY) / totalPixels + 1;
			}
		}
		
		/**
		 * 下滚动按钮
		 */
		private function handleBtnDownMouseDown(event : MouseEvent) : void 
		{
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			_txtScroll.scrollV++;
			_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			_view.addEventListener(Event.ENTER_FRAME, onBtnDownDownEnterframe);
			
		}
		
		private function onBtnDownDownEnterframe(event : Event) : void 
		{
			if(getTimer() - putTime > 500) {
				_txtScroll.scrollV++;
				_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
			}
		}	
		
		
		/**
		 * 上滚动按钮点击
		 */
		private function handleBtnUpMouseDown(event : MouseEvent=null) : void {
			RUIManager.stage.addEventListener(MouseEvent.MOUSE_UP, handleStageMouseUp);
			_txtScroll.scrollV--;
			_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			_view.addEventListener(Event.ENTER_FRAME, onBtnUpDownEnterframe);	
		}
		
		/**
		 *  上滚动按钮长按检查
		 * @param event
		 * 
		 */		
		private function onBtnUpDownEnterframe(event : Event=null) : void 
		{
			if(getTimer() - putTime > 500) 
			{
				_txtScroll.scrollV--;
				_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
			}
		}
		
		
		
		/**
		 * 鼠标滚轮事件
		 */
		private function mouseWheel(event : MouseEvent) : void 
		{
			if(isSelect == false) {
				_txtScroll.scrollV -= Math.floor(event.delta / 2);
			}else if(isSelect == true) {
				event.delta = 1;
			}
			_draghandle.y = Math.floor(poleStartY + totalPixels * (_txtScroll.scrollV - 1) / (_txtScroll.maxScrollV - 1));
		}
		
		/**
		 * remove stage event; 
		 * @param event
		 * 
		 */		
		private function handleRemoveToStage(event:Event):void
		{
			removeListeners()			
		}
		
		
		
		/**
		 * 是否总是显示滚动条,不论文本长度
		 */		
		public function set isAlwayShow(value:Boolean):void
		{
			_isAlwayShow = value;
		 	_view.visible = value;
		}
		
		override public function destroy():void
		{	
			
			removeListeners();
			_view = null;
			_btnUp = null;
			_btnDown = null;
			_draghandle = null;
			_bgBar = null;			
			_bgforshow = null;
			_txtScroll = null;		
			
			super.destroy();	
		}
			

	}
}