package
{
	import flash.utils.Dictionary;
	
	import me.shunia.xsqst_helper.Service;
	import me.shunia.xsqst_helper.User;
	import me.shunia.xsqst_helper.ui.UI;

	public class Ctx
	{
		
		private static var _id:int = -1;
		private static var _ctxDict:Dictionary = new Dictionary();
//		private static var _ctxRelationDict:Dictionary = new Dictionary();
		
		public static function getCtx(key:* = null):Ctx {
//			var t:String = null;
//			if (key) t = typeof key;
//			
//			if (!key || t == "string") {
				if (key && _ctxDict.hasOwnProperty(key)) return _ctxDict[key];
				
				_id ++;
				if (!key) key = "ctx::" + _id;
				var ctx:Ctx = new Ctx(key);
				_ctxDict[key] = ctx;
//				_ctxRelationDict[ctx.user] = ctx;
//				_ctxRelationDict[ctx.ui] = ctx;
//			} else {
//				if (_ctxRelationDict.hasOwnProperty(key)) return _ctxRelationDict[key];
//			}
			
			return new Ctx(key);
		}
		
		public static function getAllCtx():Dictionary {
			return _ctxDict;
		}
		
		private var _id:String = "";
		
		public var version:String = "2.2.7";
		public var sid:String = "4nwzaecyb0rqav1iannx1xtr";
		public var uid:String = "9201";
		
		public var user:User = null;
		public var ui:UI = null;
		public var service:Service = null;
		public function Ctx(id:String)
		{
			_id = id;
			service = new Service(sid, uid);
			user = g(User);
			ui = g(UI);
		}
		
		public function g(cls:Class):* {
			var c:ICtxCls = new cls() as ICtxCls;
			if (c) c.ctx = this;
			return c;
		}
		
	}
}