package com.wings.ui.common
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 部分组件的文本样式 
	 * @author Administrator
	 * 
	 */	
	public class RUITextformat 
	{
		private static var _instance:RUITextformat;
		public function RUITextformat()
		{		
		}
		
		/**
		 * 更新皮膚 
		 * @param ruiTf
		 * 
		 */		
		public static  function  update(ruiTf:RUITextformat):void
		{
			if(ruiTf) _instance = ruiTf;
		}
		
		
		/**
		 *  
		 * @return 
		 * 
		 */		
	    public	static  function getInstance():RUITextformat
		{
			if(_instance==null)
			{
				_instance = new RUITextformat();
			}
			return _instance;
		}
		
		/**
		 *悬停工具的文本样式 
		 * @return 
		 * 
		 */		
		public function get toolTipFormat():TextFormat{
		   var ttf:TextFormat = new TextFormat();
		   ttf.color=0xF3E372;
		   ttf.size=12;
		   ttf.leading=5;
		   ttf.font="Tahoma";
		   
		   return ttf;
		}
		
		/**
		 * 默认表单label 
		 * @return 
		 * 
		 */		
		public function get formLable():TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.color=0xFFFF99;
			tf.size=14;
			tf.leading=5;
			tf.font="Tahoma";
			tf.bold=true;			
			return tf;			
		}
		
		
		
		/**
		 *弹出框标题的文本样式 
		 * @return 
		 * 
		 */		
		public function get frameTitleFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.color=0x9c4c19;
			tf.size=14;
			tf.leading=5;
			tf.font="Tahoma";
			tf.bold=true;
			
			return tf;
		}
		
		
		
		
		/**
		 * 默认label文本样式 
		 */		
		public function get lableTextFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.color=0xFFFFCC;
			tf.size=12;
			tf.leading=5;
			tf.font="Tahoma";
			return tf;
		}
		
		
		/**
		 *输入文本样式 
		 */		
		public function get inputTextFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.color=0xffffcd;
			tf.size=12;
			tf.leading=5;
			tf.font="Tahoma";
			tf.bold=true;
			
			return tf;
		}
		
		
		
		/**
		 *默认按钮样式 
		 */		
		public function get buttonTextformat():TextFormat{
		  var tf:TextFormat = new TextFormat();
		  tf.color = 0xdfaa5a;
		  tf.size = 12;
		  tf.font="tahoma";
		  tf.align = TextFormatAlign.CENTER;
		  
		  return tf;
		}
		
		/**
		 *默认按钮over样式 
		 */		
		public function get buttonTextOverformat():TextFormat
		{			
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffcc66;
			tf.size = 12;
			tf.font="tahoma";
			tf.align = TextFormatAlign.CENTER;
			
			return tf;
//			return buttonTextformat;
		}
		
		/**
		 *默认tab按钮样式 
		 */		
		public function get tabButtonTextformat():TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x690403;
			tf.size = 14;
			tf.font="Tahoma";
			tf.align = TextFormatAlign.CENTER;			
			return tf;
		}
		
		/**
		 *默认tab按钮over样式 
		 */		
		public function get tabButtonTextOverformat():TextFormat
		{	
			var tf:TextFormat = this.tabButtonTextformat;
			tf.color = 0xFFFFCC;
			return tf;
			
			//			return buttonTextformat;
		}
		
		
		public function get buttonTextformat2():TextFormat
		{
		  var tf:TextFormat = new TextFormat();
		  tf.color = 0x841B00;
		  tf.size = 18;
		  tf.font="黑体";
		  tf.align = TextFormatAlign.CENTER;
		  
		  return tf;
		}
		
		/**
		 *数据表格表头的文本样式 
		 */		
		public function get gridTitleTextFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.color = 0x773F24;
			tf.size = 14;
			tf.font="Tahoma";
			tf.bold = true;
			tf.align = TextFormatAlign.CENTER;
			
			return tf;
		}
		
		
		/**
		 *数据表格内容字体样式 
		 */		
		public function get gridDataTextFormat():TextFormat{
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFEF2C0;
			tf.size = 14;
			tf.font="Tahoma";
			tf.bold = false;
			tf.align = TextFormatAlign.CENTER;
			
			return tf;
		}
		
		
		/**
		 * 默认表单over 
		 * @return 
		 * 
		 */		
		public function get formLable1():TextFormat
		{
			var tf:TextFormat = new TextFormat();
			tf.color=0xFFFF00;
			tf.size=14;
			tf.leading=5;
			tf.font="Tahoma";
			tf.bold=true;			
			return tf;
			
		}
		
	}
}