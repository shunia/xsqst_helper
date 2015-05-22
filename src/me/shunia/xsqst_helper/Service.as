/**
 * Created by 庆峰 on 2015/5/18.
 */
package me.shunia.xsqst_helper {

	import me.shunia.xsqst_helper.utils.Req;
	
	public class Service {

        public static function on(s:String, c:Function, ...args):void {
            var cls:Class = R[s];
            if (cls) {
                var b:BS = args.length ? new cls(args) : new cls();

                new Req().load(b.url, b.isGet, b.data, function (data:String):void {
                    var d:Object = null;
                    if (data.charAt(0) == "{") {    // json字符串
                        d = JSON.parse(data);
                        if (d && d.ret == 0)
                            c.apply(null, [d.data]);
                        else if (d && d.ret == 1)
                            c.apply(null, [d]);
//                            Global.ui.log("[SERVICE]", d.msg);
                    } else {
                        d = data as String;
                        c.apply(null, [data]);
                    }
                });
            }
        }

        public static function batch(c:Function = null, ...args):void {
            var l:int = args.length,
                apply:Function = function (a:Array):void {
                    var cp:Array = a.concat(),
                        f:Function = function (d:Object):void {
                            if (a.length > 1 && a[1] != null) a[1].apply(null, [d]);
                            l --;
                            if (l == 0) {
                                if (c != null) c();
                            }
                        };
                    cp[1] = f;
                    on.apply(null, cp);
                },
                iter:Function = function ():void {
                    for each (var o:Array in args) {
                        apply(o);
                    }
                };
            iter();
        }
		
        public static const R:Object = {
            "get_conf": {t:7, v:args[0], name:args[1]},
            "sync_1": sync_1,
            "sync_2": sync_2,
            "sync_3": sync_3,
            "sync_4": sync_4,
            "sync_5": sync_5,
            "sync_6": sync_6,
            "sync_sys_1": sync_sys_1,
            "sync_sys_2": sync_sys_2,
            "sync_sys_3": sync_sys_3,
            "sync_sys_4": sync_sys_4,
            "sync_sys_5": sync_sys_5,
            "sync_sys_6": sync_sys_6,
            "sync_user_1": sync_user_1,
            "sync_user_2": sync_user_2,
            "sync_bag": sync_bag,
            "sell_bag_gold": sell_bag_gold,
            "sell_bag_exp": sell_bag_exp,
            "sync_mine": sync_mine,
            "sync_mine_nodes": sync_mine_nodes,
            "sync_mine_num": sync_mine_num,
            "sync_sunmmon": sync_sunmmon,
            "sync_mine_queue": sync_mine_queue,
            "mine_queue_harvest": mine_queue_harvest,
            "mine_queue_add": mine_queue_add,
            "sync_maze": sync_maze,
            "sync_hero": sync_hero,
            "sync_pvp": sync_pvp,
            "sync_food": sync_food,
            "pvp_match": pvp_match,
            "pvp_reward": pvp_reward,
            "summon_hero": summon_hero,
            "use_food": use_food,
            "get_box_reward": get_box_reward,
            "sync_gift_1": sync_gift_1,
            "sync_gift_2": sync_gift_2,
            "send_gift": send_gift,
			"sync_moon_card": sync_moon_card,
			"receive_moon_card": receive_moon_card
        };
    }
}

import flash.net.URLVariables;

class BS {

    protected var _sid:String = Global.user.token;
    protected var _uid:String = Global.user.id;
    public var url:String = "http://s1.wangamemxwk.u77.com/service/main.ashx";
    public var isGet:Boolean = false;
    public var data:Object = null;

    public function BS(o:Object) {
        var v:URLVariables = new URLVariables();
        if (_sid) v["sid"] = _sid;
        if (_uid) v["userid"] = _uid;
        for (var k:String in o) {
            v[k] = o[k];
        }
        data = v;
    }

    public function get time():Number {
        return Math.random() * 1000000;
    }

}

/**
 * 获取游戏配置
 */
class get_conf extends BS {
    public function get_conf(args:Array) {
        super ({t:7, v:args[0], name:args[1]});
        delete data["uid"];
        url = "http://conf.wangamemxwk.u77.com/getconfig.ashx";
        isGet = true;
//        return base64 encoding strings
    }
}

class sync_1 extends BS {
    public function sync_1() {
        super ({t:1101});
//        return {"newvalue":0,"sound":0,"value1":"step8_over"}
    }
}

class sync_2 extends BS {
    public function sync_2() {
        super ({t:1002});
//        return {
//            "lpj":12,             // 可送礼次数
//            "max":12,             // 送礼次数上限
//            "a":4,
//            "lpjsxsj":15833}
    }
}

class sync_3 extends BS {
    public function sync_3() {
        super ({t:1011});
//        return [37,38,39,40,41,44,48,54,55,56]
    }
}

class sync_4 extends BS {
    public function sync_4() {
        super ({t:3021});
    }
}

class sync_5 extends BS {
    public function sync_5() {
        super ({t:6002});
//        return {"list1":[3,33,84,15,226,0],"list2":[3,3,2,0,2,1],"list3":[{"id":7287,"equipid":6,"isequip":0},{"id":7448,"equipid":7,"isequip":0},{"id":7464,"equipid":8,"isequip":0},{"id":7483,"equipid":9,"isequip":0},{"id":7562,"equipid":10,"isequip":1}],"list4":[2400,360,150,15,5000,2]}
    }
}

class sync_6 extends BS {
    public function sync_6() {
        super ({t:2101});
//        return {"isnew":false,"count":0}
    }
}

class sync_user_1 extends BS {
    public function sync_user_1() {
        super ({t:1001});
//        return {
//            "username":"smzdm",
//            "sex":1,
//            "figure":99000001,
//            "jb":24820291,
//            "xz":140,
//            "yjjc":8380,
//            "blhj":1,				// 徽记
//            "zrhj":1,				// 
//            "hhhj":0,				// 辉煌
//            "hlhj":0,				// 混乱
//            "mazeboxmax":3,
//            "lhsp":492,           // 荣誉碎片
//            "newmsgcount":0,
//            "blue_vip_level":0,
//            "isqh":false,
//            "lshd":0,
//            "ishz":0,
//            "sortid":1
//        }
    }
}

class sync_user_2 extends BS {
    public function sync_user_2() {
        super({t:5002});
//        return {
//            bzd: 71998,           // 饱食度
//            event1iscomplete: 1,  // 事件1,2,3属性
//            event2iscomplete: 1,
//            event3iscomplete: 0,
//            event1time: 600,      // 每过600秒事件就完成了
//            event2time: 600,
//            event3time: 0,
//            boxcount: 3,          // 当前宝箱数
//            boxtime: 34,          // 下一个宝箱时间
//            isoutfirstbox: 1,     // 是不是第一个宝箱
//            jb: 24489335,         // 金币数
//            mlist: [{             //出战列表
//                id: 418075,       // 英雄id
//                mid: 99000001,    // mid
//                exp: 4287089,     // 经验
//                wakeup: 4,        // 觉醒
//                equillv: 5,       // 武具
//                isplaying: 1,     // 是否正在出战
//                isleader: 1,      // 是否主角
//                lv: 15,           // 当前等级
//                battlevalue: 41352,   // 战力
//                tplv: 0,          //
//                isbj: 0,          //
//                islock: 0         //
//            }]
//        }
    }
}

class sync_bag extends BS {
    public function sync_bag() {
        super({t:1007});
//        return {
//            packagelv: 9,         // 包裹等级
//            list: [{              // 物品列表
//                id: 3235451,      // 包裹格子id？
//                itemid: 1000001,  // 物品id
//                isnew: 0,         // 是否新物品
//                value: 0          // ？
//            }]
//        }
    }
}

class sync_mine extends BS {
    public function sync_mine() {
        super({t:2003});
//        return {
//            "time":111,
//            "szg":18,
//            "szglv":6,
//            "wjxl":3,
//            "monstercount":0,
//            "monsterlv":19,
//            "yanmoLv":1,
//            "time1":0,
//            "szgmax":30,          // 挖矿次数上限值
//            "slszg":7,            // 神力矿工包
//            "lg":28,              // 雷管
//            "hslg":0,
//            "isreset":false,
//            "orebag1":0,          // 初中高级矿石包
//            "orebag2":0,
//            "orebag3":0
//        }
    }
}

class sync_mine_nodes extends BS {
    public function sync_mine_nodes() {
        super ({t:2005, time:time, cmd:"getNodeList"});
//        return {
//            "px":82,              // 正在挖矿的点
//            "py":4,
//            "list":[{             // 所有挖开可见的矿点
//                "x":0,
//                "y":0,
//                "type":0          // type=0表示已经挖开了
//            }]}
    }
}

class sync_food extends BS {
    public function sync_food() {
        super({t:7001});
        //return [{id:"18033", foodid:1,count:5}]
    }
}

class sync_sys_1 extends BS {
    public function sync_sys_1() {
        super({t:1013});
        //return {version:"2.2.7"}
    }
}

class sync_sys_2 extends BS {
    public function sync_sys_2() {
        super({t:4008});
        //return {count:0}
    }
}

class sync_sys_3 extends BS {
    public function sync_sys_3() {
        super({t:5004});
        //return null
    }
}

class sync_sys_4 extends BS {
    public function sync_sys_4() {
        super({t:2813});
        //return {a:56}
    }
}

class sync_sys_5 extends BS {
    public function sync_sys_5() {
        super({t:8002})
//        return [11, 18, 22. 0, 0, 0]  // 特殊道具第一列：冒险，挖矿， 王者
    }
}

class sync_sys_6 extends BS {
    public function sync_sys_6() {
        super ({t:2812});
//        return [2, 0, 0, 0]           //特殊道具第二列：宝箱钥匙，秘银钥匙，烈焰金钥匙
    }
}

class sell_bag_gold extends BS {           // 一键金币
    public function sell_bag_gold() {
        super ({t:8004});
//        return {rewards:{type:23, count:127905, rewardid:19000020}}
    }
}

class sell_bag_exp extends BS {             // 一键经验，经验平分给场上英雄
    public function sell_bag_exp() {
        super ({t:8003});
//        return {rewards:{type:6, count:420000, rewardid:19000020}}
    }
}

class use_food extends BS {
    public function use_food(args:Array) {
        super({t:7002, foodid:args[0]});
        //return {rewards:{type:24, count:72000, rewardid:1200005}}
    }
}

class get_box_reward extends BS {                  // 开宝箱
    public function get_box_reward() {
        super({t:5007});
//        return {
//            rewards: [{
//                type: 1,          // 奖励类型
//                id: 3000005,      // 物品id
//                count: 1,         // 数量
//                rewardid: 18000241
//            }]
//        }
    }
}

class switch_maze extends BS {              // 切换场景地图
    public function switch_maze(args:Array) {
        super({t:5003, mazeid:args[0]});
        //return
    }
}

class summon_hero extends BS {
    /**
     * @param doorid int 100001
     */
    public function summon_hero(args:Array) {
        super ({t:3011, doorid:args[0]});
//        return {
//            "rewards":[{
//                "type":5,
//                "id":11000001,
//                "rewardid":1500151,
//                "data":{
//                    "id":487275,
//                    "mid":11000001,
//                    "exp":0,
//                    "wakeup":1,
//                    "equiplv":0,
//                    "isplaying":0,
//                    "isleader":0,
//                    "lv":1,
//                    "battlevalue":40,
//                    "tplv":0,
//                    "isbj":0,
//                    "islock":0,
//                    "istj":false
//                }
//            }]
//        }
    }
}

class sync_sunmmon extends BS {
    public function sync_sunmmon() {
        super ({t:3010, doorid:"null"});
//        return {
//            "time":37486,                 // 重置倒计时
//            "list":[
//                {"id":9515,
//                    "doorid":100001,      // 金币
//                    "count":1},           // 剩余次数
//                {"id":9519,
//                    "doorid":100002,      // 英雄
//                    "count":0},
//                {"id":9520,
//                    "doorid":100003,      // 律动
//                    "count":0},
//                {"id":9521,
//                    "doorid":100004,      // 辉煌
//                    "count":0},
//                {"id":9522,
//                    "doorid":100005,      // 混乱
//                    "count":0},
//                {"id":9516,
//                    "doorid":100006,      // 万象
//                    "count":0}]}
    }
}

class sync_shendian extends BS {            // 神殿同步
    public function sync_shendian() {
        super ({t:1401});
//        return {
//            "list1":[
//                {"id":280621,"mid":17000001,"jg":100},
//                {"id":280624,"mid":17000025,"jg":100},
//                {"id":280627,"mid":17000027,"jg":100},
//                {"id":280630,"mid":17000003,"jg":100}],
//            "list2":[
//              {"id":280622,"mid":18000031,"jg":500},
//              {"id":280625,"mid":18000004,"jg":500},
//              {"id":280628,"mid":18000026,"jg":500},
//              {"id":280631,"mid":17000004,"jg":500}],
//            "list3":[
//                {"id":280623,"mid":19000066,"jg":6000},
//                {"id":280626,"mid":19000026,"jg":18000},
//                {"id":280629,"mid":19000003,"jg":6000},
//                {"id":280632,"mid":19000025,"jg":6000}],
//            "canbuy":true,
//            "time":37149}
    }
}

class mine_dig extends BS {             // 挖一个格
    public function mine_dig(args:Array) {
        super ({t:2004, x:args[0], y:args[1], cmd:"exploit", time:629160 + Math.random()});
//        return {
//            "x":74,
//            "y":5,
//            "type":6,                 // 矿格类型,6=铜矿
//            "exploit":{
//                "x":74,
//                "y":5,
//                "type":6,
//                "storage":2,          // 储量
//                "time":0,
//                "needtime":5},        // 需要挖多长时间
//            "nodeList":[{
//                "x":74,
//                "y":7,
//                "type":1}]}
    }
}

class sync_mine_num extends BS {
    public function sync_mine_num() {
        super ({t:1005});
//        return {
//            "res":[22,94,42,71,32,0,2,39,3,2,1,0,0,0,0,0,0,0],    // 现有矿数量
//                  铜，锡，铁，银，黄金，？，泰坦铁，红宝石，紫宝石，绿宝石，黄宝石，巨魔雕像
//            "resisopen":[1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0]     // 矿开启状态
//        }
    }
}

class mine_pick extends BS {
    public function mine_pick(args:Array) {
        super ({t:2007, x:args[0], y:args[1], cmd:"charge", time:int(Math.random() * 1000000) + Math.random()})
        //return
    }
}

class sync_mine_queue extends BS {           // 工坊挖矿队列
    public function sync_mine_queue() {
        super ({t:2016});
//        return [{
//            "id":1634,                // id
//            "sid":10001,              // 队列类型id
//            "time":2181               // 剩余时间
//        }]
    }
}

class mine_queue_harvest extends BS {
    /**
     * @param id int {sync_mine_queue}.id
     */
    public function mine_queue_harvest(args:Array) {
        super ({t:2018, id:args[0]});
//        return {
//            "rewards":[{
//                "type":9,             // 矿类型，9=锡
//                "count":16,           // 奖励数量
//                "rewardid":40000003},
//                {
//                "type":8,
//                "count":8,
//                "rewardid":40000001}]}
    }
}

class mine_queue_add extends BS {
    /**
     * @param id int 挖掘队列类型id
     */
    public function mine_queue_add(args:Array) {
        super ({t:2017, id:args[0]});
    }
}

class sync_maze extends BS {
    public function sync_maze() {
        super ({t:5001});
//        return {"mazeid":200001,"list":[{"id":98139,"mazeid":100001,"isnew":0,"e1":1,"e2":1,"e3":0}]}
    }
}

class sync_hero extends BS {
    public function sync_hero(args:Array) {
        super ({t:3001, sortid:args[0]});
//        return {"battlevalue":192146,"playingcount":20,"playingcountmax":20,"list":[{"id":418075,"mid":99000001,"exp":4655110,"wakeup":4,"equiplv":5,"isplaying":1,"isleader":1,"lv":16,"battlevalue":42428,"tplv":0,"isbj":0,"islock":0},{"id":461120,"mid":18000009,"exp":3546246,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11799,"tplv":0,"isbj":0,"islock":0},{"id":484426,"mid":18000009,"exp":278231,"wakeup":2,"equiplv":7,"isplaying":1,"isleader":0,"lv":33,"battlevalue":3318,"tplv":0,"isbj":0,"islock":0},{"id":476677,"mid":18000055,"exp":1415594,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":26,"battlevalue":9688,"tplv":0,"isbj":0,"islock":0},{"id":474123,"mid":13000009,"exp":1400566,"wakeup":3,"equiplv":4,"isplaying":1,"isleader":0,"lv":26,"battlevalue":8115,"tplv":0,"isbj":0,"islock":0},{"id":418116,"mid":17000005,"exp":4393089,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":40,"battlevalue":10289,"tplv":0,"isbj":0,"islock":0},{"id":461074,"mid":17000013,"exp":3551292,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":38,"battlevalue":9854,"tplv":0,"isbj":0,"islock":0},{"id":453888,"mid":17000017,"exp":3864193,"wakeup":3,"equiplv":5,"isplaying":1,"isleader":0,"lv":39,"battlevalue":9796,"tplv":0,"isbj":0,"islock":0},{"id":431715,"mid":17000022,"exp":4233918,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":40,"battlevalue":10357,"tplv":0,"isbj":0,"islock":0},{"id":476671,"mid":17000022,"exp":1400184,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":7786,"tplv":0,"isbj":0,"islock":0},{"id":476672,"mid":17000008,"exp":1398805,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":7068,"tplv":0,"isbj":0,"islock":0},{"id":474120,"mid":16000010,"exp":1398434,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":5445,"tplv":0,"isbj":0,"islock":0},{"id":431710,"mid":16000010,"exp":4231171,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":40,"battlevalue":6597,"tplv":0,"isbj":0,"islock":0},{"id":431714,"mid":11000006,"exp":4232298,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":68,"battlevalue":2724,"tplv":0,"isbj":0,"islock":0},{"id":476675,"mid":18000001,"exp":1415371,"wakeup":3,"equiplv":5,"isplaying":1,"isleader":0,"lv":26,"battlevalue":9331,"tplv":0,"isbj":0,"islock":0},{"id":461119,"mid":11000035,"exp":3545970,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11638,"tplv":0,"isbj":0,"islock":0},{"id":461297,"mid":18000022,"exp":3476683,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11693,"tplv":0,"isbj":0,"islock":0},{"id":476674,"mid":11000035,"exp":1415267,"wakeup":3,"equiplv":3,"isplaying":1,"isleader":0,"lv":26,"battlevalue":8820,"tplv":0,"isbj":0,"islock":0},{"id":476676,"mid":17000016,"exp":1398610,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":51,"battlevalue":2569,"tplv":0,"isbj":0,"islock":0},{"id":446370,"mid":11000030,"exp":3954022,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":67,"battlevalue":2546,"tplv":0,"isbj":0,"islock":0},{"id":481504,"mid":17000030,"exp":1036557,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":48,"battlevalue":2831,"tplv":0,"isbj":0,"islock":0},{"id":452717,"mid":11000030,"exp":2921523,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":62,"battlevalue":2480,"tplv":0,"isbj":0,"islock":0},{"id":418117,"mid":11000016,"exp":2989833,"wakeup":2,"equiplv":2,"isplaying":0,"isleader":0,"lv":62,"battlevalue":3002,"tplv":0,"isbj":0,"islock":0},{"id":418105,"mid":11000018,"exp":2994404,"wakeup":2,"equiplv":1,"isplaying":0,"isleader":0,"lv":62,"battlevalue":2422,"tplv":0,"isbj":0,"islock":0},{"id":453868,"mid":11000018,"exp":2465658,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2361,"tplv":0,"isbj":0,"islock":0},{"id":431713,"mid":11000020,"exp":2887535,"wakeup":2,"equiplv":5,"isplaying":0,"isleader":0,"lv":62,"battlevalue":3258,"tplv":0,"isbj":0,"islock":0},{"id":453880,"mid":11000020,"exp":2465576,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2999,"tplv":0,"isbj":0,"islock":0},{"id":476678,"mid":17000015,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":242,"tplv":0,"isbj":0,"islock":0},{"id":466927,"mid":12000003,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":54,"tplv":0,"isbj":0,"islock":0},{"id":474118,"mid":12000007,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":40,"tplv":0,"isbj":0,"islock":0},{"id":447855,"mid":15000011,"exp":2722403,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":61,"battlevalue":2516,"tplv":0,"isbj":0,"islock":0},{"id":452028,"mid":16000001,"exp":572635,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":41,"battlevalue":1997,"tplv":0,"isbj":0,"islock":0},{"id":431711,"mid":16000008,"exp":2722430,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":61,"battlevalue":2666,"tplv":0,"isbj":0,"islock":0},{"id":453894,"mid":16000008,"exp":2463260,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2637,"tplv":0,"isbj":0,"islock":0},{"id":466922,"mid":16000008,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":111,"tplv":0,"isbj":0,"islock":0},{"id":481502,"mid":12000007,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":40,"tplv":0,"isbj":0,"islock":0},{"id":481509,"mid":11000018,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":147,"tplv":0,"isbj":0,"islock":0},{"id":487275,"mid":11000001,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":58,"tplv":0,"isbj":0,"islock":0},{"id":487300,"mid":17000005,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":223,"tplv":0,"isbj":0,"islock":0},{"id":487301,"mid":15000001,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":72,"tplv":0,"isbj":0,"islock":0},{"id":487562,"mid":11000013,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":66,"tplv":0,"isbj":0,"islock":0}],"qycount":0}
    }
}

class sync_pvp extends BS {
    public function sync_pvp() {
        super ({t:6001});
//        return {
//            "list":[{
//                "id":1668043,
//                "sex":0,
//                "figure":"19000001",
//                "username":"狄奥尼索斯",
//                "battlevalue":142700,
//                "lv":0,
//                "iswin":0,
//                "userid":0
//            }],
//            "time":4111,
//            "arenacount":0,
//            "arenabox1isget":0,
//            "arenabox2isget":0,
//            "arenabox3isget":0
//        }
    }
}

class pvp_match extends BS {
    /**
     * @param id int oponent id
     */
    public function pvp_match(args:Array) {
        super ({t:6007, id:args[0]});
//        return {
//            "report":{"leftMG":{"name":"smzdm","merList":[99000001,18000009,18000009,18000055,13000009,17000005,17000013,17000017,17000022,17000022,17000008,16000010,16000010,11000006,18000001,11000035,18000022,11000035,17000016,17000030],"ATK":192205,"maxATK":192205,"skills":[1200033,1200028,1200028,1200081,1200013,1100007,1100012,1100016,1100016,1400004,1200020,1200020,1200004],"skillsLv":1,"firstStrike":10,"defense":31,"dodge":12,"wz":0},"rightMG":{"name":"狄奥尼索斯","merList":[19000001,11000006,12000001,14000005,15000006,11000002,16000006,17000016,15000002,17000007,16000010,11000008,11000007,15000009,13000011,16000008,12000008],"ATK":142700,"maxATK":142700,"skills":[1200004,1200017,1300002,1500002,1200024,1200020,1200005,1100002,1600002,1400001,2100002],"skillsLv":1,"firstStrike":0,"defense":25,"dodge":8,"wz":0},"skillList":[1200025,1200009,1200028,1700004,1200028,1200017,1200028],"dodgeList":[true,false,false,false,false,false,false],"damageValue":[[0,0],[-33660,0],[0,-67326],[-27540,1432],[0,-63911],[-27324,0],[0,-60523]],"xly":[],"skip":1},
//            "iswin":true}
    }
}

class pvp_reward extends BS {
    public function pvp_reward(args:Array) {
        super ({t:6006, type:args[0]});
    }
}

class sync_gift_1 extends BS {
    public function sync_gift_1() {
        super ({t:4003});
//        return {
//            "list":[{
//                "id":7193,
//                "sex":2,
//                "figure":11000010,
//                "username":"呜喵喵",
//                "battlevalue":6722524,
//                "mlv":500,
//                "canAttack":true,
//                "cangift":false,
//                "areaid":1001,
//                "ishx":1,
//                "ftype":1,
//                "tjcount":265,
//                "qycount":5,
//                "v1":0,
//                "yellow_vip_level":0,
//                "qqname":"呜喵喵"}],
//            "isenabled":1}
    }
}

class sync_gift_2 extends BS {
    public function sync_gift_2() {
        super ({t:4005});
//        return [{
//            "senderid":37,
//            "sendername":"拼命玩三郎",
//            "sendersex":1,
//            "senderfigure":99000002,
//            "id":2283464,
//            "gifttype":3,
//            "state":1,
//            "type":2,
//            "isnew":0}]
    }
}

class send_gift extends BS {
    public function send_gift(args:Array) {
        super ({t:4004,id:args[0],gifttype:args[1]});
//        return
    }
}

class sync_moon_card extends BS {
	public function sync_moon_card() {
		super({t:190202});
//		return {
//			"days":[22,22,0,0],				// 月卡剩余次数: 低级,中级,矿工卡
//			"isget":[false,false,false]}	// 是否收了
	}
}

class receive_moon_card extends BS {
	/**
	 * @param id int 月卡类型
	 */	
	public function receive_moon_card(args:Array) {
		super({t:190201});
	}
}