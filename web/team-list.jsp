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
    PreparedStatement pstmt = null, pstmtPom1 = null, pstmtPom2 = null;
    ResultSet resultSet = null, resultSetPom1 = null, resultSetPom2 = null;
    int p = 0;

    //db dotaz - tymy
    pstmt = conn.prepareStatement("SELECT tid,tname FROM teams ORDER BY tname;");
    //db dotaz na pocet zaznamu v Matches
    pstmtPom1 = conn.prepareStatement("SELECT COUNT(mid) FROM matches WHERE mhtid=? OR mvtid=?;");
    //db dotaz na pocet zaznamu v Lineups
    pstmtPom2 = conn.prepareStatement("SELECT COUNT(*) FROM lineups WHERE ltid=?;");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - výpis týmů</title>
        <base target="right"/>
    </head>
    <body>

        <table border="0" style="margin-top: 15px">
            <tbody>
                <tr><th colspan='2'><strong>Týmy</strong></th></tr>
                        <%
                            resultSet = pstmt.executeQuery();
                            while (resultSet.next()) {

                                pstmtPom1.setInt(1, resultSet.getInt("tid"));
                                pstmtPom1.setInt(2, resultSet.getInt("tid"));
                                resultSetPom1 = pstmtPom1.executeQuery();
                                resultSetPom1.next();

                                pstmtPom2.setInt(1, resultSet.getInt("tid"));
                                resultSetPom2 = pstmtPom2.executeQuery();
                                resultSetPom2.next();

                                p = resultSetPom1.getInt(1) + resultSetPom2.getInt(1);
                                out.println("<tr><td style='text-align: left'>" + resultSet.getString("tname") + "</td><td style='text-align: left'><a href='team-upd.jsp?gtid=" + resultSet.getString("tid") + "'>[upravit]</a>" + (p == 0 ? "<a href='TeamAdd?gtid=" + resultSet.getString("tid") + "'>&nbsp;[smazat]</a>" : "") + "</td></tr>");

                            }
                        %>
            </tbody>
        </table>
        <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
        <%session.setAttribute("s_msg", null);%>
        <%= request.getParameter("ls") != null ? "<div id='infomsg'>Záznam uložen !</div>" : ""%>
    </body>
</html>
<%
    //pokud nebyli provadeny dotazy na zapasy v ligovem kole nezavirame resultset ...                
    if (resultSetPom1 != null) {
        resultSetPom1.close();
        pstmtPom1.close();
        resultSetPom2.close();
        pstmtPom2.close();
    }
    resultSet.close();
    pstmt.close();
    conn.close();
%>