<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*"%>
<%@page import="java.sql.*,BL.BLMatch"%>

<%!    DbPool dbPool = null;

    public void init() {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }
%>
<%
    Connection conn = dbPool.getDBConn();
    PreparedStatement pstmt = null, pstmtm = null;
    ResultSet resultSet = null, resultSetm = null;

    /*
     if (request.getParameter("frid") != null) {
     session.setAttribute("rid", Integer.parseInt((String) request.getParameter("frid")));
     } else if (request.getParameter("frid") == null && session.getAttribute("rid") == null) {
     session.setAttribute("rid", 0);
     }
     */

    //db dotaz na databazova kola dle vybrane sezony
    pstmt = conn.prepareStatement("SELECT rid,rname FROM rounds WHERE rsid=? AND rlid=? ORDER BY rid");
    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
    pstmt.setInt(2, (Integer) session.getAttribute("lid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - sezóna - výpis kol</title>
        <base target="right"/>
    </head>
    <body <%= "onload=\"parent.frames['left'].location.href='left.jsp?showrounds=true';\""%>>
        <table border="0" style="margin-top: 15px">
            <tbody>

                <%
                    resultSet = pstmt.executeQuery();

                    while (resultSet.next()) {
                        out.println("<tr><th colspan='5'><strong>" + resultSet.getString("rname") + "</strong>&nbsp;<a href='lround-ridupd.jsp?grid=" + resultSet.getString("rid") + "'>[upravit kolo]</a>&nbsp;<a href='lround-detail.jsp?grid=" + resultSet.getString("rid") + "'>[detailní výpis]</a>&nbsp<a href='lround-matchadd.jsp?grid=" + resultSet.getString("rid") + "'>[přidat zápas]</a></th></tr>");

                        //db dotaz pro zobrazeni informaci o zapasech v danem kole
                        pstmtm = conn.prepareStatement("SELECT matches.mid,matches.mhtid,getteamname(matches.mhtid) as htn,gettotalpoints(matches.mid,matches.mhtid) as htp,matches.mvtid,getteamname(matches.mvtid) as vtn,gettotalpoints(matches.mid,matches.mvtid) as vtp,bp FROM matches WHERE matches.mrid=? ORDER BY mid");
                        pstmtm.setInt(1, resultSet.getInt("rid"));
                        resultSetm = pstmtm.executeQuery();
                        int p = 0;
                        while (resultSetm.next()) {
                            boolean noplayed = (resultSetm.getFloat("htp") == 0.0 && resultSetm.getFloat("vtp") == 0.0) ? true : false;
                            out.println("<tr>");
                            out.println("<td class='ht'>" + resultSetm.getString("htn") + "</td><td>" + (noplayed ? " - " : resultSetm.getFloat("htp")) + "</td><td>" + (noplayed ? " - " : resultSetm.getFloat("vtp")) + "</td><td class='vt'>" + resultSetm.getString("vtn") + "</td>");
                            out.println("<td>upravit:&nbsp;<a href='lround-mresult.jsp?gmid=" + (resultSetm.getInt("mid")) + "'>[ skóre ]</a>&nbsp;<a href='lround-matchedit.jsp?gmid=" + (resultSetm.getInt("mid")) + "&ght=" + (resultSetm.getInt("mhtid")) + "&gvt=" + (resultSetm.getInt("mvtid")) + "&gbp=" + (resultSetm.getString("bp")) + "&gdm=N'>[ zápas ]</a></td>");
                            out.println("<tr>");
                            p++;
                        }
                        if (p == 0) {
                            out.println("<tr><td colspan='5'>žádné zápasy - <a href='RoundAdd?grid=" + resultSet.getString("rid") + "'>[smazat kolo]</a></td></tr>");
                        }

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
    if (resultSetm != null) {
        resultSetm.close();
        pstmtm.close();
    }
    resultSet.close();
    pstmt.close();
    conn.close();
%>