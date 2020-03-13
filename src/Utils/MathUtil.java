package Utils;

import java.math.BigDecimal;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MathUtil {

    //直径选中后，直接取整，然后判定是否为奇数还是偶数，奇数+1，偶数不变，例如  21.5先取整 21 判定奇数偶数，奇数 +1   得到 22
    public static String dealDiameter(String dia){
        String ddd = MathUtil.D2save2(MathUtil.toD(dia)*2.53995) + "";
        String ccc = MathUtil.Cut0(ddd);
        if (Double.parseDouble(ccc)/2==0){
            return ccc;
        }else{
            return MathUtil.toInt(ccc)+1+"";
        }
    }



    //防止强转时崩溃操作
    public static double toD(String string) {
        if (null == string) {
            return 0;
        } else if (string.equals("")) {
            return 0;
        } else {
            try {
                return Double.parseDouble(string);
            }catch (Exception e){
                return 0;
            }
        }
    }
    //防止强转时崩溃操作
    public static int toInt(String string) {
        if (null == string) {
            return 0;
        } else if (string.equals("")) {
            return 0;
        } else {
            try{
                return Integer.parseInt(string);
            }catch (Exception e){
                return 0;
            }
        }
    }
    //去掉小数点以后的数值
    public static String Cut0(String value) {
        try {
            if (value==null||"".equals(value)){
                return "0";
            }
            if (value.contains(".")){
//            String str=Math.rint(Double.parseDouble(value))+"";
                return value.substring(0,value.lastIndexOf("."));
            }else{
                return value;
            }
        }catch (Exception e){
            return "0";
        }



//       Lg.e("TEST",DoubleUtil.Cut0("0.50"));0
//       Lg.e("TEST",DoubleUtil.Cut0("1.50"));2
//       Lg.e("TEST",DoubleUtil.Cut0("1.40"));1
//       Lg.e("TEST",DoubleUtil.Cut0("0.45"));0
    }
    //防止强转时崩溃操作(弃用，会导致xx.00000002数值)  用DoubleUtil中的方法
//    public static String x10(String string) {
//        if (string.equals("")) {
//            return "0";
//        } else {
//            return cutZero((Double.parseDouble(string)*10)+"");
//        }
//    }
    //防止强转时崩溃操作
    public static double c10(String string) {
        if (string.equals("")) {
            return 0;
        } else {
            return Double.parseDouble(string)/10;
        }
    }
    //解决 1.1-1.0=0.10000009的情况
    //double相减
    public static double doubleSub(Double v1, Double v2) {
        BigDecimal b1 = new BigDecimal(v1.toString());
        BigDecimal b2 = new BigDecimal(v2.toString());
        return b1.subtract(b2).doubleValue();
    }
    //解决 1.1+1.0=2.09999999的情况
    //double相加
    public static double sum(String d1,String d2){
        if (null == d1 || "".equals(d1)){
            d1="0";
        }
        if (null == d2 || "".equals(d2)){
            d2="0";
        }
        BigDecimal bd1 = new BigDecimal(d1);
        BigDecimal bd2 = new BigDecimal(d2);
        return bd1.add(bd2).doubleValue();
    }
    /**
     * double 除法
     * @param d1
     * @param d2
     * @param scale 四舍五入 小数点位数
     * @return
     */
    public static double div(double d1,double d2,int scale){
        //  当然在此之前，你要判断分母是否为0，
        //  为0你可以根据实际需求做相应的处理
        if (d2<=0)return 0;
        BigDecimal bd1 = new BigDecimal(Double.toString(d1));
        BigDecimal bd2 = new BigDecimal(Double.toString(d2));
        return bd1.divide
                (bd2,scale,BigDecimal.ROUND_HALF_UP).doubleValue();
    }
    //是否为数字
    public static boolean isNumeric(String str) {
        //Pattern pattern = Pattern.compile("-?[0-9]+.?[0-9]+");//这个有问题，一位的整数不能通过
        Pattern pattern = Pattern.compile("^(\\-|\\+)?\\d+(\\.\\d+)?$");//这个是对的
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
    //是否为纯数字
    public static boolean isNumber(Object o){
        return  (Pattern.compile("[0-9]*")).matcher(String.valueOf(o)).matches();
    }
    //保留两位小数（四舍五入
    public static double D2save2(Double d){
        return Double.parseDouble(String.format("%.2f", d));
    }
    public static double D2save4(Double d){
        return Double.parseDouble(String.format("%.4f", d));
    }
    //保留一位小数（四舍五入
    public static double D2save1(Double d){
        return Double.parseDouble(String.format("%.1f", d));
    }
    public static String D2saveInt(Double d){
        return Cut0(Math.round(d)+"");
    }

    public static double D2save0(Double d){
        return Double.parseDouble(String.format("%f", d));
    }
    //去掉末尾为.0的数
    public static String cutZero(String num){
        String string;
        if (num.endsWith(".0")){
            Lg.e("有0");
//            Lg.e("去掉0",string.substring(0,string.length()-2));
            string = num.substring(0,num.length()-2);
        }else{
            string=num;
        }
        return string;
    }
//
//    //超过时间(用于判断超过登陆时常时自动重登)
//    public static boolean MoreTime(double min){
//        Lg.e("最初时间",App.PDA_Time);
//        Lg.e("当前时间", CommonUtil.getTime2Fen());
//        if (doubleSub(Double.parseDouble(CommonUtil.getTime2Fen()),Double.parseDouble(App.PDA_Time))>min){
//            App.PDA_Time = CommonUtil.getTime2Fen();
//            return true;
//        }else{
//            return false;
//        }
//    }
//
//    public static Double getVoleum(String length,String diameter){
//        Double num = 0.0;
//        Double l = Double.parseDouble(length==null||length.equals("")?"0":length);
//        Double d = Double.parseDouble(diameter==null||diameter.equals("")?"0":diameter);
//        if(l>=10.1){
//            num = 0.8*l*(Math.pow(d+(0.5*l),2)/10000);
//        }else if(l<10.1&&d<14){
//            num = 0.7854*l*(Math.pow(d+(0.45*l)+0.2,2)/10000);
//        }else if(l<10.1&&d>=14){
//            Double sl = Math.pow(l,2);//长度的平方
//            Double l14 = Math.pow(14-l,2);//14-l的平方
//            num = 0.7854*l*(Math.pow(d+0.5*l+0.005*sl+0.000125*l*l14*(d-10),2)/10000);
//        }
//        DecimalFormat df = new DecimalFormat("#0.00");
//        String str = df.format(num);
//        Log.e("CalculateUtil",str);
//        return Double.parseDouble(str);
//    }
//    //英尺版的体积计算公式 材积=[((直径-4)/4)^2*长度]/1000*5
//    //((直径-4)/4)^2*长度
//    public static Double getVoleum2(String length,String diameter){
//        Double num = 0.0;
//        Double one=(MathUtil.toD(diameter)-4)/4;
//        Lg.e("getVolem2:one",one);
//        Double two = Math.pow(one,2);
//        Lg.e("getVolem2:two",two);
//        Double thr = (two*MathUtil.toD(length));
//        Lg.e("getVolem2:thr",thr);
////        String cutThr=MathUtil.Cut0(thr+"");
//        String cutThr=DoubleUtil.CutTo0(thr+"")+"";
//        Lg.e("getVolem2:four",cutThr);
//        Double four = (MathUtil.toD(cutThr))/1000*5;
//        Lg.e("getVolem2:four",four);
//        return four;
//    }
//    //英尺时，打印时不用/1000*5(直接去整数部分)
//    public static String getVoleum4Print(String length,String diameter){
//        Double num = 0.0;
//        Double one=(MathUtil.toD(diameter)-4)/4;
//        Double two = Math.pow(one,2);
//        String thr = (two*MathUtil.toD(length))+"";
//        String cutThr=DoubleUtil.CutTo0(thr)+"";
//        if (cutThr.contains(".")){
//            String ss = cutThr.substring(0,cutThr.indexOf("."));
//            return ss;
//        }else{
//            return cutThr;
//        }
//    }
//
//    //水版计算体积（保留4位）
//    public static String getVoleum4ShuiBan(String  wideave, String length, String thick, String ceng){
//        Double num = 0.0;
//        if ("".equals(ceng)||"".equals(length)||"".equals(thick)){
//            return num+"";
//        }
//        //厚*长*宽
//        return D2save4(MathUtil.toD(thick)*MathUtil.toD(length)*MathUtil.toD(ceng)*MathUtil.toD(wideave)/1000000000)+"";
//    }
//    public static String dealVoleumForPrint(String vol){
//        return (MathUtil.toD(vol)/1000000)+"";
//    }
}
