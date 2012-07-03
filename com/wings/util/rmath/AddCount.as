package com.wings.util.rmath
{
	/**
	 * 加法计算 
	 * @author hh
	 * 
	 */	
	public class AddCount extends BaseArithmetic
	{
		public function AddCount()
		{
			super();			
		}
		
		override public function count():Number
		{
			return this.left+this.right;
		}
	}
}