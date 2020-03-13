package WebSide;

import Bean.Company;
import Utils.CommonUtil;
import Utils.ExcelExport;
import Utils.Lg;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 用于备份公司信息表的数据到xls
 */
@WebServlet(urlPatterns = "/BackUpCompany")
public class BackUpCompany extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("数据备份");
        String fileName = "公司项目信息备份"+ CommonUtil.getTime(true);
        CompanyDao webDao = new CompanyDao();
        List<Company> list = webDao.getCompany();
        String[] fields = {"公司名称","电话","APPID","版本号","金蝶/ERP版本号","地址","时间控制日期","公司logo","创建时间","更新日志"};
        ExcelExport export = new ExcelExport();
        HSSFWorkbook wb = export.generateExcel();
        wb = export.generateCompanySheet(wb, fileName, fields, list);
        export.export(wb, fileName,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
