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
    pstmt = conn.prepareStatement("SELECT lname,lshort FROM leagues WHERE lid=?");
    pstmt.setInt(1, Integer.parseInt(request.getParameter("glid")));
    resultSet = pstmt.executeQuery();
    resultSet.next();
%>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - úprava ligy</title>
        <base target="right"/>
    </head>

    <body>

        <form method="post" action="LeagueUpdate">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Upravit ligu - ID:<%=request.getParameter("glid")%></strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Název:</td>
                        <td><input type="text" name="plname" value="<%=resultSet.getString("lname")%>" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td>Zkratka:</td>
                        <td><input type="text" name="plshort" value="<%=resultSet.getString("lshort")%>" style="width: 150px"></td>     
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="upravit ligu"><br/><br/>
                            <input type="hidden" name="plid" value="<%= request.getParameter("glid")%>">
                        </td>
                    </tr>
                </tbody>
            </table>
            <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
            <%session.setAttribute("s_msg", null);%>
            <%= request.getParameter("ms") != null ? "<div id='infomsg'>Zápas uložen !</div>" : ""%>
        </form>

    </body>

</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>