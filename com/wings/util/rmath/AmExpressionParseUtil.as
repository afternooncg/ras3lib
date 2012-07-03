package com.wings.util.rmath
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 4则运算解析器,原理采用半树节点模式 将()* / + - 按优先级排序处理
	 * @author hh
	 * 
	 */	
	public class AmExpressionParseUtil
	{
		public function AmExpressionParseUtil()
		{
//			导入类空间
			com.wings.util.rmath.AddCount;
			com.wings.util.rmath.SubCount;
			com.wings.util.rmath.MulCount;
			com.wings.util.rmath.DivCount;
		}
		
		/**
		 * 解析公式 
		 * @param expStr
		 * @return 
		 * 
		 */		
		public static function parse(expStr:String):Number
		{			
			if(expStr=="")
				return NaN;
			else
			{//替换空格
				var pattern:RegExp = /\s/g;
			     expStr = expStr.replace(pattern,"");
		    }
			
			var _dictArithm:Dictionary = new Dictionary();//存放字典类定义
			_dictArithm["+"] = getDefinitionByName("com.wings.util.rmath.AddCount");
			_dictArithm["-"] = getDefinitionByName("com.wings.util.rmath.SubCount");
			_dictArithm["*"] = getDefinitionByName("com.wings.util.rmath.MulCount");
			_dictArithm["/"] = getDefinitionByName("com.wings.util.rmath.DivCount");			
			
			var _currentTree:AmExpressionNode = new AmExpressionNode();
			var currNum:NumObject;
			var tree:AmExpressionNode; 
			for(var i:int=0;i<expStr.length;i++)
			{  
				var chr:String = expStr.charAt(i);       	 
				//trace(chr);          
				if("+-*/".indexOf(chr)>-1)					
				{
					if(currNum!=null)
					{//将当前值节点添加到tree,并设空    
						_currentTree.add(currNum);
						currNum = null;
					}					
					//将此操作符对象添加到当前tree   
					_currentTree.add(new (_dictArithm[chr] as Class)() as BaseArithmetic);        
				}     
				else if(chr=="(")
				{//构造新的tree,并设置为当前tree       
					tree = new AmExpressionNode();           
					_currentTree.add(tree);
					_currentTree = tree;        
				}	 
				else if(chr==")")
				{ //关闭当前tree ,将当前值节点添加到tree,并设空  
					if(currNum!=null)
					{
						_currentTree.add(currNum);  
						currNum = null; 
					}     
					//当前tree结束,跳向父tree      
					_currentTree = _currentTree.parent;        
				}
				else
				{//处理数值
					if(currNum==null)					
						currNum = new NumObject(chr);
					else					
						currNum.appendChar(chr);
				}    
			}
			
			//如果还有数值未处理,加入到当前树
			if(currNum!=null)
				_currentTree.add(currNum);       
			       
			//trace("要解析的式子为 : " +  expStr);    
			//trace("debug:" + _currentTree.printTree());
			var value:Number;
			try
			{
				value = _currentTree.eval().count();
			}
			catch(error:Error) 
			{
				value = NaN;
				trace(error.message);
			}			
			//trace("结果为:",value);
			return value;
		}
	
	
	}
}