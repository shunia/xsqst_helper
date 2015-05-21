/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper {

import me.shunia.xsqst_helper.module.Bag;
import me.shunia.xsqst_helper.module.Food;
import me.shunia.xsqst_helper.module.Gift;
import me.shunia.xsqst_helper.module.Hero;
import me.shunia.xsqst_helper.module.Maze;
import me.shunia.xsqst_helper.module.Mine;
import me.shunia.xsqst_helper.module.PVP;
import me.shunia.xsqst_helper.module.Summon;
import me.shunia.xsqst_helper.utils.Timer;

public class User {

    public static const SYNC_TIME:int = 10;

    public var id:String = "9201";
    public var token:String = "4nwzaecyb0rqav1iannx1xtr";
    public var name:String = null;
    public var jb:int = 0;                  // 金币
    public var xz:int = 0;                  // 血钻

    public var conf:Conf = null;

    public var m_food:Food = null;      //食物
    public var m_bag:Bag = null;        // 包裹
    public var m_mine:Mine = null;      // 挖矿
    public var m_summon:Summon = null;  // 招募
    public var m_pvp:PVP = null;        // pvp
    public var m_gift:Gift = null;      // 礼物
    public var m_hero:Hero = null;      // 英雄
    public var m_maze:Maze = null;      // 关卡

    private var _queue:Array = null;    // 同步方法队列，用于每过一段时间自动同步
    private var _ft:Timer = null;

    public function User() {
        m_food = new Food().setContext(this) as Food;
        m_bag = new Bag().setContext(this) as Bag;
        m_mine = new Mine().setContext(this) as Mine;
        m_summon = new Summon().setContext(this) as Summon;
        m_pvp = new PVP().setContext(this) as PVP;
        m_gift = new Gift().setContext(this) as Gift;
        m_hero = new Hero().setContext(this) as Hero;
        m_maze = new Maze().setContext(this) as Maze;
        _queue = [
            sync,
            m_food.sync,
            m_mine.sync,
            m_summon.sync,
            m_pvp.sync,
            m_bag.sync,
            m_maze.sync,
            m_gift.sync];
    }

    public function start():void {
        if (_ft) _ft.tick();
        else {
            var f:Function = function ():void {
                var q:Array = _queue.concat(),
                        n:Function = function ():void {
                            if (q.length > 0) {
                                var t:Function = q.shift();
                                t(n);
                            } else {
                                postSync();
                            }
                        };
                n.apply();
            }
            _ft = new Timer(SYNC_TIME, 0, f);
        }
    }

    public function init():void {
        conf = new Conf(function ():void {          // 目前无法解开字符串
            syncSys();

            start();
        });
    }

    public function sync(cb:Function = null):void {
        Global.service.batch(
                cb,
                [
                    "sync_user_1",
                    function (d1:Object):void {
                        name = d1.username;
                        jb = d1.jb;
                        xz = d1.xz;

//                        report(REPORT_TYPE_SYNC);
                    }
                ],
                [
                    "sync_user_2",
                    function (d2:Object):void {
                        m_food.hunger = d2.bzd;
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
//                ["sync_2", null],
                ["sync_3", null],
                ["sync_4", null],
                ["sync_5", null],
                ["sync_6", null]
        );
    }

    protected function postSync():void {
        _e().emit("userSynced", this);
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
        Global.ui.log(s, c);
    }

    /**
     * @param o
     * o.id -
     *  1  : 迷宫宝箱
     *  23 : 金币
     *  27 : 勇气点数
     *  28 : 冠军点数
     */
    public function reward(o:*):void {

    }

}
}
