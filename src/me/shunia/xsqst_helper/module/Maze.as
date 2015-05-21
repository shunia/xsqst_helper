/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.utils.Timer;

public class Maze extends BaseModule {

    private static const OPEN_BOX_TIME:int = 100;

    private var _obt:Timer = null;

    public var itl_enabled:Boolean = false;

    public function Maze() {

    }

    override public function sync(cb:Function = null):void {
        openBox();
        _c(cb);
    }

    public function openBox():void {
        if (!itl_enabled) return;

        if (!_obt) {
            _obt = new Timer(OPEN_BOX_TIME, 0, function ():void {

                Global.service.on("get_box_reward", function (data:Object):void {
                    if (data.hasOwnProperty("ret") && data.ret == 1) {

                    } else {
                        for each (var i:Object in data.rewards) {
                            _context.reward(i);
                        }

                        report(REPORT_TYPE_OPEN_BOX, data.rewards);
                    }
                });
            });
        }
    }

    public function startEvent():void {

    }

    protected static const REPORT_TYPE_SYNC:int = 0;
//    protected static const REPORT_TYPE_PVP_RESULT:int = 1;
//    protected static const REPORT_TYPE_STOPPING:int = 2;
    protected static const REPORT_TYPE_OPEN_BOX:int = 0;

    protected function report(type:int, ...args):void {
        var s:String = "[关卡]", c:String = "";
        switch (type) {
//            case REPORT_TYPE_PVP_RESULT :
//                var a:Object = args[0], i:int = args[1], data:Object = args[2];
//                c += "战斗 -> " + a.username + "(战力" + a.battlevalue + ")";
//                c += "    结果 -> " + data.iswin ? "胜利" : "失败";
//                break;
//            case REPORT_TYPE_STOPPING :
//                c += f_num == 0 ? "次数耗尽" : "打完了";
//                break;
//            case REPORT_TYPE_SYNC :
//                c += "刷新时间 -> " + Time.secToFull(refresh_time);
//                c += "    剩余次数 -> " + f_num;
//                break;
              case REPORT_TYPE_OPEN_BOX :
                      c += "宝箱 -> " + args[0].length;
                break;
        }
        Global.ui.log(s, c);
    }

}
}
