package me.shunia.xsqst_helper.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import me.shunia.xsqst_helper.Assets;
	import me.shunia.xsqst_helper.comps.Panel;
	
	public class Left_tools extends Sprite
	{
		
		protected var _p:Panel = null;
		
		public function Left_tools()
		{
			super();
			_p = new Panel();
			_p.layout.hGap = 10;
			_p.layout.direction = "vertical";
			addChild(_p);
			
			var i:DisplayObject = new Assets.ADD_ICON();
			i.addEventListener(MouseEvent.CLICK, onLogin);
			_p.add(i);
			i = new Assets.TOOL_ICON();
			i.addEventListener(MouseEvent.CLICK, onConfig);
			_p.add(i);
		}
		
		protected function onConfig(event:Event):void {
			
		}
		
		protected function onLogin(event:Event):void {
			_e().emit("playerLogin");
		}
	}
}