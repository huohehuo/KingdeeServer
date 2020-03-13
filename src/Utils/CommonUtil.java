package Utils;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CommonUtil {

    public static String getTime(boolean dia){
        SimpleDateFormat format = new SimpleDateFormat( dia ? "yyyy-MM-dd" : "yyyyMMdd");
        Date curDate = new Date();
        return format.format(curDate);
    }
    public static String getTimeLong(boolean dia){
        SimpleDateFormat format = new SimpleDateFormat( dia ? "yyyy-MM-dd HH:mm:ss" : "yyyyMMdd HH:mm:ss");
        Date curDate = new Date();
        return format.format(curDate);
    }

    private static final String PATH = "C:\\properties\\";
    //读取本地的txt文件
    public static String getString4pwd() {
        InputStreamReader inputStreamReader = null;
        String lineTxt = null;
        try {
            File file = new File(PATH+"/dowhatpwd.txt");
            if (file.isFile() && file.exists()) {
                InputStreamReader isr = new InputStreamReader(new FileInputStream(file), "utf-8");
                BufferedReader br = new BufferedReader(isr);
                while ((lineTxt = br.readLine()) != null) {
                    Lg.e("读取txt:"+lineTxt);
                    return lineTxt;
                    //保存版本号
//                    Hawk.put(Config.Apk_Version,lineTxt);
//                    System.out.println(lineTxt);
                }
                br.close();
            } else {
                System.out.println("文件不存在!");
            }
        } catch (UnsupportedEncodingException e1) {
            e1.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return lineTxt;
    }


    //解密加密的时间
    public static String dealTime(String timemd){
//        Lg.e("加密的日期："+timemd);
        StringBuffer buffer = new StringBuffer()
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(0)+"")+1))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(1)+"")+2))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(2)+"")+3))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(3)+"")+4))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(4)+"")+5))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(5)+"")+6))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(6)+"")+7))
                .append(timemd.charAt(Integer.parseInt(BaseData.Key.charAt(7)+"")+8));
        Lg.e("解析日期："+buffer.toString());
        return buffer.toString();
    }



}
