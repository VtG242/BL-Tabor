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
    pstmt = conn.prepareStatement("SELECT rname,to_char(rdate, 'DD.MM.YYYY') as rdate FROM rounds WHERE rid=?");
    pstmt.setInt(1, Integer.parseInt(request.getParameter("grid")));
    resultSet = pstmt.executeQuery();
    resultSet.next();
%>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/left.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - úprava kola kola</title>
        <base target="right"/>
        <!-- calendar stylesheet -->
        <link rel="stylesheet" type="text/css" media="all" href="calendar/calendar-system.css" title="calendar-system" />
        <!-- main calendar program -->
        <script type="text/javascript" src="calendar/calendar.js"></script>
        <!-- language for the calendar -->
        <script type="text/javascript" src="calendar/lang/calendar-en.js"></script>
        <!-- the following script defines the Calendar.setup helper function, which makes
        adding a calendar a matter of 1 or 2 lines of code. -->
        <script type="text/javascript" src="calendar/calendar-setup.js"></script>
    </head>

    <body>

        <form method="post" action="RoundUpdate">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Upravit kolo</strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Název kola:</td>
                        <td><input type="text" name="rname" value="<%=resultSet.getString("rname")%>" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td>&nbsp;Datum(rrrr-mm-dd):&nbsp;</td>
                        <td>
                            <table border="0" cellpadding="0" cellspacing="0"><tr><td><input  style="width: 122px" type="text" name="date" value="<%=resultSet.getString("rdate")%>" id="f_date_c" readonly="1" style="width: 80px;"/></td><td><img src="img/img.gif" id="f_trigger_c" style="cursor: pointer; border: 1px solid blue;" title="Výběr datumu" onmouseover="this.style.background = 'blue';" onmouseout="this.style.background = 'white';"/></td></tr></table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="upravit kolo"><br/><br/>
                            <input type="hidden" name="prid" value="<%= request.getParameter("grid")%>">
                        </td>
                    </tr>
                </tbody>
            </table>
            <%= session.getAttribute("s_msg") == null ? "" : "<div id='msg'>" + session.getAttribute("s_msg") + "</div>"%>
            <%session.setAttribute("s_msg", null);%>
        </form>

        <script type="text/javascript">
                                Calendar.setup({
                                    inputField: "f_date_c", // id of the input field
                                    ifFormat: "%d.%m.%Y", // format of the input field
                                    button: "f_trigger_c", // trigger for the calendar (button ID)
                                    align: "Tl", // alignment (defaults to "Bl")
                                    singleClick: true
                                });
        </script>

    </body>

</html>
<%
    resultSet.close();
    pstmt.close();
    conn.close();
%>