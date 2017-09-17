<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,VtGUtils.*,BL.BLMatch"%>
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

            pstmt = conn.prepareStatement("SELECT matches.mid FROM matches WHERE matches.mrid=?");
            pstmt.setInt(1, Integer.parseInt(request.getParameter("grid")));
            resultSet = pstmt.executeQuery();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/rtable.css" type="text/css"/>
        <title>BL - sezóna - výpis kola</title>
        <base target="right"/>
    </head>
    <body>
        <%                    while (resultSet.next()) {
                        BLMatch roundMatch = new BLMatch(conn, resultSet.getInt("mid"));
        %>
        <table style="margin-top: 15px">
            <tbody>
                <tr>
                    <th><%=roundMatch.getHomeTeamName()%></th>
                    <th><%=roundMatch.getMatchResult(0)%></th>
                    <th><%=roundMatch.getMatchResult(1)%></th>
                    <th><%=roundMatch.getVisitorTeamName()%></th>
                    <th rowspan="<%=roundMatch.getBP() ? "6" : "5"%>"><a href="lround-mresult.jsp?gmid=<%=resultSet.getInt("mid")%>">[ upravit skóre ]</a></th>
                </tr>
                <tr>
                    <td><select disabled><option><%=roundMatch.getHTP1Name()%></option></select><input type="text" value="<%=roundMatch.getHTP1Points()%>" style="width: 35px" disabled /></td>
                    <td><%=roundMatch.getHTP1GamePoints()%></td>
                    <td><%=roundMatch.getVTP1GamePoints()%></td>
                    <td><select disabled><option><%=roundMatch.getVTP1Name()%></option></select><input type="text" value="<%=roundMatch.getVTP1Points()%>" style="width: 35px" disabled /></td>
                </tr>
                <tr>
                    <td><select disabled><option><%=roundMatch.getHTP2Name()%></option></select><input type="text" value="<%=roundMatch.getHTP2Points()%>" style="width: 35px" disabled /></td>
                    <td><%=roundMatch.getHTP2GamePoints()%></td>
                    <td><%=roundMatch.getVTP2GamePoints()%></td>
                    <td><select disabled><option><%=roundMatch.getVTP2Name()%></option></select><input type="text" value="<%=roundMatch.getVTP2Points()%>" style="width: 35px" disabled /></td>
                </tr>
                <tr>
                    <td><select disabled><option><%=roundMatch.getHTP3Name()%></option></select><input type="text" value="<%=roundMatch.getHTP3Points()%>" style="width: 35px" disabled /></td>
                    <td><%=roundMatch.getHTP3GamePoints()%></td>
                    <td><%=roundMatch.getVTP3GamePoints()%></td>
                    <td><select disabled><option><%=roundMatch.getVTP3Name()%></option></select><input type="text" value="<%=roundMatch.getVTP3Points()%>" style="width: 35px" disabled /></td>
                </tr>
                <tr>
                    <td style="text-align: right"><input type="text" value="<%=roundMatch.getHTPoints()%>" style="text-align:right;width: 35px" disabled /></td>
                    <td><%=roundMatch.getHTGamePoints()%></td>
                    <td><%=roundMatch.getVTGamePoints()%></td>
                    <td style="text-align: left"><input type="text" value="<%=roundMatch.getVTPoints()%>" style="text-align:left;width: 35px" disabled /></td>
                </tr>
                <% if (roundMatch.getBP()) {%>
                <tr>
                    <td style="text-align: right"><select disabled><option><%=roundMatch.getBPHPname()%></option></select></td>
                    <td><%=roundMatch.getBPHTGamePoints()%></td>
                    <td><%=roundMatch.getBPVTGamePoints()%></td>
                    <td  style="text-align: left"><select disabled><option><%=roundMatch.getBPVPname()%></option></select></td>
                </tr>
                <%}%>
            </tbody>
        </table>
        <%}%>
    </body>
</html>
<%
            resultSet.close();
            pstmt.close();
            conn.close();
%>