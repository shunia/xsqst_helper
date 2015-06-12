package me.shunia.xsqst_helper.view
{
	import flash.display.Sprite;
	
	import me.shunia.xsqst_helper.game.context.Ctx;

	public class S extends Sprite
	{
		
		protected var _left:Left = null;
		protected var _right:Right = null;
		
		public function S()
		{
			_left = new Left();
			addChild(_left);
			
			_right = new Right(_("stage").stageWidth - _left.width, _("stage").stageHeight);
			_right.x = _left.width;
			addChild(_right);
			
			_e().on("showCtx", onSwitchUI);
			_e().on("playerLogin", onShowLogin);
		}
		
		private function onShowLogin(...args):void {
			// 显示登陆框
			LoginPopup.init.apply(null, args).show();
		}
		
		private function onSwitchUI(k:String):void {
			var ctx:Ctx = Ctx.getCtx(k);
			if (ctx) {
				_right.ui = ctx.ui;
			}
		}
		
	}
}