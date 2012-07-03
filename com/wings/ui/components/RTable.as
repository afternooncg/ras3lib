package com.wings.ui.components
{
	import com.wings.ui.components.constdefine.UIAlignType;
	import com.wings.ui.manager.RUIManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;


	
	/**
	 * 本类提供1个简单的表格布局功能,支持非等宽高度显示对象
	 * 可设定显示列数/cols 行间距/vspace 列间距/hspace 水平/垂直对齐模式(halign/valign)
	 * 设置dataProvider立刻触发drawUI行为
	 * @author hh
	 * 
	 */	
	public class RTable extends RBaseComponents
	{
		/**
		 * 
		 * @param params {x,y,w,h,hspacing,vspacing,cols} 水平/垂直间距 列数 
		 * 
		 */		
		public function RTable(parent:DisplayObjectContainer,params:Object=null)
		{
			super(parent,params);
		}
		
		private var _cols:int=1; 	//列数		
		private var _hspacing:int=5; //水平间距
		private var _vspacing:int=5; //垂直间距		
		private var _vtData:Vector.<DisplayObject>;
		private var _aryColW:Array;	//存放各列宽
		private var _aryRowH:Array;	//存放各行高
		private var _arySizeMap:Array;	//存放各对象尺寸的行列印象 2维数组
		private var _halign:String=UIAlignType.LEFT;  //水平对齐模式
		private var _valign:String= UIAlignType.TOP;  //垂直对齐模式 top middle bottom
		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected  function inits():void
		{	
			super.inits();
		}		
		
		/**
		 * 被子类override,控制 UI 界面绘制
		 */
		override public function drawUI():void
		{
			if(!_vtData || _vtData.length==0) return;
			while(this.numChildren>0)	this.removeChildAt(0);
			
			for(var hi:uint=0;hi<_aryColW.length;hi++)
			{
				_w += _aryColW[hi]+_hspacing;
			}
			
			for(var vi:uint=0;vi<_aryRowH.length;vi++)
			{
				_h += _aryRowH[vi]+_hspacing;
			}
			
			
			var tmpVt:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var row:int=0;
			var col:int=0;
			for(var i:uint=0;i<_vtData.length;i++)
			{
				var icon:DisplayObject = _vtData[i];
				if(icon==null) continue;
				
				var len:Number=0;
				for(var ci:uint=0;ci<col;ci++)
					len+=_aryColW[ci];
								
				if(_halign==UIAlignType.LEFT)		//左
				{
					icon.x = col*_hspacing + len;	
				}
				else if(_halign== UIAlignType .CENTER)	//中
				{
					icon.x = col*_hspacing + len + (_aryColW[col]-icon.width)/2;
				}
				else				//右
				{
					icon.x = col*_hspacing + len + (_aryColW[col]-icon.width);
				}				
				
				len=0;
				for(ci=0;ci<row;ci++)				
					len+=_aryRowH[ci];				
				
				if(_valign==UIAlignType.TOP)		//top
				{
					icon.y = row*_vspacing + len;	
				}
				else if(_valign==UIAlignType.MIDDLE)	//中
				{
					icon.y = row*_vspacing + len + (_aryRowH[row]-icon.height)/2;					
				}
				else				//底部
				{
					icon.y = row*_vspacing + len + (_aryRowH[row]-icon.height);					
				}
				
//				换行处理
				if (i>=_cols-1 && (i+1) % _cols ==0)
				{					
					row++;
					col=0;
				}
				else
				{					
					col++;
				}				
				
				this.addChild(icon);
			}
			super.drawUI();
		}
		
		/**
		 * 每次赋值都将重绘表格界面 赋值前需先设置对齐/列数 间距等参数
		 * @param dispVt
		 * 
		 */		
		public function set dataProvider(dispVt:Vector.<DisplayObject>):void
		{
			if(!dispVt) return;
			
			_vtData = dispVt;
			if(_cols<0)
			{
				_cols=0;
			}
			else if(_cols>_vtData.length)
			{
				_cols=_vtData.length;
			}
				
			
			createHelpAry();
			
			drawUI();
		}

		
		public function get dataProvider():Vector.<DisplayObject>
		{
			return _vtData; 
		}
		
		/**
		 * 列间距 
		 * @return 
		 * 
		 */		
		public function get hspacing():int
		{
			return _hspacing;
		}

		public function set hspacing(value:int):void
		{
			_hspacing = value;
		}
		
		/**
		 * 行间距 
		 * @return 
		 * 
		 */		
		public function get vspacing():int
		{
			return _vspacing;
		}

		public function set vspacing(value:int):void
		{
			_vspacing = value;
		}
		
		/**
		 * 列数 
		 * @return 
		 * 
		 */		
		public function get cols():int
		{
			return _cols;
		}
		
		public function set cols(value:int):void
		{	
			_cols = value;
		}
		
		
		override public function destroy():void
		{
			if(_vtData)
				_vtData.splice(0,_vtData.length);
			if(_aryColW)
				_aryColW.splice(0);
			if(_aryRowH) 
				_aryRowH.splice(0);
			
			if(_arySizeMap && _arySizeMap.length>0)
			{
				while(_arySizeMap.length>0)
				{
					var tmp:Vector.<DisplayObject> = _arySizeMap.pop() as Vector.<DisplayObject>;
					if(tmp)
						tmp.splice(0,tmp.length);
				}				
			}
			
			_aryColW = _aryRowH = _arySizeMap = null;
			while(this.numChildren>0)	this.removeChildAt(0);
			super.destroy();
		}
		
		/**
		 * 生成辅助计算数组 
		 * 
		 */		
		private function createHelpAry():void
		{
//			先重置辅助数组
			if(_arySizeMap)
			{
				while(_arySizeMap.length>0)
				{
					(_arySizeMap.pop() as Vector.<SizeVo>).splice(0,1000);
				}				
			}
			_arySizeMap = new Array();
			
			if(_aryColW)
			{
				_aryColW.splice(0);
				_aryRowH.splice(0);
			}
			_aryColW = new Array();
			_aryRowH = new Array();
			 
			
//			制作table映射2维数组
			var tmpVt:Vector.<SizeVo> = new Vector.<SizeVo>();
			_arySizeMap.push(tmpVt);
			for(var i:uint=0;i<_vtData.length;i++)
			{	
				if(_vtData[i]==null) continue;
				var rect:Rectangle = _vtData[i].getBounds(RUIManager.stage);				
				tmpVt.push(new SizeVo(rect.width,rect.height));
				if((i+1)%_cols==0 && i<(_vtData.length-1))
				{		
					if(tmpVt!=null) _aryRowH.push(getMaxH(tmpVt.slice()));		//写入该行最高
					tmpVt = new Vector.<SizeVo>();
					_arySizeMap.push(tmpVt);
				}				
				
				if(i==_vtData.length-1 && tmpVt!=null)
					_aryRowH.push(getMaxH(tmpVt.slice()));
					
			}
			
//			提取各列最宽
			var tmpColVt:Vector.<SizeVo> = new Vector.<SizeVo>();
			for(var k:uint=0;k<_cols;k++)
			{
				for(var j:uint=0;j<_arySizeMap.length;j++)
				{
					var vt:Vector.<SizeVo> = _arySizeMap[j] as Vector.<SizeVo>;
					if(k>vt.length-1) break;
					tmpColVt.push(vt[k] as SizeVo);	
				}
				//				写入该列最宽
				if(tmpColVt!=null) _aryColW.push(getMaxW(tmpColVt.slice()));
				tmpColVt = new Vector.<SizeVo>();
			}
		}
		
		
		/**
		 * 计算一列最大宽度 
		 * @return 
		 * 
		 */		
		private function getMaxW(vt:Vector.<SizeVo>):Number
		{
			if(!vt || vt.length==0) return 0;
			
			vt = vt.slice();//复制1分数组操作,避免影响源数据
			vt.sort(sortOnWidth);
			return vt[vt.length-1].w;			
						
			
			//按宽度排序			
			function sortOnWidth(a:SizeVo, b:SizeVo):Number 
			{
				var aw:Number = a.w;
				var bw:Number = b.w
				
				if(aw > bw)
				{
					return 1;
				} else if(aw < bw) 
				{
					return -1;
				}
				else  
				{
					return 0;
				}
			}		
		}
		
		
		/**
		 * 获取同一行最高 
		 * @return 
		 * 
		 */		
		private function getMaxH(vt:Vector.<SizeVo>):Number
		{
			if(!vt || vt.length==0) return 0;
			
			vt.sort(sortOnHeight);
			return vt[vt.length-1].h;

			//按宽度排序			
			function sortOnHeight(a:SizeVo, b:SizeVo):Number 
			{
				var ah:Number = a.h;
				var bh:Number = b.h;
				
				if(ah > bh) 
				{
					return 1;
				}
				else if(ah < bh) 
				{
					return -1;
				}
				else  
				{				
					return 0;
				}
			}
		}

		/**
		 * 水平对齐模式 支持 left/center/right  枚举类UIAlignType 
		 * @return 
		 * 
		 */		
		public function get halign():String
		{
			return _halign;
		}

		public function set halign(value:String):void
		{
			_halign = value;
		}
		
		/**
		 * 垂直对齐模式 支持 top/middle/bottom 枚举类UIAlignType 
		 * @return 
		 * 
		 */		
		public function get valign():String
		{
			return _valign;
		}

		public function set valign(value:String):void
		{
			_valign = value;
		}

		
	}
}


/**
 * 存放高宽对象 
 * @author 
 * 
 */
class SizeVo
{	
	public var w:Number;
	public var h:Number;
	public function SizeVo(w:Number,h:Number)
	{
	  this.w = Math.round(w);
	  this.h = Math.round(h);
	}
}