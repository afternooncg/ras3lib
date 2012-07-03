package com.wings.effect.preload
{
	import com.wings.common.IDestroy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * loading效果代码
	 * @author hh
	 */
	public class PreloadParticleEffect extends Sprite implements IDestroy
	{
		private var _targetX:Number = 0;
		private var _targetY:Number = 0;
		private var _started:Boolean = false;
		
		public function PreloadParticleEffect()
		{
			this.mouseChildren = this.mouseEnabled = false;
			return;
		}// end function
		
		public function startAnimation() : void
		{
			addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this._started = true;
			return;
		}// end function
		
		public function stopAnimation() : void
		{
			removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this._started = false;
			return;
		}// end function
		
		public function get started() : Boolean
		{
			return this._started;
		}// end function
		
		private function enterFrameHandler(event:Event) : void
		{
			var p:ParticleEntity = null;
			var cmp1:int = Math.random() > 0.2 ? (1) : (0);
			var cmp2:int = 0;
			while (cmp2 < cmp1)
			{            
				addChild(new ParticleEntity(this));
				cmp2++;
			}
			return;
		}// end function
		
		public function setTargetPosition(param1:Number, param2:Number) : void
		{
			this._targetX = param1;
			this._targetY = param2;
			return;
		}// end function
		
		public function get targetX() : Number
		{
			return this._targetX;
		}// end function
		
		public function get targetY() : Number
		{
			return this._targetY;
		}// end function
		
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			while(this.numChildren>0)
			{
				var p:ParticleEntity = this.removeChildAt(0) as ParticleEntity;
				if(p)
					p.destroy();
			}
		}
			
	}
}



