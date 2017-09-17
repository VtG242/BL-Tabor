<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/right.css" type="text/css"/>
        <link rel=StyleSheet href="css/ratable.css" type="text/css"/>
        <title>BL - přidání ligy</title>
        <base target="right"/>
    </head>

    <body>

        <form method="post" action="LeagueAdd">

            <table border="0" style="margin-top: 15px">
                <thead>
                    <tr>
                        <th colspan="2"><strong>Nová liga</strong></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Název:</td>
                        <td><input type="text" name="plname" value="" style="width: 150px"></td>
                    </tr>
                    <tr>
                        <td>Zkratka:</td>
                        <td><input type="text" name="plshort" value="" style="width: 150px"></td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <input type="submit" value="přidat ligu"><br/><br/>
                        </td>
                    </tr>
                </tbody>
            </table>
            <%
                if (session.getAttribute("s_msg") == null) {
                    out.println(request.getParameter("recsaved") != null ? "<div id='infomsg'>Liga přidána!</div>" : "");
                } else {
                    out.println("<div id='msg'>" + session.getAttribute("s_msg") + "</div>");
                    session.setAttribute("s_msg", null);
                }
            %>           
        </form>

    </body>

</html>
