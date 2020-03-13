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
<jsp:include page="../headLayout.jsp"/>

<div>
    <br/>
    <h2 style="width: 200px;text-align:center">概况-></h2>
</div>
<hr/>
<%
    CompanyDao aa = new CompanyDao();
    StatisticalDao statisticalDao = new StatisticalDao();
//    List list = (List) request.getAttribute("pl_list");
    String companyNum = aa.getCompanyNum();
    String statisticalNum = statisticalDao.getStatisticalNum();
    String statisticalLiveUserNum = statisticalDao.getStatisticalLiveUserNum();//获取统计信息表中的当天的活跃用户数
    String statisticalActiveNum = statisticalDao.getStatisticalActiveNum();//获取统计信息表中的当天的活跃度

    String thisMon= CommonUtil.getTime(true);
    List<LiveDataBean> liveData = statisticalDao.getStatisticalLiveData4User(thisMon.substring(0,thisMon.length()-2));
//    List<LiveDataBean> liveData4Num = statisticalDao.getStatisticalLiveData4Num(thisMon.substring(0,thisMon.length()-2));//无法统计每天活跃度
    List<String> dayList = new ArrayList<>();
    List<String> dayList4Num = new ArrayList<>();
    for (int i = 0; i <= 31; i++) {
        dayList.add(i,"0");
        dayList4Num.add(i,"0");
    }
//    Lg.e("得到daylist1111"+dayList.size(),dayList);

    /*活跃用户数*/
    for (int i = 0; i <= 32; i++) {
        for (int j = 0; j < liveData.size(); j++) {
            Lg.e("liveData"+i,MathUtil.toInt(liveData.get(j).LDay));
            if (MathUtil.toInt(liveData.get(j).LDay)==i){
                Lg.e("替换"+i+"--"+liveData.get(j).LNum);
                dayList.set(i-1,liveData.get(j).LNum);
            }
        }
    }
//    /*活跃度*/
//    for (int i = 0; i <= 32; i++) {
//        for (int j = 0; j < liveData4Num.size(); j++) {
//            if (MathUtil.toInt(liveData4Num.get(j).LDay)==i){
//                Lg.e("替换"+i+"--"+liveData4Num.get(j).LNum);
//                dayList4Num.set(i-1,liveData4Num.get(j).LNum);
//            }
//        }
//    }

//        Lg.e("得到daylist"+dayList.size(),dayList);

                    String sssss = (String)session.getAttribute(Info.UserNameKey);
%>

<%--<input type="button" class="btn btn-outline-primary"  value="刷新" onclick="window.location.reload();"/>--%>
<div style="margin:30px">
        <div class="row">
            <div class="card statiscard" onclick="location.href='CompanyList.jsp'">
                <h3>累计项目数:  <%=companyNum%><%=sssss%></h3>
            </div>
            <div class="statiscard card">
                <h3>累计用户数:  <%=statisticalNum%></h3>
            </div>
            <div class="statiscard card" onclick="location.href='ActiveUserList.jsp'">
                <h3>今日活跃人数:  <%=statisticalLiveUserNum%></h3>
            </div>
            <div class="statiscard card" onclick="location.href='ActiveUserList.jsp'">
                <h3>占比:  <%=MathUtil.D2saveInt(MathUtil.toD(statisticalActiveNum)/MathUtil.toD(statisticalNum)*100)+"%"%></h3>
            </div>
        </div>
</div>
<hr/>


<%--<div id="container2" style="width:100%;height:400px"></div>--%>
<hr/>
<div id="container" style="width:100%;height:400px"></div>
<script>
    // JS 代码
    var chart = Highcharts.chart('container', {
        title: {
            text: '当月活跃人数情况'
        },
//        subtitle: {
//            text: '数据来源：thesolarfoundation.com'
//        },
        yAxis: {
            title: {
                text: '用户数'
            }
        },
        legend: {
            layout: 'vertical',
            align: 'right',
            verticalAlign: 'middle'
        },
        plotOptions: {
            series: {
                label: {
                    connectorAllowed: false
                },
                pointStart: 1
            }
        },
        series: [{
            name: '活跃人数',
            data: <%=dayList%>
//            data:[5, 10, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2]
        }
// , {
//            name: '工人',
//            data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]
//        }, {
//            name: '销售',
//            data: [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]
//        }, {
//            name: '项目开发',
//            data: [null, null, 7988, 12169, 15112, 22452, 34400, 34227]
//        }, {
//            name: '其他',
//            data: [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]
//        }
        ],
        responsive: {
            rules: [{
                condition: {
                    maxWidth: 500
                },
                chartOptions: {
                    legend: {
                        layout: 'horizontal',
                        align: 'center',
                        verticalAlign: 'bottom'
                    }
                }
            }]
        }
    });
</script>
<%--<script>--%>
    <%--// JS 代码--%>
    <%--var chart = Highcharts.chart('container2', {--%>
        <%--title: {--%>
            <%--text: '当月活跃度情况'--%>
        <%--},--%>
<%--//        subtitle: {--%>
<%--//            text: '数据来源：thesolarfoundation.com'--%>
<%--//        },--%>
        <%--yAxis: {--%>
            <%--title: {--%>
                <%--text: '活跃度(进入软件)'--%>
            <%--}--%>
        <%--},--%>
        <%--legend: {--%>
            <%--layout: 'vertical',--%>
            <%--align: 'right',--%>
            <%--verticalAlign: 'middle'--%>
        <%--},--%>
        <%--plotOptions: {--%>
            <%--series: {--%>
                <%--label: {--%>
                    <%--connectorAllowed: false--%>
                <%--},--%>
                <%--pointStart: 1--%>
            <%--}--%>
        <%--},--%>
        <%--series: [{--%>
            <%--name: '活跃度',--%>
            <%--data: <%=dayList4Num%>--%>
<%--//            data:[5, 10, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2, 20, 30, 30, 30, 2]--%>
        <%--}--%>
<%--// , {--%>
<%--//            name: '工人',--%>
<%--//            data: [24916, 24064, 29742, 29851, 32490, 30282, 38121, 40434]--%>
<%--//        }, {--%>
<%--//            name: '销售',--%>
<%--//            data: [11744, 17722, 16005, 19771, 20185, 24377, 32147, 39387]--%>
<%--//        }, {--%>
<%--//            name: '项目开发',--%>
<%--//            data: [null, null, 7988, 12169, 15112, 22452, 34400, 34227]--%>
<%--//        }, {--%>
<%--//            name: '其他',--%>
<%--//            data: [12908, 5948, 8105, 11248, 8989, 11816, 18274, 18111]--%>
<%--//        }--%>
        <%--],--%>
        <%--responsive: {--%>
            <%--rules: [{--%>
                <%--condition: {--%>
                    <%--maxWidth: 500--%>
                <%--},--%>
                <%--chartOptions: {--%>
                    <%--legend: {--%>
                        <%--layout: 'horizontal',--%>
                        <%--align: 'center',--%>
                        <%--verticalAlign: 'bottom'--%>
                    <%--}--%>
                <%--}--%>
            <%--}]--%>
        <%--}--%>
    <%--});--%>
<%--</script>--%>

</body>


</html>
