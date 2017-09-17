<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

    <head>
        <title>..:| BT - Bowlingová liga |:..</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    </head>

    <frameset rows="30,*" frameborder="0" framespacing="0" border="false" style="margin-top: 10px">
    <frame src="<%= response.encodeURL("top.jsp")%>" marginwidth="0" frameborder="0" marginheight="0" noresize name="top" scrolling="no"/>
    <frameset cols="255,*" frameborder="0" framespacing="0" border="false">
        <frame src="left.jsp"  name="left" id="left"/>
        <frame src="right.jsp" name="right"/>
        <noframes>
            <body bgcolor='white'>
                <div align="center">
                    <h1>BT - Bowlingové turnaje</h1>
                    Aplikace vyžaduje prohlížeč podporující rámy!
                    <br>
                    Aplication requires browser suporting frames!
                </div>
            </body>
        </noframes>
    </frameset>
    </frameset>

</html>
