/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper {

import me.shunia.xsqst_helper.module.Bag;
import me.shunia.xsqst_helper.module.BaseModule;
import me.shunia.xsqst_helper.module.Food;
import me.shunia.xsqst_helper.module.Gift;
import me.shunia.xsqst_helper.module.Hero;
import me.shunia.xsqst_helper.module.Maze;
import me.shunia.xsqst_helper.module.Mine;
import me.shunia.xsqst_helper.module.PVP;
import me.shunia.xsqst_helper.module.Summon;
import me.shunia.xsqst_helper.utils.Timer;

public class User implements ICtxCls {

    public static const SYNC_TIME:int = 10;

    public var id:String = "9201";
    public var token:String = "4nwzaecyb0rqav1iannx1xtr";
    public var name:String = null;
    public var jb:int = 0;                  // 金币
    public var xz:int = 0;                  // 血钻
	
	public var row1:Object = null;
	public var row2:Object = null;

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
                                onAllSynced();
                            }
                        };
                n.apply();
            }
            _ft = new Timer(SYNC_TIME, 0, f);
        }
    }

    public function sync(cb:Function = null):void {
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

//                        report(REPORT_TYPE_SYNC);
                    }
                ],
                [
                    "sync_user_2",
                    function (d2:Object):void {
						row2 = d2;
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

    protected function onAllSynced():void {
		_e(_ctx).emit("allSynced", this);
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
     *  27 : 勇气点数
     *  28 : 冠军点数
     */
    public function reward(o:*):void {

    }
	
	protected var _ctx:Ctx = null;
	public function set ctx(value:Ctx):void {
		_ctx = value;
		onCtxInited();
	}
	public function get ctx():Ctx {
		return _ctx;
	}
	
	public function onCtxInited():void {
		m_food = initModule(Food) as Food;
		m_bag = initModule(Bag) as Bag;
		m_mine = initModule(Mine) as Mine;
		m_summon = initModule(Summon) as Summon;
		m_pvp = initModule(PVP) as PVP;
		m_gift = initModule(Gift) as Gift;
		m_hero = initModule(Hero) as Hero;
		m_maze = initModule(Maze) as Maze;
		_queue = [sync, 
			m_food.sync, 
			m_pvp.sync, 
			m_bag.sync
		];
		
		conf = new Conf(function ():void {          // 目前无法解开字符串
			syncSys();
			
			start();
		}, _ctx);
	}
	
	protected function initModule(cls:Class):BaseModule {
		var m:BaseModule = new cls();
		m.ctx = this.ctx;
//		_queue.push(m.sync);
		return m;
	}
	
}
}
