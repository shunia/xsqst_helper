/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper {

import me.shunia.xsqst_helper.module.Bag;
import me.shunia.xsqst_helper.module.Gift;
import me.shunia.xsqst_helper.module.Hero;
import me.shunia.xsqst_helper.module.Mine;
import me.shunia.xsqst_helper.module.PVP;
import me.shunia.xsqst_helper.module.Summon;
import me.shunia.xsqst_helper.utils.Timer;

public class User {

    public static const SYNC_TIME:int = 60;

    public var jb:int = 0;                  // 金币
    public var xz:int = 0;                  // 血钻
    public var hunger:int = 0;              // 饱食度

    public var m_bag:Bag = new Bag();         // 包裹
    public var m_mine:Mine = new Mine();       // 挖矿
    public var m_summon:Summon = new Summon(); // 招募
    public var m_pvp:PVP = new PVP();       // pvp
    public var m_gift:Gift = new Gift();    // 礼物
    public var m_hero:Hero = new Hero();    // 英雄

    private var _queue:Array = [sync, m_bag.sync, m_mine.sync, m_summon.sync, m_pvp.sync];

    public function User() {
        init();
        var f:Function = function ():void {
            var q:Array = _queue.concat(),
                n:Function = function ():void {
                    if (q.length > 0) {
                        var t:Function = q.shift();
                        t(n);
                    } else {

                    }
                };
            n.apply();
        }
        new Timer(SYNC_TIME, 0, f);
    }

    protected function init():void {
        syncSys();
    }

    public function sync(cb:Function = null):void {
        Global.service.batch(
                cb,
                [
                    "sync_user_1",
                    function (d1:Object):void {
                        jb = d1.jb;
                        xz = d1.xz;

                        Global.ui.log("User sync:", "金币:", jb, "血钻:", xz);
                    }
                ],
                [
                    "sync_user_2",
                    function (d2:Object):void {
                        hunger = d2.bzd;
                        m_hero.init(d2.mlist);
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
        Global.service.batch(
                null,
                ["sync_1", null],
                ["sync_2", null],
                ["sync_3", null],
                ["sync_4", null],
                ["sync_5", null],
                ["sync_6", null]
        );
    }

    private function report():void {
        trace("User Data: ", jb, xz);
    }

    /**
     * @param o
     *  27 : 勇气点数
     *  28 : 冠军点数
     */
    public function reward(o:Object):void {

    }

}
}
