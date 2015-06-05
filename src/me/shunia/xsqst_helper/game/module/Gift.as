/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	
	public class Gift extends BaseModule{
		
	    public static const DIG:int = 3;
		public static const MINE:int = 4;
		
	    public var friends:Array = null;
	    public var giftTime:int = 0;
	    public var giftTimeMax:int = 0;
		
	    protected var canGift:Array = null;
		protected var _giftsToRecv:Array = null;
		protected var _giftToRecvNum:int = 0;
		
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
							var b:Boolean = friends == null;
	                        friends = d1.list;
	                        if (canGift == null) {
	                            for each (var f:Object in friends) {
	                                if (f.cangift) {
	                                    if (canGift == null) canGift = [];
	                                    canGift.push(f);
	                                }
	                            }
	                        }
							if (b) 
	                        	report(REPORT_TYPE_SYNC_1);
	                    }
	                ],
	                [
	                    "sync_gift_2",
	                    function (d2:Object):void {
							_giftsToRecv = d2 as Array;
	                    }
	                ]
	        );
	    }
		
	    override protected function onStart():void {
			if (_giftsToRecv && _giftsToRecv.length) {
				for each (var o:Object in _giftsToRecv) {
					if (o.state == 0) {
						if (o.gifttype == 0) {	// 可加好友
							if (!inFriends(o.senderid)) 
								addFriend(o.sendername);
						} else {				// gifttype = 3/4, 3是矿石包,4是矿镐
							receiveGift(o);
							if (o.type == 2) {	// 是好友而不是陌生人,不仅要收还要回
								// ignore
							}
						}
					}
				}
			}
			if (canGift && canGift.length) {
				while (canGift.length) {
					sendGift(canGift.shift());
				}
			}
	    }
		
		protected function inFriends(id:int):Boolean {
			for each (var o:Object in friends) {
				if (o.id == id) return true;
			}
			return false;
		}
		
		protected function receiveGift(o:Object):void {
			_ctx.service.on("receive_gift", function (data:Object):void {
				report(REPORT_TYPE_GIFT_RECEIVED, o.sendername, o.id);
			}, o.id);
		}
		
	    protected function sendGift(f:Object):void {
            _ctx.service.on("send_gift", function (data:Object):void {
                f.cangift = false;
                report(REPORT_TYPE_GIFT_SENT, f.username);
            }, f.id, MINE);
	    }
		
		protected function addFriend(name:String):void {
			_ctx.service.on("add_friend", function (data:Object):void {
				if (data && data.ret == 0) report(REPORT_TYPE_FRIEND_ADDED, name);
			}, name);
		}
		
	    protected static const REPORT_TYPE_SYNC_1:int = 0;
	    protected static const REPORT_TYPE_SYNC_2:int = 1;
	    protected static const REPORT_TYPE_GIFT_SENT:int = 2;
		protected static const REPORT_TYPE_GIFT_RECEIVED:int = 3;
		protected static const REPORT_TYPE_FRIEND_ADDED:int = 4;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
	        switch (type) {
	            case REPORT_TYPE_SYNC_1 :
	                    c = "好友数量[" + friends.length + "]";
	                    var a:Array = [];
	                    for each (var f:Object in friends) {
	                        a.push(f.username);
	                    }
	                    c += "," + a.join(",");
	                break;
	            case REPORT_TYPE_SYNC_2 :
	                    c = "待收礼物数量 [" + args[0] + "]";
	                break;
	            case REPORT_TYPE_GIFT_SENT :
	                    c = "已给[" + args[0] + "]送礼[矿工包]";
	                break;
				case REPORT_TYPE_GIFT_RECEIVED : 
					var gn:String = args[1] == 3 ? "矿镐" : args[1] == 4 ? "矿石包" : args[1];
					c = "已收取[" + args[0] + "]的礼物[" + gn + "]";
					break;
				case REPORT_TYPE_FRIEND_ADDED : 
					c = "已添加[" + args[0] + "]为好友";
					break;
	        }
	        return c;
	    }
	}
}
