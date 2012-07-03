package com.wings.util.rmath
{
	public class MulCount extends BaseArithmetic
	{
		public function MulCount()
		{
			super();
		}
		
		override public function count():Number
		{
			return this.left*this.right;
		}
	}
}