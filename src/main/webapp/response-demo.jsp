<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%
    // 先设置响应头，再发送重定向；此处不能先输出 HTML。
    response.setHeader("X-Demo-Action", "redirect");
    // 重定向会让浏览器重新请求 objects，原请求中的属性不会自动传递。
    response.sendRedirect(response.encodeRedirectURL("objects?redirected=1"));
%>
