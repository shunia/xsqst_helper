package me.shunia.xsqst_helper.view
{
	import flash.display.Sprite;

	public class S extends Sprite
	{
		
		protected var _left:Left = null;
		
		public function S()
		{
			_left = new Left();
			addChild(_left);
			
			_e().on("playerLogin", onShowLogin);
		}
		
		private function onShowLogin(...args):void {
			// 显示登陆框
			var l:LoginPopup = LoginPopup.init.apply(null, args) as LoginPopup;
			if (l) 
				stage.addChild(l);
		}
	}
}