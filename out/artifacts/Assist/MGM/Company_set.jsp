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
<%@ page import="WebApp.Info" %>
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
    String code = companyDao.getDeleteCode();

    String sssss = (String)session.getAttribute(Info.UserNameKey);
%>

<jsp:include page="../headLayout.jsp"/>
<div>
    <br/>
    <h2 style="width: 200px;text-align:center">项目修改-><%=sssss%></h2>
</div>
<hr/>
<div class="container" style="margin-top: 88px">
    <div  class="card">
        <div class="card-header">
            <button type="button" class="btn btn-outline-primary" value="返回公司列表" onclick="location.href='MGM/CompanyList.jsp'">返回公司列表</button>
        </div>
        <%--<input type="button" value="更改提示" onclick="document.getElementById('tips').innerHTML = '删除成功'"/>--%>
        <%--<div class="alert alert-info">信息！请注意这个信息。</div>--%>
        <form action="./CompanyChange" method="post" style="padding: 50px">
            <button type="submit" class="btn btn-primary">确定修改</button>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 50%">
                    <a style="margin-right: 20px">公司名称:</a>
                    <input type="text" class="form-control" id="company_name" placeholder="Enter your name" name="company_name"
                           value="<%=company.getCompanyName()%>" style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 50%">
                    <a  style="margin-right: 20px">电话:</a>
                    <input type="text" class="form-control" id="phone" placeholder="Enter telephone" name="phone"
                           value="<%=company.getPhone()%>" style="width: 100%;margin-right: 10px">
                </div>
            </div>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 25%">
                    <a style="margin-right: 20px">APPID:(不可修改)</a>
                    <input type="text" class="form-control" id="app_id" placeholder="Enter telephone" name="app_id"
                           value="<%=company.getAppID()%>" style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号:</a>
                    <input type="text" class="form-control" id="app_version" placeholder="Enter telephone" name="app_version"
                           value="<%=company.getAppVersion()%>" style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号2:</a>
                    <input type="text" class="form-control" id="app_version2" placeholder="Enter telephone" name="app_version2"
                           value="<%=company.getAppVersion2()%>" style="width: 100%;margin-right: 10px">
                </div>
                <div class="form-group" style="width: 25%">
                    <a  style="margin-right: 20px">APP版本号3:</a>
                    <input type="text" class="form-control" id="app_version3" placeholder="Enter telephone" name="app_version3"
                           value="<%=company.getAppVersion3()%>" style="width: 100%;margin-right: 10px">
                </div>

            </div>

            <div class="form-group">
                <a >金蝶/ERP版本信息:</a>
                <input type="text" class="form-control" id="kd_version" placeholder="Enter telephone" name="kd_version"
                       value="<%=company.getKingdeeVersion()%>">
            </div>
            <div class="form-group">
                <a >公司地址:</a>
                <input type="text" class="form-control" id="address" placeholder="Enter telephone" name="address"
                       value="<%=company.getAddress()%>">
            </div>
            <div class="form-inline" style="margin-bottom: 10px">
                <div class="form-group" style="width: 50%">
                    <a style="margin-right: 20px">时间控制日期(20190101):</a>
                    <input type="text" class="form-control" id="end_time" placeholder="Enter telephone" name="end_time"
                           value="<%=company.getEndTime()%>">
                </div>
                <div class="form-group" style="width: 50%">
                    <a  style="margin-right: 20px">最大用户数:</a>
                    <input type="text" class="form-control" id="user_max" placeholder="Enter telephone" name="user_max"
                           value="<%=company.getUser_num_max()%>">
                </div>
            </div>
            <div class="form-group">
                <a >公司Logo:</a>
                <input type="text" class="form-control" id="img_logo_url" placeholder="Enter telephone" name="img_logo_url"
                       value="<%=company.getImg_Logo()%>">
            </div>
            <%--<input type="hidden" class="form-control" id="code" placeholder="Enter telephone" name="code"--%>
                   <%--value="<%=companyDao.getDeleteCode()%>">--%>
            <%--<div class="form-group">--%>
                <%--<a >项目Log日志:</a>--%>
                <%--&lt;%&ndash;<input type="text" class="form-control" rows="5" id="remark" placeholder="Enter telephone" name="remark"&ndash;%&gt;--%>
                       <%--&lt;%&ndash;value="<%=company.getRemark()%>">&ndash;%&gt;--%>
                <input type="hidden" class="form-control" rows="5" id="remark"  name="remark" value="<%=company.getRemark()%>">

            <%--</div>--%>

            <%--<a href="company_delete?json=" onclick="cpdelete(<%=company.getAppID()%>)">删除</a>--%>

        </form>
        <button  class="btn btn-outline-danger" style="margin: 50px;width: 150px;" onclick="cpdelete()">删除</button>
        <script type="text/javascript">
            function cpdelete(){
                var codedd = document.getElementsByName("code");
                var person=prompt("是否删除该公司的数据，版本数据也将会一并删除，请注意\n请输入操作码","Harry Potter");
                if (person!=null && person!=""){
//                    if(person=="fangzuokeji12345789!@#$%"){
                        window.location.href="company_delete?json=<%=company.getAppID()%>&pwd="+person;
//                    }else{
//                        alert("删除失败，操作码错误");
//                    }
                }
                <%--var r=confirm("是否删除该公司的数据，版本数据也将会一并删除，请注意");--%>
                <%--if (r==true){--%>
                    <%--window.location.href="company_delete?json=<%=company.getAppID()%>";--%>
                <%--}--%>
//                else{
//                    x="你按下了\"取消\"按钮!";
//                }
//                document.getElementById("demo").innerHTML=x;
            }
        </script>
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
