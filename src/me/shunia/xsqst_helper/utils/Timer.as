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
            return _time / 1000;
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

        public function set cb(value:Function):void {
            _cb = value;
        }

        public function start():void {
            if (_time > 2 && rp >= 0) {
                _t = new flash.utils.Timer(_time, _rp);
                _t.addEventListener(TimerEvent.TIMER, onTick);
                _t.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
                _t.start();
                onTick(null);             // tick at the beginning
            }
        }

        public function tick():void {
            onTick(null);
        }

        public function stop():void {
            _t.stop();
            onComplete(null);
        }

        public function Timer(time:Number = 0, rp:int = 0, cb:Function = null, cp:Function = null) {
            this.time = time;
            this.rp = rp;
            _cb = cb;
            _cp = cp;
            start();
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
