package com.wings.ui.components
{	
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * 本类提供1个简单的规则格子容器功能
	 * 适用于等长宽物体的的行列存放 
	 * @author hh
	 * 
	 */	
	public class REasyTable extends Sprite implements IDestroy
	{
		
		/**
		 * 
		 * @param ary  存放displayObject的数组
		 * @param tileW	   单元格子宽
		 * @param tileH	   格子格子高
		 * @param cols  列数
		 * @param hspace  列间距
		 * @param vspace  行间距
		 * @param zerop	 容器左上角在父容器的位置
		 * @param callBackFn 回调（drawUI后调用)
		 */		
		public function REasyTable(ary:Vector.<DisplayObject>,tileW:Number,tileH:Number,cols:int=2,hspace:int=5,vspace:int=5,zerop:Point=null,callBackFn:Function=null)
		{
			_ary = ary;
			_cols = cols;
			_hspace = hspace;
			_vspace = vspace;	
			_tileW = tileW;
			_tileH = tileH;
			if(zerop)
				_zerop= zerop;
			else
				_zerop = new Point();
						
			_callBackFn = callBackFn;
			inits();
		}
		
		protected var _ary:Vector.<DisplayObject>;
		protected var _cols:int=2;
		protected var _rows:int=0;
		
		protected var _hspace:int;
		protected var _vspace:int;
		protected var _tileW:Number;
		protected var _tileH:Number;
		protected var _zerop:Point;
		protected var _callBackFn:Function;
		protected var _w:int;
		protected var _h:int;
		
		private function inits():void
		{
			this.mouseEnabled = this.tabChildren = this.tabEnabled = false;
			drawUI();			
		}
		
		public function set data(array:Vector.<DisplayObject>):void
		{
			reset();
			_ary = array;
			drawUI();
			
		}
		
		protected function drawUI():void
		{
			if(!_ary) return;
			
			var col:int=0;
			_rows = 0;
			for(var i:uint=0;i<_ary.length;i++)
			{
				var disp:DisplayObject = _ary[i];
				var xp:int = _zerop.x + col*(_tileW+_vspace);
				var yp:int = _zerop.y + _rows*(_tileH+_hspace);
				disp.x = xp;
				disp.y = yp;
				this.addChild(disp);
				
				//换行处理
				if(i< _ary.length-1)
				{
					if (i>=_cols-1 && (i+1) % _cols ==0)
					{					
						_rows++;
						col=0;					
					}
					else
					{					
						col++;
					}
				}	
			}
			
			
			var realCol:int = _ary.length>=_cols ? _cols : _ary.length;
			_w = _zerop.x*2 + _tileW*realCol + (realCol-1)*_hspace;
			
			
			_h = _zerop.y*2 + (_rows+1)*_tileH + _rows*_vspace;;
			
			if(_callBackFn!=null)
				_callBackFn();
		}
		
		/**
		 *  重置 
		 * 
		 */		
		public function reset():void
		{
			while(this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			_ary=null;
		}
		
		public function destroy():void
		{
			reset();	
			_callBackFn = null;
		}	
		
	}
}