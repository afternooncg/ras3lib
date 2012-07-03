package com.wings.util.display 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * 网上找来的画虚线/及画扇形代码	  	 
	 * 
	 */
	public class GraphicsLineUtil 
	{
		
		/**
		 * 画斑马线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 斑马线的宽度
		 * @param	grap		<b>	Number	</b> 
		 */
		static public function drawZebraStripes(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var halfWidth:Number = width * .5;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var radian1:Number = (radian / Math.PI * 180 + 90) / 180 * Math.PI;
			var radian2:Number = (radian / Math.PI * 180 - 90) / 180 * Math.PI;
			
			var currX:Number, currY:Number;
			var p1x:Number, p1y:Number;
			var p2x:Number, p2y:Number;
			
			while (currLen <= totalLen)
			{
				currX = Ox + Math.cos(radian) * currLen;
				currY = Oy + Math.sin(radian) * currLen;
				p1x = currX + Math.cos(radian1) * halfWidth;
				p1y = currY + Math.sin(radian1) * halfWidth;
				p2x = currX + Math.cos(radian2) * halfWidth;
				p2y = currY + Math.sin(radian2) * halfWidth;
				
				graphics.moveTo(p1x, p1y);
				graphics.lineTo(p2x, p2y);
				
				currLen += grap;
			}
			
		}
		
		
		/**
		 * 画虚线
		 * 
		 * @param	graphics	<b>	Graphics</b> 
		 * @param	beginPoint	<b>	Point	</b> 
		 * @param	endPoint	<b>	Point	</b> 
		 * @param	width		<b>	Number	</b> 虚线的长度
		 * @param	grap		<b>	Number	</b> 
		 */
		static public function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += width;
				if (currLen > totalLen) currLen = totalLen;
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy +Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				
				currLen += grap;
			}
			
		}
		
		/**
		 * 通过曲线绘制精度不高的扇形 
		 * @param graphics  扇形所在grahpic的名字
		 * @param x			扇形原点的横纵坐标
		 * @param y			纵坐标
		 * @param r			扇形的半径
		 * @param angle		扇形角度(非弧度)
		 * @param startFrom	起始角度(非弧度)
		 * @param color		扇形的颜色
		 * @param returnEnd true返回最后点/false最前点
		 */
		
		public static  function drawSector(graphics:Graphics,x:Number=0,y:Number=0,r:Number=50,angle:Number=0,startFrom:Number=0,color:Number=0x000000,alpha:Number=0.6,returnEnd:Boolean=true):Point 
		{
			graphics.clear();
			graphics.beginFill(color,alpha);			
			graphics.moveTo(x, y);
			angle = (Math.abs(angle) > 360)?360:angle;
			var n:Number = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			var p:Point = new Point(0,0);
			p.x = x + r * Math.cos(startFrom);
			p.y = y + r * Math.sin(startFrom);
			graphics.lineTo(p.x, p.y);
			
			for (var i:int = 1; i <= n; i++) 
			{				
				startFrom += angleA;
				var angleMid:Number = startFrom - angleA / 2;
				var bx:Number = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
				var by:Number = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
				var cx:Number = x + r * Math.cos(startFrom);
				var cy:Number = y + r * Math.sin(startFrom);
				graphics.curveTo(bx, by, cx, cy);
			}
			if (angle != 360) 
			{
				graphics.lineTo(x, y);
			}
			graphics.endFill();
			
			if(returnEnd)
			{
				p.x = cx;
				p.y = cy;
			}
			return p;
		} 
	}
	
}