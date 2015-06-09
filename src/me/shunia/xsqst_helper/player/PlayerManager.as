package me.shunia.xsqst_helper.player
{
	public class PlayerManager
	{
		
		protected var _currentPlayers:Array = null;
		
		public function PlayerManager()
		{
			_currentPlayers = [];
		}
		
		public function init():void {
			var a:Array = Player.getSavedPlayers();
			for (var p:Player in a) {
				if (_currentPlayers.indexOf(p) == -1) {
					_currentPlayers.push(p);
					_e(this).emit("playerAdded", p);
				}
			}
			
		}
		
	}
}