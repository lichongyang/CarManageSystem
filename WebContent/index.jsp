<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet" type="text/css" />
<link href="<%=request.getContextPath() %>/css/platform.css" rel="stylesheet" type="text/css" />
<title>Insert title here</title>
</head>
<body>
<div class="container">
        <div id="pf-hd">
            <ul class="pf-nav">
                <li class="pf-nav-item home current" data-menu="car">
                    <a href="javascript:;">
                        <span class="pf-nav-icon car-icon"></span>
                        <span class="pf-nav-title">车辆销售分析</span>
                    </a>
                </li>
                <li class="pf-nav-item project" data-menu="client">
                    <a href="javascript:;">
                        <span class="pf-nav-icon client-icon"></span>
                        <span class="pf-nav-title">顾客分析</span>
                    </a>
                </li>
                <li class="pf-nav-item static" data-menu="employee">
                    <a href="javascript:;">
                        <span class="pf-nav-icon static-icon"></span>
                        <span class="pf-nav-title">绩效管理</span>
                    </a>
                </li>
            </ul>
        </div>
        <div id="pf-bd">
            <div id="pf-sider">
            </div>

            <div id="pf-page">
                <iframe src="" frameborder="no"   border="no" height="100%" width="100%" scrolling="auto"></iframe>
            </div>
        </div>

        <div id="pf-ft">
            
        </div>
    </div>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/layer.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/common.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/menu.js"></script>
    <script type="text/javascript" src="<%=request.getContextPath() %>/js/main.js"></script>
    

</body>
</html>