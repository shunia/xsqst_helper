package me.shunia.xsqst_helper.game.context
{
	public interface ICtxCls
	{
		
		function set ctx(value:Ctx):void;
		function get ctx():Ctx;
		
		function onCtxInited():void;
		
	}
}