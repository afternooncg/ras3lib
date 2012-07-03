package com.wings.util.rmath
{
	public class DivCount extends BaseArithmetic
	{
		public function DivCount()
		{
			super();
		}
		
		override public function count():Number
		{
			if(right==0)
				throw new ArgumentError("除数不得为0");
			return this.left/this.right;
		}
	}
}