package me.shunia.xsqst_helper.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import me.shunia.xsqst_helper.comps.Panel;
	
	public class Right extends Sprite
	{
		
		protected var _p:Panel = null;
		protected var _ui:DisplayObject = null;
		
		public function Right(w:int = 0, h:int = 0)
		{
			super();
			_p = new Panel();
			_p.width = w;
			_p.height = h;
			addChild(_p);
		}
		
		public function set ui(value:DisplayObject):void {
			_p.removeAll();
			_p.add(value);
		}
		
	}
}