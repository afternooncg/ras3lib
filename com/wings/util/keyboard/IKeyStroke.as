/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package com.wings.util.keyboard
{
/**
 * ����
 * @author magic
 */	
public interface IKeyStroke{
	/**
	 * ��ֵ�б�
	 * @return	Array<uint>;
	 */
	function getCodes():Array;
	/**
	 * ��ֵ�ַ�
	 */
	function getChars():String;
}

}