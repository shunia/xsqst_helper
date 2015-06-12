/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	import flash.geom.Point;
	
	public class Mine extends BaseModule{
	
	    private static const CONF:Object = {
	        queue: [],
	        job: [
	            {
	                id: 10001,
	                name: "浅表L1",
	                cost: 20,
	                time: 60 * 60,
	                receive: [0, 0, 0]          // 收获类型
	            },
	            { id: 10002, name: "浅表L2", cost: 40, time: 120 * 60, receive: [] },
	            { id: 10003, name: "浅表L3", cost: 80, time: 240 * 60, receive: [] },
	            { id: 10004, name: "中层L1", cost: 20, time: 60 * 60, receive: [0, 0, 0] },
	            { id: 10005, name: "中层L2", cost: 40, time: 120 * 60, receive: []},
	            { id: 10006, name: "中层L3", cost: 80, time: 240 * 60, receive: []},
	            { id: 10007, name: "深层L1", cost: 20, time: 60 * 60, receive: [0, 0, 0]},
	            { id: 10008, name: "深层L2", cost: 40, time: 120 * 60, receive: []},
	            { id: 10009, name: "深层L3", cost: 80, time: 240 * 60, receive: []},
	            { id: 10010, name: "地心L1", cost: 20, time: 60 * 60, receive: [0, 0, 0]},
	            { id: 10012, name: "地心L2", cost: 40, time: 120 * 60, receive: []},
	            { id: 10013, name: "地心L3", cost: 80, time: 240 * 60, receive: []}
	        ]
	    };
	
	    public var refreshTime:int = 0;
	    public var monsterLV:int = 0;
	    public var monsterNum:int = 0;
	    // 当前剩余挖矿次数
	    public var digTime:int = 0;
	    public var digTimeMax:int = 0;
	    public var lastPoint:Point = new Point();
	    public var map:Array = null;
	    public var house:Object = null;
	    public var res:Array = null;
	    public var resOpened:Array = null;
	    public var items:Array = null;
	
	    public var itl_job_high_cost_first:Boolean = false;
	
	    public function Mine() {
	        house = CONF;
			_reportName = "[挖矿]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.batch(
	                function ():void {
	//                    report(REPORT_TYPE_SYNC);
	                    start();
	
	                    _c(cb);
	                },
	                [
	                    "sync_mine",
	                    function (d1:Object):void {
	                        refreshTime = d1.time;
	                        digTime = d1.szg;
	                        digTimeMax = d1.szgmax;
	                        monsterLV = d1.monsterlv;
	                        monsterNum = d1.monstercount;
	                        items = [d1.slszg, d1.lg];
	                    }
	                ],
	                [
	                    "sync_mine_num",
	                    function (d2:Object):void {
	                        res = d2.res;
	                        resOpened = d2.resisopen;
	                    }
	                ]
	        );
	    }
	
	    override protected function onStart():void {
	        startMap();
	        startQueue();
	    }
	
	    protected function startMap():void {
	        if (map == null) {
	            _ctx.service.on("sync_mine_nodes",
	                    function (data:Object):void {
	                        lastPoint.x = data.px;
	                        lastPoint.y = data.py;
	                        map = data.list;
	
	//                        _ctx.ui.drawMap(map);
	                    });
	        }
	    }
	
	    protected function startQueue():void {
	        _ctx.service.on("sync_mine_queue", function (data:Object):void {
	            // 是否有正在进行的队列
	            house.queue = data as Array;
				if (house.queue) {
		            var l:int = house.queue.length;
		            for (var i:int = l - 1; i >= 0; i--) {
		                var o:Object = house.queue[i];
		                // 有sid才说明是一个正在工作的队列，否则说明可以开始队列
		                if (o.hasOwnProperty("sid") && o["sid"] != 0) {
		                    if (o.time == 0) {
		                        _ctx.service.on("mine_queue_harvest", function (data:Object):void {
		                            for each (var i:Object in data.rewards) {
		                                // 加到用户身上
		                                _ctx.game.reward(i);
		                            }
		                            report(REPORT_TYPE_HARVEST);
		                        }, o.id);
		                    } else {
		                        // 有坑被占了
		                        l--;
		                        report(REPORT_TYPE_JOB_TIME, o.time);
		                    }
		                }
		            }
				}
				if (house.job) {
		            var j:int = 0, jl:int = house.job.length - 1;
		            for (j; j < jl && l > 0; j++) {
		                if (house.job[j] && house.job[j].cost <= digTime) {
		                    // 有新开工的
		                    l--;
		                    _ctx.service.on("mine_queue_add", function (data:Object):void {
		                        // 通知
		                        report(REPORT_TYPE_JOB, j);
		                        // 工坊之后主动同步一次
		                        sync();
		                    }, house.job[j].id);
		                }
		            }
				}
	        });
	    }
	
	    protected static const REPORT_TYPE_SYNC:int = 0;
	    protected static const REPORT_TYPE_JOB:int = 1;
	    protected static const REPORT_TYPE_HARVEST:int = 2;
	    protected static const REPORT_TYPE_JOB_TIME:int = 3;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
	        switch (type) {
	//            case REPORT_TYPE_SYNC :
	//                    c += "矿镐刷新时间 -> " + Time.secToFull(refreshTime);
	//                    c += "    剩余次数 -> " + digTime;
	//                    c += "    小黄人等级 -> " + monsterLV;
	//                    c += "    小黄人数量 -> " + monsterNum;
	//                break;
	            case REPORT_TYPE_JOB :
	                    c = "工坊[" + house.job[args[0]].name + "]开始工作";
	                break;
	            case REPORT_TYPE_HARVEST :
	                    c = "工坊收获";
	                break;
	            case REPORT_TYPE_JOB_TIME :
	//                    c += "工坊收获还剩 -> " + Time.secToFull(args[0]);
	                break;
	        }
	        return c;
	    }
	
	}
}
