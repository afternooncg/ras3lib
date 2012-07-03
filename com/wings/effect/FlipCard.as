package com.wings.effect
{	
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import gs.TweenLite;
	import gs.easing.Back;
	
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * 1个比较常用的双面卡片翻转效果(Y轴) 
	 * @author hh
	 * 
	 */	
	public class FlipCard extends Sprite implements IDestroy
	{				
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		static public const DIRECTION_LEFT:String = "left";
		static public const DIRECTION_RIGHT:String = "right";
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		/**
		 *   
		 * @param upDisp     卡片面上显示对象
		 * @param downDisp	 卡片反面显示对象
		 * 
		 */		
		public function FlipCard(upDisp:DisplayObject,downDisp:DisplayObject) 
		{
			_upDisp = upDisp;
			_downDisp = downDisp;
			
			if (stage) 
				inits();
			else 
				addEventListener(Event.ADDED_TO_STAGE, inits);
		}
		
		private function inits(e:Event = null):void 
		{
			
			removeEventListener(Event.ADDED_TO_STAGE, inits);		
			
			_upCt = createNoneInteractiveSprite();
			_downCt = createNoneInteractiveSprite();
			_upCt.addChild(_upDisp);
			_downCt.addChild(_downDisp);			
			_upDisp.x =  -_upDisp.width * 0.5;			
			_downDisp.x = -_downDisp.width * 0.5;
			
			
			//先隐藏，旋转底面
			_downCt.scaleX *= -1;
			_downCt.visible = false;
			
			_flipCt = createNoneInteractiveSprite();
			
			_flipCt.addChild(_upCt);
			_flipCt.addChild(_downCt);
			addChild(_flipCt);
			_flipCt.x = _flipCt.width/2;			
			_currentVisibleDisp = _upCt;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		private var _upDisp:DisplayObject, _upCt:DisplayObjectContainer;				//正面显示对象及容器		
		private var _downDisp:DisplayObject, _downCt:DisplayObjectContainer;			//反面显示对象及容器
		private var _currentVisibleDisp:DisplayObject;									//当前旋转到正面的对象
		private var _degree:int = 180;			//旋转角度
		
		private var _flipCt:DisplayObjectContainer;									//旋转用容器
		private var _count:int = 0;													//旋转次数
		private var _repeatCount:int = 0;												//计数器
		private var _isForceStop:Boolean = false;										//外部强行停止,将会在当前的180动作结束后生效
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  开始翻转
		 * @param count 旋转次数 0代表无限
		 * @param direction  left/right 翻转方向 推荐用类const   DIRECTION_LEFT/DIRECTION_RIGHT		 
		 */		
		public function startRotaion(count:int=2,direction:String="left"):void
		{	
			_count = count;
			if(direction==DIRECTION_LEFT)
			{
				_degree = 180;
			}
			else
			{
				_degree = -180;
			}
			
			TweenLite.killTweensOf(_flipCt);
			TweenLite.to( _flipCt, 1, {rotationY:_degree,ease: Back.easeOut,onComplete: onFlip180Complete,onUpdate: update} );
			
		}
		
		public function stop():void
		{
			_isForceStop = true;
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(_flipCt);
			_upCt.removeChild(_upDisp);
			_downCt.removeChild(_downDisp);
			_flipCt.removeChild(_upCt);
			_flipCt.removeChild(_downCt);
			
			_upDisp = _downDisp = null;
			_upCt = _downCt = _flipCt = null;			
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
		/**
		 * 生成不可交互的sprite 
		 * @return 
		 * 
		 */		
		private function createNoneInteractiveSprite():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.mouseChildren = sp.mouseEnabled = sp.tabChildren = sp.tabEnabled = false;
			return sp;
		}
		
		
		
		/**
		 * 检查应该显示哪个面
		 */
		private function update():void
		{
			//return;
			if(_degree==180)
			{//向左转
				
				if(_currentVisibleDisp == _upCt)
				{//当前正面是_upDisp					
					_downCt.visible = _flipCt.rotationY > 90 && _flipCt.rotationY < 270;
					_upCt.visible = !_downCt.visible;
					
				}
				else
				{//当前正面是_downDisp					
					_upCt.visible = _flipCt.rotationY > 90 && _flipCt.rotationY < 270;
					_downCt.visible = !_upCt.visible;
				}			
				
			}
			else
			{//向右转
				if(_currentVisibleDisp == _upCt)
				{//当前正面是_upDisp					
					_downCt.visible = _flipCt.rotationY > -270 && _flipCt.rotationY < -90;
					_upCt.visible = !_downCt.visible;
					
				}
				else
				{//当前正面是_downDisp					
					_upCt.visible = _flipCt.rotationY >-270 && _flipCt.rotationY < -90;
					_downCt.visible = !_upCt.visible;
				}
			}
		}
		
		
		/**
		 * 旋转180度结束后执行
		 */
		private function onFlip180Complete():void
		{	
			_flipCt.rotationY = 0;			
			
			if(_currentVisibleDisp == _upCt)
			{
				_currentVisibleDisp = _downCt;
				_upCt.scaleX *= -1;
				_downCt.scaleX *= -1;
				_upCt.visible = false;
				_downCt.visible = true;					
			}
			else
			{
				_currentVisibleDisp = _upCt;
				_upCt.scaleX *= -1;
				_downCt.scaleX *= -1;
				_upCt.visible = true;
				_downCt.visible =false;
			
			}
			
			if(_count>0 || _isForceStop)
			{//
				_repeatCount++;
				if(_isForceStop || (_repeatCount == _count))
				{				
					_flipCt.transform.matrix3D = null;
					_upDisp.x =  _downDisp.x = 0;
					dispatchEvent(new Event(Event.COMPLETE));
					return;
				}
			}
			
			TweenLite.to( _flipCt, 1, {rotationY:_degree,ease: Back.easeOut,onComplete: onFlip180Complete,onUpdate: update} );			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		
	}
}