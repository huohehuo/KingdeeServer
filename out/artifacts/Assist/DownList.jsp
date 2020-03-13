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
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <style>
        /* Make the image fully responsive */
        .carousel-inner img {
            width: 100%;
            height: 100%;
            text-align:center;
            margin: 50px;
        }
    </style>
</head>
<body>
<div style="width: auto;height: auto;">
    <img src="img/home_top.png" alt="Pulpit rock" width="auto" height="400px">
</div>
<div style="margin-left: 50px;margin-top: 30px">
    <div class="form-inline">
        <div class="form-group" style="width: 25%">
            <p class="card-text">数据下载</p>
        </div>
    </div>
</div>

<div style="margin:30px 50px 400px 50px;">
            <div class="card" style="width: 100%;">
                <div class="card-body">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>文件</th>
                            <th>下载地址</th>
                            <th>备注</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>JAVA</td>
                            <td><a href="http://www.fangzuokeji.com/res/java64.exe">JAVA(64位)</a>----<a href="http://www.fangzuokeji.com/res/java32.jpg">JAVA(32位)</a></td>
                            <td>根据windows系统版本选择</td>
                        </tr>
                        <tr>
                            <td>Tomcat</td>
                            <td><a href="http://www.fangzuokeji.com/res/apache-tomcat-8.5.38.exe">apache-tomcat-8.5.38</a></td>
                            <td></td>
                        </tr>
                        </tbody>
                    </table>
                    <%--<h3 class="card-text">深圳市方左科技有限公司aaaa</h3>--%>
                    <%--<p class="card-text"></p>--%>
                    <%--<p class="card-text">企业类型：有限责任公司</p>--%>
                    <%--<p class="card-text">主营产品：金蝶PDA|PDA软件定制开发|条码采集软件程序开发</p>--%>
                    <%--<p class="card-text">公司地址：广东省深圳市罗湖区</p>--%>
                    <%--<p class="card-text">联系电话：邱经理 18319928705</p>--%>
                    <!-- <a href="#" class="card-link">Card link</a>
                    <a href="#" class="card-link">Another link</a> -->
                </div>
            </div>


</div>




<!-- 底部布局-->
<jsp:include page="item_foot.jsp"/>

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
