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

    //db dotaz na kolo
    pstmt = conn.prepareStatement("SELECT sname FROM seasons WHERE sid=?");
    pstmt.setInt(1, Integer.parseInt(request.getParameter("gsid")));
    resultSet = pstmt.executeQuery();
    resultSet.next();
%>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - úprava sezóny</title>
        <base target="right"/>
    </head>

    <body>

        <form method="post" action="SeasonUpdate">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Upravit sezónu - <%=request.getParameter("gsid")%></strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Název:</td>
                        <td><input type="text" name="psname" value="<%=resultSet.getString("sname")%>" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="upravit sezónu"><br/><br/>
                            <input type="hidden" name="psid" value="<%= request.getParameter("gsid")%>">
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