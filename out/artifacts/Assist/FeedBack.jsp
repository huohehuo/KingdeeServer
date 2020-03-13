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
</head>
<body>
<%--<jsp:include page="headLayout.jsp"/>--%>
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
<%--<jsp:include page="item_TopNavbar.jsp"/>--%>

<div style="width: auto;height: auto;">
    <img src="img/home_top.png" alt="Pulpit rock" width="auto" height="400px">
</div>
<div class="container" style="margin-top:30px">
    <div class="row">
        <div class="col-sm-4">
            <div class="card">
                <div class="card-body">
                    <h3 class="card-text">深圳市方左科技有限公司</h3>
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
        <div class="col-sm-8">
            <div class="card" style="margin-top:30px">
                <div class="card-body">
                    <h3 class="card-text">留言板</h3>
                    <p class="card-text"></p>
                    <form action="FeedBack" method="post">
                        <div class="form-group">
                            <a for="email">姓名</a>
                            <input type="text" class="form-control" id="name" placeholder="Enter your name" name="name">
                        </div>
                        <div class="form-group">
                            <a for="pwd">电话:</a>
                            <input type="text" class="form-control" id="phone" placeholder="Enter telephone" name="phone">
                        </div>
                        <div class="form-check">
                            <!-- <label class="form-check-label">
                              <input class="form-check-input" type="checkbox"> Remember me
                            </label> -->
                        </div>
                        <button type="submit" class="btn btn-primary">确定</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="container">
    <div class="card">
        <div class="card-body">
            <table class="table">
                <thead>
                <tr>
                    <th>姓名</th>
                    <th>手机信息</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <%
                    WebDao aa = new WebDao();
//    List list = (List) request.getAttribute("pl_list");
                    List list = aa.getFeedBack();
                    for (int i = 0; i < list.size(); i++) {
                        FeedBackBean rs = (FeedBackBean) list.get(i);
                %>

                <tr>
                    <td><%=rs.getName() %>
                    </td>
                    <td><%=rs.getPhone() %>
                    </td>
                    <%--<td style="height: 45px;width:80px"><%=rs.getLast_use_date() %></td>--%>
                    <td><a href="feedback_delete?json=<%=rs.getId() %>">删除</a></td>
                </tr>
                </tbody>
                <%} %>
            </table>
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
