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

    <script src="https://code.highcharts.com.cn/highcharts/highcharts.js"></script>
    <script src="https://code.highcharts.com.cn/highcharts/modules/exporting.js"></script>
    <script src="https://code.highcharts.com.cn/highcharts/modules/series-label.js"></script>
    <script src="https://code.highcharts.com.cn/highcharts/modules/oldie.js"></script>
    <script src="https://code.highcharts.com.cn/highcharts-plugins/highcharts-zh_CN.js"></script>



</head>
<style type="text/css">
    .cardBox {
        width: 200px;
        box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
        text-align: center;
        float: left;
        margin-left: 20px;
        /*margin-right: 10px;*/
        /*padding: 5px;*/
        /*padding-top: 15px;*/
    }

    .headerBox {
        color: #fff;
        padding: 10px;
        font-size: 15px;
        height: 60px;
    }

    .bodyBox {
        padding: 10px;
    }

    .bodyBox p {
        margin-left: 5px;
    }
    .statiscard {
        margin:12px;
        width: 23%;
        height: 150px;
        text-align: center;
        padding: 60px;
        background-color: #5ea4fe;
    }
</style>
<body>

<hr/>


<%--<input type="button" class="btn btn-outline-primary"  value="刷新" onclick="window.location.reload();"/>--%>
<div  style="margin:30px">
        <div class="row  justify-content-center">
            <div class="card statiscard" onclick="location.href='StoreCheck.jsp'">
                <h3>库存查询</h3>
            </div>
            <div class="statiscard card">
                <h3>仓库查询</h3>
            </div>
        </div>
</div>
<hr/>

<hr/>
</body>


</html>
