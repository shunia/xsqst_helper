package me.shunia.xsqst_helper.utils
{
	import flash.filesystem.File;
	
	import air.update.ApplicationUpdater;
	import air.update.events.UpdateEvent;

	/**
	 * 最简化的自动更新器.
	 *  
	 * @author qingfenghuang
	 */	
	public class Updater
	{
		
		private var _u:ApplicationUpdater = null;
		
		public function Updater(updateConfUrl:String)
		{
			_u = new ApplicationUpdater();
			_u.configurationFile = new File(updateConfUrl);
			_u.addEventListener(UpdateEvent.INITIALIZED, onInit);
			_u.initialize();
		}
		
		protected function onInit(e:UpdateEvent):void {
			_u.checkNow();
		}
	}
}