package com.wings.util
{
	import flash.utils.ByteArray;
		
	/**
	 * 扩展网上kinglong写的stringutil工具类
	 * @author hh
	 * 
	 */			
	public class StringUtil
	{
		
		/**
		 * 忽略大小字母比较字符是否相等;
		 * @param	char1
		 * @param	char2
		 * @return
		 */
		public static function equalsIgnoreCase(char1:String,char2:String):Boolean{
			return char1.toLowerCase() == char2.toLowerCase();
		}
		/**
		 * 比较字符是否相等;
		 * @param	char1
		 * @param	char2
		 * @return
		 */
		public static function equals(char1:String,char2:String):Boolean{
			return char1 == char2;
		}
		
		/**
		 * 是否为Email地址;
		 */
		public static function isEmail(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = String(trim(char));
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否是数值字符串;
		 * @param	char
		 * @return
		 */
		public static function isNumber(char:String):Boolean{
			if(char == null){
				return false;
			}
			return !isNaN(Number(char))
		}
		/**
		 * 检测是否是数字
		 * 
		 * @param text
		 * @param digits	指定小数位
		 * @return 
		 * @author flashyiyi
		 */
		public static function isNumber2(text:String,digits:int = -1):Boolean
		{
			if (digits > 0)
				return new RegExp("^-?(\\d|,)*\\.\\d{"+digits.toString()+"}$").test(text);
			else
				return (/^-?(\d|,)*[\.]?\d*$/).test(text);
		}
		//是否为Double型数据;
		public static function isDouble(char:String):Boolean{
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		
		/**
		 * Integer;
		 * @param	char
		 * @return
		 */
		public static function isInteger(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * English;
		 * @param	char
		 * @return
		 */
		public static function isEnglish(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 中文;
		 * @param	char
		 * @return
		 */
		public static function isChinese(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 双字节
		 * @param	char
		 * @return
		 */
		public static function isDoubleChar(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 含有中文字符
		 * @param	char
		 * @return
		 */
		public static function hasChineseChar(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char);
			var pattern:RegExp = /[^\x00-\xff]/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 注册字符;
		 * @param	char
		 * @param	len
		 * @return
		 */
		public static function hasAccountChar(char:String,len:uint=15):Boolean{
			if(char == null){
				return false;
			}
			if(len < 10){
				len = 15;
			}
			char = trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", ""); 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * URL地址;
		 * @param	char
		 * @return
		 */
		public static function isURL(char:String):Boolean{
			if(char == null){
				return false;
			}
			char = trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/; 
			var result:Object = pattern.exec(char);
			if(result == null) {
				return false;
			}
			return true;
		}
		/**
		 * 是否为空白;
		 * @param	char
		 * @return
		 */
		public static function isWhitespace(char:String):Boolean{
			switch (char) {
				case "":
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;    
				default:
					return false;
			}
		}
		/**
		 * 去左右空格;
		 * @param	char
		 * @return
		 */
		public static function trim(char:String):String{
			if(char == null){
				return null;
			}
			return rtrim(ltrim(char));
		}
		
		/**
		 * 去左空格; 
		 */
		public static function ltrim(char:String):String{
			if(char == null){
				return null;
			}
			var pattern:RegExp = /^\s*/; 
			return char.replace(pattern,"");
		}
		
		/**
		 * 去右空格;
		 */
		public static function rtrim(char:String):String{
			if(char == null){
				return null;
			}
			var pattern:RegExp = /\s*$/; 
			return char.replace(pattern,"");
		}
		
		/**
		 * 是否为前缀字符串;
		 **/
		public static function beginsWith(char:String, prefix:String):Boolean{            
			return (prefix == char.substring(0, prefix.length));
		}
		
		/**
		 * 是否为后缀字符串;
		 * @param	char
		 * @param	suffix
		 * @return
		 */
		public static function endsWith(char:String, suffix:String):Boolean{
			return (suffix == char.substring(char.length - suffix.length));
		}
		
		/**
		 * 去除指定字符串;
		 * @param	char
		 * @param	remove
		 * @return
		 */
		public static function remove(char:String,remove:String):String{
			return replace(char,remove,"");
		}
		
		/**
		 * 字符串替换;
		 * @param	char
		 * @param	replace
		 * @param	replaceWith
		 * @return
		 */
		public static function replace(char:String, replace:String, replaceWith:String):String{            
			return char.split(replace).join(replaceWith);
		}
		
		/**
		 * utf16转utf8编码;
		 * @param	char
		 * @return
		 */
		public static function utf16to8(char:String):String{
			var out:Array = new Array();
			var len:uint = char.length;
			for(var i:uint=0;i<len;i++){
				var c:int = char.charCodeAt(i);
				if(c >= 0x0001 && c <= 0x007F){
					out[i] = char.charAt(i);
				} else if (c > 0x07FF) {
					out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
						0x80 | ((c >>  6) & 0x3F),
						0x80 | ((c >>  0) & 0x3F));
				} else {
					out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
						0x80 | ((c >>  0) & 0x3F));
				}
			}
			return out.join('');
		}
		
		/**
		 * utf8转utf16编码;
		 * @param	char
		 * @return
		 */
		public static function utf8to16(char:String):String{
			var out:Array = new Array();
			var len:uint = char.length;
			var i:uint = 0;
			var char2:int
			var char3:int
			while(i<len){
				var c:int = char.charCodeAt(i++);
				switch(c >> 4){
					case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
						// 0xxxxxxx
						out[out.length] = char.charAt(i-1);
						break;
					case 12: case 13:
						// 110x xxxx   10xx xxxx
						char2 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
						break;
					case 14:
						// 1110 xxxx  10xx xxxx  10xx xxxx
						char2 = char.charCodeAt(i++);
						char3 = char.charCodeAt(i++);
						out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
							((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
						break;
				}
			}
			return out.join('');
		}
		/**
		 * 截取字符串
		 * choice:Boolean = false窃取字符前
		 */
		public static function InterceptString(str:String, choice:Boolean = false,val:String=","):String {
			var num:uint = str.indexOf(val)
			if (choice) str = str.slice(num+1)
			else str = str.slice(0,num)
			return str
		}
		/**
		 * 转换字符编码
		 **/ 
		public static function encodeCharset(char:String,charset:String):String{  
			var bytes:ByteArray = new ByteArray();  
			bytes.writeUTFBytes(char);  
			bytes.position = 0;  
			return bytes.readMultiByte(bytes.length,charset);  
		}  
		
		/**
		 * 添加新字符到指定位置
		 **/        
		public static function addAt(char:String, value:String, position:int):String {  
			if (position > char.length) {  
				position = char.length;  
			}  
			var firstPart:String = char.substring(0, position);  
			var secondPart:String = char.substring(position, char.length);  
			return (firstPart + value + secondPart);  
		}  
		
		/**
		 * 替换指定位置字符
		 */  
		public static function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String {  
			beginIndex = Math.max(beginIndex, 0);             
			endIndex = Math.min(endIndex, char.length);  
			var firstPart:String = char.substr(0, beginIndex);  
			var secondPart:String = char.substr(endIndex, char.length);  
			return (firstPart + value + secondPart);  
		}  
		
		/**
		 * 删除指定位置字符
		 **/ 
		public static function removeAt(char:String, beginIndex:int, endIndex:int):String {  
			return StringUtil.replaceAt(char, "", beginIndex, endIndex);  
		}  
		
		/**
		 * 修复双换行符
		 **/ 
		public static function fixNewlines(char:String):String {  
			return char.replace(/\r\n/gm, "\n");  
		}  
		/**
		 * 是否包含指定字符
		 * @param	str
		 * @param	val
		 * @return
		 */
		public static function contains(str:String,val:String):Boolean{
			var bool:Boolean=new Boolean()
			var num:Number = str.lastIndexOf(val)
			if(num==-1)bool=false
			else bool=true
			return bool
		}
	
		/**
		 * 匹配半角字符
		 * 
		 * @param str
		 * @return 
		 * @author flashyiyi
		 */        
		public static function matchAscii(str:String):Array
		{
			return str.match(/[\x00-\xFF]*/g);
		}
		
		/**
		 * 获取双字节文本真正的长度 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function getDobuleByteStrLen(str:String):uint
		{
			if(!str) return 0;
			var ba:ByteArray =new ByteArray;
			ba.writeMultiByte (str,"");
			return ba.length;
		}
		
		/**
		 * 获取指定子节长度字符串 
		 * @param str
		 * @param len
		 * @return 
		 * 
		 */		
		public static	function getLimitLenStr(str:String="",bytelen:int=0):String
		{
			if(str=="" || bytelen==0)
				return str;
			
			var len1:int=getDobuleByteStrLen(str);
			if(len1<=bytelen)
				return str;
			
			var str1:String="";
			var i:int=0;
			while(getDobuleByteStrLen(str1)<bytelen)
			{				
				if(getDobuleByteStrLen(str1+str.substr(i,1))<=bytelen)
				{
					str1+= str.substr(i,1);
					i++;
				}
				else
					break;
			}
			
			return str1;
		}
		
		/**
		 * 转数字为短值 如果1000000= 1000K = 1M 这种情况下，去除小数点后
		 * @param value
		 * @return 
		 * 
		 */		
		public static function foramtNumberToShortView(value:Number):String
		{
			var str:String = String(Math.round(value));
			if(str.length < 8)
			{
				return str;
			}
			else if(str.length < 12)
			{
				str = String(int(value/1000))+'K';
			}
			else 
			{
				str = String(int(value/1000000))+'M';
			}
			return str;
		}
		
		/**
		 *  转长数值为国际标准格式 如 1,355,000
		 * @param value
		 * 
		 */		
		static public function formatNumberToEnView(value:Number):String
		{
			var str:String = value.toString();
			if(str.length<=3)
				return str;
			else
			{
				var ary:Array = str.split(".");
				var str1:String ="";
				var len:int=0;
				for (var i:int = ary[0].length-1; i >= 0; i--) 
				{
					str1 = ary[0].charAt(i) + str1;
					len++;
					if(len>2)
					{
						len = 0;
						str1 = "," + str1;
					}
				}
				return  str1.charAt(0)!="," ? str1 : str1.substr(1);
			}
		}
		
		/**
		 * 将时间值转换成字符串形式 
		 * @param value 时间值(单位:秒)
		 * @param type 1 00:00  2 00:00:00
		 * @return 
		 * 
		 */		
		public static function convertNumberToTimeString(time : int,type : int = 1) : String
		{
			if(time < 0)
			{
				if(type == 1)
					return "00:00";
				else if(type == 2)
					return "00:00:00";
			}
			var min : int;
			var sec : int;
			var minStr : String;
			var secStr : String;
			if(type == 2)
			{
				var hour : int = time / 3600;
				min = (time - hour * 3600) / 60;
				sec = time - hour * 3600 - min * 60;
				var hourStr : String = (hour < 10) ? ("0" + hour) : hour.toString();
				minStr = (min < 10) ? ("0" + min) : min.toString();
				secStr = (sec < 10) ? ("0" + sec) : sec.toString();
				return hourStr + ":" + minStr + ":" + secStr;
			}
			else
			{
				min = time / 60;
				sec = time - min * 60;
				minStr = (min < 10) ? ("0" + min) : min.toString();
				secStr = (sec < 10) ? ("0" + sec) : sec.toString();
				return minStr + ":" + secStr;
			}
		}
	}
}