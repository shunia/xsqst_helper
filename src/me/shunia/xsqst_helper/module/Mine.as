/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
import flash.geom.Point;

public class Mine extends BaseModule{

    // 当前剩余挖矿次数
    public var digTime:int = 0;
    public var lastPoint:Point = new Point();
    public var map:Array = null;
    public var queue:Array = null;

    public function Mine() {
    }

    override public function sync(cb:Function = null):void {
        Global.service.batch(
                function ():void {
                    start();

                    _c(cb);
                },
                [
                    "sync_mine",
                    function (d1:Object):void {
                        digTime = d1.szg;
                    }
                ],
                [
                    "sync_mine_num",
                    function (d2:Object):void {

                    }
                ]
        );
    }

    override public function start():void {
        startMap();
        startQueue();
    }

    protected function startMap():void {
        if (map == null) {
            Global.service.on("sync_mine_nodes",
                    function (data:Object):void {
                        lastPoint.x = data.px;
                        lastPoint.y = data.py;
                        map = data.list;

                        Global.ui.drawMap(map);
                    });
        }
    }

    protected function startQueue():void {
        Global.service.on("sync_mine_queue", function (data:Object):void {
            // 是否有正在进行的队列
            queue = data as Array;
            var l:int = queue.length;
            for (var i:int = l - 1; i >= 0; i --) {
                var o:Object = queue[i];
                // 有sid才说明是一个正在工作的队列，否则说明可以开始队列
                if (o.hasOwnProperty("sid") && o["sid"] != 0) {
                    if (o.time == 0) {
                        Global.service.on("mine_queue_harvest", function (data:Object):void {
                            for each (var i:Object in data.rewards) {
                                // 加到用户身上
                                Global.user.reward(i);
                            }
                        })
                    }
                } else {
                    Global.service.on("mine_queue_add", function (data:Object):void {
                        // 工坊之后主动同步一次
                        sync();
                    }, o["id"]);
                }
            }
        });
    }

    public function report():void {
        trace("Mine Data: ", digTime);
    }

}
}
