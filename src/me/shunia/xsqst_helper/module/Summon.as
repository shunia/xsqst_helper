/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.utils.Time;
import me.shunia.xsqst_helper.utils.Timer;

public class Summon extends BaseModule{

    public static const CONF:Object = {
        100001: {name:"金币招募", req:3000, num:1},
        100002: {name:"英雄之门", req:1, num:0},
        100003: {name:"律动之门", req:1, num:0},
        100004: {name:"辉煌之门", req:1, num:0},
        100005: {name:"混乱之门", req:1, num:0},
        100006: {name:"万象之门", req:60, num:0}
    };

    public static const ZHAO_MU_SUO:String = "100001";
    public static const YING_XIONG:String = "100002";
    public static const LV_DONG:String = "100003";
    public static const HUI_HUANG:String = "100004";
    public static const HUN_LUAN:String = "100005";
    public static const WAN_XIANG:String = "100006";

    private static const SUMMON_INTERVAL:int = 5;

    public var refreshTime:int = 0;
    public var doors:Object = null;

    public var itl_enabled:Boolean = false;
    private var _inited:Boolean = false;
    private var _itl_summon_gold_max:int = 3000 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2 * 2;

    public function Summon() {
        doors = CONF;
    }

    override public function sync(cb:Function = null):void {
        Global.service.on("sync_sunmmon", function (data:Object):void {
            refreshTime = data.time;
            var req:int = 0, scale:int = 0;
            for each (var o:Object in data.list) {
                doors[o["doorid"]].num = o.count;
                req = doors[o["doorid"]].req;
                scale = Math.pow(2, o.count - 1);
                doors[o["doorid"]].req = req * scale;
            }
            doors[ZHAO_MU_SUO].num = Global.user.jb;

//            report(REPORT_TYPE_SYNC);
            start();

            _c(cb);
        });
    }

    override public function start():void {
        if (!itl_enabled) return;

        if (!_inited) {
            _inited = true;
            summon(ZHAO_MU_SUO, 20);
            summon(YING_XIONG);
            summon(LV_DONG);
            summon(HUI_HUANG);
            summon(HUN_LUAN);
        }
    }

    public function summon(id:String, time:int = 1):void {
        if (doors.hasOwnProperty(id)) {
            var t:Timer = new Timer(SUMMON_INTERVAL, time, function ():void {
                report(REPORT_TYPE_TRY, id);
                // 金币招募上限
                var allow:Boolean = true;
                if (id == ZHAO_MU_SUO ) {
                    var req:int = doors[id].req;
                    if (_context.jb <= req || req >= _itl_summon_gold_max) {
                        allow = false;
                        report(REPORT_TYPE_SUMMON_GOLD_MAX, req);
                        if (t) t.stop();
                    }
                }
                if (allow) {
                    _summonOnce(id, function (success:Boolean):void {
                        if (!success && t)
                            t.stop();
                    })
                }
            });
        }
    }

    protected function _summonOnce(id:String, cb:Function = null):void {
        var o:Object = doors[id];
        if (o.num <= o.req)
            cb(false);                  // 失败
        else
            Global.service.on("summon_hero", function (data:Object):void {
                if (id != WAN_XIANG) doors[id].req = doors[id].req * 2;
                _context.reward(data.rewards);
                report(REPORT_TYPE_SUMMON, doors[id].name, 1, doors[id].req);
                cb(true);
            }, id);
    }

    protected static const REPORT_TYPE_SYNC:int = 0;
    protected static const REPORT_TYPE_SUMMON:int = 1;
    protected static const REPORT_TYPE_SUMMON_GOLD_MAX:int = 2;
    protected static const REPORT_TYPE_TRY:int = 3;

    protected function report(type:int, ...args):void {
        var s:String = "[招募]", c:String = "";
        switch (type) {
            case REPORT_TYPE_SYNC :
                c += "刷新时间 -> " + Time.secToFull(refreshTime);
                break;
            case REPORT_TYPE_SUMMON :
                    c += args[0] + " -> " + args[1];
                    c += "    消耗 -> " + args[2];
                break;
            case REPORT_TYPE_SUMMON_GOLD_MAX :
                    c += "金币消耗溢出 -> 现有: " + _context.jb + " 需要: " + args[0] + " 限制: " + _itl_summon_gold_max;
                break;
            case REPORT_TYPE_TRY :
                    c += "尝试招募 -> " + doors[args[0]].name + " 消耗 -> " + doors[args[0]].req;
                break;
        }
        Global.ui.log(s, c);
    }


}
}
