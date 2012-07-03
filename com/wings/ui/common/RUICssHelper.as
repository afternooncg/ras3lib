package com.wings.ui.common
{
	
	/**
	 * 本类定义了组件默认的字体外观定义及资源包引用 
	 * @author hh
	 * 
	 */	
	public class RUICssHelper
	{
		private static var _instance:RUICssHelper;
		private var _ruiAssets:IRUIComponentRes;
		private var _ruiTf:RUITextformat;
		private var _ruiWh:RUIAutoWh;
		public function RUICssHelper(f:Force)
		{
			if(f==null) 
				throw new Error("单例类不可被实例化");
			
			_ruiAssets = RUIAssets.getInstance();
			_ruiTf = new RUITextformat();
			_ruiWh = new RUIAutoWh();
			
		}
		
		static public function getInstance():RUICssHelper
		{
			if(_instance==null)
			{
				_instance = new RUICssHelper(new Force());				
			}
			return _instance;
		}
		
		
		/**
		 * RUIAssets 
		 * @return 
		 * 
		 */		
		public function get ruiAssets():IRUIComponentRes
		{
			return _ruiAssets;
		}
		public function set ruiAssets(assets:IRUIComponentRes):void
		{
			if(assets)
				_ruiAssets = assets;
		}
		
		/**
		 * 相关字体 
		 * @return 
		 * 
		 */		
		public function get ruiTf():RUITextformat
		{
			return _ruiTf;
		}
		public function set ruiTf(tf:RUITextformat):void
		{
			if(tf)
				_ruiTf = tf;
		}
		
		
		/**
		 * 默认长宽 
		 * @return 
		 * 
		 */		
		public function get ruiWh():RUIAutoWh
		{
			return _ruiWh;
		}
		public function set ruiWh(ruiWh:RUIAutoWh):void
		{
			if(ruiWh)
				_ruiWh = ruiWh;
		}
	}
}

class Force{}