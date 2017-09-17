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
            PreparedStatement pstmt = null, pstmtm = null;
            ResultSet resultSet = null, resultSetm = null;


            if (request.getParameter("frid") != null) {
                session.setAttribute("rid", Integer.parseInt((String) request.getParameter("frid")));
            } else if (request.getParameter("frid") == null && session.getAttribute("rid") == null) {
                session.setAttribute("rid", 0);
            }
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - sezóna - výpis kol</title>
        <base target="right"/>
        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            function go(form)
            {
                x=form.frid.selectedIndex;
                skript="lrounds.jsp?frid="+form.frid[x].value;
                top.right.location.href=skript;
                //window.location=skript;
            }
        </SCRIPT>
    </head>
    <body>
        <table border="0" style="margin-top: 15px">
            <!--
            <caption>
                <strong>Výběr kola:</strong>
                <form>
                    <select name="frid" onChange="go(this.form)" size="1">
                        <option value="0">-- vše --</option>
            <%
                        pstmt = conn.prepareStatement("SELECT rid,rname FROM rounds WHERE rsid=? ORDER BY rid");
                        pstmt.setInt(1, (Integer) session.getAttribute("sid"));
                        resultSet = pstmt.executeQuery();

                        while (resultSet.next()) {
                            out.println("<option value='" + resultSet.getString("rid") + "' " + ((Integer) session.getAttribute("rid") == (resultSet.getInt("rid")) ? "selected" : "") + ">" + resultSet.getString("rname") + "</option>");
                        }
            %>
        </select>
    </form>
</caption>
            -->
            <tbody>

                <%
                            resultSet = pstmt.executeQuery();

                            while (resultSet.next()) {
                                out.println("<tr><th colspan='5'>" + resultSet.getString("rname") + " <a href='lround-detail.jsp?grid=" + resultSet.getString("rid") + "'>[detailní výpis]</a>&nbsp<a href='lround-matchadd.jsp?grid=" + resultSet.getString("rid") + "'>[přidat zápas]</a></th></tr>");

                                pstmtm = conn.prepareStatement("SELECT matches.mid FROM matches WHERE matches.mrid=?");
                                pstmtm.setInt(1, resultSet.getInt("rid"));
                                resultSetm = pstmtm.executeQuery();

                                while (resultSetm.next()) {
                                    BLMatch roundMatch = new BLMatch(conn, resultSetm.getInt("mid"));
                                    out.println("<tr>");
                                    out.println("<td>" + roundMatch.getHomeTeamName() + "</td><td>" + (roundMatch.getMatchResult(0)) + "</td><td>" + (roundMatch.getMatchResult(1)) + "</td><td>" + roundMatch.getVisitorTeamName() + "</td>");
                                    out.println("<td><a href=''>[ menu ]</a></td>");
                                    out.println("<tr>");
                                }

                            }
                %>
            </tbody>
        </table>
        SESSION: RID=<%= session.getAttribute("rid")%>
    </body>
</html>
<%
            resultSetm.close();
            pstmtm.close();

            resultSet.close();
            pstmt.close();
            conn.close();
%>