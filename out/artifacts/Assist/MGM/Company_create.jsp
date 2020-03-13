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
<%@ page import="WebSide.UploadCompanyCreate" %>
<%@ page import="Bean.Company" %>
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
<jsp:include page="../headLayout.jsp"/>

<div class="container" style="margin-top: 88px">
    <div  class="card">
        <%--<form name="form" method="post" action="CompanyList.jsp" style="margin-bottom: 20px">--%>
            <%--<button type="submit" class="btn btn-outline-primary">返回公司列表</button>--%>
        <%--</form>--%>
            <div class="card-header">
                <button type="button" class="btn btn-outline-primary" value="返回公司列表" onclick="location.href='CompanyList.jsp'">返回公司列表</button>
            </div>
        <form action="../UploadCompanyCreate" method="post" style="padding: 50px">
            <button type="submit" class="btn btn-primary">确定添加</button>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 50%">
                    <a style="margin-right: 20px">公司名称:</a>
                    <input type="text" class="form-control" id="company_name" placeholder="Enter your name" name="company_name"
                            style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 50%">
                    <a  style="margin-right: 20px">电话:</a>
                    <input type="text" class="form-control" id="phone" placeholder="Enter telephone" name="phone"
                           style="width: 100%;margin-right: 10px">
                </div>
            </div>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 25%">
                    <a style="margin-right: 20px">APPID:</a>
                    <input type="text" class="form-control" id="app_id" placeholder="Enter telephone" name="app_id"
                           style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号:</a>
                    <input type="text" class="form-control" id="app_version" placeholder="Enter telephone" name="app_version"
                           style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号2:</a>
                    <input type="text" class="form-control" id="app_version2" placeholder="Enter telephone" name="app_version2"
                           style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号3:</a>
                    <input type="text" class="form-control" id="app_version3" placeholder="Enter telephone" name="app_version3"
                           style="width: 100%;margin-right: 10px">
                </div>
            </div>
            <div class="form-group">
                <a for="pwd">金蝶/ERP版本信息:</a>
                <input type="text" class="form-control" id="kd_version" placeholder="Enter telephone" name="kd_version"
                       value="">
            </div>
            <div class="form-group">
                <a for="pwd">公司地址:</a>
                <input type="text" class="form-control" id="address" placeholder="Enter telephone" name="address"
                       value="">
            </div>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 50%">
                    <a style="margin-right: 20px">时间控制日期(20190101):</a>
                    <input type="text" class="form-control" id="end_time" placeholder="Enter telephone" name="end_time"
                           value="">
                </div>
                <div class="form-group" style="width: 50%">
                    <a  style="margin-right: 20px">最大用户数:</a>
                    <input type="text" class="form-control" id="user_max" placeholder="Enter telephone" name="user_max"
                           style="width: 100%;margin-right: 10px">
                </div>
            </div>
            <div class="form-group">
                <a for="pwd">公司Logo:</a>
                <input type="text" class="form-control" id="img_logo_url" placeholder="Enter telephone" name="img_logo_url"
                       value="">
            </div>
            <%--<div class="form-group">--%>
                <%--<a for="pwd">备注:</a>--%>
                <%--<textarea class="form-control" rows="5" id="remark"  name="remark"></textarea>--%>
            <%--&lt;%&ndash;<textarea class="form-control" rows="5" id="remark"  name="remark" placeholder="Enter telephone"></textarea>&ndash;%&gt;--%>

            <%--</div>--%>

            <div class="form-check">
                <!-- <label class="form-check-label">
                  <input class="form-check-input" type="checkbox"> Remember me
                </label> -->
            </div>
        </form>
    </div>
</div>

</body>


</html>
