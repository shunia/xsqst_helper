package me.shunia.xsqst_helper.game.module
{
	public class Activities extends BaseModule
	{
		
		private static const MOON_CARD_SMALL:String = "7";
		private static const MOON_CARD_MIDIUM:String = "8";
		private static const MOON_CARD_MINE:String = "9";
		
		private var _sync_moon_card:Boolean = false;
		
		public function Activities()
		{
			_reportName = "[活动]";
		}
		
		override protected function onSync(cb:Function=null):void {
			startMoodCard();
		}
		
		protected function startMoodCard():void {
			if (!_sync_moon_card) {
				_sync_moon_card = true;
				_ctx.service.on("sync_moon_card", function (data:Object):void {
					var a:Array = [];
					var f:Function = function ():void {
						report(REPORT_GET_MOON_CARDS, a.length);
					};
					var l:int = data.isget.length;
					var g:Boolean = false;
					var left:int = 0;
					for (var i:int = 0; i < l; i ++) {
						g = data.isget[i];
						left = data.days[i];
						if (!g && left) {
							var index:String = i == 0 ? MOON_CARD_SMALL : i == 1 ? MOON_CARD_MIDIUM : MOON_CARD_MINE;
							a.push(index);
						}
					}
					if (a.length > 0) {
						var b:Array = [];
						b.push(f);
						for (var k:int = 0; k < a.length; k ++) {
							b.push(["receive_moon_card", null, a[k]]);
						}
						
						_ctx.service.batch.apply(null, b);
					}
				});
			}
		}
		
		protected function startActivies():void {
			
		}
		
		protected static const REPORT_GET_MOON_CARDS:int = 1;
		
		override protected function onReport(type:int, ...args):String {
			var c:String = null;
			switch (type) {
				case REPORT_GET_MOON_CARDS : 
					c = "月卡已领取 -> " + args[0];
					break;
			}
			return c;
		}
		
	}
}