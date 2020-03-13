package WebSide.GW;

import Utils.BaseData;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;

/**
 * 用于更新时间控制表的当前时间
 */
@WebServlet(urlPatterns = "/ActiveUseTime")
public class ActiveUseTime extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("进入时间Active");
        String wrt_ip = request.getParameter("time_ip");
        String wrt_port = request.getParameter("time_port");
        String time_end = request.getParameter("time_end");
        if (time_end.length()!=8){
            request.setAttribute("feedback_ok", "no");
            request.setAttribute("feedback", "时间控制写入失败---时间必须是 8 位数字...");
            request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
            return;
        }
        String theKey= BaseData.Key;
        String[] key=theKey.split("");
        String[] time=time_end.split("");
        Lg.e("得到key{}",key);
        Lg.e("得到time{}",time);
        String result="";
        SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
        String str = System.currentTimeMillis()+"";
        String[] timethis=str.split("");
        Lg.e("时间",str);
        Lg.e("得到timethis{}",timethis);
        //时间规则
        for (int i = 0; i < 13; i++) {
            result=result+timethis[i];
            if(i==Integer.valueOf(key[0])){
                result=result+time[0];
            }
            if(i==Integer.valueOf(key[1])){
                result=result+time[1];
            }
            if(i==Integer.valueOf(key[2])){
                result=result+time[2];
            }
            if(i==Integer.valueOf(key[3])){
                result=result+time[3];
            }
            if(i==Integer.valueOf(key[4])){
                result=result+time[4];
            }
            if(i==Integer.valueOf(key[5])){
                result=result+time[5];
            }
            if(i==Integer.valueOf(key[6])){
                result=result+time[6];
            }
            if(i==Integer.valueOf(key[7])){
                result=result+time[7];
            }
        }

        Lg.e("得到结果",result);
        //125072604806291257000
        //125071697308120801133
        String url = "http://" + wrt_ip + ":" + wrt_port + "/Assist/SetUseTimeForPC" + "?json=" + result;
        Lg.e("网址", url);
        response.sendRedirect(url);
//        String getJson = HttpRequestUtils.sendGet(url);
//        Lg.e("得到数据",getJson);
//        if ("".equals(getJson)){
//            request.setAttribute("feedback_ok", "no");
//            request.setAttribute("feedback", "时间控制写入失败---地址连接失败...");
//            request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//        }else{
//            CommonResponse commonResponse = new Gson().fromJson(getJson, CommonResponse.class);
//            if (commonResponse.state){
//                Lg.e("注册成功");
//                request.setAttribute("feedback_ok", "ok");
//                request.setAttribute("feedback", "时间控制写入成功!     点击返回继续");
//                request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//            }else{
//                request.setAttribute("feedback_ok", "no");
//                request.setAttribute("feedback", "时间控制写入失败");
//                request.getRequestDispatcher("MGM/feedBack/ok_register.jsp").forward(request, response);
//                Lg.e("注册失败");
//            }
//        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
