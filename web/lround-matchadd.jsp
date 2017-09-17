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

    //db dotaz na databazova kola dle vybrane sezony
    pstmt = conn.prepareStatement("SELECT DISTINCT tid,tname FROM seasons,leagues,teams,lineups WHERE seasons.sid=? AND leagues.lid=? AND teams.tid=lineups.ltid AND seasons.sid=lineups.lsid AND leagues.lid=lineups.llid ORDER BY teams.tname;");
    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
    pstmt.setInt(2, (Integer) session.getAttribute("lid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN""http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - kolo - přidání zápasu</title>
        <base target="right"/>
    </head>
    <body>
        <form method="post" action="AddMatch">
            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th align="right"><strong>Domácí</strong></th>
                        <th align="left" ><strong>Hosté</strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <select name="ht">
                                <option value="0">-- výběr týmu ---</option>
                                <%
                                    resultSet = pstmt.executeQuery();
                                    while (resultSet.next()) {
                                %>
                                <option value="<%= resultSet.getString("tid")%>"><%= resultSet.getString("tname")%></option>
                                <%}%>
                            </select>
                        </td>
                        <td>
                            <select name="vt">
                                <option value="0">-- výběr týmu ---</option>
                                <%
                                    resultSet = pstmt.executeQuery();
                                    while (resultSet.next()) {
                                %>
                                <option value="<%= resultSet.getString("tid")%>"><%= resultSet.getString("tname")%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><!--<input type="checkbox" name="pbp" value="Y">
                            Černý Petr--> <br/><br/>
                            <input type="submit" value="přidat zápas"><br/><br/>
                            <input type="hidden" name="prid" value="<%= request.getParameter("grid")%>">
                        </td>
                    </tr>
                </tbody>
            </table>
            <%
                if (session.getAttribute("s_msg") == null) {
                    out.println(request.getParameter("recsaved") != null ? "<div id='infomsg'>Zápas přidán!</div>" : "");
                } else {
                    out.println("<div id='msg'>" + session.getAttribute("s_msg") + "</div>");
                    session.setAttribute("s_msg", null);
                }
            %>
        </form>
    </body>
</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>