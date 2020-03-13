package WebSide.ApkApi;

import Bean.UpgradeBean;
import Utils.CommonJson;
import Utils.Lg;
import WebSide.UpgradeDao;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 获取版本信息
 */
@WebServlet(urlPatterns = "/getApkVersion")
public class getApkVersion extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		  request.setCharacterEncoding("UTF-8");
		  response.setCharacterEncoding("UTF-8");
		try {

			String appid=request.getParameter("json");
			Lg.e("得到公司id",appid);
			UpgradeDao run=new UpgradeDao();
//	          	stu.setHid(hid);
	           List<UpgradeBean> list2 = run.findUpgradeBean(appid);
	           if (list2.size()>0){
				   response.getWriter().write(CommonJson.getCommonJson(true,new Gson().toJson(list2.get(0))));
			   }else{
				   response.getWriter().write(CommonJson.getCommonJson(false,""));
			   }

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
