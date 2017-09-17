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
    pstmt = conn.prepareStatement("SELECT players.psurname||' '||players.pname as pname,"
            + "count(*) as nm,"
            + "min(points) as min,"
            + "max(points) as max,"
            + "sum(points) as sum,"
            + "to_char(round(avg(points),2),'999D99') as avg "
            + "FROM gamescore,players,rounds,matches "
            + "WHERE gsid=? AND rlid=? AND rid=mrid AND mid=gmid AND pid=gpid "
            + "GROUP BY gpid,psurname,pname "
            + "ORDER BY avg(points) "
            + "DESC,sum(points) DESC;");
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
            <thead><tr><th>Poř.</th><th>Hráč</th><th>PZ</th><th>Min</th><th>Max</th><th>Suma</th><th>Průměr</th></thead>
            <tbody>
                <%
                    resultSet = pstmt.executeQuery();

                    while (resultSet.next()) {
                        out.println("<tr><td>" + p + ".</td><td style='text-align: left'>" + resultSet.getString("pname") + "</td><td style='text-align: right'>" + resultSet.getInt("nm") + "</td><td style='text-align: right'>" + resultSet.getInt("min") + "</td><td style='text-align: right'>" + resultSet.getInt("max") + "</td><td style='text-align: right'>" + resultSet.getInt("sum") + "</td><td style='text-align: center'>" + resultSet.getString("avg") + "</td></tr>");
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