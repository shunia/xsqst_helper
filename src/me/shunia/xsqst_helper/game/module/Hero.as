/**
 * Created by qingfenghuang on 2015/5/19.
 */
package me.shunia.xsqst_helper.game.module {
	
	public class Hero extends BaseModule{
	
		/**
		 * 战力 
		 */		
	    public var totalPower:int = 0;
		/**
		 * 当前出战英雄数 
		 */		
	    public var fightNum:int = 0;
		/**
		 * 最大可出战英雄数 
		 */		
	    public var fightNumMax:int = 0; 
		/**
		 * 英雄队列 
		 */		
		public var heros:Array = null;
		/**
		 * 出战英雄队列 
		 */		
		public var fightingHeros:Array = null;
	
	    public function Hero() {
			_reportName = "[英雄]";
	    }
	
	    override protected function onSync(cb:Function = null):void {
	        _ctx.service.on("sync_hero", function (data:Object):void {
	            totalPower = data.battlevalue;
	            fightNum = data.playingcount;
	            fightNumMax = data.playingcountmax;
				heros = data.list;
	            _c(cb);
	        }, 1);
	    }
	
	    public function init(o:Array):void {
			fightingHeros = o;
	    }
	}
}
