/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	
	public class Gift extends BaseModule{
	
	    public static const DIG:int = 3;
	
	    public var friends:Array = null;
	    public var giftTime:int = 0;
	    public var giftTimeMax:int = 0;
	
	    protected var canGift:Array = null;
	
	    public var itl_enabled:Boolean = false;
	
	    public function Gift() {
			_reportName = "[礼物]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.batch(
	                function ():void {
	                    start();
	
	                    _c(cb);
	                },
	                [
	                    "sync_2",
	                    function (d3:Object):void {
	                        giftTime = d3.lpj;
	                        giftTimeMax = d3.max;
	                    }
	                ],
	                [
	                    "sync_gift_1",
	                    function (d1:Object):void {
	                        friends = d1.list;
	                        if (canGift == null) {
	                            for each (var f:Object in friends) {
	                                if (f.cangift) {
	                                    if (canGift == null) canGift = [];
	                                    canGift.push(f);
	                                }
	                            }
	                        }
	
	//                        report(REPORT_TYPE_SYNC_1);
	                    }
	                ],
	                [
	                    "sync_gift_2",
	                    function (d2:Object):void {
	                        var n:int = 0;
	                        for each (var d:Object in d2) {
	                            if (d.isnew) n ++;
	                        }
	                        if (n) report(REPORT_TYPE_SYNC_2, n);
	                    }
	                ]
	        );
	    }
	
	    override public function start():void {
	        if (!itl_enabled) return;
	
	        if (canGift && canGift.length) {
	            while (canGift.length) {
	                sendGift(canGift.shift());
	            }
	        }
	    }
	
	    protected function sendGift(f:Object):void {
	        if (f.cangift) {
	            _ctx.service.on("send_gift", function (data:Object):void {
	                f.cangift = false;
	                report(REPORT_TYPE_GIFT_SENT, f.username);
	            }, f.id, DIG);
	        }
	    }
	
	    protected static const REPORT_TYPE_SYNC_1:int = 0;
	    protected static const REPORT_TYPE_SYNC_2:int = 1;
	    protected static const REPORT_TYPE_GIFT_SENT:int = 2;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
	        switch (type) {
	            case REPORT_TYPE_SYNC_1 :
	                    c = "好友数量 -> " + friends.length;
	                    var a:Array = [];
	                    for each (var f:Object in friends) {
	                        a.push(f.username);
	                    }
	                    c += "    -> " + a.join(",");
	                break;
	            case REPORT_TYPE_SYNC_2 :
	                    c = "待收礼物 -> " + args[0];
	                break;
	            case REPORT_TYPE_GIFT_SENT :
	                    c = "已送礼 -> " + args[0];
	                break;
	        }
	        return c;
	    }
	}
}
