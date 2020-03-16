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
<%@ page import="WebApp.Info" %>
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
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<body>
<%
    //获取session中的用户名
    String userName = (String)session.getAttribute(Info.UserNameKey);
%>
<div>
    <div class="row bg-dark">
        <div class="col-sm-8">
            <h4 class="navbar-brand" style="color:white;margin-left: 6.25rem;">方左科技数据中心</h4>
        </div>
        <div class="col-sm-4" style="margin:auto 0;">
            <a class="navbar-brand" href="login.jsp" target="_top" style="text-align:center;font-size: 12px;float: inherit;color:white;margin-left: 6.25rem;">用户:<%=userName%></a>
        </div>
    </div>

</div>
</body>


</html>
