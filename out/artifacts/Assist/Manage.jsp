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
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="WebSide.FeedBack" %>
<%@ page import="Utils.Lg" %>
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
    <link rel="stylesheet" href="css/bootstrap.min.css">
</head>
<%--<body>--%>
<script>
    function loadXMLDoc()
    {
//        window.location.reload();
        document.getElementsByName("name").innerText = "周杰伦";
        Lg.e("方法启动");
//        var xmlhttp;
//        if (window.XMLHttpRequest)
//        {
//            // IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
//            xmlhttp=new XMLHttpRequest();
//        }
//        else
//        {
//            // IE6, IE5 浏览器执行代码
//            xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
//        }
//        xmlhttp.onreadystatechange=function()
//        {
//            if (xmlhttp.readyState==4 && xmlhttp.status==200)
//            {
//                document.getElementById("myDiv").innerText=xmlhttp.responseText;
//            }
//        }
//        xmlhttp.open("GET","/try/ajax/demo_get.php",true);
//        xmlhttp.send();
    }
</script>

<%--<%
    // 设置每隔5秒刷新一次
    response.setIntHeader("Refresh", 5);
    // 获取当前时间
    Calendar calendar = new GregorianCalendar();
    String am_pm;
    int hour = calendar.get(Calendar.HOUR);
    int minute = calendar.get(Calendar.MINUTE);
    int second = calendar.get(Calendar.SECOND);
    if(calendar.get(Calendar.AM_PM) == 0)
        am_pm = "AM";
    else
        am_pm = "PM";
    String CT = hour+":"+ minute +":"+ second +" "+ am_pm;
    out.println("当前时间为: " + CT + "\n");
%>--%>

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
<%--<div style="width: auto;height: auto;">--%>
    <%--<img src="http://148.70.108.65:8080/LogAssist/img/bg.jpg" alt="Pulpit rock" width="100%" height="200px">--%>
<%--</div>--%>
<%--<jsp:include page="item_TopNavbar.jsp"/>--%>

<%--<div class="card" style="margin: 44px;padding: 40px">--%>
    <%--&lt;%&ndash;<form action="FeedBack" method="post">&ndash;%&gt;--%>
        <%--<div class="form-group">--%>
            <%--<a for="email">姓名</a>--%>
            <%--<input type="text" class="form-control" id="name" placeholder="Enter your name" name="name">--%>
        <%--</div>--%>
        <%--<div class="form-group">--%>
            <%--<a for="pwd">电话:</a>--%>
            <%--<input type="text" class="form-control" id="phone" placeholder="Enter telephone" name="phone">--%>
        <%--</div>--%>
        <%--<div class="form-group">--%>
            <%--<a for="pwd">更新信息:</a>--%>
            <%--<input type="text" class="form-control" id="jieguo" placeholder="显示结果" name="phone">--%>
        <%--</div>--%>
        <%--&lt;%&ndash;<a><% CT} %></a>&ndash;%&gt;--%>
        <%--<div id="myDiv"></div>--%>
        <%--<button class="btn btn-primary" onclick="loadXMLDoc()">确定</button>--%>
        <%--&lt;%&ndash;<button type="submit" class="btn btn-primary" onclick="loadXMLDoc()">确定</button>&ndash;%&gt;--%>
    <%--&lt;%&ndash;</form>&ndash;%&gt;--%>
<%--</div>--%>

<%--<iframe src="FeedBack.jsp" height="100%" width="100%" name="demo" scrolling="no" sandbox="allow-same-origin"></iframe>--%>

    <frameset cols="255,*" frameborder="no" border="0">
        <frame src="Manage_left.jsp" name="ManageLeft" scrolling="auto">
        <frame src="Manage_right.jsp" name="ManageRight" scrolling="auto">
    </frameset>
<%--</body>--%>


</html>
