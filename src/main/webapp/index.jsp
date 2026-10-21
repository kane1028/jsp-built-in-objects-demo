<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="error.jsp" %><%
    // response：在页面输出前设置响应编码和自定义响应头。
    response.setCharacterEncoding("UTF-8");
    response.setHeader("X-Demo-Topic", "JSP-Built-In-Objects");
    // POST 表单必须先设置请求编码，再读取参数。
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String displayName = (name == null || name.trim().isEmpty()) ? "同学" : name.trim();

    // session：同一浏览器会话单独保存一份访问次数。
    int sessionVisits;
    synchronized (session) {
        Integer oldVisits = (Integer) session.getAttribute("sessionVisits");
        sessionVisits = (oldVisits == null) ? 1 : oldVisits + 1;
        session.setAttribute("sessionVisits", sessionVisits);
    }

    // application：所有用户共享；同步后再读取、递增，避免并发时丢失次数。
    long applicationVisits;
    synchronized (application) {
        Long oldVisits = (Long) application.getAttribute("applicationVisits");
        applicationVisits = (oldVisits == null) ? 1L : oldVisits + 1L;
        application.setAttribute("applicationVisits", applicationVisits);
    }

    // pageContext：不指定作用域时，属性默认放在当前页面作用域。
    pageContext.setAttribute("pageNote", "这是当前 JSP 页面的属性");
    String courseName = config.getInitParameter("courseName");
%><%@ include file="/WEB-INF/jspf/functions.jspf" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>JSP 九大内置对象 · 入门演示</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="container">
    <header class="topbar">
        <a class="brand" href="objects">JSP 实验室</a>
        <nav class="nav" aria-label="主导航">
            <a href="objects">九大内置对象</a>
            <a href="scopes.jsp">四大作用域</a>
        </nav>
    </header>
    <section class="hero">
        <p class="eyebrow">JAVA WEB · 可以动手试的 JSP</p>
        <h1>九大内置对象，一页看懂</h1>
        <p class="lead">JSP 容器已经创建好这些对象，可以在脚本片段和表达式中直接使用。填写姓名、刷新页面，再试试重定向与异常处理。</p>
        <% if ("1".equals(request.getParameter("redirected"))) { %>
        <p class="result">重定向成功：浏览器发起了一个新请求，地址中的 redirected=1 是新的请求参数。</p>
        <% } %>
    </section>

    <main class="grid">
        <section class="card">
            <span class="badge">01 · 请求</span>
            <h2>request</h2>
            <p>读取浏览器提交的表单参数。</p>
            <pre class="code">request.setCharacterEncoding("UTF-8");
String name = request.getParameter("name");</pre>
            <form action="objects" method="post">
                <label for="name">你的姓名</label>
                <input id="name" name="name" maxlength="40" value="<%= h(name == null ? "" : name) %>" placeholder="输入姓名">
                <button class="button" type="submit">提交姓名</button>
            </form>
            <p class="result">收到姓名：<strong><%= h(displayName) %></strong> · 请求方法：<%= h(request.getMethod()) %></p>
        </section>

        <section class="card">
            <span class="badge">02 · 响应</span>
            <h2>response</h2>
            <p>设置响应头，或通知浏览器跳转。</p>
            <pre class="code">response.setHeader("X-Demo-Topic", "JSP-Built-In-Objects");
response.sendRedirect("objects?redirected=1");</pre>
            <p class="result">本页已设置 X-Demo-Topic 响应头。</p>
            <a class="button secondary" href="response-demo.jsp">体验重定向</a>
            <p class="muted">可在浏览器开发者工具的 Network 中查看响应头。</p>
        </section>

        <section class="card">
            <span class="badge">03 · 页面输出</span>
            <h2>out</h2>
            <p>把文字写入当前页面的响应内容。</p>
            <pre class="code">out.print("你好，" + name + "！");</pre>
            <p class="result"><% // 实际调用 out.print；先转义输入，避免把用户输入当成 HTML。
                out.print(h("你好，" + displayName + "！这句话由 out.print 输出。"));
            %></p>
            <p class="muted">out 的类型是 JspWriter。</p>
        </section>

        <section class="card">
            <span class="badge">04 · 用户会话</span>
            <h2>session</h2>
            <p>在同一用户的多次请求间保存数据。</p>
            <pre class="code">session.setAttribute("sessionVisits", count);
session.getAttribute("sessionVisits");</pre>
            <p class="result">你的会话访问次数：<strong><%= sessionVisits %></strong></p>
            <p class="muted">刷新或提交表单会加 1；会话结束后重新计数。</p>
        </section>

        <section class="card">
            <span class="badge">05 · 整个应用</span>
            <h2>application</h2>
            <p>所有用户共享同一个 Web 应用对象。</p>
            <pre class="code">synchronized (application) {
    // 读取共享次数、加 1，再保存
    application.setAttribute("applicationVisits", count);
}</pre>
            <p class="result">应用累计访问次数：<strong><%= applicationVisits %></strong></p>
            <p class="muted">这里统计本演示页；应用重启后归零。</p>
        </section>

        <section class="card">
            <span class="badge">06 · Servlet 配置</span>
            <h2>config</h2>
            <p>读取当前 JSP 对应 Servlet 的配置。</p>
            <pre class="code">config.getServletName();
config.getInitParameter("courseName");</pre>
            <p class="result">Servlet：<strong><%= h(config.getServletName()) %></strong><br>
                课程：<strong><%= h(courseName == null ? "从 /objects 访问查看参数" : courseName) %></strong></p>
            <p class="muted">courseName 来自 web.xml 的 init-param。</p>
        </section>

        <section class="card">
            <span class="badge">07 · 页面上下文</span>
            <h2>pageContext</h2>
            <p>管理当前页面属性，也能指定其他作用域。</p>
            <pre class="code">pageContext.setAttribute("pageNote", "当前页属性");
pageContext.getAttribute("pageNote");</pre>
            <p class="result"><%= h(pageContext.getAttribute("pageNote")) %></p>
            <a href="scopes.jsp">继续比较四大作用域 →</a>
        </section>

        <section class="card">
            <span class="badge">08 · 当前页面实例</span>
            <h2>page</h2>
            <p>指向当前 JSP 生成的 Servlet 实例。</p>
            <pre class="code">page == this;
page.getClass().getName();</pre>
            <p class="result">page == this：<strong><%= page == this %></strong><br>
                实际类型：<%= h(page.getClass().getName()) %></p>
            <p class="muted">JSP 会先被容器转换、编译成 Servlet。</p>
        </section>

        <section class="card">
            <span class="badge">09 · 异常信息</span>
            <h2>exception</h2>
            <p>仅在声明 isErrorPage="true" 的错误页中可用。</p>
            <pre class="code">&lt;%@ page isErrorPage="true" %&gt;
exception.getMessage();</pre>
            <a class="button secondary" href="error-demo.jsp">触发一次演示异常</a>
            <p class="muted">error-demo.jsp 抛出异常后，由 error.jsp 接收并展示。</p>
        </section>
    </main>
    <footer class="muted">提示：这是帮助理解 JSP 的入门示例，使用 scriptlet 与表达式展示对象的实际调用。</footer>
</div>
</body>
</html>
