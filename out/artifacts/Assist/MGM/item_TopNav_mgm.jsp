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
<%@ page import="com.sun.org.apache.xpath.internal.operations.String" %>
<%@ page import="WebSide.FeedBack" %>
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
    <link type="text/javascript" src="js/swiper.min.js">
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/colors.css">

    <link rel="stylesheet" href="../css/style.css">
    <style type="text/css">
        img{
            padding: 15px;
            width: 60px;
            height: 60px;
        }
        a:hover {
            　　cursor: default;
        }
    </style>
</head>

<body class="mgm_bg">
    <%--<img src="../img/logo.gif" alt="" onclick="location.href='Mgm_Right CompanyList.jsp'">--%>
    <div style="height: 80%">
        <a href = 'item_Right_mgm.jsp' target = 'Mgm_Right'><img src="../img/gxlog.jpg" alt="" style="height: 55px"></a>

        <a class="box" href="CompanyList.jsp" target="Mgm_Right"><img src="../img/left_company_set.png" alt="" >项目管理</a><br><br>

        <a class="box" href="UpgradeList.jsp" target="Mgm_Right"><img src="../img/left_upgrade.png" alt="">版本管理</a><br><br>

        <a class="box" href="UserControlList.jsp" target="Mgm_Right"><img src="../img/left_upgrade.png" alt="">用户控制</a><br><br>

        <%--<a class="box" href="../registerMsg.jsp" target="Mgm_Right"><img src="../img/left_upgrade.png" alt="">注册表</a><br><br>--%>

        <%--<a class="box" href="../testMsg.jsp" target="Mgm_Right"><img src="../img/left_upgrade.png" alt="">查询信息</a><br><br>--%>

    </div>
    <hr>
    <div style="height: 20%;margin-top: 200px;">
        <a class="box" href="./BackUpData.jsp" target="Mgm_Right"><img src="../img/left_backup.png" alt="">数据备份</a><br><br>
        <%--<a href="../BackUpCompany?json=0"><img src="../img/mgm02.png" alt="">备份</a><br><br>--%>

    </div>


</body>


</html>
