/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.utils.Timer;

public class Summon extends BaseModule{

        private var req_zhaomusuo:int = 3000;
        private var req_huihuang:int = 1;
        private var req_yingxiong:int = 1;
        private var req_hunluan:int = 1;
        private var req_lvdong:int = 1;
        private var req_wanxiang:int = 60;

        private var refresh_time:int = 0;

        private static const SUMMON_INTERVAL:int = 5;
        private static const DOOR_DEF:Object = {};

        public static const ZHAO_MU_SUO:String = "100001";
        public static const YING_XIONG:String = "100002";
        public static const LV_DONG:String = "100003";
        public static const HUI_HUANG:String = "100004";
        public static const HUN_LUAN:String = "100005";
        public static const WAN_XIANG:String = "100006";

        public function Summon() {
            DOOR_DEF[ZHAO_MU_SUO] = {num:1, req:3000};
            DOOR_DEF[YING_XIONG] = {num:0, req:1};
            DOOR_DEF[LV_DONG] = {num:0, req:1};
            DOOR_DEF[HUI_HUANG] = {num:0, req:1};
            DOOR_DEF[HUN_LUAN] = {num:0, req:1};
            DOOR_DEF[WAN_XIANG] = {num:0, req:1};
        }

        override public function sync(cb:Function = null):void {
            Global.service.on("sync_sunmmon", function (data:Object):void {
                refresh_time = data.time;
                for each (var o:Object in data.list) {
                    DOOR_DEF[o["doorid"]].num = o.count;
                }
                DOOR_DEF[ZHAO_MU_SUO].num = Global.user.jb;

                _c(cb);
            });
        }

        public function summon(id:String, time:int = 1):void {
            if (DOOR_DEF.hasOwnProperty(id)) {
                var t:Timer = new Timer(SUMMON_INTERVAL, time, function ():void {
                   _summonOnce(id, function (success:Boolean):void {
                       if (!success) t.stop();
                   })
                });
            }
        }

        protected function _summonOnce(id:String, cb:Function = null):void {
            var o:Object = DOOR_DEF[id];
            if (o.num <= o.req)
                cb(false);                  // 失败
            else
                Global.service.on("summon_hero", function (data:Object):void {
                    if (data.rewards && data.rewards.length) {

                        Global.user.sync();

                        cb(true);
                    }
                }, id);
        }

    }
}
