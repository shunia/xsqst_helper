package me.shunia.xsqst_helper
{
	import flash.net.URLRequestDefaults;
	
	import me.shunia.xsqst_helper.utils.Req;
	import me.shunia.xsqst_helper.utils.ReqParams;
	
	public class GeneralService
	{
		
		private static var _inited:Boolean = false;
		private static function init():void {
			if (!_inited) {
				_inited = true;
				URLRequestDefaults.manageCookies = false;
				URLRequestDefaults.userAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101 Firefox/38.0";
			}
		}
		
		public static function on(p:ReqParams, c:Function):void {
			init();
			if (p) {
				// make sure every thins is done within
				p.o();
				// start load with details
				new Req().load(p.u, p.g, p.d, function (data:String, ...args):void {
					var ps:Array = null;
					ps = p.resHeader ? [data, args[0]] : [data];
					
					if (ps) c.apply(null, ps);
				}, p.reqHeader, p.resHeader);
			}
		}
		
		public static function batch(c:Function = null, ...args):void {
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
		
	}
}