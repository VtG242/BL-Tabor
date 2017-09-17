<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.PrintWriter"%>
<%@page isErrorPage="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/etable.css" type="text/css"/>
        <title>BL - chybová stránka</title>
        <base target="right"/>
    </head>
    <body>

        <table border="0" style="margin-top: 15px">
            <caption>BL - chyba</caption>
            <thead>
                <tr>
                    <th>error: <%=exception%></th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <pre>
                            <% exception.printStackTrace(new PrintWriter(out));%>
                        </pre>
                    </td>
                </tr>
            </tbody>
        </table>
    </body>
</html>
