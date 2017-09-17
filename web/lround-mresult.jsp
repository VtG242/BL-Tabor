<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*,VtGUtils.*,BL.BLMatch"%>

<%!    DbPool dbPool = null;

    public void init() {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }

    public int getPlayerHC(String gender, int actualLeagueRound, int playerID, Connection conn) throws SQLException {
        int hc = 0, avg = 0;
        PreparedStatement pstmtf = conn.prepareStatement("SELECT ROUND(AVG(points)) as avg FROM gamescore,rounds,matches WHERE gpid=? AND rid !=? AND rid = mrid AND mid = gmid");
        pstmtf.setInt(1, playerID);
        pstmtf.setInt(2, actualLeagueRound);
        ResultSet resultSetf = pstmtf.executeQuery();

        while (resultSetf.next()) {
            avg = resultSetf.getInt(1);
        }

        //dale rozdelujeme vysi HC dle pohlavi
        if (gender.equals("M")) {
            hc = 0;
        } else {
            if (avg <= 120) {
                hc = 10;
            } else if (avg >= 121 && avg <= 140) {
                hc = 5;
            } else {
                hc = 0;
            }
        }

        return hc;
    }
%>
<%
    Connection conn = dbPool.getDBConn();
    PreparedStatement pstmt = null, pstmtp = null;
    ResultSet resultSet = null, resultSetp = null;
    int hc = 0, hchp1 = 0, hcvp1 = 0, hchp2 = 0, hcvp2 = 0, hchp3 = 0, hcvp3 = 0;

    BLMatch match = new BLMatch(conn, Integer.parseInt(request.getParameter("gmid")));

    pstmt = conn.prepareStatement("SELECT mhtid,getteamname(mhtid) as htn,mvtid,getteamname(mvtid) as vtn,bp FROM matches WHERE matches.mid=?");
    pstmt.setInt(1, Integer.parseInt(request.getParameter("gmid")));
    resultSet = pstmt.executeQuery();

    pstmtp = conn.prepareStatement("SELECT lpid,players.psurname||' '||players.pname AS pname,pgender FROM lineups,players WHERE lsid=? AND llid=? AND ltid=? AND pid=lpid ORDER BY pname");
    pstmtp.setInt(1, (Integer) session.getAttribute("sid"));
    pstmtp.setInt(2, (Integer) session.getAttribute("lid"));
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/addtable.css" type="text/css"/>
        <title>BL - zadání výsledku zápasu</title>
        <base target="right"/>
        <SCRIPT LANGUAGE="JavaScript" type="text/javascript" src="js/matchformcheck.js" charset="utf-8"></SCRIPT>
    </head>
    <body>
        <form method="post" action="AddMatchResult" onSubmit="return Validate(this, ff1);">
            <%
                while (resultSet.next()) {
            %>
            <table style="margin-top: 15px">
                <tbody>
                    <tr>
                        <th align="right" colspan="2"><%=resultSet.getString("htn")%></th>
                        <th align="left" colspan="2"><%=resultSet.getString("vtn")%></th>
                    </tr>
                    <tr>
                        <td>1.</td>
                        <td>
                            <select name="hp1">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mhtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getHTP1Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hchp1 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>" <%=match.getHTP1Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text" name="hpp1" value="<%=match.getHTP1Points() == 0 ? "" : (match.getHTP1Points() - hchp1)%>" style="width: 35px"/>
                        </td>
                        <td>1.</td>
                        <td>
                            <select name="vp1">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mvtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getVTP1Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hcvp1 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>"<%=match.getVTP1Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text"  name="vpp1" value="<%=match.getVTP1Points() == 0 ? "" : match.getVTP1Points() - hcvp1%>" style="width: 35px"/>
                        </td>
                    </tr>
                    <tr>
                        <td>2.</td>
                        <td>
                            <select name="hp2">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mhtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getHTP2Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hchp2 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>" <%=match.getHTP2Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text" name="hpp2" value="<%=match.getHTP2Points() == 0 ? "" : (match.getHTP2Points() - hchp2)%>" style="width: 35px"/>
                        </td>
                        <td>2.</td>
                        <td>
                            <select name="vp2">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mvtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getVTP2Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hcvp2 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>"<%=match.getVTP2Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text"  name="vpp2" value="<%=match.getVTP2Points() == 0 ? "" : match.getVTP2Points() - hcvp2%>" style="width: 35px"/>
                        </td>
                    </tr>
                    <tr>
                        <td>3.</td>
                        <td>
                            <select name="hp3">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mhtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getHTP3Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hchp3 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>" <%=match.getHTP3Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text" name="hpp3" value="<%=match.getHTP3Points() == 0 ? "" : (match.getHTP3Points() - hchp3)%>" style="width: 35px"/>
                        </td>
                        <td>3.</td>
                        <td>
                            <select name="vp3">
                                <option value="0_0" selected>Kontumace výsledku</option>                                
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mvtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                        //zjistime vysi hc pro zvoleneho hrace 
                                        hc = getPlayerHC(resultSetp.getString("pgender"), Integer.parseInt(request.getParameter("gmid")), resultSetp.getInt("lpid"), conn);
                                        if (match.getVTP3Name().startsWith(resultSetp.getString("pname"))) {
                                            //v pripade ze je editovan zapas ulozime HC pro uzivatele na dane pozici
                                            hcvp3 = hc;
                                        }
                                %>
                                <option value="<%=resultSetp.getInt("lpid") + "_" + hc%>"<%=match.getVTP3Name().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname") + "(" + hc + ")"%></option>
                                <%}%>
                            </select>
                            <input type="text"  name="vpp3" value="<%=match.getVTP3Points() == 0 ? "" : match.getVTP3Points() - hcvp3%>" style="width: 35px"/>
                        </td>
                    </tr>
                    <% if (resultSet.getString("bp").equals("Y")) { //Cerneho petra zobrazime pouze byl-li deklarovan pri zadani zapasu%>
                    <tr>
                        <td  style="text-align: right" colspan="2">
                            <select name="hpbp">
                                <option value="0">Výběr hráče</option>
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mhtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                %>
                                <option value="<%=resultSetp.getInt("lpid")%>" <%=match.getBPHPname().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname")%></option>
                                <%}%>
                            </select>
                        </td>
                        <td  style="text-align: left"  colspan="2">
                            <select  name="vpbp">
                                <option value="0">Výběr hráče</option>
                                <%
                                    pstmtp.setInt(3, resultSet.getInt("mvtid"));
                                    resultSetp = pstmtp.executeQuery();
                                    while (resultSetp.next()) {
                                %>
                                <option value="<%=resultSetp.getInt("lpid")%>" <%=match.getBPVPname().startsWith(resultSetp.getString("pname")) ? "selected" : ""%>><%=resultSetp.getString("pname")%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <%}%>
                    <tr>
                        <td colspan="4" style="height: 40px">
                            <input type="submit" value=" uložit " style="font-weight: bolder">
                            <input type="hidden" name="pmid" value="<%=request.getParameter("gmid")%>">
                            <input type="hidden" name="pht" value="<%=resultSet.getString("mhtid")%>">
                            <input type="hidden" name="pvt" value="<%=resultSet.getString("mvtid")%>">
                            <input type="hidden" name="pbp" value="<%=resultSet.getString("bp")%>">
                        </td>
                    </tr>
                </tbody>
            </table>
            <%}%>
        </form>
        <%
            if (session.getAttribute("s_msg") == null) {
                out.println(request.getParameter("recsaved") != null ? "<div id='infomsg'>Zápas uložen!</div>" : "");
            } else {
                out.println("<div id='msg'>" + session.getAttribute("s_msg") + "</div>");
                session.setAttribute("s_msg", null);
            }
        %>
    </body>
</html>
<%
    resultSetp.close();
    pstmtp.close();

    resultSet.close();
    pstmt.close();
    conn.close();
%>