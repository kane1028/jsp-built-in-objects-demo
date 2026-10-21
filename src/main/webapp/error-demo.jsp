<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp" %><%
    // 真实抛出异常，容器将请求交给 errorPage 指定的 JSP。
    // 使用运行时条件，让 JSP 生成的 Servlet 后续清理代码仍可被编译。
    if (request.getAttribute("skipDemoError") == null) {
        throw new IllegalStateException("这是为学习 exception 内置对象而主动触发的演示异常。");
    }
%><%@ include file="/WEB-INF/jspf/functions.jspf" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JSP 异常触发演示</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <header class="topbar">
        <a class="brand" href="objects">JSP 实验室</a>
        <nav class="nav" aria-label="主导航"><a href="objects">九大内置对象</a><a href="scopes.jsp">四大作用域</a></nav>
    </header>
    <main class="hero">
        <p class="eyebrow">EXCEPTION · 异常入口</p>
        <h1>异常触发演示</h1>
        <p class="lead">正常访问本页会抛出异常，并由 error.jsp 展示异常对象。</p>
        <a class="button" href="objects">返回内置对象演示</a>
    </main>
</div>
</body>
</html>
