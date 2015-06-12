package me.shunia.xsqst_helper.utils
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.Dictionary;

	public class LocalCookie
	{
		
		protected static var _session:Dictionary = null;
		private var _s:SharedObject = null;
		
		public function LocalCookie(name:String, domain:String = "/")
		{
			_s = SharedObject.getLocal(name, domain);
			_s.flush(10000);
		}
		
		public static function from(name:String, domain:String = "/"):LocalCookie {
			if (!_session) _session = new Dictionary();
			name = name.toLowerCase();
			domain = domain.toLowerCase();
			var k:String = domain + name;
			if (!_session.hasOwnProperty(k)) _session[k] = new LocalCookie(name, domain);
			return _session[k];
		}
		
		public function has(k:String):Boolean {
			return _s && _s.data && _s.data.hasOwnProperty(k);
		}
		
		public function get(k:String):* {
			if (has(k)) return _s.data[k];
			return null;
		}
		
		public function save(k:String, v:*):LocalCookie {
			if (_s) {
				_s.data[k] = v;
			}
			return this;
		}
		
		public function close():void {
			if (_s) {
				_s.close();
			}
		}
		
		public function flush():void {
			if (_s) {
				var s:String = _s.flush();
				if (s) {
					switch (s) {
						case SharedObjectFlushStatus.PENDING : 
							_s.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
							break;
						case SharedObjectFlushStatus.FLUSHED : 
							break;
					}
				}
			}
		}
		
		protected function onStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "SharedObject.Flush.Success" : 
					break;
				case "SharedObject.Flush.Failed" : 
					trace("[local cookie]", "Save denied");
					break;
			}
			_s.removeEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
	}
}