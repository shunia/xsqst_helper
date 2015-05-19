/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.utils.Timer;

public class PVP extends BaseModule{

    public static const TOTAL_F_NUM:int = 10;
    private static const MATCH_INTERVAL:int = 5;
    private static const FAIL_WAITE_INTERVAL:int = 5 * 60;

    public var f_num:int = 0;
    public var refresh_time:int = 0;
    public var oponents:Array = null;

    private var _rt:Timer = null;
    private var _ft:Timer = null;

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
            f_num = TOTAL_F_NUM - data.arenacount;

            start();

            _c(cb);
        });
    }

    override public function start():void {
        if (_rt == null) {
            _rt = new Timer(refresh_time, 1, function ():void {
                refresh_time = 0;
            });
        }
        if (!_ft && f_num > 0 && oponents && oponents.length > 0) {
            _ft = new Timer(MATCH_INTERVAL, 0, function ():void {
                var findOp:Function = function ():int {
                            for (var oi:int = 0; oi < oponents.length; oi ++) {
                                if (oponents[oi].iswin == 0) return oponents[oi].id;
                            }
                            return 0;
                        },
                        opid:int = findOp();
                if (opid) {
                    Global.service.on("pvp_match", function (data:Object):void {
                        Global.ui.log("PVP result: ", data.iswin ? "win" : "lost", opid);
                        if (!data.iswin) _ft.time = FAIL_WAITE_INTERVAL;
                        else {
                            _ft.time = MATCH_INTERVAL;
                            Global.service.batch(
                                    null,
                                    ["pvp_reward", null, 1],
                                    ["pvp_reward", null, 4],
                                    ["pvp_reward", null, 9]
                            )
                        }
                    }, opid);
                } else {
                    _ft.stop();
                    _ft = null;
                }
            });
        }
    }
}
}
