package me.shunia.xsqst_helper
{
	import me.shunia.xsqst_helper.game.GameData;
	import me.shunia.xsqst_helper.utils.LocalCookie;

	public class Player
	{
		
		protected static var instance:Player = null;
		
		protected var _datas:Array = null;
		
		public function Player()
		{
		}
		
		public static function current():Player {
			if (instance == null) instance = new Player();
			return instance;
		}
		
		public function init():void {
			_datas = getSavedPlayers() || [];
			var arr:Array = [], g:GameData = null;
			for each (var data:Object in _datas) {
				g = GameData.fromSaved(data);
				arr.push(g);
				_e().emit("gameDataAdded", g);
			}
			_datas = arr;
		}
		
		protected function getSavedPlayers():Array {
			var c:LocalCookie = LocalCookie.from("xsqst");
			return c.get("gameData");
		}
		
		public function update(data:Object):void {
			var gameData:GameData = GameData.fromRaw(data);
			save(gameData);
			_e().emit("gameDataAdded", gameData);
		}
		
		protected function save(data:GameData):void {
			var valid:Boolean = true;
			for each (var d:GameData in _datas) {
				if (d.uid == data.uid) {
					valid = false;
					break;
				}
			}
			if (valid) {
				_datas.push(data);
			}
			var c:LocalCookie = LocalCookie.from("xsqst");
			c.save("gameData", _datas);
		}
		
	}
}