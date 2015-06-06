package me.shunia.xsqst_helper
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Assets
	{
		
		[Embed(source="/assets/add_64.png")]
		public static const ADD_ICON:Class;
		
		[Embed(source="/assets/tool_64.png")]
		public static const TOOL_ICON:Class;
		
		public static function g(cls:Class = null):Sprite {
			var s:Sprite = new Sprite();
			if (cls) {
				var o:DisplayObject = new cls();
				s.addChild(o);
			}
			return s;
		}
	}
}