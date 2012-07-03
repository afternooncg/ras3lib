package com.wings.ui.components
{
	import com.wings.ui.common.RUIAssets;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * UI中使用到的各个样式的边框,改显示对象内的子对象不可操作
	 * @author yying
	 * 
	 */	
	public class RBorder extends Sprite
	{
		private var _picCt:Sprite;
		private var _skin:DisplayObject;
		public function RBorder(skin:DisplayObject = null)
		{
			super();
			_skin = skin===null?RUIAssets.getInstance().borderSkin1:skin;
			init(_skin);
		}
		
		private function init(skin:DisplayObject):void{
		    this.addChild(skin);
			this.mouseChildren = false;
		}
		
		override public function set width(value:Number):void{
			_skin.width = value;
		}
		
		override public function set height(value:Number):void{
		   _skin.height = value;
		} 
		
		
		/**
		 * 改变边框颜色 
		 * @param color
		 * 
		 */		
		public function set bgColor(color:uint):void
		{
			var cf:ColorTransform = _skin.transform.colorTransform;
			cf.color = color;
			_skin.transform.colorTransform = cf;
		}
		/**
		 * 一些特殊的边框可能会作为容器来使用
		 * 比如一些图标的边框
		 * 
		 */		
		public function addPic(dis:DisplayObject):void{
			if(_picCt==null) _picCt = new Sprite();
			_picCt.addChild(dis);
			_picCt.mouseChildren=false;
		} 
		
		/**
		 *移除边框容器内的对象 
		 */		
		public function removePic(dis:DisplayObject):void{
		   if(_picCt!=null){
		     for(var i:int=_picCt.numChildren-1;i>-1;i--){
				 _picCt.removeChildAt(i);
			 }
		   }
		}
		
		/**
		 *改变border的样式 
		 */		
		public function set borderSkin(value:DisplayObject):void{
		  _skin = value;
		  this.removeChildAt(0);
		  this.addChildAt(_skin,0);
		}
		
	}
}