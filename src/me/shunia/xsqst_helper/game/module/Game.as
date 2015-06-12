/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {

	public class Game extends BaseModule {
	
		public var name:String = "";
	    public var jb:int = 0;                  // 金币
	    public var xz:int = 0;                  // 血钻
		
		public var row1:Object = null;
		public var row2:Object = null;
	
	    public function Game() {
	    }
	
	    override protected function onSync(cb:Function = null):void {
			syncSys();
			
	        _ctx.service.batch(
					function ():void {
						onUserSynced();
						if (cb != null) cb();
					}, 
	                [
	                    "sync_user_1",
	                    function (d1:Object):void {
							row1 = d1;
	                        name = d1.username;
	                        jb = d1.jb;
	                        xz = d1.xz;
	                    }
	                ],
	                [
	                    "sync_user_2",
	                    function (d2:Object):void {
							row2 = d2;
	                    }
	                ],
	                ["sync_sys_1", null],
	                ["sync_sys_2", null],
	                ["sync_sys_3", null],
	                ["sync_sys_4", null],
	                ["sync_sys_5", null],
	                ["sync_sys_6", null]
	        );
	    }
	
	    protected function syncSys():void {
	        _ctx.service.batch(
	                null,
	                ["sync_1", null],
	//                ["sync_2", null],
	                ["sync_3", null],
	                ["sync_4", null],
	                ["sync_5", null],
	                ["sync_6", null]
	        );
	    }
		
		protected function onUserSynced():void {
			_e(_ctx).emit("userSynced", this);
		}
	
	    protected static const REPORT_TYPE_SYNC:int = 0;
	
	    private function report(type:int, ...args):void {
	        var s:String = "[角色]", c:String = "";
	        switch (type) {
	            case REPORT_TYPE_SYNC :
	                    c += name;
	                    c += "    金币 -> " + jb;
	                    c += "    血钻 -> " + xz;
	                break;
	        }
	        _ctx.ui.log(s, c);
	    }
	
	    /**
	     * @param o
	     * o.id -
	     *  1  : 迷宫宝箱
		 *  5  : 英雄
	     *  23 : 金币
		 *  24 : 食品
		 *  25 : 战力
	     *  27 : 勇气点数
	     *  28 : 冠军点数
		 * o.count - 相应奖励的数量
	     */
	    public function reward(o:*):void {
			
	    }
		
	}
}
