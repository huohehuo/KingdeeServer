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
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="WebSide.StatisticalDao" %>
<%@ page import="Bean.StatisticalBean" %>
<%@ page import="Utils.CommonUtil" %>
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
    <%--<link rel="stylesheet" href="css/bootstrap.min.css">--%>
</head>
<body>
<jsp:include page="../headLayout.jsp"/>
<%--
<%
    WebDao aa = new WebDao();
//    List list = (List) request.getAttribute("pl_list");
    List list = aa.getRegister();


    for (int i = 0; i < list.size(); i++) {
        RegisterBean rs = (RegisterBean) list.get(i);
%>--%>
<%--<%
    String tips = (String) request.getAttribute("tips");
%>
<h5 ><%=tips%></h5>--%>

<div>
    <br/>
    <h2 style="width: 200px;text-align:center">详情-></h2>
</div>
<hr/>

    <div  class="card" style="margin: 10px">
        <%--<div class="card-header">--%>
            <%--<button type="button" class="btn btn-outline-primary" value="新增项目信息" onclick="location.href='Company_create.jsp'">新增项目信息</button>--%>
        <%--</div>--%>
        <div class="card-body">
            <table class="table">
                <thead>
                <%
                    CompanyDao companyDao = new CompanyDao();
                    StatisticalDao statisticalDao = new StatisticalDao();
                    List listStat = (List) request.getAttribute("statistical");
                    List list = statisticalDao.getUpgradeListByData(CommonUtil.getTime(true));

                %>
                <tr>
                    <th>公司名称(<%=listStat.size()%>)</th>
                    <th>IMIE</th>
                    <th>版本号</th>
                    <th>活跃日期</th>
                    <%--<th>总用户数</th>--%>
                </tr>
                </thead>
                <tbody>
                <%

                    if (listStat==null){
                        %><div class="alert alert-info"> 列表数据为空</div><%
                        return;
                    }
                    for (int i = 0; i < listStat.size(); i++) {
                        StatisticalBean rs = (StatisticalBean) listStat.get(i);
                %>

                <tr>
                    <td><%=companyDao.findCompany(rs.getAppID()).get(0).getCompanyName() %></td>
                    <td><%=rs.getImie() %></td>
                    <td><%=rs.getAppVersion() %></td>
                    <td><%=rs.getRealTime()%></td>
                    <%--<td><%=statisticalDao.getStatisticalNum4Appid(rs.getAppID()) %></td>--%>
                    <%--<td style="height: 45px;width:80px"><%=rs.getLast_use_date() %></td>--%>
                        <%--<td><a href="../ActiveUser_find?json=<%=rs.getAppID()%>">管理</a></td>--%>
                </tr>
                </tbody>
                <%} %>
            </table>
        </div>

    </div>


<%--<table border="0" bgcolor="ccceee" width="750" style="height: 161px;">
    <tr bgcolor="CCCCCC" align="center">
        <td style="height: 30px;width:80px ">用户码</td>
        <td style="height: 30px;width:180px ">手机IMIE码</td>
        <td style="height: 30px;width:80px ">版本号</td>
        <td style="height: 30px;width:80px ">操作</td>

    </tr>

    <tr align="center">
        <td style="height: 45px; width:80px"><%=rs.getRegister_code() %>
        </td>
        <td style="height: 45px; width:180px"><%=rs.getVal1() %>
        </td>
        <td style="height: 45px; width:80px"><%=rs.getVal2() %>
        </td>
        &lt;%&ndash;<td style="height: 45px;width:80px"><%=rs.getLast_use_date() %></td>&ndash;%&gt;
        <td width="80px" align="center"><a href="RegisterDelete?json=<%=rs.getRegister_code() %>">删除</a></td>
    </tr>
    <%} %>

</table>--%>
</body>


</html>
