<%--
  Created by IntelliJ IDEA.
  User: NB
  Date: 2017/8/7
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" import="Bean.RegisterBean" import="WebSide.WebDao"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="WebSide.CompanyDao" %>
<%@ page import="Bean.Company" %>
<%@ page import="Utils.BaseData" %>
<%@ page import="Utils.ExcelExport" %>
<%@ page import="Utils.HttpRequestUtils" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="WebSide.UpgradeDao" %>
<html>
<head>
    <title>注册用户管理</title>
    <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/4.1.0/css/bootstrap.min.css">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.staticfile.org/jquery/3.2.1/jquery.min.js"></script>

    <!-- popper.min.js 用于弹窗、提示、下拉菜单 -->
    <script src="https://cdn.staticfile.org/popper.js/1.12.5/umd/popper.min.js"></script>

    <!-- 最新的 Bootstrap4 核心 JavaScript 文件 -->
    <script src="https://cdn.staticfile.org/twitter-bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="../css/bootstrap.min.css">



</head>
<style type="text/css">
    .cardBox {
        width: 200px;
        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        text-align: center;
        float: left;
        margin-left: 20px;
        /*margin-right: 10px;*/
        /*padding: 5px;*/
        /*padding-top: 15px;*/
    }

    .headerBox {
        color: #fff;
        padding: 10px;
        font-size: 15px;
        height: 60px;
    }

    .bodyBox {
        padding: 10px;
    }

    .bodyBox p {
        margin-left: 5px;
    }
</style>
<body>

<jsp:include page="../headLayout.jsp"/>

<%
    String baseUrl = BaseData.baseUrl;
    CompanyDao companyDao = new CompanyDao();
    UpgradeDao upgradeDao = new UpgradeDao();
//    List list = (List) request.getAttribute("pl_list");
    String companyNum = companyDao.getCompanyNum();
    String upgradeNum = upgradeDao.getUpgradeNum();
%>

<div class="container" style="margin-top: 88px">
    <div class="cardBox">
        <div class="headerBox" style="background-color: #4caf50;">
            <p>
                <a href="../BackUpCompany?json=0" title="查看详情" style="cursor: pointer; color:white">公司信息表备份</a>
            </p>
        </div>
        <div class="bodyBox">
            <p>备份数量：<%=companyNum%></p>
            <%--<p>备份日期：20191010</p>--%>
            <%--<p>项目状态：--%>
                <%--<a href="javascript:void(0)" class="label label-success" style="border-radius: .25em;">启动</a>--%>
            <%--</p>--%>
            <%--<p>异常状态：<span style="color:green">无异常</span></p>--%>
        </div>
    </div>
    <div class="cardBox">
        <div class="headerBox" style="background-color: #4caf50;">
            <p>
                <a href="../BackUpUpgrade?json=0" title="查看详情" style="cursor: pointer; color:white">版本信息表备份</a>
            </p>
        </div>
        <div class="bodyBox">
            <p>备份数量：<%=upgradeNum%></p>
            <%--<p>备份日期：20191010</p>--%>
            <%--<p>项目状态：--%>
            <%--<a href="javascript:void(0)" class="label label-success" style="border-radius: .25em;">启动</a>--%>
            <%--</p>--%>
            <%--<p>异常状态：<span style="color:green">无异常</span></p>--%>
        </div>
    </div>
    <!-- 在form中设置隐藏控件，用来存储JS中的值 -->
    <%--<form name="frmApp" action="./CompanyChangeLog" id="frmAppId" mothed="post"/>--%>
    <input id="app_id" type="hidden" name="test" value="">
    <input id="remark" type="hidden" name="test" value="">
    <%--</form>--%>
</div>
<script type="text/javascript">
    function submitForm1() {
        var Sel = document.getElementById("citySel");
        var index = Sel.selectedIndex;
        var val = Sel.options[index].value;
        var textRemark = document.getElementById('remark2');
        var ssss = textRemark.innerHTML;
//        HttpRequestUtils.sendGet("http://192.168.0.136:8084/Assist/CompanyChangeLog?app_id="+val+"&remark="+textRemark);
        <%--var url =<%=baseUrl%>+"CompanyChangeLog?";--%>
//        window.location.href=url+"app_id="+val+"&remark="+textRemark;
        window.location.href = "http://192.168.0.136:8084/Assist/CompanyChangeLog?app_id=" + val + "&remark=" + ssss;
    }
    function checkCp() {
        var Sel = document.getElementById("citySel");
        var index = Sel.selectedIndex;
        var val = Sel.options[index].value;
        var txt = Sel.options[index].text;

//    var frm = document.getElementById("frmAppId"); // 获取表单
//    frm.submit(); // 对表单进行提交

        document.getElementById("app_id").value = val;

        document.getElementById('remark2').innerText = txt;

//    document.getElementById('hh').innerHTML = '删除成功'+val
//    var options=$("#my_level-name option:selected");
//    var ea_id=options.val(); //拿到选中项的值

//    HttpRequestUtils.sendGet("http://192.168.0.136:8084/Assist/company_find?json="+val);

        <%--&lt;%&ndash;%>
        <%--boolean okDelete = companyDao.deleteCompany(company.getAppID());--%>
        <%--if (!okDelete){--%>

        <%--%>--%>
        <%--//        alert("删除成功");--%>
        <%--window.self.location = "MGM/CompanyList.jsp";--%>
        <%--//        document.getElementById("tips").value = "删除成功"--%>
        <%--&lt;%&ndash;%>
        <%--}else{--%>
        <%--%>--%>

        <%--window.self.location = "MGM/CompanyList.jsp";--%>
        <%--alert("删除失败");&lt;%&ndash;%>
        <%--}--%>
        <%--%>--%>
    }
</script>
</body>


</html>
