package 
{
	import com.wings.ui.common.IRUIComponentRes;
	import com.wings.ui.common.RUISkin;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
		
	/**
	 * 项目通用UI控件资源
	 * @author hh
	 */
	
	[Event(name="complete", type="flash.events.Event")]
	
	public class ComponentsRes extends Sprite implements IRUIComponentRes 
	{		
		private var _inited:Boolean = false;//资源是否加载完毕
		protected var _loader:Loader;

		public function get loader():Loader
		{
			return _loader;
		}

		 
		[Embed(source="/assets/componentSkin.swf", mimeType="application/octet-stream")]
		private var _compSkin:Class;
		
		[Embed(source="/assets/windowbg.png",scaleGridLeft="50", scaleGridTop="44", scaleGridRight="235",scaleGridBottom="130")]
		private var _windowbg:Class;
		
		//[Embed(source="/assets/windowbg1.png",scaleGridLeft="120", scaleGridTop="100", scaleGridRight="200",scaleGridBottom="110")]
		[Embed(source="/assets/windowbg1.png",scaleGridLeft="110", scaleGridTop="130", scaleGridRight="160",scaleGridBottom="190")]
		private var _windowbg1:Class;
		
		[Embed(source="/assets/windowbg2.png",scaleGridLeft="85", scaleGridTop="78", scaleGridRight="179",scaleGridBottom="142")]
		private var _windowbg2:Class;
		
		[Embed(source="/assets/coboxheadbtnOver.png",scaleGridLeft="14", scaleGridTop="3", scaleGridRight="160",scaleGridBottom="20")]
		private var _coboxheadbtnOver:Class;
		[Embed(source="/assets/coboxheadbtn.png",scaleGridLeft="14", scaleGridTop="3", scaleGridRight="160",scaleGridBottom="20")]
		private var _coboxheadbtn:Class;
		
		[Embed(source="/assets/btn1_Up.png",scaleGridLeft="20", scaleGridTop="8", scaleGridRight="150",scaleGridBottom="20")]
		private var _btnUp1:Class;
		[Embed(source="/assets/btn1_Over.png",scaleGridLeft="20", scaleGridTop="8", scaleGridRight="150",scaleGridBottom="20")]
		private var _btnOver1:Class;
		
		[Embed(source="/assets/confirm_over.png")]
		private var _confirm_over:Class;
		[Embed(source="/assets/confirm_up.png")]
		private var _confirm_up:Class;
		
		
		[Embed(source="/assets/tip.png")]
		private var _tooltipBgImg:Class;
		
		
		public function ComponentsRes():void 
		{
			Security.allowDomain("*");
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handleLoaded);
		}
		
		/**
		 * 开始加载框架内嵌UI资源 
		 * 
		 */
		public function Load():void
		{				
			_loader.loadBytes(new _compSkin());
		}
		
		/**
		 * 获取Loader的.swf指定导出类实例 
		 * @return 
		 * 
		 */		
		public function GetObject(className:String):Object
		{			
			if(_inited && className)
			{
				var c:Class;
				if(_loader.contentLoaderInfo.applicationDomain && _loader.contentLoaderInfo.applicationDomain.hasDefinition(className))
				{
					c=_loader.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;					
					if(c) return new c();
					
				}
				else if(ApplicationDomain.currentDomain.hasDefinition(className))
				{	
					c = ApplicationDomain.currentDomain.getDefinition(className) as Class;
					if(c) return new c();				
				}	 	
			}
			return null;
		}	
		
		/**
		 * 框架内嵌UI资源加载完毕 
		 * @param event
		 * 
		 */		
		private function handleLoaded(event:Event):void
		{			
			_inited = true;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,handleLoaded);
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		
		/**
		 * 窗体背景 
		 * @return 
		 * 
		 */		
		public function get WindowBg():DisplayObject
		{
			return new _windowbg() as DisplayObject;
		}
		
		/**
		 * 窗体背景1
		 * @return 
		 * 
		 */		
		public function get WindowBg1():DisplayObject
		{
			return new _windowbg1() as DisplayObject;
		}
		
		/**
		 * 窗体背景2
		 * @return 
		 * 
		 */		
		public function get WindowBg2():DisplayObject
		{
			return new _windowbg2() as DisplayObject;
		}
		
		/**
		 * 悬停背景 
		 * @return 
		 * 
		 */		
		public function get ToolTipSkin():DisplayObject
		{
			//return this.GetObject("ToolTipSkin") as DisplayObject;
			return new _tooltipBgImg()  as DisplayObject;
		}
		
		/**
		 * 数值调整增加按钮 皮肤1 
		 * @return 
		 * 
		 */		
		public function get incBtnSkin1():RUISkin			
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btnInc") as DisplayObject;
			bs.overState = GetObject("btnInc_over") as DisplayObject;
			return bs;
		}
		
		/**
		 * 数值调整减少按钮 皮肤1 
		 * @return 
		 * 
		 */		
		public function get decBtnSkin1():RUISkin			
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btnDec") as DisplayObject;
			bs.overState = GetObject("btnDec_over") as DisplayObject;
			return bs;			
		}
		
		
		/**
		 * checkbox 皮肤1 
		 * @return 
		 * 
		 */		
		public function get checkBoxSkin1():RUISkin			
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("checkbox") as DisplayObject;
			bs.overState = GetObject("checkbox_over") as DisplayObject;
			return bs;
		}
		
		
		/**
		 * radiobox 皮肤1 
		 * @return 
		 * 
		 */		
		public function get radioButtonSkin1():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("radio") as DisplayObject;
			bs.overState = GetObject("radio_over") as DisplayObject;
			return bs;		
		}
		
		
		/**
		 * 默认base按钮样式 
		 * @return 
		 * 
		 */		
		public function get baseBtnSkin():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			
			var tranBtn:Sprite = new Sprite();
			tranBtn.graphics.beginFill(0xFFFFFF,0);
			tranBtn.graphics.drawRect(0,0,1,1);
			tranBtn.graphics.endFill();			
			bs.upState = tranBtn;
			bs.overState = tranBtn;
			return bs;
		}
		
		
		/**
		 * 按钮样式1 
		 * @return 
		 * 
		 */		
		public function get btnSkin1():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = new _btnUp1() as DisplayObject;
			bs.overState = new _btnOver1() as DisplayObject;			
			return bs;
			
		}
		
		public function get btnSkin2():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btn2_Up") as DisplayObject;
			bs.overState = GetObject("btn2_Over") as DisplayObject;
			return bs;
		}
		
		public function get btnSkin3():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btn3_Up") as DisplayObject;
			bs.overState = GetObject("btn3_Over") as DisplayObject;
			return bs;
		}
		
		public function get btnSkin4():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btn4_Up") as DisplayObject;
			bs.overState = GetObject("btn4_Over") as DisplayObject;
			return bs;
		}
		
		public function get btnSkin5():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btn5_Up") as DisplayObject;
			bs.overState = GetObject("btn5_Over") as DisplayObject;
			return bs;
		}		
		
		public function get btnSkin6():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("btn6_Up") as DisplayObject;
			bs.overState = GetObject("btn6_Over") as DisplayObject;
			return bs;
		}
		
		public function get btnSkin7():RUISkin{
			var bs:RUISkin = new RUISkin();
			bs.upState = new _confirm_up() as DisplayObject;
			bs.overState = new _confirm_over() as DisplayObject;
			return bs;
		}
		
		/**
		 * 关闭按钮样式 
		 * @return 
		 * 
		 */		
		public function get closeBtnSkin():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("cancel_Up") as DisplayObject;
			bs.overState = GetObject("cancel_Over") as DisplayObject;
			return bs;
		}
		
		/**
		 *列表中子对象的皮肤 
		 * @return 
		 * 
		 */		
		public function get comboxItemSkin():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = GetObject("item_upSkin") as DisplayObject;
			bs.overState = GetObject("item_overSkin") as DisplayObject;
			bs.downState = GetObject("item_downSkin") as DisplayObject;
			bs.disableState =  GetObject("item_disabledSkin") as DisplayObject;
			return bs;
		}
		
		/**
		 *列表背景 
		 * @return 
		 * 
		 */
		public function get listBg():DisplayObject
		{
			return GetObject("List_skin") as DisplayObject;
		}
		
		/**
		 *获取下拉菜单样式 
		 * @return 
		 * 
		 */		
		public function get comboxSkin():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState = new _coboxheadbtn() as DisplayObject;
			bs.overState = new _coboxheadbtnOver() as DisplayObject;			
			return bs;		  
		}
		
		/**
		 * 边框样式1
		 * 
		 */		
		public function get borderSkin1():DisplayObject{
			return GetObject("border1") as DisplayObject;
		}		
		/**
		 * 边框样式2
		 * 
		 */		
		public function get borderSkin2():DisplayObject{
			return GetObject("border2") as DisplayObject;
		}	
		
		/**
		 * 边框样式3
		 * 
		 */		
		public function get borderSkin3():DisplayObject{
			return GetObject("border3") as DisplayObject;
		}	
		
		/**
		 * 边框样式4
		 * 
		 */		
		public function get borderSkin4():DisplayObject{
			return GetObject("border4") as DisplayObject;
		}	
		
		/**
		 *弹出框样式1
		 */		
		public function get frameSkin1():DisplayObject{
			return GetObject("popFrame") as DisplayObject;
		}
		/**
		 * 水平滑动条资源皮肤 
		 * @return 
		 * 
		 */		
		public function get hsliderSkin1():DisplayObjectContainer
		{
			return  GetObject("HSliderMc") as DisplayObjectContainer;
		}
		/**
		 * 竖立滑动条资源皮肤 
		 * @return 
		 * 
		 */
		public function get vsliderSkin1():DisplayObjectContainer
		{
			return  GetObject("VSliderMc") as DisplayObjectContainer;
		}
		
		/**
		 * tab切换按钮默认皮肤 
		 * @return 
		 * 
		 */		
		public function get tabBtn1():RUISkin
		{
			var bs:RUISkin = new RUISkin();
			bs.upState =  GetObject("tabBtnUp") as DisplayObject;
			bs.overState =  GetObject("tabBtnOver") as DisplayObject;
			bs.downState =  GetObject("tabBtnDown") as DisplayObject;
			return bs;		  
		}
		
		
		
		/**
		 *数据表格表头的样式 
		 */		
		public function get columnSkin():RUISkin{
			var cs:RUISkin = new RUISkin();
			cs.upState = GetObject("RDataGridColumnUp") as DisplayObjectContainer;
			cs.overState = GetObject("RDataGridColumnOver") as DisplayObjectContainer;
			cs.downState = GetObject("RDataGridColumnDown") as DisplayObjectContainer;
			
			return cs;
		}
	
	}
	
}
