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

    //db dotaz na kolo
    pstmt = conn.prepareStatement("SELECT pname,psurname,pgender FROM players WHERE pid=?");
    pstmt.setInt(1, Integer.parseInt(request.getParameter("gpid")));
    resultSet = pstmt.executeQuery();
    resultSet.next();
%>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - úprava hráče</title>
        <base target="right"/>
    </head>

    <body>

        <form method="post" action="PlayerUpdate">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Upravit hráče - <%=request.getParameter("gpid")%></strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Jméno:</td>
                        <td><input type="text" name="ppname" value="<%=resultSet.getString("pname")%>" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td>Příjmení:</td>
                        <td><input type="text" name="ppsurname" value="<%=resultSet.getString("psurname")%>" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="radio" name="ppsex" value="M" <%=resultSet.getString("pgender").contains("M") ? "checked":""%>>Muž<br>
                            <input type="radio" name="ppsex" value="F" <%=resultSet.getString("pgender").contains("F") ? "checked":""%>>žena
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="upravit"><br/><br/>
                            <input type="hidden" name="ppid" value="<%= request.getParameter("gpid")%>">
                        </td>
                    </tr>
                </tbody>
            </table>
            <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
            <%session.setAttribute("s_msg", null);%>
        </form>

    </body>

</html>
<%  
    resultSet.close();
    pstmt.close();
    conn.close();
%>