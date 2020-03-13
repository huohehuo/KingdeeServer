<%--
  Created by IntelliJ IDEA.
  User: NB
  Date: 2017/8/7
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" import="Bean.RegisterBean" import="WebSide.WebDao"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="WebSide.CompanyDao" %>
<%@ page import="Bean.Company" %>
<%@ page import="Utils.BaseData" %>
<%@ page import="Utils.ExcelExport" %>
<%@ page import="WebSide.UserControlDao" %>
<%@ page import="WebSide.StatisticalDao" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="Utils.CommonUtil" %>
<%@ page import="Bean.RegisterCodeBean" %>
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
    <%--<link rel="stylesheet" href="../js/vue.min.js">--%>
    <%--<link rel="stylesheet" href="../js/vue.min.js" />--%>
    <script src="../js/jquery.js"></script>
    <script src="https://cdn.staticfile.org/vue/2.2.2/vue.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios@0.12.0/dist/axios.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.13.1/lodash.min.js"></script>

</head>

<body>
<jsp:include page="../headLayout.jsp"/>
<%--
<%
    WebDao aa = new WebDao();
//    List list = (List) request.getAttribute("pl_list");
    List list = aa.getRegister();


    for (int i = 0; i < list.size(); i++) {
        RegisterBean rs = (RegisterBean) list.get(i);
%>--%>
<%
//    String tips = (String) request.getAttribute("tips");
//    HttpSession session = request.getSession();
//    String user = (String) session.getAttribute("userID");

%>

<div>
    <br/>
    <h2 style="width: 200px;text-align:center">用户控制->
        </h2>
</div>

<div>
    <hr/>
    <form action="../ActiveRegisterCode" method="post" style="padding-left: 20px">
        <h4 >PDA注册:</h4><a style="margin-right: 20px" href="http://148.70.108.65:8080/fangzuo/ui/Setting.html" target="_blank">(或者进入注册页面)</a>
        <div class="form-inline">
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px">IP地址:</a>
                <input type="text" class="form-control" id="wrt_ip" placeholder="Enter telephone" name="wrt_ip" href="fff" v-model="T_ip"
                       value="192.168.0.103" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px" v-model="T_tip">端口:</a>
                <input type="text" class="form-control" id="wrt_port" placeholder="Enter telephone" name="wrt_port" v-model="T_port"
                       value="8081" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px">注册码:</a>
                <input type="text" class="form-control" id="wrt_register_code" placeholder="Enter telephone" v-model="T_code"
                       name="wrt_register_code"
                       value="cc6ace5a59d39f08" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px"></a>
                <button type="submit" class="btn btn-primary form-control"  v-on:click="toRgist('')">确认注册</button>
            </div>
        </div>
    </form>
    <hr/>
    <form action="../ActiveUseTime" method="post" style="padding-left: 20px">
        <h4 >时间控制:</h4>
        <div class="form-inline" style="margin-bottom: 10px">
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px">IP地址:</a>
                <input type="text" class="form-control" id="time_ip" placeholder="Enter telephone" name="time_ip" href="fff"
                       value="192.168.0.103" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px">端口:</a>
                <input type="text" class="form-control" id="time_port" placeholder="Enter telephone" name="time_port"
                       value="8081" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px">终止日期(时间格式为：年月日组合的八位数：20190101):</a>
                <input type="text" class="form-control" id="time_end" placeholder="Enter telephone"
                       name="time_end"
                       value="20190101" style="width: 100%;margin-right: 10px">
            </div>
            <div class="form-group" style="width: 25%">
                <a style="margin-right: 20px"></a>
                <button type="submit" class="btn btn-primary form-control">确认修改</button>
            </div>
        </div>
    </form>
    <hr/>
</div>


<%--<div style="width: 100%">--%>
    <div  class="card" style="margin: 10px">

        <a style="padding-left: 20px;padding-top: 10px">当天请求注册的数据:</a>
        <div class="card-body">
            <table class="table">
                <thead>
                <%
                    StatisticalDao statisticalDao = new StatisticalDao();
                %>
                <tr>
                    <th>公司名称</th>
                    <th>APPID</th>
                    <th>备注</th>
                    <th>注册码</th>
                    <th>请求时间</th>
                    <%--<th>时间控制日期</th>--%>
                </tr>
                </thead>
                <tbody>
                <%
                    //    List list = (List) request.getAttribute("pl_list");
                    List stsList = statisticalDao.getRegisterCodeByData(CommonUtil.getTime(false));
                    if (stsList==null){
                %><div class="alert alert-info"> 列表数据为空</div><%
                        return;
                    }
                    for (int i = 0; i < stsList.size(); i++) {
                        RegisterCodeBean rs = (RegisterCodeBean) stsList.get(i);
                %>

                <tr>
                    <td><%=rs.getCompanyName() %></td>
                    <td><%=rs.getAppID() %></td>
                    <td><%=rs.getNote() %></td>
                    <td><%=rs.getRegister_code() %></td>
                    <td><%=rs.getTime() %></td>
                    <%--<td style="height: 45px;width:80px"><%=rs.getLast_use_date() %></td>--%>
                    <%--<td><a href="../company_find?json=<%=rs.getAppID()%>">管理</a></td>--%>
                    <%--<td><a href="../company_find_4log?json=<%=rs.getAppID()%>">程序更新日志</a></td>--%>
                </tr>
                </tbody>
                <%} %>
            </table>
        </div>

    </div>
    <%--<div class="registerhtml" style="width: 48%">--%>
        <%--<iFrame src=" http://148.70.108.65:8080/fangzuo/ui/Setting.html" width="48%" height="100%"></iFrame>--%>
    <%--</div>--%>

</div>

<%--当日请求注册的公司数据--%>




<script>
var ss = new Vue({
    el:'rgstVue',
    data:{
        T_tip:'',
        T_ip:'',
        T_port:'',
        T_code:''
    },
    watch:{
        T_port:function (newQuestion, oldQuestion) {
            this.T_tip = 'bianhua'
//            this.T_tip = this.T_ip+':'+T_port+'/'+T_code,
//            if(this.Tip.length>4){
//                this.T_tip = '端口：不能超过四位'
//            }else{
//                this.T_tip = '端口：'
//            }
        },
        methods:{
            toRgist:function (str) {
                var theone = this.T_code + 'fzkj601';
                var addpwd = $.md5(theone);
                var cat = addpwd.substring(8, 24);
                var addpwd2 = $.md5(cat);
                var cat2 = addpwd2.substring(8, 24);
//                url = "http://" + ip2 + ":" + port2 + "/Assist/RegisterCode" + "?json=" + cat2;

                axios.get('http://'+this.T_ip+':'+this.T_port+'/Assist/RegisterCode?json='+cat2)
                    .then(function (response) {
                        console.log(response);
                        vm.testTxtC = _.capitalize(response)
//                        vm.answer = _.capitalize(response.data.answer)
                    })
                    .catch(function (error) {
                        console.log(error);
//                        vm.answer = error
                        vm.testTxtC = 'Error! Could not reach the API. ' + error
                    })

            }
        }
    }
});

    function toRegister() {
        var url;
        							console.log("111");
        var ip2 = document.getElementById("wrt_ip").innerText;
        							console.log("111");
        var port2 = document.getElementById("wrt_port").innerText;
        							console.log("111");
        var one = document.getElementById("wrt_register_code").innerText;
        var theone = one + "fzkj601";
        var addpwd = $.md5(theone);
        var cat = addpwd.substring(8, 24);
        var addpwd2 = $.md5(cat);
        var cat2 = addpwd2.substring(8, 24);
        url = "http://" + ip2 + ":" + port2 + "/Assist/RegisterCode" + "?json=" + cat2;
        							console.log(url);
        //							document.getElementById("changeurl").href = url;
        //				document.getElementById("theurl").innerHTML = url;
        //document.getElementById("tvcode").value = url;
        // window.location.href=url;
        window.open(url, top);
        //				mui.ajax(url,null);
        //											loadXMLDoc(url);

    }

</script>

<%--<%
    //    List list = (List) request.getAttribute("pl_list");
    CompanyDao aa = new CompanyDao();
    List list = aa.getCompany();
    List<TestB> testBS = new ArrayList<>();

//    String[] strings = new String[]{"{ text: 'One', value: 'A' }","{ text: 'One2', value: 'B' }","{ text: 'One3', value: 'C' }"};
//    strings[0]="{ text: 'One', value: 'A' }";
//    strings[1]="";
//    strings[3]="";
//    strings[4]="{ text: 'One4', value: 'D' }";
//    strings[5]="{ text: 'One5', value: 'E' }";
%>--%>
<%--<div id="example-5">--%>
    <%--<select v-model="selected">--%>
        <%--<option disabled value="">请选择</option>--%>
        <%--<%--%>
            <%--for (int i = 0; i < list.size(); i++) {--%>
                <%--Company rs = (Company) list.get(i);--%>
                <%--testBS.add(new TestB(rs.getCompanyName(), rs.getAppID()));--%>

        <%--%>--%>
        <%--<option><%=rs.getCompanyName()%>--%>
        <%--</option>--%>
        <%--<%--%>
            <%--}--%>
            <%--String res = new Gson().toJson(testBS);--%>
        <%--%>--%>
    <%--</select>--%>
    <%--<span id="getSelectData">Selected: {{ selected }}</span>--%>
<%--</div>--%>
<br/>

<%--<div id="select2">--%>
    <%--<select v-model="selected">--%>
        <%--<option v-for="option in options" v-bind:value="option.value">--%>
            <%--{{ option.text }}--%>
        <%--</option>--%>
    <%--</select>--%>
    <%--<span>Selected: {{ selected }}</span>--%>
<%--</div>--%>
<%--<br/>--%>


<%--<div id="app-5">--%>
    <%--<p>{{ message }}</p>--%>
    <%--<button v-on:click="reverseMessage">反转消息</button>--%>
    <%--<button v-on:click="toSet('')">修改消息</button>--%>
<%--</div>--%>


<%--<div id="watch-example">--%>
    <%--<p>--%>
        <%--Ask a yes/no question:--%>
        <%--<input v-model="question">--%>
    <%--</p>--%>
    <%--<p>{{ answer }}</p>--%>
<%--</div>--%>
<script>
    var watchExampleVM = new Vue({
        el: '#watch-example',
        data: {
            question: '',
            answer: 'I cannot give you an answer until you ask a question!'
        },
        watch: {
            // 如果 `question` 发生改变，这个函数就会运行
            question: function (newQuestion, oldQuestion) {
                this.answer = 'Waiting for you to stop typing...'
                this.debouncedGetAnswer()
            }
        },
        created: function () {
            // `_.debounce` 是一个通过 Lodash 限制操作频率的函数。
            // 在这个例子中，我们希望限制访问 yesno.wtf/api 的频率
            // AJAX 请求直到用户输入完毕才会发出。想要了解更多关于
            // `_.debounce` 函数 (及其近亲 `_.throttle`) 的知识，
            // 请参考：https://lodash.com/docs#debounce
            this.debouncedGetAnswer = _.debounce(this.getAnswer, 500)
        },
        methods: {
            getAnswer: function () {
//                if (this.question.indexOf('?') === -1) {
//                    this.answer = 'Questions usually contain a question mark. ;-)'
//                    return
//                }
                this.answer = 'Thinking...'
                var vm = this
                axios.get('http://148.70.108.65:8080/LogAssist/UserIO')
                    .then(function (response) {
                        console.log(response);
                        vm.answer = _.capitalize(response)
//                        vm.answer = _.capitalize(response.data.answer)
                    })
                    .catch(function (error) {
                        console.log(error);
//                        vm.answer = error

                        vm.answer = 'Error! Could not reach the API. ' + error
                    })
            }
        }
    })
    var slel = new Vue({
        el: '#example-5',
        data: {
            selected: ''
        }
    })

    var test = new Vue({
        el: '#app-5',
        data: {
            message: 'Hello Vue.js!'
        },
        methods: {
            reverseMessage: function () {
                this.message = this.message.split('').reverse().join('')
            },
            toSet: function (str) {
                this.message = document.getElementById("getSelectData").innerText
            }
        }
    })

    var dle = new Vue({
        el: '#select2',
        data: {
            selected: 'A',
            <%--options: <%=res%>--%>
//            options: [{"text":"one","value":"A"},{"text":"one2","value":"B"},{"text":"one3","value":"C"}]
//            options: [
//                { text: 'One', value: 'A' },
//                { text: 'Two', value: 'B' },
//                { text: 'Three', value: 'C' }
//            ]
        }
    })

</script>

<hr/>


<%--<div class="container" style="margin-top: 88px">--%>
<%--<div  class="card">--%>
<%--<div class="card-body">--%>
<%--<table class="table">--%>
<%--<thead>--%>
<%--<%--%>
<%--CompanyDao aa = new CompanyDao();--%>
<%--UserControlDao userControlDao = new UserControlDao();--%>
<%--//                    List userControlList = userControlDao.getUserControlList();--%>
<%--//                    String statisticalNum = statisticalDao.getUserNum4Appid();--%>
<%--%>--%>
<%--<tr>--%>
<%--<th>公司名称</th>--%>
<%--<th>APP版本号</th>--%>
<%--<th>用户数</th>--%>
<%--</tr>--%>
<%--</thead>--%>
<%--<tbody>--%>
<%--<%--%>

<%--//    List list = (List) request.getAttribute("pl_list");--%>
<%--List list = aa.getCompany();--%>
<%--if (list==null){--%>
<%--%><div class="alert alert-info"> 列表数据为空</div><%--%>
<%--return;--%>
<%--}--%>
<%--for (int i = 0; i < list.size(); i++) {--%>
<%--Company rs = (Company) list.get(i);--%>
<%--%>--%>

<%--<tr>--%>
<%--<td><%=rs.getCompanyName() %></td>--%>
<%--<td><%=rs.getAppVersion() %></td>--%>
<%--<td><%=userControlDao.getUserControlNum4Appid(rs.getAppID() )%></td>--%>
<%--&lt;%&ndash;<td><%=rs.getAppID() %></td>&ndash;%&gt;--%>
<%--&lt;%&ndash;<td style="height: 45px;width:80px"><%=rs.getLast_use_date() %></td>&ndash;%&gt;--%>
<%--<td><a href="../company_find_4upgrade?json=<%=rs.getAppID()%>">管理</a></td>--%>
<%--</tr>--%>
<%--</tbody>--%>
<%--<%} %>--%>
<%--</table>--%>
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
