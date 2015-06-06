/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	import me.shunia.xsqst_helper.game.Ctx;
	import me.shunia.xsqst_helper.game.ICtxCls;
	
	public class BaseModule implements ICtxCls {
		
		protected var _inited:Boolean = false;
		protected var _reportName:String = "[模块]";
		
		protected var _itlEnabled:Boolean = false;
		protected var _itlDirty:Boolean = false;
	
	    public function BaseModule() {
	    }
		
		public function set itlEnabled(value:Boolean):void {
			if (value != _itlEnabled) _itlDirty = true;
			_itlEnabled = value;
			if (_inited && _itlDirty) {
				_itlDirty = false;
				report(REPORT_FUNCTIONGING);
			}
		}
		
		public function get itlEnabled():Boolean {
			return _itlEnabled;
		}
	
	    public function sync(cb:Function = null):void {
			if (!_inited) {
				_inited = true;
				report(REPORT_MODULE_OPEN);
				if (_inited && _itlDirty) {
					_itlDirty = false;
					report(REPORT_FUNCTIONGING);
				}
			}
//			_ctx.ui.log(_reportName, "sync");
			onSync(cb);
	    }
		
		protected function onSync(cb:Function = null):void {
			// override 
		}
	
	    public function start():void {
			if (!itlEnabled) return;
			
			onStart();
	    }
		
		protected function onStart():void {
			// override 
		}
	
	    protected function _c(cb:Function = null):void {
	        if (cb != null) cb();
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
			
		}
		
		protected function report(type:int, ...args):void {
			var c:String = null;
			if (type == REPORT_MODULE_OPEN) 
				c = "模块已启用";
			else if (type == REPORT_FUNCTIONGING) 
				c = "相关功能已" + (_itlEnabled ? "开启" : "关闭");
			else {
				args.unshift(type);
				c = onReport.apply(null, args);
			}
			if (c) _ctx.ui.log(_reportName, c);
		}
		
		protected function onReport(type:int, ...args):String {
			return "";
		}
		
		protected static const REPORT_MODULE_OPEN:int = -1;
		protected static const REPORT_FUNCTIONGING:int = -2;
		
	}
}