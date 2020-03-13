<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>Insert title here</title>
  <link rel="stylesheet" type="text/css" href="css/loginstyle.css"/>
  <link rel="stylesheet" href="https://cdn.staticfile.org/twitter-bootstrap/4.1.0/css/bootstrap.min.css">
  <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
  <script src="https://cdn.staticfile.org/jquery/3.2.1/jquery.min.js"></script>

  <!-- popper.min.js 用于弹窗、提示、下拉菜单 -->
  <script src="https://cdn.staticfile.org/popper.js/1.12.5/umd/popper.min.js"></script>

  <!-- 最新的 Bootstrap4 核心 JavaScript 文件 -->
  <script src="https://cdn.staticfile.org/twitter-bootstrap/4.1.0/js/bootstrap.min.js"></script>

</head>
<body>
<jsp:include page="../../headLayout.jsp"/>
<%
  String feedok = (String) request.getAttribute("feedback_ok");
  String feed = (String) request.getAttribute("feedback");
%>
<div class="container" style="margin-top: 88px">
  <br/>
    <div class="container" style="padding: 50px" text-align="center">

    <%
        if ("ok".equals(feedok)){
            %>
        <table>
            <tr>
                <th><img src="./img/success.png" alt="" style="text-align:center"></th>
                <th> <h2 style="padding-left:50px;text-align:center"><%=feed%></h2></th>
            </tr>
        </table>
    <%
        }else{
    %>
        <table>
            <tr>
                <th><img src="./img/error.png" alt="" style="text-align:center"></th>
                <th> <h2 style="padding-left:50px;text-align:center"><%=feed%></h2></th>
            </tr>
        </table>

    <%
        }
    %>
    </div>
  <hr/>
  <button type="button" class="btn btn-outline-primary container" value="返回" onclick="window.history.go(-1)">返回</button>
</div>

</body>
</html>