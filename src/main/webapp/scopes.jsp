<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="WEB-INF/jspf/functions.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-store");
    String mode = request.getParameter("mode");
    String value = request.getParameter("value");
    if (value == null || value.trim().isEmpty()) value = "你好，JSP";
    if (value.length() > 80) value = value.substring(0, 80);

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // 使当前会话失效：下一页会创建一个新会话，application 中的数据仍在。
        if ("new-session".equals(mode)) {
            session.invalidate();
            response.sendRedirect("scope-result.jsp?mode=new-session");
            return;
        }

        if ("same".equals(mode) || "forward".equals(mode) || "redirect".equals(mode)) {
            // 相同的属性名，分别存入四种作用域。每一行都是独立的保存操作。
            pageContext.setAttribute("scopeValue", value, PageContext.PAGE_SCOPE);
            request.setAttribute("scopeValue", value);
            session.setAttribute("scopeValue", value);
            application.setAttribute("scopeValue", value);

            if ("forward".equals(mode)) {
                // 转发：还是同一次请求，但已经换了一个 JSP 页面。
                request.setAttribute("viewMode", "forward");
                pageContext.forward("scope-result.jsp");
                return;
            }
            if ("redirect".equals(mode)) {
                // 重定向：浏览器会向目标页面发起一次全新的请求。
                response.sendRedirect("scope-result.jsp?mode=redirect");
                return;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>四种作用域演示 · JSP 课堂实验</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<main class="container">
    <header class="topbar">
        <a class="brand" href="objects">JSP 课堂实验</a>
        <nav class="nav"><a href="objects">九大内置对象</a><a href="scopes.jsp">四种作用域</a></nav>
    </header>
    <section class="hero">
        <p class="eyebrow">实验二 / FOUR SCOPES</p>
        <h1>四种作用域，数据能保存多久？</h1>
        <p class="lead">把同一个值存入四个位置，再通过本页、转发、重定向和新会话观察差别。</p>
    </section>

    <section class="card">
        <h2>1. 输入并选择观察方式</h2>
        <form action="scopes.jsp" method="post">
            <label for="value">演示数据</label>
            <input id="value" name="value" maxlength="80" value="<%= h(value) %>" required>
            <p class="muted">前三个按钮会先向四种作用域保存数据；“新会话”只清除当前会话，不重新保存。</p>
            <div class="actions">
                <button class="button" name="mode" value="same">保存并在本页读取</button>
                <button class="button secondary" name="mode" value="forward">保存并转发</button>
                <button class="button secondary" name="mode" value="redirect">保存并重定向</button>
                <button class="button secondary" name="mode" value="new-session">使会话失效并查看</button>
            </div>
        </form>
    </section>

    <section class="card">
        <h2>2. 当前页面的实际读取结果</h2>
        <p class="notice"><%= "same".equals(mode) && "POST".equalsIgnoreCase(request.getMethod()) ? "已在本页保存并读取：四种作用域都能取到值。" : "当前是直接访问页面，尚未向本页和本次请求保存数据。会话和应用可能保留上次保存的值。" %></p>
        <div class="table-wrap">
            <table>
                <thead><tr><th>作用域</th><th>读取代码</th><th>实际值</th><th>有效范围</th></tr></thead>
                <tbody>
                <tr><td><strong>page</strong></td><td><code>pageContext.getAttribute("scopeValue")</code></td><td><%= pageContext.getAttribute("scopeValue") == null ? "（不可见 / 未保存）" : h(pageContext.getAttribute("scopeValue")) %></td><td>当前 JSP 页面</td></tr>
                <tr><td><strong>request</strong></td><td><code>request.getAttribute("scopeValue")</code></td><td><%= request.getAttribute("scopeValue") == null ? "（不可见 / 未保存）" : h(request.getAttribute("scopeValue")) %></td><td>同一次请求，包括转发</td></tr>
                <tr><td><strong>session</strong></td><td><code>session.getAttribute("scopeValue")</code></td><td><%= session.getAttribute("scopeValue") == null ? "（不可见 / 未保存）" : h(session.getAttribute("scopeValue")) %></td><td>同一用户的同一会话</td></tr>
                <tr><td><strong>application</strong></td><td><code>application.getAttribute("scopeValue")</code></td><td><%= application.getAttribute("scopeValue") == null ? "（不可见 / 未保存）" : h(application.getAttribute("scopeValue")) %></td><td>同一 Web 应用，所有用户共享</td></tr>
                </tbody>
            </table>
        </div>
    </section>

    <section class="card">
        <h2>3. 记住这四行保存代码</h2>
        <pre class="code">pageContext.setAttribute("scopeValue", value, PageContext.PAGE_SCOPE);
request.setAttribute("scopeValue", value);
session.setAttribute("scopeValue", value);
application.setAttribute("scopeValue", value);</pre>
        <p class="muted">范围从小到大：page → request → session → application。会话超时或失效会清除 session；应用重启或重新部署会清除 application。</p>
    </section>
</main>
</body>
</html>
