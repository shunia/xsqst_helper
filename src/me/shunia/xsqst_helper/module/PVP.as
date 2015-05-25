/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	import me.shunia.xsqst_helper.utils.Timer;
	
	public class PVP extends BaseModule{
	
	    public static const TOTAL_F_NUM:int = 10;
	    private static const MATCH_INTERVAL:int = 5;
	    private static const FAIL_WAITE_INTERVAL:int = 5 * 60;
	
	    public var fNum:int = 0;
	    public var refresh_time:int = 0;
	    public var oponents:Array = null;
		public var raw:Object = null;
		public var win:int = 0;
	    private var _rt:Timer = null;
	    private var _ft:Timer = null;
	    private var _fightStarted:Boolean = false;
	
	    public var itl_enabled:Boolean = false;
		private var _inited:Boolean = false;
	
	    //                "id":1668043,
	    //                "sex":0,
	    //                "figure":"19000001",
	    //                "username":"狄奥尼索斯",
	    //                "battlevalue":142700,
	    //                "lv":0,
	    //                "iswin":0,
	    //                "userid":0
	    public function PVP() {
			_reportName = "[竞技]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.on("sync_pvp", function (data:Object):void {
				raw = data;
	            refresh_time = data.time;
	            oponents = data.list;
				var i:int = win = 0;
				while (i < oponents.length) {
					if (oponents[i].iswin) win ++;
					i ++;
				}
	            fNum = TOTAL_F_NUM - data.arenacount;
				
	//            report(REPORT_TYPE_SYNC);
	            start();
	
	            _c(cb);
	        });
	    }
	
	    override public function start():void {
	        if (!itl_enabled) return;
	
//	        if (_rt == null) {
//	            _rt = new Timer(refresh_time, 1, function ():void {
//	                refresh_time = 0;
//	            });
//	        }
	        startPVP();
			
			startReward();
	    }
		
		protected function startPVP():void {
			if (!fNum) {
				if (_ft) {
					_ft.stop();
					_ft = null;
				}
				return;
			}
			var o:Object = getNextToFight();
			if (!o) {
				if (_ft) {
					_ft.stop();
					_ft = null;
				}
				return;
			}
			
			report(REPORT_TYPE_AUTO_FIGHT_START);
			// 异步游标，用来记录当前打到第几个
			var f:Function = function ():void {
				_ctx.service.on("pvp_match", function (data:Object):void {
					if (!data.iswin) 
						_ft.time = FAIL_WAITE_INTERVAL;  // 如果失败，就把下一次pvp的时间延后
					else {
						// 胜利就打下一个
						win ++;
						_ft.time = MATCH_INTERVAL;
					}
					o.iswin = data.iswin;
					report(REPORT_TYPE_PVP_RESULT, o, o.id, data);
					startPVP();
				}, o.id);
			};
			
			if (!_ft) {
				_ft = new Timer();
				_ft.time = MATCH_INTERVAL;
				_ft.rp = 1;
				_ft.cb = f;
			}
			_ft.start();
		}
		
		protected function getNextToFight():Object {
			var b:Boolean = true, i:int = 0, o:Object = null;
			while (b) {
				o = oponents[i];
				if (!o.iswin) {
					b = false;
				}
				i ++;
			}
			return o;
		}
		
		protected function startReward():void {
			if (win >= 1 && raw.arenabox1isget == 0)
				pvpReward(1);
			if (win >= 4 && raw.arenabox2isget == 0)
				pvpReward(4);
			if (win >= 9 && raw.arenabox3isget == 0)
				pvpReward(9);
		}
		
		protected function pvpReward(index:int = 1):void {
			_ctx.service.on("pvp_reward", function (data:Object):void {
				if (!(data.ret == 1))
					report(REPORT_TYPE_REWARD, index);
			}, index);
		}
	
	    protected static const REPORT_TYPE_SYNC:int = 0;
	    protected static const REPORT_TYPE_PVP_RESULT:int = 1;
	    protected static const REPORT_TYPE_STOPPING:int = 2;
	    protected static const REPORT_TYPE_REWARD:int = 3;
		protected static const REPORT_TYPE_AUTO_FIGHT_START:int = 4;
	
	    override protected function onReport(type:int, ...args):String {
	        var c:String = null, t1:Object = null;
	        switch (type) {
	            case REPORT_TYPE_PVP_RESULT :
	                    var a:Object = args[0], i:int = args[1], data:Object = args[2];
	                    c = "与[" + a.username + "](战力" + a.battlevalue + ")";
	                    c += "的战斗结果[" + data.iswin ? "胜利" : "失败" + "]";
	                break;
	            case REPORT_TYPE_STOPPING :
	                    c = "战斗" + (fNum == 0 ? "次数耗尽" : "打完了");
	                break;
//	            case REPORT_TYPE_SYNC :
//	                    c = "刷新时间 -> " + Time.secToFull(refresh_time);
//	                    c += "    剩余次数 -> " + fNum;
	                break;
	            case REPORT_TYPE_REWARD :
	                    c = "[" + args[0] + "]胜奖励已领取";
	                break;
				case REPORT_TYPE_AUTO_FIGHT_START : 
					c = "自动战斗开始";
					break;
	        }
			return c;
	    }
	}
}
