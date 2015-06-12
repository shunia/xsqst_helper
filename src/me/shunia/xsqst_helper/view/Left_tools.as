package me.shunia.xsqst_helper.view
{
	import flash.display.Sprite;
	
	import me.shunia.xsqst_helper.Assets;
	import me.shunia.xsqst_helper.comps.Button;
	import me.shunia.xsqst_helper.comps.Panel;
	
	public class Left_tools extends Sprite
	{
		
		protected var _p:Panel = null;
		
		public function Left_tools()
		{
			super();
			_p = new Panel();
			_p.layout.direction = "vertical";
			addChild(_p);
			
			var btn:Button = new Button()
				.setProp(Button.P_H_GAP, 0)
				.setProp(Button.P_V_GAP, 0)
				.setProp(Button.P_FRAME_UP, new Assets.ADD_ICON())
				.update();
			btn.on(onLogin);
			_p.add(btn);
			btn = new Button()
				.setProp(Button.P_H_GAP, 0)
				.setProp(Button.P_V_GAP, 0)
				.setProp(Button.P_FRAME_UP, new Assets.TOOL_ICON())
				.update();
			_p.add(btn);
			btn.on(onConfig);
		}
		
		protected function onConfig():void {
			
		}
		
		protected function onLogin():void {
			_e().emit("playerLogin");
		}
	}
}