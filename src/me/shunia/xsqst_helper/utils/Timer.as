/**
 * Created by 庆峰 on 2015/5/18.
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
        private var _time:int = 0;
        private var _rp:int = 0;

        public function set time(value:Number):void {
            if (value * 1000 != _time) {
                _time = value * 1000;
                if (_t) _t.delay = _time;
            }
        }
        public function get time():Number {
            return _time;
        }

        public function set rp(value:int):void {
            if (value != _rp) {
                _rp = value;
                if (_t) _t.repeatCount = _rp;
            }
        }
        public function get rp():int {
            return _rp;
        }

        public function tick():void {
            onTick(null);
        }

        public function stop():void {
            onComplete(null);
        }

        public function Timer(time:Number, rp:int, cb:Function, cp:Function = null) {
            this.time = time;
            this.rp = rp;
            _cb = cb;
            _cp = cp;
            if (time > 0.02 && rp >= 0) {
                _t = new flash.utils.Timer(this.time, this.rp);
                _t.addEventListener(TimerEvent.TIMER, onTick);
                _t.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
                _t.start();
                tick();             // tick at the beginning
            }
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
