<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,java.util.regex.*"%>
<%@page import="VtGUtils.*"%>

<%!    DbPool dbPool = null;

    public void init() {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }
%>
<%
    //platnost session neomezena
    request.getSession(true);
    session.setMaxInactiveInterval(-1);

    //je-li zadan turnaj presmerujeme na stranku s menu:
    if (request.getParameter("league") != null) {
        String[] leagueInfo = Pattern.compile("_").split(request.getParameter("league"));
        //Nastavime id a název ligy do session
        session.setAttribute("lid", Integer.parseInt(leagueInfo[0]));
        session.setAttribute("lname", leagueInfo[1]);
        session.setAttribute("lshort", leagueInfo[2]);
        response.sendRedirect(response.encodeRedirectURL("frames.jsp"));
    }

    Connection conn = dbPool.getDBConn();
    PreparedStatement pstmt = null;
    ResultSet resultSet = null;

    //nastavime defaultni sezonu - posledni ID
    pstmt = conn.prepareStatement("SELECT max(sid) FROM seasons");
    resultSet = pstmt.executeQuery();
    while (resultSet.next()) {
        session.setAttribute("sid", resultSet.getInt(1));
    }
%>
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel=StyleSheet href="css/default.css" type="text/css"/>
        <title>BL - Bowlingové ligy</title>
    </head>
    <body>

        <h1>BL - Bowlingové ligy - Tábor: verze 1.0</h1>
        <fieldset id="ds">
            <legend>Výběr ligy</legend>
            <form action="index.jsp" method="get">
                <select name="league">
                    <%
                        pstmt = conn.prepareStatement("SELECT lid,lname,lshort FROM leagues ORDER BY lid");
                        resultSet = pstmt.executeQuery();
                        while (resultSet.next()) {
                            out.print("<option value='" + resultSet.getInt(1) + "_" + resultSet.getString(2) + "_" + resultSet.getString(3) + "'>" + resultSet.getString(2) + "&nbsp;(" + resultSet.getString(3) + ")</option>");
                        }
                    %>
                </select>
                &nbsp;<input type="submit" class="submit" value="zvolit"/>
            </form>
        </fieldset>

        <ul>
            <li>13.07.2014 - Přidána možnost zadávat kontumace přes hráče s id 0 "Kontumace výsledku"</li>
        </ul>

        <div id="msg"><%= session.getAttribute("s_msg") != null ? session.getAttribute("s_msg") : ""%></div>
        <%session.removeAttribute("s_msg");%>

    </body>
</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>
