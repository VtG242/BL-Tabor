<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*,java.sql.*"%>
<%@page errorPage="error.jsp"%>
<%
    session.setMaxInactiveInterval(-1);

    if (request.getParameter("fsid") != null) {
        session.setAttribute("sid", Integer.parseInt((String) request.getParameter("fsid")));
    } else if (request.getParameter("fsid") == null && session.getAttribute("sid") == null) {
        session.setAttribute("sid", 1);
    }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <title>BL - Administrace</title>
        <base target="right"/>
    </head>
    <body>

        <fieldset style="font-weight: bolder;">
            <legend>Administrace:</legend>

            <ul>
                <li><a href='league-list.jsp' class="menu">[ Ligy ]</a></li>
                <ul><li><a href='league-add.jsp' class='menu'>Přidat ligu</a></li></ul>
                <li><a href='season-list.jsp' class="menu">[ Sezóny ]</a></li>
                <ul><li><a href='season-add.jsp' class='menu'>Přidat sezónu</a></li></ul>
                <br/>
                <li><a href='team-list.jsp' class="menu">[ Seznam týmů ]</a></li>
                <ul><li><a href='team-add.jsp' class='menu'>Přidat tým</a></li></ul>
                <li><a href='player-list.jsp' class="menu">[ Seznam hráčů ]</a></li>
                <ul><li><a href='player-add.jsp' class='menu'>Přidat hráče</a></li></ul>
                <br/>
                <li><a href='left.jsp' class="menu" target="left">[ zpět do sezóny ]</a></li>
            </ul>

        </fieldset>
    </body>
</html>
