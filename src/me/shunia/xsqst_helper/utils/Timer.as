/**
 * Created by Çì·å on 2015/5/18.
 */
package me.shunia.xsqst_helper.utils {
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.Timer;

    public class Timer {

        private var _t:flash.utils.Timer = null;
        private var _cb:Function = null;
        private var _cp:Function = null;

        public function Timer(time:int, rp:int, cb:Function, cp:Function) {
            _cb = cb;
            _cp = cp;
            _t = new flash.utils.Timer(time, rp);
            _t.addEventListener(TimerEvent.TIMER, onTick);
            _t.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
            _t.start();
        }

        private function onTick(e:Event):void {
            if (_cb != null) _cb.apply(null);
        }

        private function onComplete(e:Event):void {
            if (_cp != null) _cp.apply(null);
            _cb = null;
            _cp = null;
            _t.removeEventListener(TimerEvent.TIMER, onTick);
            _t.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
            _t.stop();
            _t = null;
        }

    }
}
