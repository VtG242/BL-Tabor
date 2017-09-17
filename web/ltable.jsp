<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*"%>
<%@page import="java.sql.*"%>
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
    int p = 1;

    //db dotaz na poradi v dane sezone
    pstmt = conn.prepareStatement("SELECT "
            + "tname as team,"
            + "sum(pointstotal) as points,"
            + "count(*) as nm,"
            + "sum(scoretotal) as st,"
            + "to_char(round(avg(scoretotal),2),'999D99') as avg "
            + "FROM endresults,teams,rounds "
            + "WHERE esid=? AND rounds.rlid=? AND rid=erid AND tid=etid GROUP BY etid,tname ORDER BY sum(pointstotal) DESC,round(avg(scoretotal),2) DESC;");
    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
    pstmt.setInt(2, (Integer) session.getAttribute("lid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/stable.css" type="text/css"/>
        <title>BL - sezóna - tabulka</title>
        <base target="right"/>
    </head>
    <body>
        <table border="0" style="margin-top: 15px">
            <thead><tr><th>Poř.</th><th>Tým</th><th>Body</th><th>PZ</th><th>Celkem</th><th>Průměr</th></thead>
            <tbody>
                <%
                    resultSet = pstmt.executeQuery();

                    while (resultSet.next()) {
                        out.println("<tr><td>" + p + ".</td><td style='text-align: left'>" + resultSet.getString("team") + "</td><td style='text-align: right'>" + resultSet.getString("points") + "</td><td style='text-align: right'>" + resultSet.getInt("nm") + "</td><td style='text-align: right'>" + resultSet.getInt("st") + "</td><td style='text-align: center'>" + resultSet.getString("avg") + "</td></tr>");
                        p++;
                    }
                %>
            </tbody>
            <tfoot></tfoot>
        </table>
    </body>
</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>