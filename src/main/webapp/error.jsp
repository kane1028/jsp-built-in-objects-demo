<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %><%@ include file="/WEB-INF/jspf/functions.jspf" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JSP exception 内置对象 · 错误页</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <header class="topbar">
        <a class="brand" href="objects">JSP 实验室</a>
        <nav class="nav" aria-label="主导航"><a href="objects">九大内置对象</a><a href="scopes.jsp">四大作用域</a></nav>
    </header>
    <main>
        <section class="hero">
            <p class="eyebrow">EXCEPTION · 容器转交的异常</p>
            <h1>在错误页读取 exception</h1>
            <p class="lead">本页声明了 isErrorPage="true"，因此可以使用 exception 内置对象。</p>
        </section>
        <section class="card">
            <h2>实际异常信息</h2>
            <pre class="code">&lt;%@ page isErrorPage="true" %&gt;
exception.getClass().getName();
exception.getMessage();</pre>
            <% if (exception != null) { %>
            <p class="result">异常类型：<strong><%= h(exception.getClass().getName()) %></strong></p>
            <p class="result">异常消息：<%= h(exception.getMessage()) %></p>
            <p class="muted">error-demo.jsp 通过 errorPage="error.jsp" 指定了本页。容器捕获异常后，将异常交给本页处理。</p>
            <% } else { %>
            <p class="result">当前没有异常：你直接打开了错误页。</p>
            <p class="muted">请点击“再次触发异常”，观察容器如何传递 exception 对象。</p>
            <% } %>
            <a class="button" href="objects">返回内置对象演示</a>
            <a class="button secondary" href="error-demo.jsp">再次触发异常</a>
        </section>
    </main>
</div>
</body>
</html>
