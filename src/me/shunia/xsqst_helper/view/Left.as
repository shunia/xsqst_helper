package me.shunia.xsqst_helper.view
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Left extends Sprite
	{
		
		protected var _list:Left_playerList = null;
		protected var _tool:Left_tools = null;
		
		public function Left()
		{
			_list = new Left_playerList();
			addChild(_list);
			
			_tool = new Left_tools();
			addChild(_tool);
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void {
			_tool.y = stage.stageHeight - _tool.height - 5;
		}
	}
}