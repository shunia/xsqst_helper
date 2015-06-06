/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	
	public class Maze extends BaseModule {
		
		public var box:Box = null;
		public var story:Story = null;
		public var maze:MazeData = null;
		public var raw:Object = null;
	
	    public function Maze() {
			_reportName = "[关卡]";
			maze = new MazeData();
			box = new Box(onOpenBox);
			story = new Story(onCompleteStory);
	    }
		
	    override protected function onSync(cb:Function = null):void {
			_ctx.service.on("sync_maze", function (data:Object):void {
				raw = data;
				maze.id = data.mazeid;
				maze.data = data.list;
				_c(cb);
			});
	    }
		
		protected function onCompleteStory(index:int):void {
			_ctx.service.on("start_story", function (data:Object):void {
				if (data.ret != 1) report(REPORT_TYPE_COMPLETE_STORY, maze.id, index);
			}, index, 0);
		}
		
		protected function onOpenBox():void {
            _ctx.service.on("get_box_reward", function (data:Object):void {
                if (data.ret != 1) {
                    for each (var i:Object in data.rewards) {
                        _ctx.user.reward(i);
                    }
					
                    report(REPORT_TYPE_OPEN_BOX, data.rewards);
                }
            });
	    }
	
	    protected static const REPORT_TYPE_SYNC:int = 0;
	//    protected static const REPORT_TYPE_PVP_RESULT:int = 1;
	//    protected static const REPORT_TYPE_STOPPING:int = 2;
	    protected static const REPORT_TYPE_OPEN_BOX:int = 1;
		protected static const REPORT_TYPE_COMPLETE_STORY:int = 2;
	
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
	                      c = "开启宝箱[" + args[0].length + "]";
	                break;
				  case REPORT_TYPE_COMPLETE_STORY : 
					  c = "完成迷宫[" + args[0] + "]故事[" + args[1] + "]";
					  break;
	        }
	        return c;
	    }
	
	}
}
import me.shunia.xsqst_helper.utils.Timer;

class MazeData {
	
	public var id:int = 0;
	public var all:Array = null;
	
	public function MazeData() {
		
	}
	
	public function set data(value:Array):void {
		all = value;
	}
	
}

class Box {
	
	public var maxTime:int = 0;
	
	protected var _count:int = 0;
	protected var _time:int = 0;
	protected var _t:Timer = null;
	protected var _handler:Function = null;
	
	public function Box(openHandler:Function) {
		_handler = openHandler;
	}
	
	public function set count(value:int):void {
		_count = value;
		if (_count > 0) {
			_handler();
			_count = 0;
		}
	}
	public function get count():int {
		return _count;
	}
	
	public function set time(value:int):void {
		_time = value;
		if (_time) {
			if (!_t) _t = new Timer(350, 1, null, onTime);
			_t.time = _time;
		}
	}
	public function get time():int {
		return _time;
	}
	
	protected function onTime():void {
		_t = null;
		if (_handler) _handler();
	}
	
}

class Story {
	
	protected var _completes:Array = null;
	protected var _times:Array = null;
	protected var _handler:Function = null;
	
	public function Story(completeHandler:Function) {
		_handler = completeHandler;
	}
	
	public function set data(value:Object):void {
		_times = [value.event1time, value.event2time, value.event3time];
		_completes = [value.event1iscomplete, value.event2iscomplete, value.event3iscomplete];
		for (var i:int = 0; i < _completes.length; i ++) {
			if (!_completes[i] && _times[i] >= 800) {
				_handler(i + 1);
			}
		}
	}
	
}