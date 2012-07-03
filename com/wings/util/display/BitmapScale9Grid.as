package com.wings.util.display
{
	import com.wings.common.IDestroy;
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 本类提供规则位图9宫格缩放功能 注意flash的grapic填充绘图某些透明png会出现边缘1px的异常填充，需手动cut操作,如果bitmapdata为非透明就无需cut,
	 * 注意graphics关联的dispobj需要x.y值取整
	 * @author hh
	 * 
	 */	
	public class BitmapScale9Grid extends Sprite implements IDestroy
	{		
		private var _source : BitmapData;		
					
		private var _leftUp : BitmapData;
		private var _leftCenter : BitmapData;
		private var _leftBottom : BitmapData;
		private var _centerUp : BitmapData;
		private var _center : BitmapData;
		private var _centerBottom : BitmapData;
		private var _rightUp : BitmapData;
		private var _rightCenter : BitmapData;
		private var _rightBottom : BitmapData;
		
		private var _width : int;
		private var _height : int;
		
		private var minWidth : int;
		private var minHeight : int;
						
		private var _targetGrahics:Graphics;
		
		private var _leftw:int;
		private var _scalew:int;		//中间缩放宽度
		private var _rightw:int;
		
		private var _toph:int;
		private var _scaleh:int;		//中间缩放高度
		private var _bottomh:int;
		private var _isCutRightBorder:Boolean=false;		//某些透明png图右边重复填充会出现1px边,需要cut
		
		public  var _tmpCt:DisplayObjectContainer;
				
		/**
		 *  
		 * @param source			位图
		 * @param rect				9宫格区		 相对图的0,0点的矩形区
		 * * @param rect				9宫格区		 相对图的0,0点的矩形区
		 * @param graphics			绘图区		 如果graphic==null.则绘图到自身,否则就填充到graphics,如果graphic!=null,要确保grahpic关联的dispobj x/y 取整数
		 */		
		public function BitmapScale9Grid(source:BitmapData, rect:Rectangle,isCutRightBorder:Boolean=false,scaleMode:int=0,graphics:Graphics=null) 
		{				
			_isCutRightBorder = isCutRightBorder;
			_targetGrahics = graphics;
			if(_targetGrahics==null)
				_targetGrahics = this.graphics;
			if(rect!=null && source!=null)
			{
				this.mouseChildren = false;
				
				this._source = source;
				
				if(rect.x<0) rect.x=0;				
				_leftw = rect.x;				
				
				if(rect.y<0) rect.y=0; 				
				_toph = rect.y;
				
				if(rect.width<0)
					rect.width=0;
				else if(rect.width>source.width)
					rect.width=source.width;
				
				if(rect.height<0)
					rect.height=0;
				else if(rect.height>source.height)
					rect.height=source.height;
								
				_bottomh = source.height - _toph - rect.height;
				_scaleh = rect.height;				
								
				_rightw = source.width - _leftw - rect.width;
				_scalew = rect.width;
								
				inits();
			}
			
			
		}
		
		private function inits() : void 
		{			
			_tmpCt = new Sprite();
			_tmpCt.mouseChildren  = _tmpCt.mouseEnabled = false;
			
			_width = _source.width;
			_height = _source.height;
			
			_leftUp = getBitmap(0, 0, _leftw, _toph);			
			
			_leftCenter = getBitmap(0, _toph, _leftw, _scaleh);
			
			_leftBottom = getBitmap(0, _height-_bottomh, _leftw, _bottomh);
			
			_centerUp = getBitmap(_leftw, 0, _scalew, _toph);
			
			_center = getBitmap(_leftw, _toph, _scalew, _scaleh);
			
			_centerBottom = getBitmap(_leftw, _height-_bottomh, _scalew,_bottomh);
			
			_rightUp = getBitmap(_width-_rightw, 0, _rightw, _toph);			
			
			_rightCenter = getBitmap(_width-_rightw, _toph,_rightw, _scaleh);
			
			_rightBottom = getBitmap(_width-_rightw, _height-_bottomh, _rightw,_bottomh);
			
			minWidth = _leftw + _rightw;
			minHeight = _toph + _bottomh;
			
		}
		
		private function getBitmap(x:Number, y:Number, w:Number, h:Number) : BitmapData 
		{
			if(w>0 && h>0)
			{
				var bit:BitmapData = new BitmapData(w, h,true,0);			
				bit.copyPixels(_source, new Rectangle(x, y, w, h), new Point(0, 0));
				return bit;
			}
			return null;
		}
		
		override public function set x(value : Number) : void
		{
			super.x = int(value);
		}
		
		override public function set y(value : Number) : void
		{
			super.y = int(value);
		}
		
		override public function set width(w : Number) : void 
		{			
			updateSize(w,_height);
		}
		
		override public function set height(h : Number) : void 
		{
			updateSize(_width,h);
		}
		
		
		/**
		 * 重绘  采用扩展区域copyphfixs式
		 * 
		 */		
		public function updateSize2(w:Number,h:Number,graphics:Graphics=null) : void 
		{	
			if(w < minWidth)
				w = minWidth;			
			_width = w;
			
			if(h < minHeight)
				h = minHeight;			
			_height = h;
			
			if(graphics!=null)
				_targetGrahics = graphics;
			
			_scalew = _width - _leftw - _rightw;
			_scaleh = _height - _toph - _bottomh;
			
			_targetGrahics.clear();
			
			var max:Matrix;
			
			//上中
			if(_centerUp && _scalew>0 && _toph>0)
			{
				var centerUp:Bitmap = new Bitmap(new BitmapData(_scalew,_toph,true,0));
				repeateFillBg(centerUp.bitmapData,_centerUp);
				_tmpCt.addChild(centerUp);
				centerUp.x = _leftw;
				centerUp.y = 0;
			}
			
			
			//左中
			if(_leftCenter)
			{
				if(_leftw>0 && _scaleh>0)
				{
					var leftCenter:Bitmap = new Bitmap(new BitmapData(_leftw,_scaleh,true,0));
					repeateFillBg(leftCenter.bitmapData,_leftCenter);
					_tmpCt.addChild(leftCenter);
					leftCenter.x = 0;
					leftCenter.y = _toph;
				}
			}
			
			//中
			if(_center)
			{		
				if(_scalew>0 && _scaleh>0)
				{
					var center:Bitmap = new Bitmap(new BitmapData(_scalew,_scaleh,true,0));
					repeateFillBg(center.bitmapData,_center);
					_tmpCt.addChild(center);
					center.x = _leftw;
					center.y = _toph;
				}
			}	
			
			//右中
			if(_rightCenter)
			{
				if(_rightw>0 && _scaleh>0)
				{
					var rightCenter:Bitmap = new Bitmap(new BitmapData(_rightw,_scaleh,true,0));
					repeateFillBg(rightCenter.bitmapData,_rightCenter);
					_tmpCt.addChild(rightCenter);
					rightCenter.x = _width-_rightw;
					rightCenter.y = _toph;
				}
			}
			
		
			//下中
			if(_centerBottom)
			{
				if(_scalew>0 && _bottomh>0)
				{					
					var centerBottom:Bitmap = new Bitmap(new BitmapData(_scalew,_bottomh,true,0));
					repeateFillBg(centerBottom.bitmapData,_centerBottom);
					_tmpCt.addChild(centerBottom);
					centerBottom.x = _leftw;
					centerBottom.y = _height-_bottomh;
				}	
			}
			
			
			//左上
			if(_leftUp)
			{
				var leftUp:Bitmap = new Bitmap(_leftUp);			
				_tmpCt.addChild(leftUp);
			}
			
			
			//右上			
			if(_rightUp)
			{
				var rightUp:Bitmap = new Bitmap(_rightUp);			
				_tmpCt.addChild(rightUp);
				rightUp.x = _width - _rightw;
			}
			
			//左下
			if(_leftBottom)
			{
				var leftBottom:Bitmap = new Bitmap(_leftBottom);			
				_tmpCt.addChild(leftBottom);
				leftBottom.y = _height - _bottomh;
			}	
			
			//右下
			if(_rightBottom)
			{
				var rightBottom:Bitmap = new Bitmap(_rightBottom);			
				_tmpCt.addChild(rightBottom);
				rightBottom.x = _width - _rightw;
				rightBottom.y = _height - _bottomh;
			}
			
//			RUIManager.stage.addChild(_tmpCt);
//			_tmpCt.x = _tmpCt.y = 200;
//			return;
			
			var tmpBmp:Bitmap = DisplayObjectKit.displayObjToBitmap(_tmpCt,true);			
			_targetGrahics.beginBitmapFill(tmpBmp.bitmapData,null,false);
			_targetGrahics.drawRect(0,0,tmpBmp.width,tmpBmp.height);
			_targetGrahics.endFill();
			
//			tmpBmp.bitmapData.dispose();
			tmpBmp = null;
//			return;
			while(_tmpCt.numChildren>0)
				_tmpCt.removeChildAt(0);
			
			leftUp.bitmapData = null;
			leftUp = null;
			
			if(centerUp)
			{
				centerUp.bitmapData = null;
				centerUp = null;
			}
			
			rightUp.bitmapData = null;
			rightUp = null;
			
			if(leftCenter)
			{
				leftCenter.bitmapData = null;
				leftCenter = null;
			}
			
			if(center)
			{
				center.bitmapData = null;
				center = null;
			}
			
			if(rightCenter)
			{
				rightCenter.bitmapData = null;
				rightCenter = null;
			}
			
			leftBottom.bitmapData = null;
			leftBottom = null;
			
			if(centerBottom)
			{
				centerBottom.bitmapData = null;
				centerBottom = null;
			}
			
			rightBottom.bitmapData = null;
			rightBottom = null;
		}
		
		/**
		 * 重复填充 
		 * @param sourceBmpData
		 * @param penBmpData
		 * 
		 */		
		private function repeateFillBg(sourceBmpData:BitmapData,penBmpData:BitmapData):void
		{
			if(sourceBmpData == null || penBmpData==null)
				return;
			
			var cols:int = Math.ceil(sourceBmpData.width/penBmpData.width);
			var rows:int = Math.ceil(sourceBmpData.height/penBmpData.height);
			var rect:Rectangle = new Rectangle(0,0,penBmpData.width,penBmpData.height);
			for (var i:int = 0; i < cols; i++) 
			{
				for (var j:int = 0; j < rows; j++) 
				{
					sourceBmpData.copyPixels(penBmpData,rect,new Point(i*penBmpData.width,j*penBmpData.height),null,null,true);
				}				
			}
		}
				
		/**
		 * 重绘算法2,采用扩展区域拉升式
		 * 
		 */		
		public function updateSize(w:Number,h:Number,graphics:Graphics=null) : void 
		{	
			if(w < minWidth)
				w = minWidth;			
			_width = w;
			
			if(h < minHeight)
				h = minHeight;			
			_height = h;
			
			if(graphics!=null)
				_targetGrahics = graphics;
			
			_scalew = _width - _leftw - _rightw;
			_scaleh = _height - _toph - _bottomh;
			
			_targetGrahics.clear();
			
			var max:Matrix;
			
			//上中
			if(_centerUp && _scalew>0 && _toph>0)
			{
				var centerUp:Bitmap = new Bitmap(_centerUp);
				centerUp.width = _scalew;
				_tmpCt.addChild(centerUp);
				centerUp.x = _leftw;
				centerUp.y = 0;
			}
			
			
			//左中
			if(_leftCenter && _leftw>0 && _scaleh>0)
			{
				var leftCenter:Bitmap = new Bitmap(_leftCenter);
				leftCenter.height = _scaleh;
				_tmpCt.addChild(leftCenter);
				leftCenter.x = 0;
				leftCenter.y = _toph;
			}
			
			//中
			if(_center && _scalew>0 && _scaleh>0)
			{		
				var center:Bitmap = new Bitmap(_center);				
				center.width = _scalew;
				center.height = _scaleh;
				_tmpCt.addChild(center);
				center.x = _leftw;
				center.y = _toph;
			}	
			
			//右中
			if(_rightCenter && _rightw>0 && _scaleh>0)
			{
				var rightCenter:Bitmap = new Bitmap(_rightCenter);
				_tmpCt.addChild(rightCenter);
				rightCenter.height = _scaleh;
				rightCenter.x = _width-_rightw;
				rightCenter.y = _toph;
			}
			
			
			//下中
			if(_centerBottom && _scalew>0 && _bottomh>0)
			{
				var centerBottom:Bitmap = new Bitmap(_centerBottom);				
				centerBottom.width = _scalew;
				_tmpCt.addChild(centerBottom);
				centerBottom.x = _leftw;
				centerBottom.y = _height-_bottomh;
			}
			
			
			//左上
			if(_leftUp)
			{
				var leftUp:Bitmap = new Bitmap(_leftUp);			
				_tmpCt.addChild(leftUp);
			}
			
			
			//右上			
			if(_rightUp)
			{
				var rightUp:Bitmap = new Bitmap(_rightUp);			
				_tmpCt.addChild(rightUp);
				rightUp.x = _width - _rightw;
			}
			
			//左下
			if(_leftBottom)
			{
				var leftBottom:Bitmap = new Bitmap(_leftBottom);			
				_tmpCt.addChild(leftBottom);
				leftBottom.y = _height - _bottomh;
			}	
			
			//右下
			if(_rightBottom)
			{
				var rightBottom:Bitmap = new Bitmap(_rightBottom);			
				_tmpCt.addChild(rightBottom);
				rightBottom.x = _width - _rightw;
				rightBottom.y = _height - _bottomh;
			}
			
			//			RUIManager.stage.addChild(_tmpCt);
			//			_tmpCt.x = _tmpCt.y = 200;
			//			return;
			
			var tmpBmp:Bitmap = DisplayObjectKit.displayObjToBitmap(_tmpCt,true);			
			_targetGrahics.beginBitmapFill(tmpBmp.bitmapData,null,false);
			_targetGrahics.drawRect(0,0,tmpBmp.width,tmpBmp.height);
			_targetGrahics.endFill();
			
			//			tmpBmp.bitmapData.dispose();
			tmpBmp = null;
			//			return;
			while(_tmpCt.numChildren>0)
				_tmpCt.removeChildAt(0);
			
			if(leftUp)
			{
				leftUp.bitmapData = null;
				leftUp = null;
			}
			
			if(centerUp)
			{
				centerUp.bitmapData = null;
				centerUp = null;
			}
			
			if(rightUp)
			{
				rightUp.bitmapData = null;
				rightUp = null;
			}
			
			if(leftCenter)
			{
				leftCenter.bitmapData = null;
				leftCenter = null;
			}
			
			if(center)
			{
				center.bitmapData = null;
				center = null;
			}
			
			if(rightCenter)
			{
				rightCenter.bitmapData = null;
				rightCenter = null;
			}
			
			if(leftBottom)
			{
				leftBottom.bitmapData = null;
				leftBottom = null;
			}
			
			if(centerBottom)
			{
				centerBottom.bitmapData = null;
				centerBottom = null;
			}
			
			if(rightBottom)
			{
				rightBottom.bitmapData = null;
				rightBottom = null;
			}

		}
		
		
		public function destroy():void
		{
			var ary:Array = [_leftUp,_leftCenter,_leftBottom,_centerUp,_center,_centerBottom,_rightUp,_rightCenter,_rightBottom];
			for(var i:uint=0;i<ary.length;i++)
			{
				var bmp:BitmapData = ary[i] as BitmapData;
				bmp.dispose();				
				bmp = null;
			}
			
			_targetGrahics = null;
		}
	}

}
