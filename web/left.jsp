<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*,java.sql.*"%>
<%@page errorPage="error.jsp"%>
<%!    DbPool dbPool = null;

    public void init() {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }
%>
<%
    session.setMaxInactiveInterval(-1);
    Connection conn = dbPool.getDBConn();
    PreparedStatement pstmt = null;
    ResultSet resultSet = null;

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
        <title>BL - sezóna</title>
        <base target="right"/>
        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            function go(form)
            {
                x = form.fsid.selectedIndex;
                skript = "left.jsp?fsid=" + form.fsid[x].value;
                top.left.location.href = skript;
                top.right.location.href = "right.jsp";
                //window.location=skript;
            }
        </SCRIPT>
    </head>
    <body>

        <fieldset style="font-weight: bolder;">
            <legend>Sezóna:</legend>
            <form>
                <select name="fsid" onChange="go(this.form)" size="1">
                    <%
                        pstmt = conn.prepareStatement("SELECT sid,sname FROM seasons ORDER BY sid");
                        resultSet = pstmt.executeQuery();

                        while (resultSet.next()) {
                            out.println("<option value='" + resultSet.getString("sid") + "' " + ((Integer) session.getAttribute("sid") == (resultSet.getInt("sid")) ? "selected" : "") + ">" + resultSet.getString("sname") + "</option>");
                        }
                    %>
                </select>
            </form>

            <ul>
                <li><a href='season-teams.jsp' class="menu">[ Týmy ]</a></li>
                    <%
                        /*
                         if (request.getParameter("showteams") != null && request.getParameter("showteams").contains("true")) {
                         out.println("<ul><li><a href='season-team-add.jsp' class='menu'>Přidat tým</a></li></ul>");
                         } else {
                         out.println("<br/>");
                         }
                         */
                    %>
                <li><a href='lrounds.jsp' class="menu">[ Ligová kola ]</a></li>
                    <%
                        if (request.getParameter("showrounds") != null && request.getParameter("showrounds").contains("true")) {
                            out.println("<ul><li><a href='lround-ridadd.jsp' class='menu'>Přidat kolo</a></li></ul>");
                        } else {
                            out.println("<br/>");
                        }
                    %>
                <li><a href='ltable.jsp' class="menu">[ Tabulka ]</a></li>
                <li><a href='lstats.jsp' class="menu">[ Statistiky ]</a></li>
                <br/>
                <li><a href='administration.jsp' class="menu" target="left">[ Administrace ]</a></li>
                <br/>
                <li><a href='gd.jsp' class="menu">[ Export výsledků - GD ]</a></li>
                <!--<li><a href='www.jsp' class="menu">[ Export výsledků - WWW ]</a></li>-->
                <br/>
            </ul>

        </fieldset>
    </body>
</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>