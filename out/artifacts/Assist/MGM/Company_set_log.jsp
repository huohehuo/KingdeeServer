<%--
  Created by IntelliJ IDEA.
  User: NB
  Date: 2017/8/7
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" import="Bean.FeedBackBean" import="WebSide.WebDao"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="WebSide.FeedBack" %>
<%@ page import="Utils.Lg" %>
<%@ page import="WebSide.CompanyDao" %>
<%@ page import="Bean.Company" %>
<%@ page import="Utils.HttpRequestUtils" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

<%
    CompanyDao companyDao = new CompanyDao();
    //获得number
    Company company = (Company) request.getAttribute("company");
%>
<jsp:include page="../headLayout.jsp"/>
<div>
    <br/>
    <h2 style="margin-left: 24px">LOG日志修改-></h2>
</div>
<hr/>
<div class="" style="margin: 10px">
    <div  class="card">
        <div class="card-header">
            <button type="button" class="btn btn-outline-primary" value="返回公司列表" onclick="location.href='MGM/CompanyList.jsp'">返回公司列表</button>
        </div>
        <%--<input type="button" value="更改提示" onclick="document.getElementById('tips').innerHTML = '删除成功'"/>--%>
        <%--<div class="alert alert-info">信息！请注意这个信息。</div>--%>
        <form action="./CompanyChangeLog" method="post" style="padding: 20px">
            <button type="submit" class="btn btn-primary">确定修改</button>
            <input type="hidden" class="form-control" id="app_id" placeholder="Enter telephone" name="app_id"
                   value="<%=company.getAppID()%>" style="width: 100%;margin-right: 10px">
            <h2 style="margin-right: 20px;margin-top: 10px">公司名称:<%=company.getCompanyName()%></h2>

            <div class="form-group">
                <a >项目LOG日志:</a>
                <%--<input type="text" class="form-control" rows="5" id="remark" placeholder="Enter telephone" name="remark"--%>
                       <%--value="<%=company.getRemark()%>">--%>
                <textarea class="form-control" rows="28"  id="remark"  name="remark"><%=company.getRemark()%></textarea>

            </div>


        </form>
        <%--<form action="../company_delete" method="post">--%>
            <%--<input type="text" class="form-control" id="app_id2" placeholder="Enter telephone" name="app_id"--%>
                   <%--value="<%=company.getAppID()%>">--%>
            <%--<button  type="submit" class="btn btn-primary">删除公司</button>--%>
        <%--</form>--%>
    </div>
</div>


<%--<script type="text/javascript">--%>
    <%--ddd.onclick =function deleteCp(){--%>
        <%--console.log("进入方法");--%>
        <%--document.getElementById('tips').innerHTML = '删除成功'--%>
        <%--<%--%>
            <%--String backTip =HttpRequestUtils.sendGet("http://localhost:8084/Assist/company_delete?json="+company.getAppID());--%>

        <%--%>--%>
        <%--&lt;%&ndash;&lt;%&ndash;%>--%>
        <%--&lt;%&ndash;boolean okDelete = companyDao.deleteCompany(company.getAppID());&ndash;%&gt;--%>
            <%--&lt;%&ndash;if (!okDelete){&ndash;%&gt;--%>

                    <%--&lt;%&ndash;%>&ndash;%&gt;--%>
<%--&lt;%&ndash;//        alert("删除成功");&ndash;%&gt;--%>
        <%--&lt;%&ndash;window.self.location = "MGM/CompanyList.jsp";&ndash;%&gt;--%>
<%--&lt;%&ndash;//        document.getElementById("tips").value = "删除成功"&ndash;%&gt;--%>
        <%--&lt;%&ndash;&lt;%&ndash;%>--%>
        <%--&lt;%&ndash;}else{&ndash;%&gt;--%>
            <%--&lt;%&ndash;%>&ndash;%&gt;--%>

        <%--&lt;%&ndash;window.self.location = "MGM/CompanyList.jsp";&ndash;%&gt;--%>
        <%--&lt;%&ndash;alert("删除失败");&lt;%&ndash;%>--%>
                            <%--&lt;%&ndash;}&ndash;%&gt;--%>
                        <%--&lt;%&ndash;%>&ndash;%&gt;--%>
    <%--}--%>
<%--</script>--%>
</body>


</html>
