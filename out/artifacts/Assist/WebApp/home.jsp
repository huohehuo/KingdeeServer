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
<%@ page import="WebSide.FeedBack" %>
<%@ page import="WebSide.CompanyDao" %>
<%@ page import="Bean.Company" %>
<%@ page import="WebSide.StatisticalDao" %>
<%@ page import="Bean.LiveDataBean" %>
<%@ page import="Utils.Lg" %>
<%@ page import="WebApp.Info" %>
<%@ page import="Utils.MathUtil" %>
<%@ page import="Utils.CommonUtil" %>
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
</head>
<%
    String userName = (String)session.getAttribute(Info.UserNameKey);
    if (null == userName || "".equals(userName)){//若本地session不存在登录用户的缓存数据，则跳到登录界面
        response.sendRedirect(request.getContextPath()+"/WebApp/login.jsp");
    }
%>
<frameset rows="66px,*" frameborder="no" border="0">
    <frame src="home_top.jsp" name="WebApp_Top" scrolling="no">
    <frame src="home_btm.jsp" name="WebApp_Btm" scrolling="auto">
</frameset>


</html>
