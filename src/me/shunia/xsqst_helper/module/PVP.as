/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import flash.utils.getTimer;

import me.shunia.xsqst_helper.utils.Time;

import me.shunia.xsqst_helper.utils.Timer;

public class PVP extends BaseModule{

    public static const TOTAL_F_NUM:int = 10;
    private static const MATCH_INTERVAL:int = 5;
    private static const FAIL_WAITE_INTERVAL:int = 5 * 60;

    public var f_num:int = 0;
    public var refresh_time:int = 0;
    public var oponents:Array = null;

    public var oponentsNotFight:Array = null;
    public var rewardsReceived:Array = null;

    private var _rt:Timer = null;
    private var _ft:Timer = null;
    private var _fightStarted:Boolean = false;

    public var itl_enabled:Boolean = false;

    //                "id":1668043,
    //                "sex":0,
    //                "figure":"19000001",
    //                "username":"狄奥尼索斯",
    //                "battlevalue":142700,
    //                "lv":0,
    //                "iswin":0,
    //                "userid":0
    public function PVP() {
        f_num = TOTAL_F_NUM;
    }

    override public function sync(cb:Function = null):void {
        Global.service.on("sync_pvp", function (data:Object):void {
            refresh_time = data.time;
            oponents = data.list;
            if (oponentsNotFight == null) {
                for each (var f:Object in oponents) {
                    if (!f.iswin) {
                        if (oponentsNotFight == null) oponentsNotFight = [];
                        oponentsNotFight.push(f);
                    }
                }
            }
            f_num = TOTAL_F_NUM - data.arenacount;

//            report(REPORT_TYPE_SYNC);
            start();

            _c(cb);
        });
    }

    override public function start():void {
        if (!itl_enabled) return;

        if (_rt == null) {
            _rt = new Timer(refresh_time, 1, function ():void {
                refresh_time = 0;
            });
        }
        if (!_fightStarted && oponentsNotFight && oponentsNotFight.length > 0 && f_num) {
            _fightStarted = true;
            // 没打的人数和可战斗次数选小的
            var t:int = oponentsNotFight.length > f_num ? f_num : oponentsNotFight.length;
            // 异步游标，用来记录当前打到第几个
            var i:int = 0;
            var f:Function = function ():void {
                var o:Object = oponentsNotFight[i];
                Global.service.on("pvp_match", function (data:Object):void {
                    if (data.iswin == 1) _ft.time = FAIL_WAITE_INTERVAL;  // 如果失败，就把下一次pvp的时间延后
                    else {
                        // 胜利就打下一个
                        i ++;
                        _ft.time = MATCH_INTERVAL;
                    }
                    o.iswin = data.iswin;
                    report(REPORT_TYPE_PVP_RESULT, o, o.id, data);
                }, o.id);
                if (oponentsNotFight.length == 0) {
                    _ft.stop();
                    _ft = null;
                    oponentsNotFight = null;
                }
            };

            _ft = new Timer();
            _ft.time = MATCH_INTERVAL;
            _ft.rp = t;
            _ft.cb = f;
            _ft.start();
        }
        // 奖励, 先尝试获取一次奖励，不管结论如何，都标记为奖励已获取
        if (rewardsReceived == null) {
            rewardsReceived = [];
            Global.service.on("pvp_reward", function (data:Object):void {
                rewardsReceived.push(1);
                if (!(data.ret == 1))
                    report(REPORT_TYPE_REWARD, 1);
            }, 1);
            Global.service.on("pvp_reward", function (data:Object):void {
                rewardsReceived.push(1);
                if (!(data.ret == 1))
                    report(REPORT_TYPE_REWARD, 4);
            }, 4);
            Global.service.on("pvp_reward", function (data:Object):void {
                rewardsReceived.push(1);
                if (!(data.ret == 1))
                    report(REPORT_TYPE_REWARD, 9);
            }, 9);
        }
    }

    protected function getOponent(id:int):Object {
        for each (var a:Object in oponents) {
            if (a.id == id) return a;
        }
        return null;
    }

    protected static const REPORT_TYPE_SYNC:int = 0;
    protected static const REPORT_TYPE_PVP_RESULT:int = 1;
    protected static const REPORT_TYPE_STOPPING:int = 2;
    protected static const REPORT_TYPE_REWARD:int = 3;

    protected function report(type:int, ...args):void {
        var s:String = "[PK]", c:String = "", t1:Object = null;
        switch (type) {
            case REPORT_TYPE_PVP_RESULT :
                    var a:Object = args[0], i:int = args[1], data:Object = args[2];
                    c += "战斗 -> " + a.username + "(战力" + a.battlevalue + ")";
                    c += "    结果 -> " + data.iswin ? "胜利" : "失败";
                break;
            case REPORT_TYPE_STOPPING :
                    c += f_num == 0 ? "次数耗尽" : "打完了";
                break;
            case REPORT_TYPE_SYNC :
                    c += "刷新时间 -> " + Time.secToFull(refresh_time);
                    c += "    剩余次数 -> " + f_num;
                break;
            case REPORT_TYPE_REWARD :
                    c += args[0] + "胜奖励已领取";
                break;
        }
        Global.ui.log(s, c);
    }
}
}
