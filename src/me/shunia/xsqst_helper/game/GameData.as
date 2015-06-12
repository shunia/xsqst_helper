package me.shunia.xsqst_helper.game
{
	
	public class GameData
	{
		
		public var version:String = "2.2.11";
		
		public var name:String = null;
		public var sid:String = null;
		public var uid:String = null;
		public var avatar:String = null;
		
		public function set raw(value:Object):void {
			if (value) {
				name = value.display_name;
				sid = value.sid;
				uid = value.uid;
				avatar = value.display_avatar;
			}
		}
		
		public static function fromRaw(data:Object):GameData {
			var g:GameData = new GameData();
			g.raw = data;
			return g;
		}
		
		public static function fromSaved(data:Object):GameData {
			var g:GameData = new GameData();
			g.avatar = data.avatar;
			g.sid = data.sid;
			g.uid = data.uid;
			g.name = data.name;
			g.version = data.version;
			return g;
		}
		
	}
}