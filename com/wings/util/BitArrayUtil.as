package com.wings.util
{
	import flash.utils.ByteArray;
	  	
	/**
	 * 位读写操作封装,改编网络代码 目前只支持4字节
	 * 使用场景,用1个int做为系列bool值存储容器
	 * 位在 ByteArray 中的位置从左到右边 0,1,2... BitArray.length * 8 - 1
	 * 注:当以配置为使用目标情况下,read模式都应采用readUnsign的类型
	 * @author hh
	 * 
	 */	
	public class BitArrayUtil extends ByteArray 
	{
		
		/** 
		 * 构造函数。 
		 * @param bytes 初始化 
		 *  
		 */              
		public function BitArrayUtil(bytes:ByteArray = null) 
		{ 
			if (bytes != null) 
			{ 
				this.writeBytes(bytes, 0, bytes.length); 
			} 
		} 
		
		/** 
		 * 返回位长度 
		 * @return  
		 *  
		 */              
		public function get bitLength():uint 
		{ 
			return this.length * 8; 
		} 
		
		/** 
		 * 返回由参数 index 指定bit位置处的位的值。1 为 true，0 为 false 。 
		 * @param index 一个整数 
		 * @return 指示索引处的位的值 
		 *  
		 */              
		public function getValueByIndex(index:int = 0):Boolean 
		{ 
			if(index<0)
				index = 0;
			else if(index>this.bitLength-1)
				index = this.bitLength-1;
			
			index++; //+1用于计算长度			
			
			var byteIndex:uint = Math.ceil(index/8) - 1;  // 所在字节位置的索引 
			var flag:uint = 1 << (bitLength - index) % 8; // 获得mask数据 0001000 1为index指定位置
			
			return Boolean(this[byteIndex] & flag); 
		} 
		
		/** 
		 * 设置由参数 index 指定bit位置处的位的值。 
		 * @param index 
		 * @param value 要设置的值。true 为 1 ，false 为 0 。 
		 *  
		 */              
		public function setValueByIndex(index:int, value:Boolean):void 
		{ 			
			if(index<0)
				index = 0;
			else if(index>this.bitLength-1)
				index = this.bitLength-1;
			
			index++;		
			
			var byteIndex:uint = Math.ceil(index/8) - 1; 
			var flag:uint = 1 << (this.bitLength - index) % 8; // 计算标志位 
			if (value) 
			{ 
				this[byteIndex] |= flag; // 或 1 
			} 
			else 
			{ 
				this[byteIndex] &= ~flag; // 取反& 0 
			} 
		}	
		
	}
}