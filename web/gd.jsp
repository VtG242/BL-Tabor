<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*;"%>

<%@page errorPage="error.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/default.css" type="text/css"/> 
        <title>BL - export do GD</title>
    </head>
    <body>
        <h1>GoodData - export</h1>
        <pre>
            <%
                File f = new File("/opt/GoodData/BL-Tabor/etl.pid");

                if (f.exists() && !f.isDirectory()) {
                    out.println("Nahrávání dat do GoodData probíhá - <a href='gd-progress.jsp'>[ zobrazit detaily ]</a>.");

                } else {

                    String s = null, command = "cd /opt/GoodData/BL-Tabor;./etl.sh";
                    StringBuffer sb = new StringBuffer();
                    String[] cmd = {"/bin/bash", "-c", command};

                    Process p = Runtime.getRuntime().exec(cmd);

                    //je-li prikaz ukoncen - je vracena navratova hodnota (0=vse je v poradku)
                    int status = p.waitFor();
                    if (status == 0) {
                        //spusteni prikazu probehlo uspesne - cteme ze standartniho vystupu programu
                        BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
                        // vytiskneme vystup spousteneho souboru
                        while ((s = stdInput.readLine()) != null) {
                            sb.append(s).append("\n");
                        }
                        out.println(sb.toString());
                        stdInput.close();
                    } else {
                        //spusteni prikazu neprobehlo uspesne - cteme z chyboveho vystupu programu
                        BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
                        // read the output from the command
                        while ((s = stdErr.readLine()) != null) {
                            sb.append(s).append("\n");
                        }
                        out.println(sb.toString());
                        stdErr.close();
                    }
                }
            %>
        </pre>
    </body>
</html>
