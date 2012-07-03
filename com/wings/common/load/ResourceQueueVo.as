package com.wings.common.load
{
	import flash.display.Loader;
	import flash.utils.ByteArray;

	/**
	 * @author hh
	 */
	public class ResourceQueueVo
	{
		// 类型定义
		public static const TYPE_IMAGE : String = "image";
		public static const TYPE_MOVIECLIP : String = "movieclip";
		public static const TYPE_TEXT : String = "text";
		public static const TYPE_XML : String = "xml";
		
		public var id : String="";
		public var url : String="";
		public var type : String = "";
		public var bytes:ByteArray;
		
		public function ResourceQueueVo(id:String,url:String,type:String,bytes:ByteArray=null)
		{
			if(id=="" || url=="" || type=="") throw new ArgumentError("ResourceQueueVo参数不得为空");
			this.id = id;
			this.url = url;
			this.type = type;
			if(bytes)this.bytes = bytes;
		}
		
		
	}
}
