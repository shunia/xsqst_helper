/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	import me.shunia.xsqst_helper.utils.Timer;
	
	public class Maze extends BaseModule {
	
	    private static const OPEN_BOX_TIME:int = 100;
	
	    private var _obt:Timer = null;
		
		public var raw:Object = null;
		public var mazes:Array = null;
		public var currentMazeId:String = null;
	    public var itl_enabled:Boolean = false;
	
	    public function Maze() {
			_reportName = "[关卡]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
			_ctx.service.on("sync_maze", function (data:Object):void {
				raw = data;
				currentMazeId = data.mazeid;
				mazes = data.list;
				
				start();
				_c(cb);
			});
	    }
		
		override public function start():void {
			openBox();
			startEvent();
		}
	
	    public function openBox():void {
	        if (!itl_enabled) return;
	
	        if (!_obt) {
	            _obt = new Timer(OPEN_BOX_TIME, 0, function ():void {
	
	                _ctx.service.on("get_box_reward", function (data:Object):void {
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
			var maze:Object = null;
			for each (var o:Object in mazes) {
				if (o.mazeid == currentMazeId) {
					maze = o;
					break;
				}
			}
			if (maze) {
				
			}
	    }
	
	    protected static const REPORT_TYPE_SYNC:int = 0;
	//    protected static const REPORT_TYPE_PVP_RESULT:int = 1;
	//    protected static const REPORT_TYPE_STOPPING:int = 2;
	    protected static const REPORT_TYPE_OPEN_BOX:int = 0;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null;
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
	                      c = "宝箱 -> " + args[0].length;
	                break;
	        }
	        return c;
	    }
	
	}
}
