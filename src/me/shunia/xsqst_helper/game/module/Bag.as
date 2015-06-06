/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {

	public class Bag extends BaseModule {
	
		private static const INIT_BLOCK_NUM:int = 8;
		
		public var itemNum:int = 0;
		public var blockNum:int = 0;
		public var raw:Object = null;
		
		protected var _baseNum:int = -1;
		
	    public function Bag() {
			_reportName = "[包裹]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.on("sync_bag", function (data:Object):void {
				raw = data;
				blockNum = INIT_BLOCK_NUM + data.packagelv * 2;
				itemNum = data.list.length;
				if (cb == null) _baseNum = itemNum;
				
	            start();
				
	            _c(cb);
	        });
	    }
	
	    override protected function onStart():void {
			oneKeySell();
	    }
		
		protected function oneKeySell():void {
			if (_baseNum < 0 || itemNum > _baseNum) {
				_ctx.service.batch(
					function ():void {
						report(REPORT_TYPE_ONE_KEY_SELL);
						onSync();
					}, 
					[
						"sell_bag_gold", 
						null
					], 
					[
						"sell_bag_exp",
						null
					]
				);
			}
		}
	
	    public var jy:Array = null;
	    public var jb:Array = null;
	
	    public var hz_mx:int = 0;
	    public var hz_wk:int = 0;
	    public var hz_wz:int = 0;
	    public var ys_bx:int = 0;
	    public var ys_my:int = 0;
	    public var ys_ly:int = 0;
		
	    protected static const REPORT_TYPE_SYNC:int = 0;
	    protected static const REPORT_TYPE_ONE_KEY_SELL:int = 1;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
	        switch (type) {
	            case REPORT_TYPE_SYNC :
	                break;
	            case REPORT_TYPE_ONE_KEY_SELL :
	                    c = "一键清包结束";
	                break;
	        }
	        return c;
	    }
	}
}
