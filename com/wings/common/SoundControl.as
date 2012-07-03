package com.wings.common
{
	
	import com.wings.util.debug.MyLogger;
	
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	/**
	 * 简单声音播放控制器
	 * @author hh
	 * 
	 */	
	public class SoundControl extends EventDispatcher
	{
		public static const SOUND_STOP:String="SoundIsStop";
		
		protected var _soundBufferSpeed:int=30;    //渐变速度
		protected var _round:int=20000;    //循环次数
		protected var _bufferRound:int=int(1000/_soundBufferSpeed)+1;   //计算渐变次数
		
		
		protected var _soundTimer:Timer = new Timer(_soundBufferSpeed,_bufferRound);
		protected var _mySound:Sound;
		protected var _mySound2:Sound;		//临时变量
		protected var _mySoundChannel:SoundChannel;
		protected var _mySoundTransform:SoundTransform;
		public var _position:Number=0;
		
		protected var _isPlaying:Boolean=false;  //是否播放状态
		
		protected var _isNeedTimer:Boolean = false;
		
		protected var _val:Number = 0.5;
		
		protected var _soundChangeflag:int = 0;//-1减小
		
		/**
		 *  
		 * @param mysound
		 * @param isNeedTimer  是否启用渐隐渐现效果
		 * @param round 循环播放次数 
		 * 
		 */		
		function SoundControl(mysound:Sound=null,isNeedTimer:Boolean=true,round:int=20000,val:Number=0.5)
		{
			_isNeedTimer = isNeedTimer;
			_round = round;
			_mySound=mysound;
			_val = val;				
		}

		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}

		
		public function set round(value:int):void
		{
			_round = value;
		}

		public function get mySound():Sound
		{
			return _mySound;
		}
		
		public function set mySound(sound:Sound):void
		{
			if(_mySound)
				_mySound.removeEventListener(SOUND_STOP,onChangeSound);
			_mySound = sound;
		}

		/**
		 * 播放 
		 * @param startTime
		 * 
		 */		
		public function play(startTime:Number=0):void
		{	
					
			if(_mySound)
			{
				try
				{	
					_isPlaying=true;			
					_mySoundChannel=_mySound.play(startTime,_round);
					if(_mySoundChannel==null)//某些情况碰到声卡设备异常的情况 将会返回null
						return;
					_mySoundTransform=_mySoundChannel.soundTransform;
					
					if(_isNeedTimer)
					{
						setVolOnTimer(0);				
						_soundTimer.removeEventListener("timer",subVol);
						_soundTimer.reset();
						_soundTimer.addEventListener("timer",addVol);
						_soundTimer.start();
					}
				}	
				catch(e:Error)
				{
					MyLogger.warnOutput("音乐播放异常" + e.message + " url:" + _mySound.url);
				}
			}
			
		}
		
		/**
		 * 禁音,有别于stop,只是把音量设置为0,不影响逻辑 
		 * 
		 */		
		public function mute():void
		{
			setVolOnTimer(0);
			setVol(0);
		}
		
		/**
		 *停止 
		 * 
		 */		
		public function stop():void
		{	
			if(!_mySoundChannel)
				return;
			
			if(_isPlaying==true && _isNeedTimer)
			{	
				_soundTimer.removeEventListener("timer",addVol);
				_soundTimer.reset();
				_soundTimer.addEventListener("timer",subVol);
				_soundTimer.start();
				//trace("stop");
			}
			else
			{
				_mySoundChannel.stop();
				_isPlaying=false;
				if(_mySound)
					_mySound.dispatchEvent(new Event(SOUND_STOP));				
			}
		}
		
		/**
		 *暂停 
		 * @return 
		 * 
		 */		
		public function pause():void
		{
			if(_isPlaying==true){
				_position=_mySoundChannel.position;
				stop();
			}else{
				play(_position);
			}
		}
		
		/**
		 * 更换音乐
		 * @param sound
		 * 
		 */		
		public function change(sound:Sound):void
		{
			if(sound)
			{
				if(_isPlaying==true && _mySound)
				{//如果有文件在播放中,并且不处于渐大或渐小过程					
					_mySound2=sound;					
					_mySound.addEventListener(SOUND_STOP,onChangeSound);							
					stop();
				}
				else
				{						
					_soundTimer.removeEventListener("timer",addVol);
					_soundTimer.removeEventListener("timer",subVol);					
					_soundTimer.stop();
					_soundTimer.reset();
					
					if(mySound)
						_mySound.removeEventListener(SOUND_STOP,onChangeSound);
					if(_mySoundChannel)
						_mySoundChannel.stop();	
					
					
					_mySound = sound;
					play();
				}				
			}
			else
			{
				stop();
			}
		}
		
		/**
		 * 切换声音时处理 
		 * @param evt
		 * @return 
		 * 
		 */		
		private function onChangeSound(evt:Event):void
		{
			_mySound.removeEventListener(SOUND_STOP,onChangeSound);
			if(_mySound2)
			{
				_mySound=_mySound2;
				_mySound2 = null;							
				play();
				//trace("changed");
			}
			
		}
		
		/**
		 * 设置音量
		 * @param vol
		 * 
		 */		
		public function setVol(vol:Number):void
		{
			_val = vol;
			if(!_soundTimer || (_soundTimer && !_soundTimer.running))
				setVolOnTimer(_val);
		}
		
		/**
		 * 设置音量//渐隐渐现时调用 
		 * @param vol
		 * @return 
		 * 
		 */		
		private function setVolOnTimer(vol:Number):void
		{
			
			if(_isPlaying==true && _mySoundChannel)
			{
				_mySoundTransform=_mySoundChannel.soundTransform;
				_mySoundTransform.volume=vol;
//				_mySoundTransform.volume=0;
				_mySoundChannel.soundTransform=_mySoundTransform;		
				
				//trace(_mySoundTransform.volume+" isp:"+_isPlaying);
			}
		}
		
		/**
		 * 减小音量 
		 * @param evt
		 * 
		 */		
		private function subVol(evt:TimerEvent):void
		{
			setVolOnTimer( _mySoundTransform.volume-(1/_bufferRound) );
			if(_mySoundTransform.volume<0){
				_mySoundTransform.volume=0;
				setVolOnTimer(0);
				
				_soundTimer.reset();
				_soundTimer.removeEventListener("timer",subVol);
				
				_mySoundChannel.stop();
				_isPlaying=false;
				_mySound.dispatchEvent(new Event(SOUND_STOP));
			}
		}
		
		/**
		 * 缓冲增音 
		 * @param evt
		 * 
		 */		
		private function addVol(evt:TimerEvent):void
		{
			setVolOnTimer( _mySoundTransform.volume+(1/_bufferRound) );
			if(_mySoundTransform.volume>=_val){
				_mySoundTransform.volume=_val;
				setVolOnTimer(_val);
				
				_soundTimer.reset();
				_soundTimer.removeEventListener("timer",addVol);
			}
		}
		
	}
}
