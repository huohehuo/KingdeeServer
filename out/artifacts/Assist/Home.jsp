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
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/home_style.css">
</head>
<body>

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
    <div style="width: auto;height: auto;">
        <img src="img/home_top.png" alt="Pulpit rock" width="auto" height="400px">
    </div>

    <div class="row" style="margin: 50px">
        <div class="column">
            <img class="column2" style="margin-right: 50px" src="img/ztkj.jpg" alt="#">
        </div>
        <div class="column card">
            <div class="card-body">
                <h3 class="card-text">整体框架</h3>
                <p class="card-text"></p>
                <p class="card-text">企业类型：有限责任公司</p>
                <p class="card-text">主营产品：金蝶PDA|PDA软件定制开发|条码采集软件程序开发</p>
                <p class="card-text">公司地址：广东省深圳市罗湖区</p>
                <p class="card-text">联系电话：邱经理 18319928705</p>
                <p class="card-text">深圳方左科技有限公司，简称（方左技术）专业从事于企业可视化移动条码采集信息化精益管理整体解决方案
                    ，方左技术以其贴近用户的差异化创新、立志在***短时间内成为市面上价值服务宗旨的管理方案专家，以持之以恒的科研投入、严格有效的质量控制、快捷放心的售后服务，
                    方左技术坚持以技术创新为持续发展之根本，秉承“人才，团队，管理，技术”的核心管理理念，方左技术将继续坚持以更贴合业务的解决方案、
                    更高质量的产品和更快捷放心的服务回报客户，为客户提供贴身、完整的可视化移动条码采集精益管理应用解决方案，不断帮助客户创造价值，成为您身边的精益生产管理专家</p>
                <!-- <a href="#" class="card-link">Card link</a>
                <a href="#" class="card-link">Another link</a> -->
            </div>
        </div>
    </div>
    <div class="row" style="margin: 50px">
        <div class="column">
            <img class="column2" style="margin-right: 50px" src="img/lc.jpg" alt="#">
        </div>
        <div class="column card">
            <div class="card-body">
                <h3 class="card-text">解决方案</h3>
                <p class="card-text"></p>
                <p class="card-text">企业类型：有限责任公司</p>
                <p class="card-text">主营产品：金蝶PDA|PDA软件定制开发|条码采集软件程序开发</p>
                <p class="card-text">公司地址：广东省深圳市罗湖区</p>
                <p class="card-text">联系电话：邱经理 18319928705</p>
                <!-- <a href="#" class="card-link">Card link</a>
                <a href="#" class="card-link">Another link</a> -->
            </div>
        </div>
    </div>
    <div class="row" style="margin: 50px">
        <div class="column">
            <img class="column2" style="margin-right: 50px" src="img/jjfa.jpg" alt="#">
        </div>
        <div class="column card">
            <div class="card-body">
                <h3 class="card-text">整体框架</h3>
                <p class="card-text"></p>
                <p class="card-text">企业类型：有限责任公司</p>
                <p class="card-text">主营产品：金蝶PDA|PDA软件定制开发|条码采集软件程序开发</p>
                <p class="card-text">公司地址：广东省深圳市罗湖区</p>
                <p class="card-text">联系电话：邱经理 18319928705</p>
                <!-- <a href="#" class="card-link">Card link</a>
                <a href="#" class="card-link">Another link</a> -->
            </div>
        </div>
    </div>

<jsp:include page="item_foot.jsp"/>

<%--<!-- 底部布局-->--%>
<%--<div class="jumbotron text-center" style="margin-bottom:0">--%>
    <%--<div class="container">--%>
        <%--<div class="row">--%>
            <%--<div class="col-sm-4">--%>
                <%--<h3> 关于我们</h3>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
            <%--</div>--%>

            <%--<div class="col-sm-4">--%>
                <%--<h3> 关于我们</h3>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
            <%--</div>--%>
            <%--<div class="col-sm-4">--%>
                <%--<h3> 关于我们</h3>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
                <%--<li>公司介绍</li>--%>
            <%--</div>--%>
        <%--</div>--%>
    <%--</div>--%>
<%--</div>--%>

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
