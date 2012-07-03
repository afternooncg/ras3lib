package com.wings.util.rmath
{
	/**
	 * 减法
	 * @author hh
	 * 
	 */	
	public class SubCount extends BaseArithmetic
	{
		public function SubCount()
		{
			super();
		}
		
		override public function count():Number
		{
			return this.left-this.right;
		}
	}
}