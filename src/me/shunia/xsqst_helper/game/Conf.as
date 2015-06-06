/**
 * Created by qingfenghuang on 2015/5/20.
 */
package me.shunia.xsqst_helper.game {
import flash.utils.Dictionary;

import me.shunia.xsqst_helper.utils.Timer;

public class Conf {

    private static const STRS:Array = [
            "升级经验表",
            "英雄勇者",
            "宿命锻造",
            "宿命武具",
            "徽记",
            "矿物列表",
            "食物",
            "冒险地点",
            "升级经验战力结算",
            "武具强化",
            "道具表",
            "背包格数和升级",
            "矿脉属性",
            "十字镐",
            "尘土徽记和宿命武具获得",
            "招募",
            "英雄技能",
            "被动技能",
            "动作和特效表_角色动作",
            "动作和特效表_场景特效",
            "TIP配置",
            "事件表",
            "怪物组",
            "奖励事件掉落组",
            "额外成功率价格",
            "货币表",
            "切磋竞技场战斗场景表",
            "新手_新手值",
            "动作和特效表_角色特效",
            "系统配置表",
            "转生价格",
            "合作技能",
            "游戏功能开启表",
            "魂晶兑换",
            "国王订单",
            "自动挖矿",
            "游戏故事配置",
            "Q点购买表",
            "活动时间表",
            "每日充值活动",
            "累计充值活动",
            "每日消费活动",
            "累计消费活动",
            "目标活动击杀BOSS",
            "目标活动击杀巨魔",
            "特殊事件",
            "目标活动血钻招募",
            "目标活动招募",
            "道具兑换活动",
            "活动道具",
            "商店配置",
            "杂项",
            "公告系统",
            "秘术之门",
            "区域配置",
            "争霸战奖励表",
            "字体配置",
            "钥匙表",
            "图书馆图鉴收集兑换奖励",
            "图书馆精通点数兑换奖励",
            "书页表",
            "契约加成",
            "国王订单额外奖励",
            "免费赠送",
            "活动奖励事件掉落组",
            "CDKEY礼包奖励事件掉落组",
            "秘术奖励事件掉落组",
            "签到奖励事件掉落组",
            "招募奖励事件掉落组",
            "连锁活动总表",
            "连锁活动事件序列表",
            "积分合战主表",
            "积分合战节点表",
            "积分合战每日赛季经验奖励",
            "积分合战经验兑换",
            "积分合战赛点兑换奖励"
    ];

    public static const EXP:int = 0;
    public static const HERO:int = 1;
    public static const FORGE:int = 2;
    public static const WEAPON:int = 3;
    public static const SUMMON:int = 4;
    public static const MINE:int = 5;
    public static const FOOD:int = 6;
    public static const MAZE:int = 7;
    public static const POWER:int = 8;
    public static const STRENGTHEN:int = 9;

    public var all:Dictionary = new Dictionary();
	protected var _ctx:Ctx = null;

    public function Conf(onComplete:Function, ctx:Ctx) {
		_ctx = ctx;
        new Timer(1, 1, null, onComplete);
        return;

        var f:Function = function (i:int = 0):void {
            if (i < STRS.length) {
                var n:String = STRS[i],
                    r:Function = function (data:Object):void {
//                        var ba:ByteArray = Base64.decode(data as String);
//                        ba.position = 0;
//                        ba.uncompress();
//                        trace(ba.toString());
//                        trace(ba.length);
//                        trace(parseInt(ba[0], 16), ba[1], ba[2], ba[3], ba[4], ba[5], ba[6], ba[7]);
//                        trace(ba[ba.length - 1], ba[ba.length - 2], ba[ba.length - 3], ba[ba.length - 4], ba[ba.length - 5], ba[ba.length - 6], ba[ba.length - 7], ba[ba.length - 8]);
//                        var t1:String = ba.readMultiByte(ba.length, "utf16");
//                        var a:* = ba.readObject();
//                        var s:String = Base64.decodeStr(data as String);
                        f(++ i);
                    };
                genTask(_ctx.version, n, r);
            } else {
                onComplete();
            }
        };
        f.apply();
    }

    protected function genTask(v:String, name:String, cb:Function):void {
        _ctx.service.on("get_conf", cb, v, name);
    }

}
}
