package me.shunia.xsqst_helper.player
{
	public class PlayerManager
	{
		public function PlayerManager()
		{
		}
		
		public function init():void {
			var a:Array = Player.getSavedPlayers();
			for (var p:Player in a) {
				_e(this).emit("playerAdded", p);
			}
			
		}
		
	}
}