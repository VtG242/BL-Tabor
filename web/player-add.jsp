<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="VtGUtils.*"%>
<%@page import="java.sql.*,BL.BLMatch"%>
<%@page errorPage="error.jsp"%>

<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - přidání hráče</title>
        <base target="right"/>
    </head>

    <body>

        <form method="post" action="PlayerAdd">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Přidat hráče</strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Jméno:</td>
                        <td><input type="text" name="ppname" value="" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td>Příjmení:</td>
                        <td><input type="text" name="ppsurname" value="" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="radio" name="ppsex" value="M">Muž<br>
                            <input type="radio" name="ppsex" value="F">žena
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="submit" value="přidat"><br/><br/>
                        </td>
                    </tr>
                </tbody>
            </table>
            <%
                if (session.getAttribute("s_msg") == null) {
                    out.println(request.getParameter("recsaved") != null ? "<div id='infomsg'>Hráč přidán!</div>" : "");
                } else {
                    out.println("<div id='msg'>" + session.getAttribute("s_msg") + "</div>");
                    session.setAttribute("s_msg", null);
                }
            %>
        </form>

    </body>

</html>
