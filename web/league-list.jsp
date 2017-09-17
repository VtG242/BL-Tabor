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

    //db dotaz na sezony
    pstmt = conn.prepareStatement("SELECT lid,lname,lshort FROM leagues ORDER BY lid;");
    //db dotaz na pocet zaznamu v Rounds
    pstmtPom1 = conn.prepareStatement("SELECT COUNT(rid) FROM rounds WHERE rlid=?;");
    //db dotaz na pocet zaznamu v Lineups
    pstmtPom2 = conn.prepareStatement("SELECT COUNT(*) FROM lineups WHERE llid=?;");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - výpis lig</title>
        <base target="right"/>
    </head>
    <body>

        <table border="0" style="margin-top: 15px">
            <tbody>
                <tr><th colspan='3'><strong>Ligy</strong></th></tr>
                        <%
                            resultSet = pstmt.executeQuery();
                            while (resultSet.next()) {
                                pstmtPom1.setInt(1, resultSet.getInt("lid"));
                                resultSetPom1 = pstmtPom1.executeQuery();
                                resultSetPom1.next();

                                pstmtPom2.setInt(1, resultSet.getInt("lid"));
                                resultSetPom2 = pstmtPom2.executeQuery();
                                resultSetPom2.next();

                                p = resultSetPom1.getInt(1) + resultSetPom2.getInt(1);

                                out.println("<tr><td style='text-align: left'>" + resultSet.getString("lname") + "</td><td style='text-align: left'>" + resultSet.getString("lshort") + "</td><td style='text-align: left'><a href='league-upd.jsp?glid=" + resultSet.getString("lid") + "'>[upravit]</a>" + (p == 0 ? "<a href='LeagueAdd?glid=" + resultSet.getString("lid") + "'>&nbsp;[smazat]</a>" : "") + "</td></tr>");

                            }
                        %>
            </tbody>
        </table>
        <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
        <%session.setAttribute("s_msg", null);%>
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