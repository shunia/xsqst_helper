package me.shunia.xsqst_helper.view
{
	import flash.display.Sprite;
	
	import me.shunia.xsqst_helper.comps.Button;
	import me.shunia.xsqst_helper.comps.Panel;
	import me.shunia.xsqst_helper.game.context.Ctx;
	
	public class Left_playerList extends Sprite
	{
		
		protected var _list:Panel = null;
		
		public function Left_playerList()
		{
			super();
			
			_list = new Panel();
			_list.layout.direction = "vertical";
			addChild(_list);
			
			_e().on("initCtx", function add(ctx:Ctx):void {
				var btn:Button = new Button()
				.setProp(Button.P_LABEL, ctx.id)
				.update();
				btn.on(function ():void {
					_e().emit("showCtx", btn.getProp(Button.P_LABEL));
				});
				_list.add(btn);
			});
			
//			addChild(new Button()
//				.setProp(Button.P_LABEL, "测试")
//				.update());
		}
	}
}