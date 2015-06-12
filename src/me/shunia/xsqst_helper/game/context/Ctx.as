package me.shunia.xsqst_helper.game.context
{
	import flash.utils.Dictionary;
	
	import me.shunia.xsqst_helper.game.module.Bag;
	import me.shunia.xsqst_helper.game.module.BaseModule;
	import me.shunia.xsqst_helper.game.module.Food;
	import me.shunia.xsqst_helper.game.module.Gift;
	import me.shunia.xsqst_helper.game.module.Hero;
	import me.shunia.xsqst_helper.game.module.Maze;
	import me.shunia.xsqst_helper.game.module.Mine;
	import me.shunia.xsqst_helper.game.module.PVP;
	import me.shunia.xsqst_helper.game.module.Summon;
	import me.shunia.xsqst_helper.game.ui.GameOverView;
	import me.shunia.xsqst_helper.utils.Timer;
	import me.shunia.xsqst_helper.game.module.Game;
	import me.shunia.xsqst_helper.game.GameConf;
	import me.shunia.xsqst_helper.game.GameData;
	import me.shunia.xsqst_helper.game.GameService;

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
			
			return ctx;
		}
		
		public static function getAllCtx():Dictionary {
			return _ctxDict;
		}
		
		
		public var id:String = "";
		
		public var data:GameData = null;
		public var ui:GameOverView = null;
		public var service:GameService = null;
		
		public static const SYNC_TIME:int = 10;	//全局同步更新时间
		public var conf:GameConf = null;			// 配置文件
		public var game:Game = null;		// 主数据同步
		public var food:Food = null;      		// 食物
		public var bag:Bag = null;        		// 包裹
		public var mine:Mine = null;      		// 挖矿
		public var summon:Summon = null;  		// 招募
		public var pvp:PVP = null;        		// pvp
		public var gift:Gift = null;      		// 礼物
		public var hero:Hero = null;      		// 英雄
		public var maze:Maze = null;      		// 关卡
		
		private var _queue:Array = null;    	// 同步方法队列，用于每过一段时间自动同步
		private var _ft:Timer = null;			// 同步计时器
		
		public function Ctx(id:String)
		{
			this.id = id;
			ui = g(GameOverView);
		}
		
		public function init(data:GameData):void {
			this.data = data;
			service = new GameService(data.sid, data.uid);
			createModules();
			start();
		}
		
		protected function createModules():void {
			_queue = [];
			var ctx:Ctx = this,
				fn:Function = 
				function (cls:Class):ICtxCls {
					var ic:BaseModule = new cls() as BaseModule;
					ic.ctx = ctx;
					_queue.push(ic.sync);
					return ic;
				};
			game = fn(Game);
			food = fn(Food);
			bag = fn(Bag);
			mine = fn(Mine);
			summon = fn(Summon);
			pvp = fn(PVP);
			gift = fn(Gift);
			hero = fn(Hero);
			maze = fn(Maze);
		}
		
		protected function start():void {
			if (!_ft) {
				var f:Function = function ():void {
					var q:Array = _queue.concat(), 
						n:Function = function ():void {
							if (q.length > 0) {
								var t:Function = q.shift();
								t(n);
							} else {
								onAllSynced();
							}
						};
					n.apply();
				}
				_ft = new Timer(SYNC_TIME, 0, f);
			}
		}
		
		protected function onAllSynced():void {
			_e(this).emit("allSynced");
		}
		
		public function g(cls:Class):* {
			var c:ICtxCls = new cls() as ICtxCls;
			if (c) c.ctx = this;
			return c;
		}
		
	}
}