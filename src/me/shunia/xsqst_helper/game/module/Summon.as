/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	
	import me.shunia.xsqst_helper.utils.Time;
	
	public class Summon extends BaseModule{
	
		/**
		 * 刷新时间 
		 */	
	    public var refreshTime:int = 0;
		/**
		 * 当前所有召唤们数据 
		 */	
	    public var doors:Object = {};
	
		public var itl:Intelligence = null;
	
	    public function Summon() {
			_reportName = "[招募]";
			doors[Door.ZHAO_MU_SUO] = new Door(Door.ZHAO_MU_SUO);
			doors[Door.YING_XIONG] = new Door(Door.YING_XIONG);
			doors[Door.LV_DONG] = new Door(Door.LV_DONG);
			doors[Door.HUI_HUANG] = new Door(Door.HUI_HUANG);
			doors[Door.HUN_LUAN] = new Door(Door.HUN_LUAN);
			doors[Door.WAN_XIANG] = new Door(Door.WAN_XIANG);
	    }
		
		override public function onCtxInited():void {
			super.onCtxInited();
			itl = new Intelligence(_ctx.game);
			_e(_ctx).on("userSynced", function ():void {
				doors[Door.YING_XIONG].count = _ctx.game.row1.blhj;
				doors[Door.LV_DONG].count = _ctx.game.row1.zrhj;
				doors[Door.HUI_HUANG].count = _ctx.game.row1.hhhj;
				doors[Door.HUN_LUAN].count = _ctx.game.row1.hlhj;
			});
		}
		
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.on("sync_sunmmon", function (data:Object):void {
	            refreshTime = data.time;
	            var req:int = 0, scale:int = 0, d:Door = null;
	            for each (var o:Object in data.list) {
					d = getDoor(o.doorid);
	                d.num = o.count;
	            }
	
	//            report(REPORT_TYPE_SYNC);
	            start();
	
	            _c(cb);
	        });
	    }
		
		/**
		 * 每日招募 
		 */		
		public function dailySummon():void {
			var d:Door = null;
			for (var id:String in doors) {
				d = doors[id];
				if (itl.canSummon(d)) 
					d.summon(
						_ctx, 
						function (succ:Boolean, data:Object, id:String):void {
							if (succ) _ctx.game.reward(data.rewards);
							report(REPORT_TYPE_SUMMON, succ, getDoor(id));
						}, 
						itl.getMaxSummon(d)
					);
			}
		}
		
		protected function getDoor(id:String):Door {
			return doors[id];
		}
	
	    override protected function onStart():void {
			if (itl.allow_daily_summon && !itl.daily_summon_started) {
				dailySummon();
				itl.daily_summon_started = true;
			}
	    }
		
	    protected static const REPORT_TYPE_SYNC:int = 0;
	    protected static const REPORT_TYPE_SUMMON:int = 1;
	    protected static const REPORT_TYPE_SUMMON_GOLD_MAX:int = 2;
	    protected static const REPORT_TYPE_TRY:int = 3;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
	        switch (type) {
	            case REPORT_TYPE_SYNC :
	                c = "刷新时间 -> " + Time.secToFull(refreshTime);
	                break;
	            case REPORT_TYPE_SUMMON :
					c = "[" + args[1].name + "]招募[" + (args[0] ? "成功" : "失败") + "]";
	                break;
	            case REPORT_TYPE_SUMMON_GOLD_MAX :
//	                    c += "金币消耗溢出 -> 现有: " + _context.jb + " 需要: " + args[0] + " 限制: " + _itl_summon_gold_max;
	                break;
	            case REPORT_TYPE_TRY :
	                    c = "尝试招募 -> " + doors[args[0]].name + " 消耗 -> " + doors[args[0]].req;
	                break;
	        }
	        return c;
	    }
	
	}
}
import me.shunia.xsqst_helper.game.module.Game;
import me.shunia.xsqst_helper.game.context.Ctx;

class Intelligence {
	
	public var allow_daily_summon:Boolean = true;
	public var daily_summon_started:Boolean = false;
	public var allow_summon_wanxiang:Boolean = false;
	
	private var _summon_gold_max:int = 10;	// 十次
	private var _summon_hui_ji_max:int = 1;
	private var _summon_wan_xiang_max:int = 0;
	
	protected var o:Object = {};
	protected var _context:Game = null;
	
	public function Intelligence(user:Game) {
		_context = user;
		o[Door.ZHAO_MU_SUO] = {max:_summon_gold_max};
		o[Door.YING_XIONG] = {max:_summon_hui_ji_max};
		o[Door.LV_DONG] = {max:_summon_hui_ji_max};
		o[Door.HUI_HUANG] = {max:_summon_hui_ji_max};
		o[Door.HUN_LUAN] = {max:_summon_hui_ji_max};
		o[Door.WAN_XIANG] = {max:_summon_wan_xiang_max};
	}
	
	public function set summon_gold_max(value:int):void {
		_summon_gold_max = value;
		o[Door.ZHAO_MU_SUO].max = value;
	}
	public function get summon_gold_max():int {
		return _summon_gold_max;
	}
	
	public function set summon_hui_ji_max(value:int):void {
		_summon_hui_ji_max = value;
		o[Door.YING_XIONG].max = value;
		o[Door.LV_DONG].max = value;
		o[Door.HUI_HUANG].max = value;
		o[Door.HUN_LUAN].max = value;
	}
	public function get summon_hui_ji_max():int {
		return _summon_hui_ji_max;
	}
	
	public function set summon_wan_xiang_max(value:int):void {
		_summon_wan_xiang_max = value;
		o[Door.HUN_LUAN].max = value;
	}
	public function get summon_wan_xiang_max():int {
		return _summon_wan_xiang_max;
	}
	
	public function canSummon(door:Door):Boolean {
		if (door.id == Door.ZHAO_MU_SUO) {
			if (_context.jb < door.req || door.req >= (door.baseReq * Math.pow(2, _summon_gold_max))) {
				return false;
			}
		} else if (door.id == Door.WAN_XIANG) {
			if (!allow_summon_wanxiang || door.req > _context.xz) return false;
		} else {
			// 需求的徽记少于设定的徽记数 && 有足够的徽记
			if (door.req < _summon_hui_ji_max || door.count < door.req) return false;
		}
		return true;
	}
	
	public function getMaxSummon(door:Door):int {
		return o[door.id].max;
	}
	
}

class Door {
	
	protected static const C:Object = {
		100001: {name:"金币招募", req:3000, num:1},
		100002: {name:"英雄之门", req:1, num:0},
		100003: {name:"律动之门", req:1, num:0},
		100004: {name:"辉煌之门", req:1, num:0},
		100005: {name:"混乱之门", req:1, num:0},
		100006: {name:"万象之门", req:60, num:0}}
	
	public static const ZHAO_MU_SUO:String = "100001";
	public static const YING_XIONG:String = "100002";
	public static const LV_DONG:String = "100003";
	public static const HUI_HUANG:String = "100004";
	public static const HUN_LUAN:String = "100005";
	public static const WAN_XIANG:String = "100006";
	
	public var id:String = "";
	public var name:String = "";
	public var req:int = 1;
	public var baseReq:int = 1;
	public var count:int = 0;
	protected var _num:int = 0;
	
	public function Door(id:String) {
		this.id = id;
		baseReq = C[id].req;
		name = C[id].name;
	}
	
	public function set num(value:int):void {
		_num = value;
		req = baseReq * (id == WAN_XIANG ? 1 : Math.pow(2, _num - 1));
	}
	public function get num():int {
		return _num;
	}
	public function getNextReq():int {
		return id == WAN_XIANG ? req : req * 2;
	}
	public function summon(ctx:Ctx, cb:Function, t:int = 1):void {
		ctx.service.on("summon_hero", function (data:Object):void {
			t --;
			var succ:Boolean = true;
			if (data.hasOwnProperty("ret") && data.ret == 1) succ = false;
			if (succ && id != WAN_XIANG) num = num + 1;
			cb(succ, data, id);
			if (succ && t > 0) summon(ctx, cb, t);
		}, id);
	}
}
