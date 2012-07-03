package com.wings.effect.preload
{
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	
	/**
	 * 改自loading效果代码
	 * @author hh
	 * 
	 */		
	public class ParticleEntity extends Sprite implements IDestroy
	{
		private var _system:PreloadParticleEffect;
//		private var _mc:MovieClip;
		private var _mc:DisplayObject;
		private var _deltaRotation:Number;
		private var _minScale:Number;
		private var _speed:Number;
		private var _alphaSpeed:Number = 0.02;
		private var _scaleSpeed:Number = 0.05;
		public static const STEP:int = 10;
		public static const MIN_DIS:Number = 5;
		public static const MAX_DIS:Number = 100;
		
		public function ParticleEntity(effectController:PreloadParticleEffect)
		{
			this.mouseChildren = this.mouseEnabled = false;
			
			this._deltaRotation = Math.random() * 8 - 4;
			this._minScale = Math.random() * 0.2 + 0.4;
			this._speed = Math.random() * 3 + 2;
			this._system = effectController;
			
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0x00FFFF);
			shape.graphics.drawCircle(0,0,int(Math.random()*5));
			shape.graphics.endFill();
			this._mc = shape;
			this._mc.filters = [new GlowFilter(0x099FF)];
			
			var iframe:int = int(Math.random() * 4 + 1);
			//this._mc.gotoAndStop(iframe);
			
			var angel1:Number = Math.random() * Math.PI - Math.PI / 2;
			var angel2:Number = Math.random() * Math.PI + Math.PI / 2;
			var rmdAngel:Number = Math.random() > 0.8 ? (angel1) : (angel2);
			
			this._mc.x = effectController.targetX + Math.cos(rmdAngel) * MAX_DIS;
			this._mc.y = effectController.targetY + Math.sin(rmdAngel) * MAX_DIS;
			this._mc.scaleX = Math.random() * 0.6 + 0.8;
			this._mc.scaleY = this._mc.scaleX;
			this._mc.alpha = 0;
			this._mc.cacheAsBitmap = true;
			addChild(this._mc);
			addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			return;
		}// end function
		
		public function enterFrameHandler(event:Event) : void
		{
			this._mc.rotation = this._mc.rotation + this._deltaRotation;
			
			if (this._mc.alpha < 1)			
				this._mc.alpha = this._mc.alpha + this._alphaSpeed;
			
			
			if (this._mc.scaleX > this._minScale)	
				this._mc.scaleX = this._mc.scaleY = this._mc.scaleX - this._scaleSpeed;
				
			var angel:Number = Math.atan2(this._system.targetY - this._mc.y, this._system.targetX - this._mc.x);
			this._mc.x = this._mc.x + Math.cos(angel) * this._speed;
			this._mc.y = this._mc.y + Math.sin(angel) * this._speed;
			var distance:Number = Math.abs(this._mc.x - this._system.targetX);
			if (distance < MIN_DIS + 50)
			{
				this._alphaSpeed = 0.08;
			}
			if (distance < MIN_DIS)
			{
				this._mc.alpha = this._mc.alpha - 0.5;
				if (this._mc.alpha <= 0)
				{
					removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
					if (parent != null)
					{
						parent.removeChild(this);
					}
					removeChild(this._mc);
				}
			}
			return;
		}// end function
		
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			while(this.numChildren>0)
				this.removeChildAt(0);
			_system = null;
		}
	}
}
