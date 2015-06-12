package me.shunia.xsqst_helper.utils
{
	public class P
	{
		protected var _queue:Array = [];
		protected var _cb:Function = null;
		protected var _errorCB:Function = null;
		protected var _error:* = null;
		protected var _result:* = null;
		
		public function then(cb:Function):P {
			_queue.push(cb);
			next();
			return this;
		}
		
		protected function next():void {
			if (_error) {
				_queue = [];
			}
			if (_queue.length == 0 && _error) {
				reject();
			} else if (!_cb && _queue.length) {
				_cb = _queue.shift();
				handle();
			}
		}
		
		public function error(cb:Function):P {
			_errorCB = cb;
			return this;
		}
		
		protected function handle():P {
			_cb.apply(null, [
				function (error:*, ...args):void {
					_cb = null;
					_error = error;
					_result = args;
					next();
				}
			].concat(_result));
			return this;
		}
		
		protected function reject():void {
			_errorCB.apply(null, [_error]);
		}
	}
}