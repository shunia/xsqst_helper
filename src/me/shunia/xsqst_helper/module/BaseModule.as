/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.module {
	
	import me.shunia.xsqst_helper.User;
	
	public class BaseModule implements ICtxCls {
	
	    protected var _context:User = null;
		protected var _inited:Boolean = false;
		protected var _reportName:String = "[]";
	
	    public function BaseModule() {
	    }
		
	    public function setContext(context:User):BaseModule {
	        _context = context;
	        return this;
	    }
		
		public function getContext():User {
			return _context;
		}
	
	    public function sync(cb:Function = null):void {
			if (!_inited) {
				_inited = true;
				report(REPORT_FUNC_START);
				onSync(cb);
			}
	    }
		
		protected function onSync(cb:Function = null):void {
			
		}
	
	    public function start():void {
	
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
			if (type == REPORT_FUNC_START) 
				c = "模块已开启";
			else {
				args.unshift(type);
				c = onReport.apply(null, args);
			}
			if (c) _ctx.ui.log(_reportName, c);
		}
		
		protected function onReport(type:int, ...args):String {
			return "";
		}
		
		protected static const REPORT_FUNC_START:int = -1;
		
	}
}