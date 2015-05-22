/**
 * Created by qingfenghuang on 2015/5/20.
 */
package me.shunia.xsqst_helper.module {
import me.shunia.xsqst_helper.Service;

/**
 * {"id":18033,"foodid":1,"count":5},
 * {"id":17514,"foodid":2,"count":8},
 * {"id":17517,"foodid":3,"count":1},
 * {"id":17960,"foodid":4,"count":16},
 * {"id":17961,"foodid":5,"count":0},
 * {"id":17833,"foodid":6,"count":1},
 * {"id":17516,"foodid":7,"count":0},
 * {"id":17891,"foodid":8,"count":0},
 * {"id":17513,"foodid":9,"count":2},
 * {"id":17515,"foodid":11,"count":6},
 * {"id":18043,"foodid":12,"count":5}
 */
public class Food extends BaseModule {

    public static const CONF:Object = {
        "1": {name:"饱食草", hunger:21600, id:18033, count:0},
        "2": {name:"梅子便当", hunger:28800, id:17514, count:0},
        "3": {name:"爱心蛋包饭", hunger:36000, id:18033, count:0},
        "4": {name:"一乐拉面", hunger:54000, id:18033, count:0},
        "5": {name:"牛肉盖浇饭", hunger:72000, id:18033, count:0},
        "6": {name:"巨无霸汉堡", hunger:54000, power:100, id:18033, count:0},
        "7": {name:"醋昆布", hunger:3600, id:18033, count:0},
        "8": {name:"林檎糖", hunger:7200, id:18033, count:0},
        "9": {name:"棒棒糖", hunger:10800, id:18033, count:0},
        "10": {name:"章鱼小丸子", hunger:18000, id:18033, count:0},
        "11": {name:"草莓蛋糕", hunger:21600, id:18033, count:0},
        "12": {name:"以太巧克力", hunger:18000, power:100, id:18033, count:0}
    };
    public static const TOTAL_HUNGER:int = 72000;
    public static const FOOD_1:int = 1;
    public static const FOOD_2:int = 2;
    public static const FOOD_3:int = 3;
    public static const FOOD_4:int = 4;
    public static const FOOD_5:int = 5;
    public static const FOOD_6:int = 6;
    public static const FOOD_7:int = 7;
    public static const FOOD_8:int = 8;
    public static const FOOD_9:int = 9;
    public static const FOOD_10:int = 10;
    public static const FOOD_11:int = 11;
    public static const FOOD_12:int = 12;

    /**
     * 饱食度
     */
    public var hunger:int = 0;
    public var foods:Object = null;

    public var itl_enabled:Boolean = false;
    protected var _itl_power_item_first:Boolean = true;
    protected var _itl_main_food_first:Boolean = true;
    protected var _itl_keep_full:Boolean = false;
    protected var _itl_no_small_food:Boolean = false;

    protected var _disabledFoods:Array = [];

    public function Food() {
        super();
    }

    override public function sync(cb:Function = null):void {
        Service.on("sync_food", function (data:Object):void {
            var a:Array = data as Array;
            foods = foods == null ? CONF : foods;
            for each (var item:Object in a) {
                var o:Object = foods[item.foodid];
                o.id = item.id;
                o.count = item.count;
            }

            start();

            _c(cb);
        });
    }

    override public function start():void {
        if (!itl_enabled) return;

        intellgent();
        getNextFood(function (id:int):void {
            if (id) useFood(id);
        });
    }

    protected function intellgent():void {

    }

    protected function getNextFood(cb:Function = null):void {
        var i:int = 0;
        if (_itl_power_item_first) i = checkFull([FOOD_6, FOOD_12]);
        if (!i && _itl_main_food_first) i = checkFull([FOOD_5, FOOD_4, FOOD_3, FOOD_2, FOOD_1]);
        if (!i) i = checkFull([FOOD_11, FOOD_10, FOOD_9, FOOD_8, FOOD_7]);
        cb(i);
    }

    protected function checkFull(ids:Array):int {
        for each (var id:int in ids) {
            if (
                    _disabledFoods.indexOf(id) ==  -1 &&                // 让吃
                    foods[id].count > 0 &&                              // 有
                    hunger + foods[id].hunger <= TOTAL_HUNGER           // 吃了不会越界
            )
                return id;
        }
        return 0;
    }

    public function useFood(foodid:int):void {
        Service.on("use_food", function (data:Object):void {
            if (data.ret == 1) {
                if (_disabledFoods.indexOf(foodid) == -1) _disabledFoods.push(foodid);
            } else {
                hunger += data.count;
                Global.ui.log("Food: ", foods[foodid].name, ",add hunger: ", data.count);
            }
        }, foodid);
    }

}
}
