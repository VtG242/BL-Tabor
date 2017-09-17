<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*"%>
<%@page import="java.sql.*,BL.BLMatch"%>
<%@page errorPage="error.jsp"%>
<%!    DbPool dbPool = null;

    public void init() {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }
%>
<%
    Connection conn = dbPool.getDBConn();
    PreparedStatement pstmt = null;
    ResultSet resultSet = null;

    /*
     if (request.getParameter("frid") != null) {
     session.setAttribute("rid", Integer.parseInt((String) request.getParameter("frid")));
     } else if (request.getParameter("frid") == null && session.getAttribute("rid") == null) {
     session.setAttribute("rid", 0);
     }
     */

    //db dotaz na databazova kola dle vybrane sezony
    pstmt = conn.prepareStatement("SELECT DISTINCT tname,tid FROM teams,lineups WHERE tid=ltid AND lsid=? AND llid=? ORDER BY tname;");
    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
    pstmt.setInt(2, (Integer) session.getAttribute("lid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - sezóna - výpis týmů</title>
        <base target="right"/>
    </head>
    <body>

        <table border="0" style="margin-top: 15px">
            <tbody>
                <tr><th colspan='2'><strong>Týmy v soutěži</strong></th></tr>
                        <%
                            resultSet = pstmt.executeQuery();
                            while (resultSet.next()) {
                                out.println("<tr><td style='text-align: left'>" + resultSet.getString("tname") + "</td><td><a href='season-team-add.jsp?gtid=" + resultSet.getString("tid") + "&gtname=" + resultSet.getString("tname") + "&action=Update'>[upravit soupisku]</a></td></tr>");

                            }
                        %>
            </tbody>
        </table>
        <%
            //db dotaz na databazova kola dle vybrane sezony
            pstmt = conn.prepareStatement("SELECT DISTINCT tname,tid FROM teams WHERE tid NOT IN (SELECT ltid FROM lineups WHERE lsid=? AND llid=?) ORDER BY tname");
            pstmt.setInt(1, (Integer) session.getAttribute("sid"));
            pstmt.setInt(2, (Integer) session.getAttribute("lid"));
        %>        
        <table border="0" style="margin-top: 15px">
            <tbody>
                <tr><th colspan='2'><strong>Nezařazené týmy</strong></th></tr>
                        <%
                            resultSet = pstmt.executeQuery();
                            while (resultSet.next()) {
                                out.println("<tr><td style='text-align: left'>" + resultSet.getString("tname") + "</td><td><a href='season-team-add.jsp?gtid=" + resultSet.getString("tid") + "&gtname=" + resultSet.getString("tname") + "&action=Add'>[přidat do sezóny]</a></td></tr>");

                            }
                        %>
            </tbody>
        </table>            
        <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
        <%session.setAttribute("s_msg", null);%>
    </body>
</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>