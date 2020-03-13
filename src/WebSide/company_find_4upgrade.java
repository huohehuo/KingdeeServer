package WebSide;

import Bean.Company;
import Bean.UpgradeBean;
import Utils.Lg;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class pl_find
 */
@WebServlet(urlPatterns = "/company_find_4upgrade")
public class company_find_4upgrade extends HttpServlet {
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
			CompanyDao companyDao=new CompanyDao();
//	          	stu.setHid(hid);
	           List<UpgradeBean> upgradeList = run.findUpgradeBean(appid);
	           List<Company> companys = companyDao.findCompany(appid);
	           if (upgradeList.size()>0){
	           	Lg.e("得到更新版本信息",upgradeList.get(0));
				   request.setAttribute("upgrade", upgradeList.get(0));
				   request.getRequestDispatcher("MGM/Company_set_upgrade.jsp").forward(request, response);
			   }else{
				   UpgradeBean bean = new UpgradeBean();
				   bean.CompanyName =companys.get(0).CompanyName;
				   bean.AppVersion =companys.get(0).AppVersion;
				   bean.AppVersion2 =companys.get(0).AppVersion2;
				   bean.AppVersion3 =companys.get(0).AppVersion3;
				   bean.AppID =appid;
				   bean.UpgradeLog ="升级提示";
				   bean.UpgradeUrl ="http://148.70.108.65:8080/AppFile/GZWS/app-debug.apk";
				   request.setAttribute("upgrade", bean);
				   request.getRequestDispatcher("MGM/Company_set_upgrade.jsp").forward(request, response);
			   }

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
