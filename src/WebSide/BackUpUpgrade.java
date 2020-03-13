package WebSide;

import Bean.UpgradeBean;
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
@WebServlet(urlPatterns = "/BackUpUpgrade")
public class BackUpUpgrade extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
        Lg.e("数据备份");
        String fileName = "版本信息备份"+ CommonUtil.getTime(true);
        UpgradeDao webDao = new UpgradeDao();
        List<UpgradeBean> list = webDao.getUpgradeList();
        String[] fields = {"公司名称","版本号","AppID","更新地址","更新日期","更新提示"};
        ExcelExport export = new ExcelExport();
        HSSFWorkbook wb = export.generateExcel();
        wb = export.generateUpgradeSheet(wb, fileName, fields, list);
        export.export(wb, fileName,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
