package com.wings.ui.components
{

	import com.wings.ui.common.RUIAssets;
	import com.wings.ui.common.RUISkin;
	import com.wings.ui.components.events.RCollectionChangeEvent;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * radiobutton
	 * @author hh
	 * 
	 */	
	public class RRadioButton extends RCheckBox
	{
		/**
		 *  
		 * @param label
		 * @param params
		 * @param defaultHandler
		 * 
		 */	
		
		public function RRadioButton(label:String = "",index:int=0,value:Object=null,parent:DisplayObjectContainer=null, params:Object=null,icon:RUISkin=null,defaultHandler:Function = null)
		{
						
			if(icon==null) icon = RUIAssets.getInstance().radioButtonSkin1;
			super(label,index,value,parent,params,icon,defaultHandler);
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @private
		 * Initializes the instance.
		 */
		override protected function inits():void
		{
			super.inits();
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Additional getters and setters
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		// Overridden API: _SuperClassName_
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  API
		//
		//--------------------------------------------------------------------------
		
	
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: _SuperClassName_
		//
		//--------------------------------------------------------------------------
	

		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Broadcasting
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Eventhandling
		//
		//--------------------------------------------------------------------------
		
		
//		override protected function handleOnClick(event:MouseEvent):void
//		{
//			super.handleOnClick(event);
//			//this.dispatchEvent(new RCollectionChangeEvent(RCollectionChangeEvent.ONCHANGE,_index,_value));
//		}
	}
}