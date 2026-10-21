<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="WEB-INF/jspf/functions.jspf" %>
<%
    response.setHeader("Cache-Control", "no-store");
    // 目标页只读取数据，绝不重新保存，否则无法观察作用域的区别。
    String mode = (String) request.getAttribute("viewMode");
    if (mode == null) mode = request.getParameter("mode");
    String title = "直接访问目标页面";
    String explanation = "没有执行保存操作。page 和 request 为空，session 和 application 可能保留以前的数据。";
    if ("forward".equals(mode)) {
        title = "请求转发后的结果";
        explanation = "换了 JSP 页面，所以 page 取不到；仍是同一次请求，所以 request、session、application 都能取到。";
    } else if ("redirect".equals(mode)) {
        title = "浏览器重定向后的结果";
        explanation = "浏览器发起了新请求，所以 page、request 取不到；同一会话和应用仍在，所以 session、application 能取到。";
    } else if ("new-session".equals(mode)) {
        title = "会话失效后的结果";
        explanation = "原会话已失效。新页面、新请求、新会话都没有原数据；application 仍属于同一应用，能保留先前保存的值。";
    }
    Object pageValue = pageContext.getAttribute("scopeValue");
    Object requestValue = request.getAttribute("scopeValue");
    Object sessionValue = session.getAttribute("scopeValue");
    Object applicationValue = application.getAttribute("scopeValue");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= h(title) %> · JSP 课堂实验</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<main class="container">
    <header class="topbar">
        <a class="brand" href="objects">JSP 课堂实验</a>
        <nav class="nav"><a href="objects">九大内置对象</a><a href="scopes.jsp">四种作用域</a></nav>
    </header>
    <section class="hero">
        <p class="eyebrow">实验二 / SCOPE RESULT</p>
        <h1><%= h(title) %></h1>
        <p class="lead"><%= h(explanation) %></p>
    </section>
    <section class="card">
        <h2>目标页面：scope-result.jsp</h2>
        <p class="notice">本页只执行 getAttribute()，以下都是服务器实际读取的结果。</p>
        <div class="table-wrap">
            <table>
                <thead><tr><th>作用域</th><th>读取代码</th><th>实际值</th><th>是否可见</th></tr></thead>
                <tbody>
                <tr><td><strong>page</strong></td><td><code>pageContext.getAttribute("scopeValue")</code></td><td><%= pageValue == null ? "（null）" : h(pageValue) %></td><td><%= pageValue == null ? "不可见" : "可见" %></td></tr>
                <tr><td><strong>request</strong></td><td><code>request.getAttribute("scopeValue")</code></td><td><%= requestValue == null ? "（null）" : h(requestValue) %></td><td><%= requestValue == null ? "不可见" : "可见" %></td></tr>
                <tr><td><strong>session</strong></td><td><code>session.getAttribute("scopeValue")</code></td><td><%= sessionValue == null ? "（null）" : h(sessionValue) %></td><td><%= sessionValue == null ? "不可见" : "可见" %></td></tr>
                <tr><td><strong>application</strong></td><td><code>application.getAttribute("scopeValue")</code></td><td><%= applicationValue == null ? "（null）" : h(applicationValue) %></td><td><%= applicationValue == null ? "不可见" : "可见" %></td></tr>
                </tbody>
            </table>
        </div>
        <p><a class="button" href="scopes.jsp">返回，继续实验</a></p>
    </section>
    <section class="card">
        <h2>四种方式的预期结果</h2>
        <div class="table-wrap">
            <table>
                <thead><tr><th>操作</th><th>page</th><th>request</th><th>session</th><th>application</th></tr></thead>
                <tbody>
                <tr><td>保存并在本页读取</td><td>可见</td><td>可见</td><td>可见</td><td>可见</td></tr>
                <tr><td>保存并转发</td><td>不可见</td><td>可见</td><td>可见</td><td>可见</td></tr>
                <tr><td>保存并重定向</td><td>不可见</td><td>不可见</td><td>可见</td><td>可见</td></tr>
                <tr><td>保存数据后使会话失效</td><td>不可见</td><td>不可见</td><td>不可见</td><td>可见</td></tr>
                </tbody>
            </table>
        </div>
        <p class="muted">“会话失效”实验需要先保存一次数据。直接点它时，application 也可能尚未保存。</p>
    </section>
</main>
</body>
</html>
