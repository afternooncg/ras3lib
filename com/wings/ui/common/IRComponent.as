package com.wings.ui.common
{
	import com.wings.common.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;

	public interface IRComponent extends IDestroy,IRSize
	{		
		
		function get uniqueid():int;
		
		function setLocationXY(x:Number,y:Number):void;
		
		function drawUI():void
		
		
	}
}