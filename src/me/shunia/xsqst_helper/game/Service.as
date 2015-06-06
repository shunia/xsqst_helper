/**
 * Created by 庆峰 on 2015/5/18.
 */
package me.shunia.xsqst_helper.game {
	import me.shunia.xsqst_helper.utils.Req;

	
	public class Service {
		
		private var _base:Object = {};
		
		public function Service(sid:String, uid:String) {
			_base.sid = sid;
			_base.uid = uid;
		}
		
        public function on(s:String, c:Function, ...args):void {
            var p:Params = R[s];
            if (p) {
                p.base(_base).args(args).o();

                new Req().load(p.u, p.g, p.d, function (data:String):void {
                    var d:Object = null;
                    if (data.charAt(0) == "{") {    // json字符串
                        d = JSON.parse(data);
                        if (d && d.ret == 0)
                            c.apply(null, [d.data]);
                        else if (d && d.ret == 1)
                            c.apply(null, [d]);
//                            _ctx.ui.log("[SERVICE]", d.msg);
                    } else {
                        d = data as String;
                        c.apply(null, [data]);
                    }
                });
            }
        }

        public function batch(c:Function = null, ...args):void {
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
		
        public var R:Object = {
            "get_conf": 
				Params.g('{"t":"7", "sid":"{sid}", "v":"{0}", "name":"{1}"}').
					url("http://conf.wangamemxwk.u77.com/getconfig.ashx").
					post(false),
				//        return base64 encoding strings
            "sync_1": 
				Params.g('{"t":1101, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {"newvalue":0,"sound":0,"value1":"step8_over"}
            "sync_2": 
				Params.g('{"t":1002, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {
				//            "lpj":12,             // 可送礼次数
				//            "max":12,             // 送礼次数上限
				//            "a":4,
				//            "lpjsxsj":15833}
            "sync_3": 
				Params.g('{"t":1011, "sid":"{sid}", "userid":"{uid}"}'),
				//        return [37,38,39,40,41,44,48,54,55,56]
            "sync_4": 
				Params.g('{"t":3021, "sid":"{sid}", "userid":"{uid}"}'),
            "sync_5": 
				Params.g('{"t":6002, "sid":"{sid}", "userid":"{uid}"}'),
				//    return {
				//		"list1":[3,33,84,15,226,0],
				//		"list2":[3,3,2,0,2,1],
				//		"list3":[{"id":7287,"equipid":6,"isequip":0},
				//			{"id":7448,"equipid":7,"isequip":0},
				//			{"id":7464,"equipid":8,"isequip":0},
				//			{"id":7483,"equipid":9,"isequip":0},
				//			{"id":7562,"equipid":10,"isequip":1}],
				//		"list4":[2400,360,150,15,5000,2]}
            "sync_6": 
				Params.g('{"t":2101, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {"isnew":false,"count":0}
            "sync_sys_1": 
				Params.g('{"t":1013, "sid":"{sid}", "userid":"{uid}"}'),
				//			return {version:"2.2.7"}
            "sync_sys_2": 
				Params.g('{"t":4008, "sid":"{sid}", "userid":"{uid}"}'),
				//return {coun"t":0}
            "sync_sys_3": 
				Params.g('{"t":5004, "sid":"{sid}", "userid":"{uid}"}'),
				//return null
            "sync_sys_4": 
				Params.g('{"t":2813, "sid":"{sid}", "userid":"{uid}"}'),
				//return {a:56}
            "sync_sys_5": 
				Params.g('{"t":8002, "sid":"{sid}", "userid":"{uid}"}'),
				//        return [11, 18, 22. 0, 0, 0]  // 特殊道具第一列：冒险，挖矿， 王者
            "sync_sys_6": 
				Params.g('{"t":2812, "sid":"{sid}", "userid":"{uid}"}'),
				//        return [2, 0, 0, 0]           //特殊道具第二列：宝箱钥匙，秘银钥匙，烈焰金钥匙
            "sync_user_1": 
				Params.g('{"t":1001, "sid":"{sid}", "userid":"{uid}"}'),
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
            "sync_user_2": 
				Params.g('{"t":5002, "sid":"{sid}", "userid":"{uid}"}'),
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
            "sync_bag": 
				Params.g('{"t":1007, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {
				//            packagelv: 9,         // 包裹等级
				//            list: [{              // 物品列表
				//                id: 3235451,      // 包裹格子id？
				//                itemid: 1000001,  // 物品id
				//                isnew: 0,         // 是否新物品
				//                value: 0          // ？
				//            }]
				//        }
            "sell_bag_gold": 
				Params.g('{"t":8004, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {rewards:{type:23, count:127905, rewardid:19000020}}
            "sell_bag_exp": 
				Params.g('{"t":8003, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {rewards:{type:6, count:420000, rewardid:19000020}}
            "sync_mine": 
				Params.g('{"t":2003, "sid":"{sid}", "userid":"{uid}"}'),
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
            "sync_mine_nodes": 
				Params.g('{"t":2005, "sid":"{sid}", "userid":"{uid}", "time":"{time}", "cmd":"getNodeList"}'),
				//        return {
				//            "px":82,              // 正在挖矿的点
				//            "py":4,
				//            "list":[{             // 所有挖开可见的矿点
				//                "x":0,
				//                "y":0,
				//                "type":0          // type=0表示已经挖开了
				//            }]}
            "sync_mine_num": 
				Params.g('{"t":1005, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {
				//            "res":[22,94,42,71,32,0,2,39,3,2,1,0,0,0,0,0,0,0],    // 现有矿数量
				//                  铜，锡，铁，银，黄金，？，泰坦铁，红宝石，紫宝石，绿宝石，黄宝石，巨魔雕像
				//            "resisopen":[1,1,1,1,1,0,1,1,1,1,1,1,0,0,0,0,0,0]     // 矿开启状态
				//        }
            "sync_sunmmon": 
				Params.g('{"t":3010, "sid":"{sid}", "userid":"{uid}", "doorid":"null"}'),
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
            "sync_mine_queue": 
				Params.g('{"t":2016, "sid":"{sid}", "userid":"{uid}"}'),
				//        return [{
				//            "id":1634,                // id
				//            "sid":10001,              // 队列类型id
				//            "time":2181               // 剩余时间
				//        }]
            "mine_queue_harvest": 
				Params.g('{"t":2018, "sid":"{sid}", "userid":"{uid}", "id":"{0}"}'),
				//        return {
				//            "rewards":[{
				//                "type":9,             // 矿类型，9=锡
				//                "count":16,           // 奖励数量
				//                "rewardid":40000003},
				//                {
				//                "type":8,
				//                "count":8,
				//                "rewardid":40000001}]}
            "mine_queue_add": 
				Params.g('{"t":2017, "sid":"{sid}", "userid":"{uid}", "id":"{0}"}'),
            "sync_maze": 
				Params.g('{"t":5001, "sid":"{sid}", "userid":"{uid}"}'),
//				        return {
//							"mazeid":200001,
//							"list":[
//								{"id":98139,"mazeid":100001,"isnew":0,"e1":1,"e2":1,"e3":0}]}
            "sync_hero": 
				Params.g('{"t":3001, "sid":"{sid}", "userid":"{uid}", "sortid":"{0}"}'),
				//        return {"battlevalue":192146,"playingcount":20,"playingcountmax":20,"list":[{"id":418075,"mid":99000001,"exp":4655110,"wakeup":4,"equiplv":5,"isplaying":1,"isleader":1,"lv":16,"battlevalue":42428,"tplv":0,"isbj":0,"islock":0},{"id":461120,"mid":18000009,"exp":3546246,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11799,"tplv":0,"isbj":0,"islock":0},{"id":484426,"mid":18000009,"exp":278231,"wakeup":2,"equiplv":7,"isplaying":1,"isleader":0,"lv":33,"battlevalue":3318,"tplv":0,"isbj":0,"islock":0},{"id":476677,"mid":18000055,"exp":1415594,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":26,"battlevalue":9688,"tplv":0,"isbj":0,"islock":0},{"id":474123,"mid":13000009,"exp":1400566,"wakeup":3,"equiplv":4,"isplaying":1,"isleader":0,"lv":26,"battlevalue":8115,"tplv":0,"isbj":0,"islock":0},{"id":418116,"mid":17000005,"exp":4393089,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":40,"battlevalue":10289,"tplv":0,"isbj":0,"islock":0},{"id":461074,"mid":17000013,"exp":3551292,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":38,"battlevalue":9854,"tplv":0,"isbj":0,"islock":0},{"id":453888,"mid":17000017,"exp":3864193,"wakeup":3,"equiplv":5,"isplaying":1,"isleader":0,"lv":39,"battlevalue":9796,"tplv":0,"isbj":0,"islock":0},{"id":431715,"mid":17000022,"exp":4233918,"wakeup":3,"equiplv":6,"isplaying":1,"isleader":0,"lv":40,"battlevalue":10357,"tplv":0,"isbj":0,"islock":0},{"id":476671,"mid":17000022,"exp":1400184,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":7786,"tplv":0,"isbj":0,"islock":0},{"id":476672,"mid":17000008,"exp":1398805,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":7068,"tplv":0,"isbj":0,"islock":0},{"id":474120,"mid":16000010,"exp":1398434,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":26,"battlevalue":5445,"tplv":0,"isbj":0,"islock":0},{"id":431710,"mid":16000010,"exp":4231171,"wakeup":3,"equiplv":0,"isplaying":1,"isleader":0,"lv":40,"battlevalue":6597,"tplv":0,"isbj":0,"islock":0},{"id":431714,"mid":11000006,"exp":4232298,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":68,"battlevalue":2724,"tplv":0,"isbj":0,"islock":0},{"id":476675,"mid":18000001,"exp":1415371,"wakeup":3,"equiplv":5,"isplaying":1,"isleader":0,"lv":26,"battlevalue":9331,"tplv":0,"isbj":0,"islock":0},{"id":461119,"mid":11000035,"exp":3545970,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11638,"tplv":0,"isbj":0,"islock":0},{"id":461297,"mid":18000022,"exp":3476683,"wakeup":3,"equiplv":7,"isplaying":1,"isleader":0,"lv":38,"battlevalue":11693,"tplv":0,"isbj":0,"islock":0},{"id":476674,"mid":11000035,"exp":1415267,"wakeup":3,"equiplv":3,"isplaying":1,"isleader":0,"lv":26,"battlevalue":8820,"tplv":0,"isbj":0,"islock":0},{"id":476676,"mid":17000016,"exp":1398610,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":51,"battlevalue":2569,"tplv":0,"isbj":0,"islock":0},{"id":446370,"mid":11000030,"exp":3954022,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":67,"battlevalue":2546,"tplv":0,"isbj":0,"islock":0},{"id":481504,"mid":17000030,"exp":1036557,"wakeup":2,"equiplv":0,"isplaying":1,"isleader":0,"lv":48,"battlevalue":2831,"tplv":0,"isbj":0,"islock":0},{"id":452717,"mid":11000030,"exp":2921523,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":62,"battlevalue":2480,"tplv":0,"isbj":0,"islock":0},{"id":418117,"mid":11000016,"exp":2989833,"wakeup":2,"equiplv":2,"isplaying":0,"isleader":0,"lv":62,"battlevalue":3002,"tplv":0,"isbj":0,"islock":0},{"id":418105,"mid":11000018,"exp":2994404,"wakeup":2,"equiplv":1,"isplaying":0,"isleader":0,"lv":62,"battlevalue":2422,"tplv":0,"isbj":0,"islock":0},{"id":453868,"mid":11000018,"exp":2465658,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2361,"tplv":0,"isbj":0,"islock":0},{"id":431713,"mid":11000020,"exp":2887535,"wakeup":2,"equiplv":5,"isplaying":0,"isleader":0,"lv":62,"battlevalue":3258,"tplv":0,"isbj":0,"islock":0},{"id":453880,"mid":11000020,"exp":2465576,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2999,"tplv":0,"isbj":0,"islock":0},{"id":476678,"mid":17000015,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":242,"tplv":0,"isbj":0,"islock":0},{"id":466927,"mid":12000003,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":54,"tplv":0,"isbj":0,"islock":0},{"id":474118,"mid":12000007,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":40,"tplv":0,"isbj":0,"islock":0},{"id":447855,"mid":15000011,"exp":2722403,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":61,"battlevalue":2516,"tplv":0,"isbj":0,"islock":0},{"id":452028,"mid":16000001,"exp":572635,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":41,"battlevalue":1997,"tplv":0,"isbj":0,"islock":0},{"id":431711,"mid":16000008,"exp":2722430,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":61,"battlevalue":2666,"tplv":0,"isbj":0,"islock":0},{"id":453894,"mid":16000008,"exp":2463260,"wakeup":2,"equiplv":0,"isplaying":0,"isleader":0,"lv":59,"battlevalue":2637,"tplv":0,"isbj":0,"islock":0},{"id":466922,"mid":16000008,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":111,"tplv":0,"isbj":0,"islock":0},{"id":481502,"mid":12000007,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":40,"tplv":0,"isbj":0,"islock":0},{"id":481509,"mid":11000018,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":147,"tplv":0,"isbj":0,"islock":0},{"id":487275,"mid":11000001,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":58,"tplv":0,"isbj":0,"islock":0},{"id":487300,"mid":17000005,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":223,"tplv":0,"isbj":0,"islock":0},{"id":487301,"mid":15000001,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":72,"tplv":0,"isbj":0,"islock":0},{"id":487562,"mid":11000013,"exp":0,"wakeup":1,"equiplv":0,"isplaying":0,"isleader":0,"lv":1,"battlevalue":66,"tplv":0,"isbj":0,"islock":0}],"qycount":0}
            "sync_pvp": 
				Params.g('{"t":6001, "sid":"{sid}", "userid":"{uid}"}'),
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
            "sync_food": 
				Params.g('{"t":7001, "sid":"{sid}", "userid":"{uid}"}'),
				//return [{id:"18033", foodid:1,count:5}]
            "pvp_match": 
				Params.g('{"t":6007, "sid":"{sid}", "userid":"{uid}", "id":"{0}"}'),
				//        return {
				//            "report":{"leftMG":{"name":"smzdm","merList":[99000001,18000009,18000009,18000055,13000009,17000005,17000013,17000017,17000022,17000022,17000008,16000010,16000010,11000006,18000001,11000035,18000022,11000035,17000016,17000030],"ATK":192205,"maxATK":192205,"skills":[1200033,1200028,1200028,1200081,1200013,1100007,1100012,1100016,1100016,1400004,1200020,1200020,1200004],"skillsLv":1,"firstStrike":10,"defense":31,"dodge":12,"wz":0},"rightMG":{"name":"狄奥尼索斯","merList":[19000001,11000006,12000001,14000005,15000006,11000002,16000006,17000016,15000002,17000007,16000010,11000008,11000007,15000009,13000011,16000008,12000008],"ATK":142700,"maxATK":142700,"skills":[1200004,1200017,1300002,1500002,1200024,1200020,1200005,1100002,1600002,1400001,2100002],"skillsLv":1,"firstStrike":0,"defense":25,"dodge":8,"wz":0},"skillList":[1200025,1200009,1200028,1700004,1200028,1200017,1200028],"dodgeList":[true,false,false,false,false,false,false],"damageValue":[[0,0],[-33660,0],[0,-67326],[-27540,1432],[0,-63911],[-27324,0],[0,-60523]],"xly":[],"skip":1},
				//            "iswin":true}
            "pvp_reward": 
				Params.g('{"t":6006, "sid":"{sid}", "userid":"{uid}", "type":"{0}"}'),
            "summon_hero": 
				Params.g('{"t":3011, "sid":"{sid}", "userid":"{uid}", "doorid":"{0}"}'),
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
            "use_food": 
				Params.g('{"t":7002, "sid":"{sid}", "userid":"{uid}", "foodid":"{0}"}'),
				//return {rewards:{type:24, count:72000, rewardid:1200005}}
            "get_box_reward": 
				Params.g('{"t":5007, "sid":"{sid}", "userid":"{uid}"}'),
				//        return {
				//            rewards: [{
				//                type: 1,          // 奖励类型
				//                id: 3000005,      // 物品id
				//                count: 1,         // 数量
				//                rewardid: 18000241
				//            }]
				//        }
            "sync_gift_1": 
				Params.g('{"t":4003, "sid":"{sid}", "userid":"{uid}"}'),
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
            "sync_gift_2": 
				Params.g('{"t":4005, "sid":"{sid}", "userid":"{uid}"}'),
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
            "send_gift": 
				Params.g('{"t":4004, "sid":"{sid}", "userid":"{uid}", "id":"{0}", "gifttype":"{1}"}'),
			"receive_gift": 
				Params.g('{"t":4006, "sid":"{sid}", "userid":"{uid}", "id":"{0}"}'),
				//		return 
				//			{"msg":"铜*2,","rewards":[{"type":8,"count":2,"rewardid":1000010}]}
			"add_friend":
				Params.g('{"t":4009, "sid":"{sid}", "userid":"{uid}", "name":"{0}"}'),
				//		return
			"sync_moon_card": 
				Params.g('{"t":190202, "sid":"{sid}", "userid":"{uid}"}'),
				//		return {
				//			"days":[22,22,0,0],				// 月卡剩余次数: 低级,中级,矿工卡
				//			"isget":[false,false,false]}	// 是否收了
			"receive_moon_card": 
				Params.g('{"t":190201, "sid":"{sid}", "userid":"{uid}"}'),
			"switch_maze": 
				Params.g('{"t":5003, "sid":"{sid}", "userid":"{uid}", "mazeid":"{0}"}'),
			"sync_shendian": 
				Params.g('{"t":1401, "sid":"{sid}", "userid":"{uid}", "mazeid":"{0}"}'),
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
			"mine_dig":
				Params.g('{"t":2004, "sid":"{sid}", "userid":"{uid}", "x":"{0}", "y":"{1}", "cmd":"exploit", "time":"{time}"}'),
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
			"mine_pick":
				Params.g('{"t":2004, "sid":"{sid}", "userid":"{uid}", "x":"{0}", "y":"{1}", "cmd":"charge", "time":"{time}"}'),
			"open_story": 
				Params.g('{"t":5006, "sid":"{sid}", "userid":"{uid}", "type":"{0}"}'),
				//		return {"time":0}
			"start_story":
				Params.g('{"t":5005, "sid":"{sid}", "userid":"{uid}", "type":"{0}", "isxz":"{1}"}')
//				return {
//					"eventtype":1,
//					"report":{
//						"leftMG":{},
//						"rightMG":{},
//						"skillList":[],
//						"dodgeList":[false,true,false,false,false],
//						"damageValue":[[0,-103628],[0,0],[0,-103628],[-32270,0],[0,-97351]],
//						"xly":[],
//						"skip":1},
//					"iswin":true,
//					"rewards":[{"type":25,"count":180,"rewardid":2700014}]}
        };
    }
}
import flash.net.URLVariables;

class Params {
	
	public var u:String = "http://s1.wangamemxwk.u77.com/service/main.ashx";
	public var g:Boolean = false;
	public var d:Object = null;
	
	protected var _json:String = null;
	protected var _base:Object = null;
	protected var _args:Array = null;
	
	public function Params(j:String) {
		_json = j;
	}
	
	public static function g(j:String):Params {
		return new Params(j);
	}
	
	public function url(s:String):Params {
		u = s;
		return this;
	}
	
	public function post(b:Boolean):Params {
		g = !b;
		return this;
	}
	
	public function base(b:Object):Params {
		_base = b;
		return this;
	}
	
	public function args(args:Array):Params {
		_args = args;
		return this;
	}
	
	public function o():Params {
		var s:String = rpl(_json, "{uid}", _base.uid);
		s = rpl(s, "{sid}", _base.sid);
		s = rpl(s, "{time}", String(int(Math.random() * 1000000) + Math.random()));
		if (_args && _args.length) {
			for (var i:int = 0; i < _args.length; i ++) {
				s = rpl(s, "{" + i + "}", _args[i]);
			}
		}
		var json:Object = JSON.parse(s);
		var v:URLVariables = new URLVariables();
		for (var k:String in json) {
			v[k] = json[k];
		}
		d = v;
		return this;
	}
	
	protected function rpl(s:String, tag:String, to:String):String {
		if (s.indexOf(tag) != -1) return s.replace(tag, to);
		return s;
	}
	
}