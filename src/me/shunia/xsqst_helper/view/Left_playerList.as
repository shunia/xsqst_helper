package me.shunia.xsqst_helper.view
{
	import flash.display.Sprite;
	
	import me.shunia.xsqst_helper.comps.Button;
	
	public class Left_playerList extends Sprite
	{
		public function Left_playerList()
		{
			super();
			
			addChild(new Button()
				.setProp(Button.P_LABEL, "测试")
				.update());
		}
	}
}