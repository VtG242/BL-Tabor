<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*"%>
<%@page import="java.sql.*"%>
<%
    session.setMaxInactiveInterval(-1);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BL - Název ligy</title>
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <base target="left"/>
    </head>
    <body>
        <table>
            <tr>
                <td><strong>Bowlingová liga - <%=(String) session.getAttribute("lname") + " (" + session.getAttribute("lshort") + ")"%></strong></td><td><strong><a href='index.jsp' class="menu" target="_top">[ změna ligy ]</a></strong></td>
            </tr>
        </table>
    </body>
</html>
