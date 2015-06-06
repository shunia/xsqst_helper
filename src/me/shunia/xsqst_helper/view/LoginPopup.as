package me.shunia.xsqst_helper.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LoginPopup extends Sprite
	{
		
		protected var _u:String = null;
		protected var _p:String = null;
		
		// 半透明灰色遮罩
		protected var _m:Shape = null;
		
		public function LoginPopup(args:Array)
		{
			super();
			args.length ? (_u = args[0]) : (_p = "");
			args.length > 1 ? (_p = args[1]) : (_p = "");
			
			create();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function create():void {
			
		}
		
		protected function onAdded(event:Event):void {
			if (!_m) _m = new Shape();
			if (_m.width != stage.stageWidth || _m.height != stage.stageHeight) {
				_m.graphics.clear();
				_m.graphics.beginFill(0xffffff, 0.7);
				_m.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_m.graphics.endFill();
			}
			
		}
		
		protected static var _i:LoginPopup = null;
		public static function init(...args):LoginPopup {
			if (_i == null) _i = new LoginPopup(args);
			return _i;
		}
		
	}
}