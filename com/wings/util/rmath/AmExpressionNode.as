package com.wings.util.rmath
{
	/**
	 * 表达式树节点 
	 * @author hh
	 * 
	 */	
	public class AmExpressionNode extends BaseArithmetic
	{
		/**
		 * 字节点数组 
		 */		
		public var vtNodes:Vector.<IArithmetic>;
		
		/**
		 * 父节点 
		 */		
		public var parent:AmExpressionNode;
		
		
		public function AmExpressionNode()
		{
			vtNodes = new Vector.<IArithmetic>();
		}
		
		/**
		 * 新增子节点 
		 * @param node
		 * 
		 */		
		public function add(node:IArithmetic):void
		{		
			if(node is AmExpressionNode)
				(node as AmExpressionNode).parent = this; 
			this.vtNodes.push(node);    
		}
		
		
		/**
		 * 解析计算 
		 * @param tree
		 * @return 
		 * 
		 */		
		public function eval():IArithmetic
		{   
			var me:AmExpressionNode;
			var node:IArithmetic = this;			
			
			//先计算(),将改节点的值替换成计算的值
			var i:int=0;
			for(i=0;i<this.vtNodes.length;i++)
			{
				node = this.vtNodes[i];
				if(node is AmExpressionNode)
				{	
					var tmpnode1:AmExpressionNode = node as AmExpressionNode; 
					this.vtNodes[i] = tmpnode1.eval();        
				}
			}  
			
			//计算*/
			for(i=0;i<this.vtNodes.length;i++)
			{	
				node = this.vtNodes[i];                
				if( (node is MulCount) || (node is DivCount))
				{
					if((i-1)<0 || (i+1)>(this.vtNodes.length-1))
						throw new Error("表达式异常");
					var tmpnode2:BaseArithmetic = node as BaseArithmetic;					
					tmpnode2.left = this.vtNodes[i-1].count();
					tmpnode2.right = this.vtNodes[i+1].count();
					//将得到的结果包装为NumObject,并把 vtNodes[i+1],vtNodes[i]和vtNodes[i-1] 合并为1个位置           
					this.vtNodes[i+1] = new NumObject(node.count().toString());
					this.vtNodes.splice(i-1,2);            
					i-=2;        
				}   
			}   
			
			//计算+-
			for(i=0;i<this.vtNodes.length;i++)
			{				
				node = this.vtNodes[i];
				if(!(node is NumObject))
				{	
					if((i-1)<0 || (i+1)>(this.vtNodes.length-1))
						throw new Error("表达式异常");
					
					tmpnode2 = node as BaseArithmetic;
					tmpnode2.left = this.vtNodes[i-1].count();
					tmpnode2.right = this.vtNodes[i+1].count(); 
					//将得到的结果包装为NumObject替代tree[i+1],并将node和tree[i-1]指空    
					this.vtNodes[i+1] = new NumObject(node.count().toString());
					this.vtNodes.splice(i-1,2);            
					i-=2;
				}
			}
			
			return this.vtNodes[this.vtNodes.length-1];
		}
		
		/**
		 * 打印 
		 * @param tree
		 * @param spaces
		 * 
		 */		
		public function printTree(spaces:String=""):void
		{
			var node:IArithmetic;   
			spaces = spaces || "";
			
			for(var i:int=0;i<this.vtNodes.length;i++)
			{ 
				node = this.vtNodes[i];
				if(node is AmExpressionNode)
				{
					(node as AmExpressionNode).printTree(spaces+"=====");
				}
				else
				{
					//trace(spaces+node); 
				}
			}
		}

	}
}